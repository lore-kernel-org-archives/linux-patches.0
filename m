Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52321494DC;
	Tue, 25 Jun 2024 09:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308188; cv=none; b=ge5M2+Kk1PrMqqzHAkAaIh/upZXIagcE2GnJUlk3QFCwflsjmzwlK0ypyU1UNEliCQQ5Pfiy5IlMOTlKEk3J61I+qgLfEGIVXO1znOuvdPD4UPLAjgUzzEpAK2YfuOk8WiSZEUK7eg+PplYhiRv7aHArxM0mTQiG90t6flPO4Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308188; c=relaxed/simple;
	bh=xGwdL6GWbOOJ37qGD+YtNK5YoG2QpNcNVPIRTow4nFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vl4TkPdKzHmIoXrb7EU0yGikt3LJUWOfrzpeAeORwJQcbZCnClTLSqrM+dt6v/jmFvdX49oaOGTLGjv30b4mn2Fa4Ihew0i9wPeOocgm2r+Lks/rBu9+V7WNu5foiZnReTlttNpo8nwwDdMvnpCTl7+F6jhASi1MWITU68WVklU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bM/mVYtR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bM/mVYtR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30139C32781;
	Tue, 25 Jun 2024 09:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308188;
	bh=xGwdL6GWbOOJ37qGD+YtNK5YoG2QpNcNVPIRTow4nFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bM/mVYtRpu/jmJ6Eaw1j06TmDp0ZHJMHd0LykRDc8q+7aVXSMSPci6sVHAnu3sWJz
	 wfsdY65wtnmg2NZIU0qAkzrGae1eXaLvT38LAHkGQatRlsSi087H8m7/Zhu5CFeZWF
	 nbNcGLKsBJ+LFWytALDuApM2pFyeLYkTrBDiSduo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 037/250] netpoll: Fix race condition in netpoll_owner_active
Date: Tue, 25 Jun 2024 11:29:55 +0200
Message-ID: <20240625085549.482591143@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit c2e6a872bde9912f1a7579639c5ca3adf1003916 ]

KCSAN detected a race condition in netpoll:

	BUG: KCSAN: data-race in net_rx_action / netpoll_send_skb
	write (marked) to 0xffff8881164168b0 of 4 bytes by interrupt on cpu 10:
	net_rx_action (./include/linux/netpoll.h:90 net/core/dev.c:6712 net/core/dev.c:6822)
<snip>
	read to 0xffff8881164168b0 of 4 bytes by task 1 on cpu 2:
	netpoll_send_skb (net/core/netpoll.c:319 net/core/netpoll.c:345 net/core/netpoll.c:393)
	netpoll_send_udp (net/core/netpoll.c:?)
<snip>
	value changed: 0x0000000a -> 0xffffffff

This happens because netpoll_owner_active() needs to check if the
current CPU is the owner of the lock, touching napi->poll_owner
non atomically. The ->poll_owner field contains the current CPU holding
the lock.

Use an atomic read to check if the poll owner is the current CPU.

Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://lore.kernel.org/r/20240429100437.3487432-1-leitao@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netpoll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 543007f159f99..55bcacf67df3b 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -316,7 +316,7 @@ static int netpoll_owner_active(struct net_device *dev)
 	struct napi_struct *napi;
 
 	list_for_each_entry_rcu(napi, &dev->napi_list, dev_list) {
-		if (napi->poll_owner == smp_processor_id())
+		if (READ_ONCE(napi->poll_owner) == smp_processor_id())
 			return 1;
 	}
 	return 0;
-- 
2.43.0



