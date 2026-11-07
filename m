Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063773;
	b=mG38NeII93L4oaZxBOHlqs5Qg/IeQXmybb2wnucy7H7NqoN5i1FfuotCUHVS4oZLoW1q
	 n2NjzKSuUUeVoaFcZFkqfts8kyIopa9dsyvbcfthvrXi3qdBVLc+uSgTgDpUwYs3TZhZF
	 EyxRUVXrNWnPH0g0EHS+i+nYgV6NDBg9CzO+cGJNdg5OCHOf/oNfUr7TbWNBb9prvhMfL
	 SQyEfDpZ3B0kdRHGdE190VlEB+nIfIqDSTryuh0tdqrWSngJSNe0IYdEhcZyLHmcM1Rzp
	 LfIw21Pb0pxNeQv+ieT2RRpfgl3RGPQuHNs9PZvO67tB3it4wIGieUhf4kq2Tdr873w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063773;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rYBp90EDVuNn/K0Xn56xA5jJHyt7dqRCv/MCe1ywbNE=;
	b=EBTiDogpJg1Vg5rXWU9Y9wRuZCsASoCtTY8d393IJAdhczsoz8Rv9B2xHWzNVLo7Kg7g
	 nF/c4AE3cwqmlueyipKaVdwPUiU1VbdrYT3ggp4xtPG98/C36y5DTU5yPqwxOJC4sSnGF
	 ernuZe7gsdTLeLRu3CxpLYFFC4Iu1EIoLl06YYtQnLNJq6ueO5lVUOHpdWgyZHb3W56t4
	 FsjRAUPT3qg1d4blq0qgsOGPDbhQZjZtlTlNC1paFQ/eSPxEEFT+4JyOTBYNlDE44Nr/q
	 bPsg1UtSZwrPu9CSvDZGV0i+j79G98vu6JvCxkNgdq0m3Ffr76WHvrDtNNFqfM9/7Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LDVp6Iwz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2A860A2615;
	Sat,  7 Nov 2026 15:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LDVp6Iwz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800A91F0089F;
	Sat,  7 Nov 2026 15:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063772;
	bh=rYBp90EDVuNn/K0Xn56xA5jJHyt7dqRCv/MCe1ywbNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LDVp6Iwzullh5kQrnbaD4vwYQx3S46ZiC5fsBQIoC2mLgj06PlsZ4jWZjHqvJH+/L
	 RXlONnTS+vNmmHgzS4xnRlInJvJ/BVHPkgCRUXL1m6ZZp+YKnDBfyMA7izl92iF3ZW
	 qd2mnT9J5CbjF12wQJFc1zP5qlwDwQ26rRqdfxU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 846/869] apparmor: dont revalidate inherited files under files->file_lock
Date: Sat,  7 Nov 2026 08:58:48 -0500
Message-ID: <20261107134921.511410668@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Georgia Garcia <georgia.garcia@canonical.com>

[ Upstream commit a913281f600157aa036b7c02afbb18a0ac115187 ]

aa_inherit_files() revalidates inherited files on exec using
iterate_fd(), which calls the callback with files->file_lock held,
so the revalidation is done with IN_ATOMIC. However the unix socket
mediation path can sleep: aa_unix_file_perm() drops a ref on the
peer's path with path_put(), and unix_fs_perm() -> aa_path_perm()
allocates a buffer with aa_get_buffer(false), resulting in

  BUG: sleeping function called from invalid context at fs/dcache.c:1039
  ...
   dput.part.0+0x24/0x180
   path_put+0x2c/0x60
   aa_unix_file_perm+0x42a/0x17b0
   aa_file_perm+0xcd3/0x1060
   match_file+0x10b/0x190
   iterate_fd+0xe6/0x280
   aa_inherit_files+0x250/0x4f0

Only grab a ref on each file under iterate_fd(), and revalidate it
after the lock is dropped, so revalidation is done with no locks held
and does not need to be atomic. Denied fds are still replaced with
/dev/null, or closed if it can not be opened.

Fixes: b1aea2c19607 ("apparmor: fix race in unix socket mediation when peer_path is used")
Cc: stable@vger.kernel.org
Signed-off-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/file.c | 61 ++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 30 deletions(-)

diff --git a/security/apparmor/file.c b/security/apparmor/file.c
index 534a93520c569..3176e5623d3d4 100644
--- a/security/apparmor/file.c
+++ b/security/apparmor/file.c
@@ -691,49 +691,50 @@ static void revalidate_tty(const struct cred *subj_cred, struct aa_label *label)
 		no_tty();
 }
 
-struct cred_label {
-	const struct cred *cred;
-	struct aa_label *label;
-};
-
-static int match_file(const void *p, struct file *file, unsigned int fd)
+/*
+ * iterate_fd() callback, called with files->file_lock held: grab a ref
+ * on the next file so it can be revalidated without the lock held.
+ */
+static int get_next_file(const void *p, struct file *file, unsigned int fd)
 {
-	struct cred_label *cl = (struct cred_label *)p;
+	*(struct file **)p = get_file(file);
 
-	if (aa_file_perm(OP_INHERIT, cl->cred, cl->label, file,
-			 aa_map_file_to_perms(file), IN_ATOMIC))
-		return fd + 1;
-	return 0;
+	return fd + 1;
 }
 
-
 /* based on selinux's flush_unauthorized_files */
 void aa_inherit_files(const struct cred *cred, struct files_struct *files)
 {
 	struct aa_label *label = aa_get_newest_cred_label(cred);
-	struct cred_label cl = {
-		.cred = cred,
-		.label = label,
-	};
-	struct file *devnull = NULL;
-	unsigned int n;
+	struct file *devnull = NULL, *file;
+	bool devnull_tried = false;
+	unsigned int n = 0;
 
 	revalidate_tty(cred, label);
 
-	/* Revalidate access to inherited open files. */
-	n = iterate_fd(files, 0, match_file, &cl);
-	if (!n) /* none found? */
-		goto out;
-
-	devnull = dentry_open(&aa_null, O_RDWR, cred);
-	if (IS_ERR(devnull))
-		devnull = NULL;
-	/* replace all the matching ones with this */
-	do {
+	/*
+	 * Revalidate access to inherited open files. Each file is
+	 * revalidated holding only a reference to it, with no locks
+	 * held, as revalidation may sleep (e.g. unix socket mediation
+	 * dropping path refs, or allocating path buffers).
+	 */
+	while ((n = iterate_fd(files, n, get_next_file, &file)) != 0) {
+		int error = aa_file_perm(OP_INHERIT, cred, label, file,
+					 aa_map_file_to_perms(file), false);
+
+		fput(file);
+		if (!error)
+			continue;
+		if (!devnull_tried) {
+			devnull_tried = true;
+			devnull = dentry_open(&aa_null, O_RDWR, cred);
+			if (IS_ERR(devnull))
+				devnull = NULL;
+		}
+		/* replace the denied fd (n - 1) with devnull, or close it */
 		replace_fd(n - 1, devnull, 0);
-	} while ((n = iterate_fd(files, n, match_file, &cl)) != 0);
+	}
 	if (devnull)
 		fput(devnull);
-out:
 	aa_put_label(label);
 }
-- 
2.53.0



