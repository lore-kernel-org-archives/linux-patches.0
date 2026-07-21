Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2540D3EEAE2;
	Tue, 21 Jul 2026 18:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659944; cv=none; b=esm/Piz7qNlH0dH0PlmIEEVXYrD1V1aprGdRKesLgJYakGY+K8hQNuATu8gsGNcFT06PSCiTq17osn1xkuteWiX6ZGoyzF0eNgymXNsMpFUlUdv1gMeajouyjEEAvD1pSRJj7TgXOgKi2g5arVYOaHeZ9fdrtHC71HjlCQ6N2Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659944; c=relaxed/simple;
	bh=lscydcDsswnvi6l2jMd/YJzGP9EfvB6NQCvkOoQMdqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wz2ODpLJ7o7ObNVrEEnb2N9leqhTHtzZpcsG/OTyHC4OcZdztR8WCjAB4vhRJO6Fo5y8oQG4p2fw4RruE/hGl/smoJv7OEM/nZyeC0Ld5GY/PNWtdTS0JjhdyJgixT7pn691OvJjO7ISEb65mRhk16dcprTeiMXVK0mQutc7hGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KtLm8ir+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KtLm8ir+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9112A1F000E9;
	Tue, 21 Jul 2026 18:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659943;
	bh=MVTYecWcDeaYU0F924wa3MgyGtKq4b+TWhOSgakPB3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KtLm8ir+CouTQ5nbSRJYRFarfkkPA2wFg1Ku60a+v+5w/rYEem1nLX894bxGvgrnP
	 flyevdu4iCoB/m7ZLi2Y5ZLyL/D9kJf/8bQ98QonzS7flIaDcqq4bfmfjMzsPO62It
	 +oyHe908cdYfsyvuWQdfhhpecZs3wARghZwLn5KA=
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
Subject: [PATCH 7.1 0793/2077] tipc: fix UAF in tipc_l2_send_msg()
Date: Tue, 21 Jul 2026 17:07:46 +0200
Message-ID: <20260721152611.500039554@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index a3bd1ef17558a3..05dcd2f9e887a6 100644
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



