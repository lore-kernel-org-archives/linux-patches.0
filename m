Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1051F7566;
	Tue,  3 Dec 2024 14:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237917; cv=none; b=XFHtXbPskSIbUWfScdyHWdRQV5ye+NSONfMG0TdkN7d79IX+/vsgw1r9id0squkV7EUNOBAvK42IB2UfH7l88J4p4lJjpp5SU7k1TG3Tx0fSf2+A0p3feoNh5GS6D29YRNZAVoT1zgml5WzMraLedC5XvA792lWUDQ8NY62l+tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237917; c=relaxed/simple;
	bh=5h3qzxqtn8GWbD9sGxr2whoexmQLzrprfiR8K8ILSrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lp6TrmC+xFfy12BAUbWJjIo3CAWwyhL1sIoAjlgGW1X8s/MfbrjLz8p5VhdPY9i6M6CiFmoO8IH4OUtz80jHP8jzZ37tODbeBgXHlP2+RxO/LOmRvWG9K9evSKXLmRYRYWUCCrJPhlRPK7wuV8X0tI+b7rSE6yv6VwNsBl7zkr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ybk8leD6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ybk8leD6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA48C4CECF;
	Tue,  3 Dec 2024 14:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237917;
	bh=5h3qzxqtn8GWbD9sGxr2whoexmQLzrprfiR8K8ILSrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ybk8leD6g68Lgx2mbrV0Nv20J3WRuLBYvEd3NikyPiZNRg+ip2jpTrbv1KSzNr71O
	 y0UoDRLQKUrRkLjrBUrg7Kz0V2v6Y/lYJg/0gAFx9WDKHq3QKzeNZu3Nv9lBbVQbNm
	 pWA9ngiTGbWRxXBxhIL7Y9JLvbTKl2OpAio1moMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 075/817] cachefiles: Fix NULL pointer dereference in object->file
Date: Tue,  3 Dec 2024 15:34:07 +0100
Message-ID: <20241203143958.618567015@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit 31ad74b20227ce6b40910ff78b1c604e42975cf1 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/interface.c | 14 ++++++++++----
 fs/cachefiles/ondemand.c  | 30 ++++++++++++++++++++++++------
 2 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/fs/cachefiles/interface.c b/fs/cachefiles/interface.c
index 35ba2117a6f65..3e63cfe158747 100644
--- a/fs/cachefiles/interface.c
+++ b/fs/cachefiles/interface.c
@@ -327,6 +327,8 @@ static void cachefiles_commit_object(struct cachefiles_object *object,
 static void cachefiles_clean_up_object(struct cachefiles_object *object,
 				       struct cachefiles_cache *cache)
 {
+	struct file *file;
+
 	if (test_bit(FSCACHE_COOKIE_RETIRED, &object->cookie->flags)) {
 		if (!test_bit(CACHEFILES_OBJECT_USING_TMPFILE, &object->flags)) {
 			cachefiles_see_object(object, cachefiles_obj_see_clean_delete);
@@ -342,10 +344,14 @@ static void cachefiles_clean_up_object(struct cachefiles_object *object,
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
diff --git a/fs/cachefiles/ondemand.c b/fs/cachefiles/ondemand.c
index 38ca6dce8ef29..fe3de9ad57bf6 100644
--- a/fs/cachefiles/ondemand.c
+++ b/fs/cachefiles/ondemand.c
@@ -60,20 +60,26 @@ static ssize_t cachefiles_ondemand_fd_write_iter(struct kiocb *kiocb,
 {
 	struct cachefiles_object *object = kiocb->ki_filp->private_data;
 	struct cachefiles_cache *cache = object->volume->cache;
-	struct file *file = object->file;
+	struct file *file;
 	size_t len = iter->count, aligned_len = len;
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
 	ret = __cachefiles_prepare_write(object, file, &pos, &aligned_len, len, true);
 	cachefiles_end_secure(cache, saved_cred);
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	trace_cachefiles_ondemand_fd_write(object, file_inode(file), pos, len);
 	ret = __cachefiles_write(object, file, pos, iter, NULL, NULL);
@@ -82,6 +88,8 @@ static ssize_t cachefiles_ondemand_fd_write_iter(struct kiocb *kiocb,
 		kiocb->ki_pos += ret;
 	}
 
+out:
+	fput(file);
 	return ret;
 }
 
@@ -89,12 +97,22 @@ static loff_t cachefiles_ondemand_fd_llseek(struct file *filp, loff_t pos,
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
-- 
2.43.0



