Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065550;
	b=47Bbvx76CTIDCyNOPcU2V3QoW5Mza3tcgFz9eJUexnGPryFzAQs3hKDFOkwasBtUGzxh
	 Uwwzg9bGFP+jP0uMyAPloxjkN9jksMMsQoKWGcsmxkAiZFYz0nX7W6GuWJyHvv7VzsDsH
	 H79/+yZxpM0eX4fe8JEJHxwyfdjU8qxd1mlt1OKkhQoNyb5u6mdw3ScgKGU0m+iRbPGGw
	 4ww1nb2ayV0glev9IiPL/noUL1bsgE0cBFcnk9un0vPxpSrs5YmhBkEmVlyeAP17XB3CX
	 vxelIgM7MAT4je898mOqhNxS8WiMv6bVpxyvvCOIqacNBR1sfZc506B0cjKH+maoEXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065550;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=mTmW45QbuprZg95DqW1rmyZNg+XxaZY6JzwepZSjCTc=;
	b=D97iiDOsRxMG18zVfha8uf4GTaJlx47aOZFjcMQAbt6JSnSekgxFgeIWcnnPYEF7elv/
	 C5D3PnpYiQhHS9NjcmUDFQBCEkQX9QbKIKp+pNddkVjvK1TvjkW5+Iv4AAzEaFSrPVT9j
	 wYLD9TfZD2tOpQL+4o8Y1J+RUq5WokftqnF+hxGbPFC5suKpK8z5hThKd4NmAbOHOWkh4
	 S+OqpsPrLAgg+fcZIa7rstDwI7VI0Zs4Aj+TYtJtlLY+RHhUIPpyZY6hYPQU+GzTAEdSD
	 JV6zLHp1tD2O7yBCmJ4nSxX93zHKEkO/ajZoi38XsV9PFPxX29qvXwRp4I6Wo1GOMTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p0xslZPF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB7F606A330;
	Sat,  7 Nov 2026 15:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p0xslZPF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34F31F0089F;
	Sat,  7 Nov 2026 15:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065550;
	bh=mTmW45QbuprZg95DqW1rmyZNg+XxaZY6JzwepZSjCTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p0xslZPFqJfwu5D1+GS8nCPpAiaF5Cuuwx8RS8eTY+iAf287+EErLsQeXoOrlXzog
	 fqyajK6+5d+yid5VWipBrXQ1Tu54S22THXm21ttXzi6qjEq9sObQuVs7hJ/r16qWqP
	 MEjKQh6tuDVt9dAZGiTnXaLkzNEuWv/BMQya0vzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurelien@aurel32.net>,
	=?UTF-8?q?Fabian=20Gr=C3=BCnbichler?= <f.gruenbichler@proxmox.com>,
	Georgia Garcia <georgia.garcia@canonical.com>,
	=?UTF-8?q?Maxime=20B=C3=A9lair?= <maxime.belair@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1223/1257] apparmor: fix NULL ctx->peer derefs in unix socket ctx updates
Date: Sat,  7 Nov 2026 08:58:39 -0500
Message-ID: <20261107135013.129228864@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Bélair <maxime.belair@canonical.com>

[ Upstream commit 4de32fd05ce9e63b492899215ea929e7d306cdab ]

aa_unix_file_perm lazily refreshes the AppArmor context cached on a unix
socket. Two of the helpers it uses assume ctx->peer has already been set:

	update_peer_ctx ->  l = aa_label_merge(old, label, GFP_ATOMIC);
	update_sk_ctx   ->  } else if (aa_label_is_subset(plabel, old)) {

where @old is ctx->peer. Neither aa_label_merge nor aa_label_is_subset
allows NULL. So both fault on the aa_label->size load.

  BUG: kernel NULL pointer dereference, address: 000000000000004c
  RIP: 0010:__aa_label_next_not_in_set+0xb/0xd0
  Call Trace:
   aa_label_is_subset+0x3f/0x70
   aa_unix_file_perm+0x5e8/0x9d0
   aa_file_perm+0x45a/0x550
   apparmor_file_permission+0x44/0xb0
   security_file_permission+0x40/0x100
   rw_verify_area+0x56/0x180
   vfs_write+0x7c/0x480
   ksys_write+0xbf/0xf0

ctx->peer is only recorded for stream connections and socket pairs.
unix_dgram_connect sets unix_peer(sk) without going through that path,
so a connected AF_UNIX datagram socket has unix_peer(sk) set while
ctx->peer is still NULL, and the first write that needs revalidation
reaches the helpers above.

Both derefs date back to the Fixes: commit, but the update_sk_ctx() one
was dormant until commit 4483efe4f215 ("apparmor: fix shadowing of plabel
that prevents cache from being updated") stopped @plabel being shadowed,
which is why bisecting the oops lands there.

A NULL @old just means no peer label has been recorded yet, so install
the label directly instead of merging or comparing against it.

Fixes: 88fec3526e84 ("apparmor: make sure unix socket labeling is correctly updated.")
Cc: stable@vger.kernel.org
Reported-by: Aurelien Jarno <aurelien@aurel32.net>
Closes: https://bugs.debian.org/1145111
Tested-by: Fabian Grünbichler <f.gruenbichler@proxmox.com>
Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: Maxime Bélair <maxime.belair@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/af_unix.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/security/apparmor/af_unix.c b/security/apparmor/af_unix.c
index b908e744818c9..58c638830afc4 100644
--- a/security/apparmor/af_unix.c
+++ b/security/apparmor/af_unix.c
@@ -682,7 +682,7 @@ static void update_sk_ctx(struct sock *sk, struct aa_label *label,
 		if (old == plabel) {
 			rcu_assign_pointer(ctx->peer_lastupdate,
 					   aa_get_label(plabel));
-		} else if (aa_label_is_subset(plabel, old)) {
+		} else if (!old || aa_label_is_subset(plabel, old)) {
 			rcu_assign_pointer(ctx->peer_lastupdate,
 					   aa_get_label(plabel));
 			rcu_assign_pointer(ctx->peer, aa_get_label(plabel));
@@ -700,13 +700,17 @@ static void update_peer_ctx(struct sock *sk, struct aa_sk_ctx *ctx,
 	spin_lock(&unix_sk(sk)->lock);
 	old = rcu_dereference_protected(ctx->peer,
 					lockdep_is_held(&unix_sk(sk)->lock));
-	l = aa_label_merge(old, label, GFP_ATOMIC);
-	if (l) {
-		if (l != old) {
-			rcu_assign_pointer(ctx->peer, l);
-			aa_put_label(old);
-		} else
-			aa_put_label(l);
+	if (!old) {
+		rcu_assign_pointer(ctx->peer, aa_get_label(label));
+	} else {
+		l = aa_label_merge(old, label, GFP_ATOMIC);
+		if (l) {
+			if (l != old) {
+				rcu_assign_pointer(ctx->peer, l);
+				aa_put_label(old);
+			} else
+				aa_put_label(l);
+		}
 	}
 	spin_unlock(&unix_sk(sk)->lock);
 }
-- 
2.53.0



