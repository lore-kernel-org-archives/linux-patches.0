Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2978015B0FC;
	Mon, 29 Jan 2024 17:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548198; cv=none; b=rA5/OKZ0KJyH5UtgS7TLSeFQa7JxqosXW4AIC5Dcr84NZN1urzL/f0QIulCuAF/KZM2N8neITI9U7kfTvjsYvSPBPSblxZ/nX7tJ3oSPwmS7a9ya4ulNjXfEvjRnyyKhHR0kUwkNPvnZpAoimjcy5vM8SRFVQQWnsYhS9a8uB+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548198; c=relaxed/simple;
	bh=+13LCaXo7WdDWgAXDfTe6wz9cfBm0laoFobFC2JXbKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=atFBtqSvvE3LWY8klolPeLRL8smHfi6CmLu782O/FMsJE2XehMQflR59jIjs5OucPtpsPyTWBUYdIephN9AlH15QlSHbyYP2cYGmuFxw/9h4nDC73HmsUWatcun5U3S3NEhhn2wKIHL5ZuEAG8g0wWcMSU6uwMatc1Z10sJjo/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=paAT8ljP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="paAT8ljP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3267C43394;
	Mon, 29 Jan 2024 17:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548198;
	bh=+13LCaXo7WdDWgAXDfTe6wz9cfBm0laoFobFC2JXbKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=paAT8ljP9pt+FMfNoya+VRoDCvMUVMPqZ/MRzRo8vPiYRnvYs3FtyF+hiM/BbSgy0
	 dMR3RSAToAplsKAkXBPdx7kgvDdrSYIkYg7hTt1Tp4yR1UZZBIS3+nNpuHRY12m8r3
	 a4hbTi3Hd3TTDTFKF67aD8qQR1gutuf0NNpzPBiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	syzbot+c52ab18308964d248092@syzkaller.appspotmail.com,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 013/185] hwrng: core - Fix page fault dead lock on mmap-ed hwrng
Date: Mon, 29 Jan 2024 09:03:33 -0800
Message-ID: <20240129165959.023463426@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -211,6 +214,7 @@ static inline int rng_get_data(struct hw
 static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 			    size_t size, loff_t *offp)
 {
+	u8 buffer[RNG_BUFFER_SIZE];
 	ssize_t ret = 0;
 	int err = 0;
 	int bytes_read, len;
@@ -238,34 +242,37 @@ static ssize_t rng_dev_read(struct file
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
@@ -276,6 +283,7 @@ static ssize_t rng_dev_read(struct file
 		}
 	}
 out:
+	memzero_explicit(buffer, sizeof(buffer));
 	return ret ? : err;
 
 out_unlock_reading:


