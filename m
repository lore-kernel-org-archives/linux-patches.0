Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82911FFC41;
	Thu, 13 Feb 2025 15:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460979; cv=none; b=p0K6Otq9JrX8ce7CWMvRnj1Ccr8C4G6n8UcgAO9MkEXXgShs2nUOJPCqytRyrOyXhn4HAwXKlFMjl/kGrcTdlleG3xPa3WLcLkJhMeiaOFsSMYQdX1L41idWHNA7mnj+waXyWq2AhjRmAFE87WRhxzSR0axMQF0iPYl1XTNRMhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460979; c=relaxed/simple;
	bh=gYfpTkf5caQEJwj0haH14dP8gLTZoJOjBEid4aVUsEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+GtYgAsaUQNuLipTtHrhXmusWWQx7w2d7zkVpydN1l341BnU9gvLfKjDN88PJbMeI6RKIFg/22Ezynery3oT6P2ruqouc/mBeFuyKyZ/N7l60oiFPqFMsIcDfc0/7/aVfAML0QSEjnCoVP3V5XyEL2nAtav3gm9/PGK4X1Nafk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CNq6xDG2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CNq6xDG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54592C4CED1;
	Thu, 13 Feb 2025 15:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460978;
	bh=gYfpTkf5caQEJwj0haH14dP8gLTZoJOjBEid4aVUsEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNq6xDG2FpR0A6MWgc0MiFpXQFFCWMg+WO8xTUWLfCd4L48PB5XR4kxDl7OtHaIR1
	 snGapS1w0qc1e/6AVWYvSjGxCCugyJTsL5Ge0HvGzR2kmoNjgY4cvfsJnbYYw8KHOm
	 WRwW67dvOcPMuE9epGMWXwF3FSIV+eY1oICPULIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Bin Lan <lanbincn@qq.com>
Subject: [PATCH 6.6 266/273] cachefiles: Fix NULL pointer dereference in object->file
Date: Thu, 13 Feb 2025 15:30:38 +0100
Message-ID: <20250213142417.928171331@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zizhi Wo <wozizhi@huawei.com>

commit 31ad74b20227ce6b40910ff78b1c604e42975cf1 upstream.

At present, the object->file has the NULL pointer dereference problem in
ondemand-mode. The root cause is that the allocated fd and object->file
lifetime are inconsistent, and the user-space invocation to anon_fd uses
object->file. Following is the process that triggers the issue:

	  [write fd]				[umount]
cachefiles_ondemand_fd_write_iter
				       fscache_cookie_state_machine
					 cachefiles_withdraw_cookie
  if (!file) return -ENOBUFS
					   cachefiles_clean_up_object
					     cachefiles_unmark_inode_in_use
					     fput(object->file)
					     object->file = NULL
  // file NULL pointer dereference!
  __cachefiles_write(..., file, ...)

Fix this issue by add an additional reference count to the object->file
before write/llseek, and decrement after it finished.

Fixes: c8383054506c ("cachefiles: notify the user daemon when looking up cookie")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Link: https://lore.kernel.org/r/20241107110649.3980193-5-wozizhi@huawei.com
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Bin Lan <lanbincn@qq.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cachefiles/interface.c |   14 ++++++++++----
 fs/cachefiles/ondemand.c  |   30 ++++++++++++++++++++++++------
 2 files changed, 34 insertions(+), 10 deletions(-)

--- a/fs/cachefiles/interface.c
+++ b/fs/cachefiles/interface.c
@@ -327,6 +327,8 @@ static void cachefiles_commit_object(str
 static void cachefiles_clean_up_object(struct cachefiles_object *object,
 				       struct cachefiles_cache *cache)
 {
+	struct file *file;
+
 	if (test_bit(FSCACHE_COOKIE_RETIRED, &object->cookie->flags)) {
 		if (!test_bit(CACHEFILES_OBJECT_USING_TMPFILE, &object->flags)) {
 			cachefiles_see_object(object, cachefiles_obj_see_clean_delete);
@@ -342,10 +344,14 @@ static void cachefiles_clean_up_object(s
 	}
 
 	cachefiles_unmark_inode_in_use(object, object->file);
-	if (object->file) {
-		fput(object->file);
-		object->file = NULL;
-	}
+
+	spin_lock(&object->lock);
+	file = object->file;
+	object->file = NULL;
+	spin_unlock(&object->lock);
+
+	if (file)
+		fput(file);
 }
 
 /*
--- a/fs/cachefiles/ondemand.c
+++ b/fs/cachefiles/ondemand.c
@@ -61,20 +61,26 @@ static ssize_t cachefiles_ondemand_fd_wr
 {
 	struct cachefiles_object *object = kiocb->ki_filp->private_data;
 	struct cachefiles_cache *cache = object->volume->cache;
-	struct file *file = object->file;
+	struct file *file;
 	size_t len = iter->count;
 	loff_t pos = kiocb->ki_pos;
 	const struct cred *saved_cred;
 	int ret;
 
-	if (!file)
+	spin_lock(&object->lock);
+	file = object->file;
+	if (!file) {
+		spin_unlock(&object->lock);
 		return -ENOBUFS;
+	}
+	get_file(file);
+	spin_unlock(&object->lock);
 
 	cachefiles_begin_secure(cache, &saved_cred);
 	ret = __cachefiles_prepare_write(object, file, &pos, &len, true);
 	cachefiles_end_secure(cache, saved_cred);
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	trace_cachefiles_ondemand_fd_write(object, file_inode(file), pos, len);
 	ret = __cachefiles_write(object, file, pos, iter, NULL, NULL);
@@ -83,6 +89,8 @@ static ssize_t cachefiles_ondemand_fd_wr
 		kiocb->ki_pos += ret;
 	}
 
+out:
+	fput(file);
 	return ret;
 }
 
@@ -90,12 +98,22 @@ static loff_t cachefiles_ondemand_fd_lls
 					    int whence)
 {
 	struct cachefiles_object *object = filp->private_data;
-	struct file *file = object->file;
+	struct file *file;
+	loff_t ret;
 
-	if (!file)
+	spin_lock(&object->lock);
+	file = object->file;
+	if (!file) {
+		spin_unlock(&object->lock);
 		return -ENOBUFS;
+	}
+	get_file(file);
+	spin_unlock(&object->lock);
 
-	return vfs_llseek(file, pos, whence);
+	ret = vfs_llseek(file, pos, whence);
+	fput(file);
+
+	return ret;
 }
 
 static long cachefiles_ondemand_fd_ioctl(struct file *filp, unsigned int ioctl,


