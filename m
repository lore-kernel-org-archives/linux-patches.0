Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9388651AEEE;
	Wed, 30 Sep 2026 17:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789338; cv=none; b=BiANbGQZwA2ULgGXkPGdcnUK+gGwcklI0UXW1Ilfn+X1RnnhNNP4g0cSqBd5Y+TTCt6ekjpoplu3DhZWUDUgMcPJLiAHpxIN+lUyDGdbS7bb5phvrS+gLo07hgwgrpfOKMYzLsNiQKIeBTvAeYOfYoD45pbUXKnMAOQFWO5yRtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789338; c=relaxed/simple;
	bh=tLHi5H4VAxVegJHTk+bvjIx+UZtKPwzIc6eipQSB3/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JTwlL78E4Edu+dN/tY05JrU2uBNXdMnvk5QREJuKUwAKZvX/WrbnZYjzz2aqvgLaeYmWQFNSz+x70hvaWZ4e5wtP0jtlZ5R/nMeRU9dICr9spT4vtgqLNyON4XiHA/RKMlhl2Qt0xsPXLVMEUfYZY1AgdbZIDHgnj28rHKLWFPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tsVbGCE4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tsVbGCE4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4951F000FF;
	Wed, 30 Sep 2026 17:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789337;
	bh=qgY7ggTPMqZd6mGJdm0CALwKUXAGJai/5ZFN3AoeLI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tsVbGCE4+FDSo2dMRWUq3erd+YzinatNluTwH0OVbCGgAEzhABXxD8u7YE6qMdSLX
	 rYkci+82vKH/eKt1HDF7LyByE2aAObtK66/287stL9Ouapuy1R2Zpi7m17fW6meRaE
	 QlRqH/ex3OvOYfgOJmnEBefI/T9FbUO9gKuCcuL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 440/877] nfp: hold IPsec RX state under the XArray lock
Date: Wed, 30 Sep 2026 17:22:31 +0200
Message-ID: <20260930152424.177278704@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sang-Hoon Choi <csh0052@gmail.com>

[ Upstream commit 1a983a4e14c635c40354be110cd9a1a5c94e01e6 ]

nfp_net_ipsec_rx() drops the XArray lock before taking a reference to the
xfrm_state it found. The delete path can erase the entry and drop the last
state reference in that interval. RX can then try to increment a zero
refcount after the state has been queued for destruction.

The driver queues firmware invalidation asynchronously; the delete path
does not wait for the command to complete or drain pending RX processing.

The XFRM garbage collector waits for an RCU grace period before freeing
the state. That delays reclamation but does not make acquiring a reference
from zero valid.

Take the xfrm_state reference before releasing the XArray lock so
xa_erase() cannot run between lookup and reference acquisition.

Fixes: 57f273adbcd4 ("nfp: add framework to support ipsec offloading")
Reported-by: Changyul Lee <lcy8047@gmail.com>
Signed-off-by: Sang-Hoon Choi <csh0052@gmail.com>
Link: https://patch.msgid.link/179001455912.44752.17153022439349797877.idr-bug-92@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/crypto/ipsec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
index 515069d5637b0..3925a00aeaf7e 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
@@ -637,11 +637,12 @@ int nfp_net_ipsec_rx(struct nfp_meta_parsed *meta, struct sk_buff *skb)
 
 	xa_lock(&nn->xa_ipsec);
 	x = xa_load(&nn->xa_ipsec, saidx);
+	if (x)
+		xfrm_state_hold(x);
 	xa_unlock(&nn->xa_ipsec);
 	if (!x)
 		return -EINVAL;
 
-	xfrm_state_hold(x);
 	sp->xvec[sp->len++] = x;
 	sp->olen++;
 	xo = xfrm_offload(skb);
-- 
2.53.0



