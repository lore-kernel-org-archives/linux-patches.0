Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BA63B8BAE;
	Thu, 15 Jan 2026 17:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497275; cv=none; b=hGWvrWRiL9up0hlOQ7/QOEmhSAyF8li+tS2dtmhE9taRkUwC55BZZ3isx2RTfMocdwA3tDHkQo9Tp9YbExEubt4FE2tVwrXor8mutc0eG8EPtJtHQTJTzR9ejGxzIBwE8yusdI1sG9lrWLpBP95ZUlrnbK+tktN3ThDCyDIRTNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497275; c=relaxed/simple;
	bh=aHqrOLUpm/ikbH96BmFcFIkgHlDpoQpKudoYRUzaEh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5Y6DRS6fRKlnaz8sRG/MSjfPIB9OiydI0kYAJuKcJB7XxoKlElW47FQ9dYsXXhV1zf6tfHtHM/+V8JVze2q8H73aMP9UExjEGf+0lQGV/E/hTNiFxwSkPQGZrMPy+Ky3Bn1bGq4ZmyU9BtUYbbV/o5AKWl8/H3SeM4xmLF5BcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rYLlgSXD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rYLlgSXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1AA3C116D0;
	Thu, 15 Jan 2026 17:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497275;
	bh=aHqrOLUpm/ikbH96BmFcFIkgHlDpoQpKudoYRUzaEh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rYLlgSXDmg2ftsFGTFhiL2aoZ2Ed7N3ZZn5gk9tHz5p12H81HbhMul7Az2T+iji2C
	 vEwD6Wb7fy6XFCtEMzStzWMJ7VQOXQb1wc/ilCl7M6rTNOqFm68yp7C3fR0JzIOWB6
	 Ul/QqwPWCJ0oxcJhz3wGGLC8ldR4W571xsF7YYGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+999eb23467f83f9bf9bf@syzkaller.appspotmail.com,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/554] xfrm: also call xfrm_state_delete_tunnel at destroy time for states that were never added
Date: Thu, 15 Jan 2026 17:41:09 +0100
Message-ID: <20260115164246.359026455@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 10deb69864840ccf96b00ac2ab3a2055c0c04721 ]

In commit b441cf3f8c4b ("xfrm: delete x->tunnel as we delete x"), I
missed the case where state creation fails between full
initialization (->init_state has been called) and being inserted on
the lists.

In this situation, ->init_state has been called, so for IPcomp
tunnels, the fallback tunnel has been created and added onto the
lists, but the user state never gets added, because we fail before
that. The user state doesn't go through __xfrm_state_delete, so we
don't call xfrm_state_delete_tunnel for those states, and we end up
leaking the FB tunnel.

There are several codepaths affected by this: the add/update paths, in
both net/key and xfrm, and the migrate code (xfrm_migrate,
xfrm_state_migrate). A "proper" rollback of the init_state work would
probably be doable in the add/update code, but for migrate it gets
more complicated as multiple states may be involved.

At some point, the new (not-inserted) state will be destroyed, so call
xfrm_state_delete_tunnel during xfrm_state_gc_destroy. Most states
will have their fallback tunnel cleaned up during __xfrm_state_delete,
which solves the issue that b441cf3f8c4b (and other patches before it)
aimed at. All states (including FB tunnels) will be removed from the
lists once xfrm_state_fini has called flush_work(&xfrm_state_gc_work).

Reported-by: syzbot+999eb23467f83f9bf9bf@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=999eb23467f83f9bf9bf
Fixes: b441cf3f8c4b ("xfrm: delete x->tunnel as we delete x")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 0e2e13c62e6b7..8287dc73e839d 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -497,6 +497,7 @@ void xfrm_state_free(struct xfrm_state *x)
 }
 EXPORT_SYMBOL(xfrm_state_free);
 
+static void xfrm_state_delete_tunnel(struct xfrm_state *x);
 static void xfrm_state_gc_destroy(struct xfrm_state *x)
 {
 	hrtimer_cancel(&x->mtimer);
@@ -511,6 +512,7 @@ static void xfrm_state_gc_destroy(struct xfrm_state *x)
 	kfree(x->preplay_esn);
 	if (x->type_offload)
 		xfrm_put_type_offload(x->type_offload);
+	xfrm_state_delete_tunnel(x);
 	if (x->type) {
 		x->type->destructor(x);
 		xfrm_put_type(x->type);
@@ -670,7 +672,6 @@ void __xfrm_state_destroy(struct xfrm_state *x)
 }
 EXPORT_SYMBOL(__xfrm_state_destroy);
 
-static void xfrm_state_delete_tunnel(struct xfrm_state *x);
 int __xfrm_state_delete(struct xfrm_state *x)
 {
 	struct net *net = xs_net(x);
-- 
2.51.0



