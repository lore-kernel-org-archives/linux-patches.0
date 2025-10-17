Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4993328E5;
	Fri, 17 Oct 2025 15:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713474; cv=none; b=Mvn7pfefWLE1l/O2uNoqtii+hoPDpdKStYwLCDbDjWigGOWyVXRI8F0wB62P9EQUWC1va9Tr7k0NKnB27hLD8NFWupzIhX5C1Xl1bfG9oMKLLRF8AoVouemdk+PpH8LjufV1C9jLxhTEZcMhosHrGbfXKBhl6cPpqSZ0dtvPqRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713474; c=relaxed/simple;
	bh=nYTdEQhJEjNzZA4sad1XXL5PWk5lAMlwa2Hxfjf95u4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5MBinyQfFLwYOzermJc+oBdIpBnZIHJJdY+x2r9V35rwyXuTHpScoVcbS2PAfZpwdr8qeCMVPZDAKTfXLFXpVFbLpepuyK+hCAbusjfDjQlNd80n4Kbt57/QKuFyY4LBcw6ty3XMwaEUyraLk6uOjFg5JqLuzB8blcLaNA7Hq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HeJiCM7n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HeJiCM7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC1BC4CEE7;
	Fri, 17 Oct 2025 15:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713474;
	bh=nYTdEQhJEjNzZA4sad1XXL5PWk5lAMlwa2Hxfjf95u4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HeJiCM7nXyhbll8TniAxcRcnu17ve97ZMqYcatvUnSt8ZkH5IHdgzToT6JNye2sQ8
	 wI0SdaOlxfgSMMAX7madRZFakb3godINtdz00t63z9EHL7R24JJvjKyzjeZjJoMooz
	 wYP4BpDibRkxv1FhkofgMz4gyTPi8eOHhM4oPI0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.6 002/201] fscontext: do not consume log entries when returning -EMSGSIZE
Date: Fri, 17 Oct 2025 16:51:03 +0200
Message-ID: <20251017145134.813046013@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

From: Aleksa Sarai <cyphar@cyphar.com>

commit 72d271a7baa7062cb27e774ac37c5459c6d20e22 upstream.

Userspace generally expects APIs that return -EMSGSIZE to allow for them
to adjust their buffer size and retry the operation. However, the
fscontext log would previously clear the message even in the -EMSGSIZE
case.

Given that it is very cheap for us to check whether the buffer is too
small before we remove the message from the ring buffer, let's just do
that instead. While we're at it, refactor some fscontext_read() into a
separate helper to make the ring buffer logic a bit easier to read.

Fixes: 007ec26cdc9f ("vfs: Implement logging through fs_context")
Cc: David Howells <dhowells@redhat.com>
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
Link: https://lore.kernel.org/20250807-fscontext-log-cleanups-v3-1-8d91d6242dc3@cyphar.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fsopen.c |   70 ++++++++++++++++++++++++++++++++----------------------------
 1 file changed, 38 insertions(+), 32 deletions(-)

--- a/fs/fsopen.c
+++ b/fs/fsopen.c
@@ -18,50 +18,56 @@
 #include "internal.h"
 #include "mount.h"
 
+static inline const char *fetch_message_locked(struct fc_log *log, size_t len,
+					       bool *need_free)
+{
+	const char *p;
+	int index;
+
+	if (unlikely(log->head == log->tail))
+		return ERR_PTR(-ENODATA);
+
+	index = log->tail & (ARRAY_SIZE(log->buffer) - 1);
+	p = log->buffer[index];
+	if (unlikely(strlen(p) > len))
+		return ERR_PTR(-EMSGSIZE);
+
+	log->buffer[index] = NULL;
+	*need_free = log->need_free & (1 << index);
+	log->need_free &= ~(1 << index);
+	log->tail++;
+
+	return p;
+}
+
 /*
  * Allow the user to read back any error, warning or informational messages.
+ * Only one message is returned for each read(2) call.
  */
 static ssize_t fscontext_read(struct file *file,
 			      char __user *_buf, size_t len, loff_t *pos)
 {
 	struct fs_context *fc = file->private_data;
-	struct fc_log *log = fc->log.log;
-	unsigned int logsize = ARRAY_SIZE(log->buffer);
-	ssize_t ret;
-	char *p;
+	ssize_t err;
+	const char *p __free(kfree) = NULL, *message;
 	bool need_free;
-	int index, n;
-
-	ret = mutex_lock_interruptible(&fc->uapi_mutex);
-	if (ret < 0)
-		return ret;
-
-	if (log->head == log->tail) {
-		mutex_unlock(&fc->uapi_mutex);
-		return -ENODATA;
-	}
+	int n;
 
-	index = log->tail & (logsize - 1);
-	p = log->buffer[index];
-	need_free = log->need_free & (1 << index);
-	log->buffer[index] = NULL;
-	log->need_free &= ~(1 << index);
-	log->tail++;
+	err = mutex_lock_interruptible(&fc->uapi_mutex);
+	if (err < 0)
+		return err;
+	message = fetch_message_locked(fc->log.log, len, &need_free);
 	mutex_unlock(&fc->uapi_mutex);
+	if (IS_ERR(message))
+		return PTR_ERR(message);
 
-	ret = -EMSGSIZE;
-	n = strlen(p);
-	if (n > len)
-		goto err_free;
-	ret = -EFAULT;
-	if (copy_to_user(_buf, p, n) != 0)
-		goto err_free;
-	ret = n;
-
-err_free:
 	if (need_free)
-		kfree(p);
-	return ret;
+		p = message;
+
+	n = strlen(message);
+	if (copy_to_user(_buf, message, n))
+		return -EFAULT;
+	return n;
 }
 
 static int fscontext_release(struct inode *inode, struct file *file)


