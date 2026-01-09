Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CC331A7EA;
	Fri,  9 Jan 2026 11:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959376; cv=none; b=FDfYJhURcUY6wZcXzMexlWoZxA4S2W8C905JwwVyt7yBxqOW4j7KkIE94+LSjjlV0LdanIkOFFRqV6RUkxohrv0g4GGpp1qeJMgDy0Zdj05X1v3D+4JQ7PqgrNUty5HkkABlCNwaDMYERPypnsl5m2ZWlpSzNegNlxouLkT67Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959376; c=relaxed/simple;
	bh=u7cbSRmpmXJ54MZx4dcB8bmqZEJKaSh/wdYtquhnCBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSPZK1Kn4s9GSCx9PC+aLpR68RsfE2h/V8OjPf8rhZs7kwXp4fUxGk2Fq8YRprLpJVCjt+A+9m0eBRvUVoHFR91kDP/D7bVDDfmLZBYyh2SMuaXZbrhMBUAmImSkM+0waSTX0PP16u//8UgjtM/wAlU45iEUG2l1z6W2pK2TUNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mM1PdJZ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mM1PdJZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC7CC4CEF1;
	Fri,  9 Jan 2026 11:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959376;
	bh=u7cbSRmpmXJ54MZx4dcB8bmqZEJKaSh/wdYtquhnCBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mM1PdJZ4sV71SXppQIbUqpSHcbeYmj2O3MZT9W9hzGSOTP/UlBlpcD6f3oSXiCtnK
	 ohtteII/e6a8A4Hteyr1qYf/HXH/1ZzICjDcdpSTlFtkkvhDXWPKOxa8qVIvvDDqEO
	 NrdWhrzzr4zch+2NgoFaJBzr4C3VCniNhM14WZps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+999eb23467f83f9bf9bf@syzkaller.appspotmail.com,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/737] xfrm: also call xfrm_state_delete_tunnel at destroy time for states that were never added
Date: Fri,  9 Jan 2026 12:32:22 +0100
Message-ID: <20260109112134.118207633@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b0e2958342ad2..3d806492e1de9 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -521,6 +521,7 @@ void xfrm_state_free(struct xfrm_state *x)
 }
 EXPORT_SYMBOL(xfrm_state_free);
 
+static void xfrm_state_delete_tunnel(struct xfrm_state *x);
 static void xfrm_state_gc_destroy(struct xfrm_state *x)
 {
 	hrtimer_cancel(&x->mtimer);
@@ -535,6 +536,7 @@ static void xfrm_state_gc_destroy(struct xfrm_state *x)
 	kfree(x->preplay_esn);
 	if (x->type_offload)
 		xfrm_put_type_offload(x->type_offload);
+	xfrm_state_delete_tunnel(x);
 	if (x->type) {
 		x->type->destructor(x);
 		xfrm_put_type(x->type);
@@ -731,7 +733,6 @@ void __xfrm_state_destroy(struct xfrm_state *x)
 }
 EXPORT_SYMBOL(__xfrm_state_destroy);
 
-static void xfrm_state_delete_tunnel(struct xfrm_state *x);
 int __xfrm_state_delete(struct xfrm_state *x)
 {
 	struct net *net = xs_net(x);
-- 
2.51.0



