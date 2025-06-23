Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E58E221FBE;
	Mon, 23 Jun 2025 21:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715159; cv=none; b=Eb/wIpfbs4QPWq6zgLOvOLZPG64snTgyUJdYl0+slw52k5mLNz0UuzRSV/Sz+wZ7zFQVc5UQjKlzmdTyZXgxv4qu7jrL1Q1UyAPkZUCuHcif4yAhzD/f60yQ5cWrfiijOWl0o/U4FM34WFKv+NiueS3EtpE7ocZrL3J50QjrA2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715159; c=relaxed/simple;
	bh=k05DgeHj4OmnQgDQr9g2z11ug3mxe8YJgjvOQ/Can6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JluF6VFGGnkU+XaKgXL8SRzGdpblCpwZsbwW83FWkAXyERs0xo3Ulb0DyxQ4f+8swI7zAlwaTm/knu/TXOmAOrT0Fv+u6dK2BTJREZCI7IXevqYHIzLUmHIMThi0FlCgBWuqUQxEwg5zqlX2j3tJLiZgbM0iIt+Sq6NY8yXED4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v3bRlKPl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v3bRlKPl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D20C4CEEA;
	Mon, 23 Jun 2025 21:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715159;
	bh=k05DgeHj4OmnQgDQr9g2z11ug3mxe8YJgjvOQ/Can6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v3bRlKPlIKddNbQcVkh43CoezPj/jXUqBVMjmj2F0diu8NC5jodgjB/yC0/1yrl2G
	 WY6X6PXayAAKw0hqJiPPT7Bw3ulKOXfWmyhe+ehTBf+8kZtv3iSU6IUAFJTzuwOrML
	 /rghQ1RKbksmZ2xCPecd4F4bafN529pVTmVMTcWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.15 462/592] smb: improve directory cache reuse for readdir operations
Date: Mon, 23 Jun 2025 15:07:00 +0200
Message-ID: <20250623130711.416285152@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bharath SM <bharathsm.hsk@gmail.com>

commit 72dd7961a4bb4fa1fc456169a61dd12e68e50645 upstream.

Currently, cached directory contents were not reused across subsequent
'ls' operations because the cache validity check relied on comparing
the ctx pointer, which changes with each readdir invocation. As a
result, the cached dir entries was not marked as valid and the cache was
not utilized for subsequent 'ls' operations.

This change uses the file pointer, which remains consistent across all
readdir calls for a given directory instance, to associate and validate
the cache. As a result, cached directory contents can now be
correctly reused, improving performance for repeated directory listings.

Performance gains with local windows SMB server:

Without the patch and default actimeo=1:
 1000 directory enumeration operations on dir with 10k files took 135.0s

With this patch and actimeo=0:
 1000 directory enumeration operations on dir with 10k files took just 5.1s

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cached_dir.h |    8 ++++----
 fs/smb/client/readdir.c    |   28 +++++++++++++++-------------
 2 files changed, 19 insertions(+), 17 deletions(-)

--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -21,10 +21,10 @@ struct cached_dirent {
 struct cached_dirents {
 	bool is_valid:1;
 	bool is_failed:1;
-	struct dir_context *ctx; /*
-				  * Only used to make sure we only take entries
-				  * from a single context. Never dereferenced.
-				  */
+	struct file *file; /*
+			    * Used to associate the cache with a single
+			    * open file instance.
+			    */
 	struct mutex de_mutex;
 	int pos;		 /* Expected ctx->pos */
 	struct list_head entries;
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -850,9 +850,9 @@ static bool emit_cached_dirents(struct c
 }
 
 static void update_cached_dirents_count(struct cached_dirents *cde,
-					struct dir_context *ctx)
+					struct file *file)
 {
-	if (cde->ctx != ctx)
+	if (cde->file != file)
 		return;
 	if (cde->is_valid || cde->is_failed)
 		return;
@@ -861,9 +861,9 @@ static void update_cached_dirents_count(
 }
 
 static void finished_cached_dirents_count(struct cached_dirents *cde,
-					struct dir_context *ctx)
+					struct dir_context *ctx, struct file *file)
 {
-	if (cde->ctx != ctx)
+	if (cde->file != file)
 		return;
 	if (cde->is_valid || cde->is_failed)
 		return;
@@ -876,11 +876,12 @@ static void finished_cached_dirents_coun
 static void add_cached_dirent(struct cached_dirents *cde,
 			      struct dir_context *ctx,
 			      const char *name, int namelen,
-			      struct cifs_fattr *fattr)
+			      struct cifs_fattr *fattr,
+				  struct file *file)
 {
 	struct cached_dirent *de;
 
-	if (cde->ctx != ctx)
+	if (cde->file != file)
 		return;
 	if (cde->is_valid || cde->is_failed)
 		return;
@@ -910,7 +911,8 @@ static void add_cached_dirent(struct cac
 static bool cifs_dir_emit(struct dir_context *ctx,
 			  const char *name, int namelen,
 			  struct cifs_fattr *fattr,
-			  struct cached_fid *cfid)
+			  struct cached_fid *cfid,
+			  struct file *file)
 {
 	bool rc;
 	ino_t ino = cifs_uniqueid_to_ino_t(fattr->cf_uniqueid);
@@ -922,7 +924,7 @@ static bool cifs_dir_emit(struct dir_con
 	if (cfid) {
 		mutex_lock(&cfid->dirents.de_mutex);
 		add_cached_dirent(&cfid->dirents, ctx, name, namelen,
-				  fattr);
+				  fattr, file);
 		mutex_unlock(&cfid->dirents.de_mutex);
 	}
 
@@ -1022,7 +1024,7 @@ static int cifs_filldir(char *find_entry
 	cifs_prime_dcache(file_dentry(file), &name, &fattr);
 
 	return !cifs_dir_emit(ctx, name.name, name.len,
-			      &fattr, cfid);
+			      &fattr, cfid, file);
 }
 
 
@@ -1073,8 +1075,8 @@ int cifs_readdir(struct file *file, stru
 	 * we need to initialize scanning and storing the
 	 * directory content.
 	 */
-	if (ctx->pos == 0 && cfid->dirents.ctx == NULL) {
-		cfid->dirents.ctx = ctx;
+	if (ctx->pos == 0 && cfid->dirents.file == NULL) {
+		cfid->dirents.file = file;
 		cfid->dirents.pos = 2;
 	}
 	/*
@@ -1142,7 +1144,7 @@ int cifs_readdir(struct file *file, stru
 	} else {
 		if (cfid) {
 			mutex_lock(&cfid->dirents.de_mutex);
-			finished_cached_dirents_count(&cfid->dirents, ctx);
+			finished_cached_dirents_count(&cfid->dirents, ctx, file);
 			mutex_unlock(&cfid->dirents.de_mutex);
 		}
 		cifs_dbg(FYI, "Could not find entry\n");
@@ -1183,7 +1185,7 @@ int cifs_readdir(struct file *file, stru
 		ctx->pos++;
 		if (cfid) {
 			mutex_lock(&cfid->dirents.de_mutex);
-			update_cached_dirents_count(&cfid->dirents, ctx);
+			update_cached_dirents_count(&cfid->dirents, file);
 			mutex_unlock(&cfid->dirents.de_mutex);
 		}
 


