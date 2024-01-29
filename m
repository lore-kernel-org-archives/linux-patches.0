Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8FE15DBB1;
	Mon, 29 Jan 2024 17:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548437; cv=none; b=C2uGfUUXBcfaso0b6hl6JsO69UAd1gQEaJrbkFHL8/bXUeEKKCyTyTeVj0A2qjYhoQj8xUymBUYWnGcesu4HXlBdPtYzsIQHQ6bCn9EWgYZUNirZ9zCCGVEnz42Pih+LioH8dbconebO9M/tZ5OowEUPpMkp17+GclVp09QeWyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548437; c=relaxed/simple;
	bh=+6xg0IlJXySnRMyIqKv4Kh4C41gwa7DpLpvGRN7l6nQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=coZAeYY+9HDO8h1Im2UEsK5HvNge/c+f9SSUuCraflH8ARnNW4Q47do+LZ+bj5879pOLkNmXH+IA3P66hVQXgqDHtGwi0hYTo0U+dpLSShfopr8/HtZ5AnEwht7zv5PPrOJ2XHEj1ayQgGuQKBHg8VXjSYNQ6v4vZjNa1k5OR9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xLnxL1Io; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xLnxL1Io"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6938C433F1;
	Mon, 29 Jan 2024 17:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548436;
	bh=+6xg0IlJXySnRMyIqKv4Kh4C41gwa7DpLpvGRN7l6nQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xLnxL1IoA4hdh3yI1ihAbHjIsEl7HoxHUhdbTKl2JV/2pACv+r8R1111Rlq8BwE1+
	 /FJkRneBl7pWzOQ5GY0a0q97holz7SQph39MGQt1yPXtD6lf5zb+QIgsO2GTQhq2g2
	 fOCHD0zL8Z9JB8onAMnHTn6cmcz2cF2Axw/ya7cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	syzbot+c52ab18308964d248092@syzkaller.appspotmail.com,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 041/331] hwrng: core - Fix page fault dead lock on mmap-ed hwrng
Date: Mon, 29 Jan 2024 09:01:45 -0800
Message-ID: <20240129170016.141753084@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 78aafb3884f6bc6636efcc1760c891c8500b9922 upstream.

There is a dead-lock in the hwrng device read path.  This triggers
when the user reads from /dev/hwrng into memory also mmap-ed from
/dev/hwrng.  The resulting page fault triggers a recursive read
which then dead-locks.

Fix this by using a stack buffer when calling copy_to_user.

Reported-by: Edward Adam Davis <eadavis@qq.com>
Reported-by: syzbot+c52ab18308964d248092@syzkaller.appspotmail.com
Fixes: 9996508b3353 ("hwrng: core - Replace u32 in driver API with byte array")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/hw_random/core.c |   34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -23,10 +23,13 @@
 #include <linux/sched.h>
 #include <linux/sched/signal.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/uaccess.h>
 
 #define RNG_MODULE_NAME		"hw_random"
 
+#define RNG_BUFFER_SIZE (SMP_CACHE_BYTES < 32 ? 32 : SMP_CACHE_BYTES)
+
 static struct hwrng *current_rng;
 /* the current rng has been explicitly chosen by user via sysfs */
 static int cur_rng_set_by_user;
@@ -58,7 +61,7 @@ static inline int rng_get_data(struct hw
 
 static size_t rng_buffer_size(void)
 {
-	return SMP_CACHE_BYTES < 32 ? 32 : SMP_CACHE_BYTES;
+	return RNG_BUFFER_SIZE;
 }
 
 static void add_early_randomness(struct hwrng *rng)
@@ -209,6 +212,7 @@ static inline int rng_get_data(struct hw
 static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 			    size_t size, loff_t *offp)
 {
+	u8 buffer[RNG_BUFFER_SIZE];
 	ssize_t ret = 0;
 	int err = 0;
 	int bytes_read, len;
@@ -236,34 +240,37 @@ static ssize_t rng_dev_read(struct file
 			if (bytes_read < 0) {
 				err = bytes_read;
 				goto out_unlock_reading;
+			} else if (bytes_read == 0 &&
+				   (filp->f_flags & O_NONBLOCK)) {
+				err = -EAGAIN;
+				goto out_unlock_reading;
 			}
+
 			data_avail = bytes_read;
 		}
 
-		if (!data_avail) {
-			if (filp->f_flags & O_NONBLOCK) {
-				err = -EAGAIN;
-				goto out_unlock_reading;
-			}
-		} else {
-			len = data_avail;
+		len = data_avail;
+		if (len) {
 			if (len > size)
 				len = size;
 
 			data_avail -= len;
 
-			if (copy_to_user(buf + ret, rng_buffer + data_avail,
-								len)) {
+			memcpy(buffer, rng_buffer + data_avail, len);
+		}
+		mutex_unlock(&reading_mutex);
+		put_rng(rng);
+
+		if (len) {
+			if (copy_to_user(buf + ret, buffer, len)) {
 				err = -EFAULT;
-				goto out_unlock_reading;
+				goto out;
 			}
 
 			size -= len;
 			ret += len;
 		}
 
-		mutex_unlock(&reading_mutex);
-		put_rng(rng);
 
 		if (need_resched())
 			schedule_timeout_interruptible(1);
@@ -274,6 +281,7 @@ static ssize_t rng_dev_read(struct file
 		}
 	}
 out:
+	memzero_explicit(buffer, sizeof(buffer));
 	return ret ? : err;
 
 out_unlock_reading:


