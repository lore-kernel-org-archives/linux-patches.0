Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1F669942;
	Wed, 21 Feb 2024 13:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523659; cv=none; b=VVD9IylqToRREXa0eYC7ZLdLXz62BxCyY6g5YKVcSxaM6yl+VbwmP8WDvZ97bmYcpiOpqqZdGSU0xReWxY7X2hp6k5OUIXSQ5r8IddgEnbRFcUfaFeydfhfoFRsoNrprkwhDb64uUCAB0EHgEgNtJs2OsyrYUv3Mpx/hWdp46FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523659; c=relaxed/simple;
	bh=qZMZv04+fcx6BiNJoTcZXzT3gwOnTwyEG1jlr7eWZDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MiECW6iIDBxVPW2xCB/yGGb13Nto74qyN7NwiN61PK9EarM7HxD9hEVY1MJBAbcMtSBvMZQ0x8/d2CIYYlIt3CIgOAxOMSVG103+nfBx5bwayH1KAWFyWEwt0ds+PWsNh3Tq6LPnFdsJbysFGIhNm+9FAEniO712TxCu5+eXOKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KvidqamS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KvidqamS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DBA6C433F1;
	Wed, 21 Feb 2024 13:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523658;
	bh=qZMZv04+fcx6BiNJoTcZXzT3gwOnTwyEG1jlr7eWZDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KvidqamS12Y17+Vim0oBDSHkmnCbUH8FC02A6OYLzAOCikyFUIUbCp62DfXdMGSQo
	 NxnoBQzH4g22nOXjEEuc/drqLlclUS46E00M2L3nSTvNhZ8M7m4Do/sL/2Gw28tvQW
	 Em4TT+IKGnZLztS2cDDl0QtfOL0ZBbQePctL6FPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	syzbot+c52ab18308964d248092@syzkaller.appspotmail.com,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 020/379] hwrng: core - Fix page fault dead lock on mmap-ed hwrng
Date: Wed, 21 Feb 2024 14:03:19 +0100
Message-ID: <20240221125955.517581554@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -24,10 +24,13 @@
 #include <linux/random.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/uaccess.h>
 
 #define RNG_MODULE_NAME		"hw_random"
 
+#define RNG_BUFFER_SIZE (SMP_CACHE_BYTES < 32 ? 32 : SMP_CACHE_BYTES)
+
 static struct hwrng *current_rng;
 /* the current rng has been explicitly chosen by user via sysfs */
 static int cur_rng_set_by_user;
@@ -59,7 +62,7 @@ static inline int rng_get_data(struct hw
 
 static size_t rng_buffer_size(void)
 {
-	return SMP_CACHE_BYTES < 32 ? 32 : SMP_CACHE_BYTES;
+	return RNG_BUFFER_SIZE;
 }
 
 static void add_early_randomness(struct hwrng *rng)
@@ -206,6 +209,7 @@ static inline int rng_get_data(struct hw
 static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 			    size_t size, loff_t *offp)
 {
+	u8 buffer[RNG_BUFFER_SIZE];
 	ssize_t ret = 0;
 	int err = 0;
 	int bytes_read, len;
@@ -233,34 +237,37 @@ static ssize_t rng_dev_read(struct file
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
@@ -271,6 +278,7 @@ static ssize_t rng_dev_read(struct file
 		}
 	}
 out:
+	memzero_explicit(buffer, sizeof(buffer));
 	return ret ? : err;
 
 out_unlock_reading:


