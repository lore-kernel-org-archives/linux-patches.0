Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033A544AB73;
	Tue, 21 Jul 2026 22:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671758; cv=none; b=cN+UNwhB0YhIDbdsEa4AZPevq9o5ZbyetSNGu4F/Hb535UmIhW+UE70gaUvG/2WHGw3CVaXdgdKYpY/lQUrJZUkNdKM8UUf6u4Pf7ppb01cSQ2eKuTSOSfMHrctb3RSANYJQPyW8mODnl5mPaqVrypRBz3zg9ddYe2nyg08/lso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671758; c=relaxed/simple;
	bh=c/7VmsvilK3ZoEfzhZ5kQf4QVSY7PDUMlAy+rQmf3fE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/mJvOFI0TVUV8EEM/EDtLqnIPTB8K9SMPWSxoR8Mpguh+dRDJmRFiz+msB9eeK2FhEylOORaccbD612yzuQQICoihqT1f1blXFGKsqyWjgVxteeVTCQjCI6y/csbaB6Ik2nbJWvcfqJyZKsFsSzQlHE1HqaE+Dn69GddA7ktFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CE919VOq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CE919VOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A64D1F000E9;
	Tue, 21 Jul 2026 22:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671756;
	bh=UNZeT38bjg9xte8G77dnkAyu3yeir70FeYcDW+LRGcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CE919VOqVBhOQQ8jDT6pnvPWfCXlEM+Z3RDeEHBbZkdQo/6wU2E6U4wU++olH+QEE
	 TKk5FJrBD2XfysWSsTX6ulg3siK96jdHiyvrV+bBSt2WY4UZG4whlkyfETIZ9Eu1+d
	 QGs8sFUoh+dzAmvZRL08DHpsM5rXm2jYV9UGlfC0=
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
Subject: [PATCH 5.15 368/843] tipc: fix UAF in tipc_l2_send_msg()
Date: Tue, 21 Jul 2026 17:20:03 +0200
Message-ID: <20260721152414.309607607@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8c2793181ee7b0..986b1fd8885447 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -484,6 +484,7 @@ void tipc_disable_l2_media(struct tipc_bearer *b)
 	dev = (struct net_device *)rtnl_dereference(b->media_ptr);
 	dev_remove_pack(&b->pt);
 	RCU_INIT_POINTER(dev->tipc_ptr, NULL);
+	RCU_INIT_POINTER(b->media_ptr, NULL);
 	synchronize_net();
 	dev_put(dev);
 }
-- 
2.53.0



