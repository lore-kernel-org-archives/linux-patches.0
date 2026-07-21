Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4899F3E49CF;
	Tue, 21 Jul 2026 18:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657360; cv=none; b=JWqduhtUhUBAF6Bw5hXoRlrRYDWTetu3PDpJuLC+hKQtIe4fTTLdsLKWguHj3tj+33g9ukVgoiJF7oUgIzoflb1+2VRabjN/tTjVNwsCZqgOW/GRnc+BRvrJgyB3mIGyrR88pp4EUs+KXifw/uW02wiChYJCShDNf4AYUQchoMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657360; c=relaxed/simple;
	bh=DW6mC5VN2h/9OwNF5CVmGh9GK0sdABIluUS2NvX+l3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g45eDPd0r14hZoJGB9CuTXeNddpOs1NdfjyEboyjV07VG3uyQqArM5QD5IrSQjGeE2lWjqI7fKGJzNsKB5UDxYRG2c+bXq2ozUYjedVPz9CdMzKv9aXtFDMhJt3hZ9RxOPGgdT8ZbZ+Mq+TGpKy0GLLxkGz9U0qYnNUNkRhX06w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQpZ7/Ad; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQpZ7/Ad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB8B1F00A3A;
	Tue, 21 Jul 2026 18:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657359;
	bh=9jW+X3OLag4OZFItW8cB5qTRG7lxoeTGPOoHIURG0HE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sQpZ7/Ad7zwGLPRHneMRvB7PGGXyfmTOdFqxsJNnDFnoNVq9pPlunAFa5vSxj5qiP
	 QuLvFXYrP3PoWZl00eq/0mWabuzaCzPxzg/gU85jTnZwQPU0m16f3Bl/VRb5Kh9j4q
	 O62//UDQicWt98KdVnK1O1Oen+RNvgfxmQ5qhCM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0734/1611] apparmor: fix race in unix socket mediation when peer_path is used
Date: Tue, 21 Jul 2026 17:14:10 +0200
Message-ID: <20260721152531.889853586@linuxfoundation.org>
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

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit b1aea2c1960771a276d7e68c7424168eccd0c3da ]

The holding a reference to the peer_sk is not enough to ensure access
to the peer sk path. Accessing the path outside of the state lock
allows for a race with unix_release_sock(). Fix this by taking the
state lock and getting a reference to the path under lock.

Ideally for connected sockets we would cache this information so we
don't have to take the lock here. But for now just fix the race.

Fixes: bc6e5f6933b8e ("apparmor: Remove use of the double lock")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/af_unix.c | 64 ++++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 29 deletions(-)

diff --git a/security/apparmor/af_unix.c b/security/apparmor/af_unix.c
index 7757829188d603..81cba79f7aa237 100644
--- a/security/apparmor/af_unix.c
+++ b/security/apparmor/af_unix.c
@@ -748,41 +748,47 @@ int aa_unix_file_perm(const struct cred *subj_cred, struct aa_label *label,
 	if (!peer_sk)
 		goto out;
 
-	peer_addr = aa_sunaddr(unix_sk(peer_sk), &peer_addrlen);
-
-	struct path peer_path;
-
-	peer_path = unix_sk(peer_sk)->path;
-	if (!is_sk_fs && is_unix_fs(peer_sk)) {
-		last_error(error,
-			   unix_fs_perm(op, request, subj_cred, label,
-					is_unix_fs(peer_sk) ? &peer_path : NULL));
-	} else if (!is_sk_fs) {
-		struct aa_sk_ctx *pctx = aa_sock(peer_sk);
-
-		rcu_read_lock();
-		plabel = aa_get_newest_label(pctx->label);
-		rcu_read_unlock();
-		/* no fs check of aa_unix_peer_perm because conditions above
-		 * ensure they will never be done
-		 */
-		last_error(error,
-			xcheck(unix_peer_perm(subj_cred, label, op,
+	if (!is_sk_fs) {
+		bool is_peer_fs = is_unix_fs(peer_sk);
+
+		peer_addr = aa_sunaddr(unix_sk(peer_sk), &peer_addrlen);
+		if (is_peer_fs) {
+			struct path peer_path;
+
+			unix_state_lock(peer_sk);
+			peer_path = unix_sk(peer_sk)->path;
+			if (peer_path.dentry)
+				path_get(&peer_path);
+			unix_state_unlock(peer_sk);
+
+			last_error(error,
+				   unix_fs_perm(op, request, subj_cred, label,
+						&peer_path));
+			if (peer_path.dentry)
+				path_put(&peer_path);
+		} else {
+			struct aa_sk_ctx *pctx = aa_sock(peer_sk);
+
+			rcu_read_lock();
+			plabel = aa_get_newest_label(pctx->label);
+			rcu_read_unlock();
+			/* no fs check of aa_unix_peer_perm because conditions
+			 * above ensure they will never be done
+			 */
+			last_error(error,
+				xcheck(unix_peer_perm(subj_cred, label, op,
 					      MAY_READ | MAY_WRITE, sock->sk,
 					      is_sk_fs ? &path : NULL,
 					      peer_addr, peer_addrlen,
-					      is_unix_fs(peer_sk) ?
-							&peer_path : NULL,
-					      plabel),
-			       unix_peer_perm(file->f_cred, plabel, op,
+					      NULL, plabel),
+				       unix_peer_perm(file->f_cred, plabel, op,
 					      MAY_READ | MAY_WRITE, peer_sk,
-					      is_unix_fs(peer_sk) ?
-							&peer_path : NULL,
-					      addr, addrlen,
+					      NULL, addr, addrlen,
 					      is_sk_fs ? &path : NULL,
 					      label)));
-		if (!error && !__aa_subj_label_is_cached(plabel, label))
-			update_peer_ctx(peer_sk, pctx, label);
+			if (!error && !__aa_subj_label_is_cached(plabel, label))
+				update_peer_ctx(peer_sk, pctx, label);
+		}
 	}
 	sock_put(peer_sk);
 
-- 
2.53.0



