Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B6F35DA40;
	Tue, 21 Jul 2026 19:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662297; cv=none; b=prRXhCrK+LpxpW/4ZgEr26fwv5DarH/b6eam4vmGhvAnBFRCprNA2k8LiXt42CEm3cfNs4E2jkRfn7djxKAocFmGls+84VeesuBuobexEYA8RpvYdLeCz7cnlf/uExqqfDGci07VEmyUnzoJkkIdsiQVoXYazJAwOx5PKw68EPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662297; c=relaxed/simple;
	bh=e1lFhPRuaZE50Bl2i82FrglRXOsYyBX3klAqE0MBsQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SieCWURdbWOMVt62d448vbhzRPFuiE9lwhXasGK3BroZ4qNgXcRKaEzIuNrf0HcMGFQc8IHccpIOENt1RFFnnumsrrDNeYQtezT98EZPbpTvh8F2CTZMiKOJwpda8FRByzPnHObGNfFyiMNJ9Tti09IEpolBsTAVX5BdP9tlCyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZZJfksZq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZJfksZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC281F000E9;
	Tue, 21 Jul 2026 19:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662296;
	bh=T3Ox65RCveeW6inugYs9Ys36gwbodJGSDIxVaRJE+ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZZJfksZqC2ZKBIF/zS84iJYV2my6FIf9iSiBnREkhfmWoI/PJLgMwdzM7EH9DfuHl
	 havieTZEJqGS5e2hTxqi3IY6cFqdrId/mzblm+TYdLpcwFnHwKZxxta4QGSkay+6SX
	 EDyUqAf8l4xgGPyUPWAoIvSO0HEsOceO9Q/7y2nM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+64ec81389cbad56a8c35@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jon Maloy <jmaloy@redhat.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0391/1276] tipc: fix UAF in tipc_l2_send_msg()
Date: Tue, 21 Jul 2026 17:13:54 +0200
Message-ID: <20260721152454.857307532@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f4c3d89fc986b0da196ddfc6cfe0ea5d5d08bec6 ]

Syzbot reported a slab-use-after-free in ipvlan_hard_header() when
called from tipc_l2_send_msg().

The root cause is that tipc_disable_l2_media() calls synchronize_net()
while b->media_ptr is still valid. This allows concurrent RCU readers
to obtain the device pointer after synchronize_net() has finished.
The pointer is cleared later in bearer_disable(), but without any
subsequent synchronization, allowing the device to be freed while
still in use by readers.

Fix this by clearing b->media_ptr in tipc_disable_l2_media() before
calling synchronize_net().

This is safe to do now because the call order in bearer_disable()
was reversed in 0d051bf93c06 ("tipc: make bearer packet filtering generic")
to call tipc_node_delete_links() (which needs the pointer) before
disable_media().

Fixes: 282b3a056225 ("tipc: send out RESET immediately when link goes down")
https: //lore.kernel.org/netdev/6a2c1007.428ffe26.258b27.015d.GAE@google.com/T/#u
Reported-by: syzbot+64ec81389cbad56a8c35@syzkaller.appspotmail.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jon Maloy <jmaloy@redhat.com>
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Link: https://patch.msgid.link/20260612135949.4010482-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/bearer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index ae1ddbf7185392..8866a3d713132c 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -482,6 +482,7 @@ void tipc_disable_l2_media(struct tipc_bearer *b)
 	dev = (struct net_device *)rtnl_dereference(b->media_ptr);
 	dev_remove_pack(&b->pt);
 	RCU_INIT_POINTER(dev->tipc_ptr, NULL);
+	RCU_INIT_POINTER(b->media_ptr, NULL);
 	synchronize_net();
 	dev_put(dev);
 }
-- 
2.53.0



