Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF72F5FF18;
	Tue, 13 Feb 2024 17:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845982; cv=none; b=Gk4C89HQpsmhkYUUPWz0XBNAmfWySS026Le/RLhffueZhmtcQ4eswoza1ECQeLApa79YTa/z4UEogvaG/lDdfeU/5vhRX8aT3s3fZWPwDWhSN2e7eG5OgBTbnBu4z+akHe+73BbeBxgBXHdtL/5FVrUa6OtesWHJGYgJ52/YgsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845982; c=relaxed/simple;
	bh=eTCzPHrMn9xE1RAMgiKkIagDqbA0L5GC7xjLxY88v9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdfZQOwTM9Jo9ioMXVuG6pr8QG5hkAIuJ3NWx7+m7zCfLiboYkSrGbgP+cAdQeHSIgbRSODdGdXZtPOWTynWZqkhoJNNC47dHVP3aHveJEyKIbjo9btBg6DlWqHUikqTVBhWwnO73Hr0aF1qIKrjZ/fi5ZZUkwNrqnDNllsjQY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g9/e0PO/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g9/e0PO/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B7CC433C7;
	Tue, 13 Feb 2024 17:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845982;
	bh=eTCzPHrMn9xE1RAMgiKkIagDqbA0L5GC7xjLxY88v9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g9/e0PO/zOPcEAPqFS+dkrBX9UqUfJbORS2IBTA0zuuq88mM+xWp5xfSBqAQtDThS
	 he/pOCD6xX5ju/sr/OuCqWLq2AxwlxXMjmHY69hfw7K+9PEGzv17Fi49xW3L6jAT4v
	 9hmLQLrNs40+igBCPhaSR4ZAk/KLFkL/S++NFYSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 6.7 110/124] new helper: user_path_locked_at()
Date: Tue, 13 Feb 2024 18:22:12 +0100
Message-ID: <20240213171856.945026908@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 74d016ecc1a7974664e98d1afbf649cd4e0e0423 upstream.

Equivalent of kern_path_locked() taking dfd/userland name.
User introduced in the next commit.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namei.c            |   16 +++++++++++++---
 include/linux/namei.h |    1 +
 2 files changed, 14 insertions(+), 3 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2573,13 +2573,13 @@ static int filename_parentat(int dfd, st
 }
 
 /* does lookup, returns the object with parent locked */
-static struct dentry *__kern_path_locked(struct filename *name, struct path *path)
+static struct dentry *__kern_path_locked(int dfd, struct filename *name, struct path *path)
 {
 	struct dentry *d;
 	struct qstr last;
 	int type, error;
 
-	error = filename_parentat(AT_FDCWD, name, 0, path, &last, &type);
+	error = filename_parentat(dfd, name, 0, path, &last, &type);
 	if (error)
 		return ERR_PTR(error);
 	if (unlikely(type != LAST_NORM)) {
@@ -2598,12 +2598,22 @@ static struct dentry *__kern_path_locked
 struct dentry *kern_path_locked(const char *name, struct path *path)
 {
 	struct filename *filename = getname_kernel(name);
-	struct dentry *res = __kern_path_locked(filename, path);
+	struct dentry *res = __kern_path_locked(AT_FDCWD, filename, path);
 
 	putname(filename);
 	return res;
 }
 
+struct dentry *user_path_locked_at(int dfd, const char __user *name, struct path *path)
+{
+	struct filename *filename = getname(name);
+	struct dentry *res = __kern_path_locked(dfd, filename, path);
+
+	putname(filename);
+	return res;
+}
+EXPORT_SYMBOL(user_path_locked_at);
+
 int kern_path(const char *name, unsigned int flags, struct path *path)
 {
 	struct filename *filename = getname_kernel(name);
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -66,6 +66,7 @@ extern struct dentry *kern_path_create(i
 extern struct dentry *user_path_create(int, const char __user *, struct path *, unsigned int);
 extern void done_path_create(struct path *, struct dentry *);
 extern struct dentry *kern_path_locked(const char *, struct path *);
+extern struct dentry *user_path_locked_at(int , const char __user *, struct path *);
 int vfs_path_parent_lookup(struct filename *filename, unsigned int flags,
 			   struct path *parent, struct qstr *last, int *type,
 			   const struct path *root);


