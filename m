Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065551;
	b=P+cBzRdmGRxwkYRH91Eot5bV22uJzsgLuRMOfFonVQNiLx3NQDgFep5Y1orcCIQ0y4iX
	 bymdxeGa/eQXUmRWDAO1Si+Y8+X/QpZfljgZEOsnDVEn36ng2yarIZAZj2iEW45Xk7881
	 P9VwDR1LIt4TkCsKU/Lxm4MAejt3uGSHQCq5EUqQoLT+0OBjoMG9onCmDLvN7I10DDjEr
	 BXlUe5q5IzpRtMPjmct3vdxSzMCs7CNTTJWnNgwJ2upPgLK+JYAvoYc0XesgdUwWZz8qE
	 aSwJ9JqxtFLmwuE/2uenmhCV3oNsF+duTpcG0pQTuHYLJ5Ydh1X4OM5JyO+0m1zan6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065551;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jFSSP8TWMCwcC98XjHtLzMKp+dZVvgs5mrypSNVipMw=;
	b=3GmfA6VvEDUxPrSl49t+1tGZrmH3GoP89yXMMYfUqWUcsANjAbviijteMRHVmOvEGOIC
	 nNaSm5pe11WqOQnUP58fuRzp4/a3nqykakMyWhdokqCqG7jAhHe16ZKqCMTSOkozRsu/H
	 H1BRVAi1C6vzUI2CIEjLzQ+JNOwyv1zZQ8KtT2Y+Tm8pKzmHVs+o5rY2xGs4kbxHor7Aa
	 IVoiDeZZ1c5MQIsoev8e5MWoeBZpdUIa2g53mPGQpESvROLhw6cvz4GXItOyQ7HBdoPM4
	 H7esg81ehZ+M0s1QsEcmEyyBriAB78dJrG6c4ItnrovtMkRHo25mgBgmmNUeljSpTDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nagcOZxl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692E3606A330;
	Sat,  7 Nov 2026 15:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nagcOZxl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D8C1F008A1;
	Sat,  7 Nov 2026 15:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065551;
	bh=jFSSP8TWMCwcC98XjHtLzMKp+dZVvgs5mrypSNVipMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nagcOZxlkmuXTQ9TyHdlVm961zXCg5ZbNKO+ym+013TuWmUEIBhtaNHgp5sIeXhNK
	 en3vwM7i3gfPETeCaXpBqP7EVnSaAI+Nubae8DeEYrGnyvC16IX1hQegPZxWPzHF+Q
	 00xVXQ0H9NSE6yilcC2v4eakfuppher5e+FPK+Dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1224/1257] apparmor: dont revalidate inherited files under files->file_lock
Date: Sat,  7 Nov 2026 08:58:40 -0500
Message-ID: <20261107135013.154613271@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 3e74b613db325..b52781e05a5a1 100644
--- a/security/apparmor/file.c
+++ b/security/apparmor/file.c
@@ -706,49 +706,50 @@ static void revalidate_tty(const struct cred *subj_cred, struct aa_label *label)
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



