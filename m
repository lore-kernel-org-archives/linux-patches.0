Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD218471271;
	Tue, 21 Jul 2026 18:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656873; cv=none; b=h9I5HswT9ijWlmoI8u7stflFd+HyMbbaSQiLTHRMhmRVjJ4ylN+vx9neUO8J5y/R46pXZsca6+nP5mYLB93pSCnPTTcQ7EM/MTg5SNIzVSH76eZG3TsNjeuc97l1z7zDOe9wxMoTG2RLiSfX3EP25pmclhJjIBRLtLtELFStm+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656873; c=relaxed/simple;
	bh=1ubtWrElNZ7DmGxSrqqaltd9x2niZrYYWBLMAjBPwtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zd2TfnPQut7nTAdYcuEkzuz1+8NtSFdPFpQDNHqxCeyzjs5+8enSxqaZdcpbtViF4lPVD56q3MpdjaemaD4KNLIUcaURZqCqYvugW1o5kMnc91jHVIIYQFMxY7KDQqWVtSzWc5EST0uTLDmdtNjBkJCXN0w0IeUXyhz8QPWvhnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CvHp4yx5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CvHp4yx5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDF71F000E9;
	Tue, 21 Jul 2026 18:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656872;
	bh=Bd1wRySnyY8mJespjUOwphZRChgrmqx734ws0wwaypk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CvHp4yx5E9934k2oVECHyAdehwAqpHjxg6+KnqceAXCZJHNlTGPm7olQAnoS71O6V
	 iXPit4sBA9xpD7YdbWrK0Jb+/LsbATxpG1uxLmhuxx7DyzzSCO7oj1ku2GYKCb+fyO
	 SmpoQvv3EmxlsPEaTgxBMsqSgUMkCJwpIhebFy34=
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
Subject: [PATCH 6.18 0550/1611] tipc: fix UAF in tipc_l2_send_msg()
Date: Tue, 21 Jul 2026 17:11:06 +0200
Message-ID: <20260721152527.748210657@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



