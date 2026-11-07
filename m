Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063760;
	b=ntp8ABOJkkjvBpMeCGVG4Q8r/6zU5IzV7vA1YLxN80iYW4ZryA8kNUJtXplxW79hk6Nw
	 adsg2po6ZsdNT4fWuztIFuRZXrSYFUu5kKvIGBqH7u0Wm2x9YBXr4G4BmdrzUTjpa/9ci
	 CS8uR6od88jRfXXUJ40e6kqpOf3WaCFZIGAwGj0N1hWMTZWcdf6B/hn0UrnLLmi23UZEz
	 JMAvyws/bNRol82VYjPjU9Pp4c9PrPaPByMD+tiEbPNfqyxzZpGPwTf9VHWJrMr1V/ndu
	 W2+PF6wiqIPUpxovv8VWgSYamrvtb4p/rzI6jHG4ZXIEkpqq7P9slZm2BZUvntI2k7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063760;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=oTaFyWjA1M3iMBiNvXl83wEuMc0ASujNG2r3bMLVONc=;
	b=cia/im4OdSV1xbDJgiiM0i/RD7QE4IhA0rl887p65uxf+YTxd7ZSqIEKoOF14/ooQ/4G
	 BVYZs0iMmjVzMgV1HlDABKy9s3FjP/n9kxmWnwcD1E2QKEgjyPewTqpxKSLTWZsiRttp+
	 t+xuyNR6pLurbrMMNbgIZ64D5vZfOXIVRtug32IcmsX9pvkXjBLKjoxdX5M/qEZweEfcw
	 QBLTDEMJyiTAeGj+M5stSx3rFHtPIMyo15qJjGyktBcqlx3yXhbG6MWlytJMoLKnVqhTh
	 jeaowJXiAY2+46NRkSJUwI+dn+72U0TDzoZhrhHcfzoWM7bbqMDbtTHq6g2fZVxZOWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WdNPUUvg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71DB606D81B;
	Sat,  7 Nov 2026 15:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WdNPUUvg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B59B1F0089F;
	Sat,  7 Nov 2026 15:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063759;
	bh=oTaFyWjA1M3iMBiNvXl83wEuMc0ASujNG2r3bMLVONc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WdNPUUvgfXIKZeiihoyOtb1nb25QgFRTQkCQaJVa5an4wF3EjcICqhWMsxaigysN0
	 DXXxDVw2hXCgeu05hCd1BzeYCObXVuWdqStP5zIiof/ofj0i/h+AP8Wydb61hGUDnW
	 VxYty99pGsIs5YklbAF7sHKM2K8oME4/RvETHQEs=
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
Subject: [PATCH 6.18 845/869] apparmor: fix NULL ctx->peer derefs in unix socket ctx updates
Date: Sat,  7 Nov 2026 08:58:47 -0500
Message-ID: <20261107134921.484764092@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 834a3b1c2f0af..aa2b31d5598cd 100644
--- a/security/apparmor/af_unix.c
+++ b/security/apparmor/af_unix.c
@@ -676,7 +676,7 @@ static void update_sk_ctx(struct sock *sk, struct aa_label *label,
 		if (old == plabel) {
 			rcu_assign_pointer(ctx->peer_lastupdate,
 					   aa_get_label(plabel));
-		} else if (aa_label_is_subset(plabel, old)) {
+		} else if (!old || aa_label_is_subset(plabel, old)) {
 			rcu_assign_pointer(ctx->peer_lastupdate,
 					   aa_get_label(plabel));
 			rcu_assign_pointer(ctx->peer, aa_get_label(plabel));
@@ -694,13 +694,17 @@ static void update_peer_ctx(struct sock *sk, struct aa_sk_ctx *ctx,
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



