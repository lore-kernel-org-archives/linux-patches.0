Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AB1CA40;
	Tue, 16 Jul 2024 15:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144189; cv=none; b=ZYCVhGFUokXvF1bXt2dEacGTKQdJuKXEUqwZe8D1cy9EsrFIvAbcwfLNpcT5H2vA2WjDHtlmSe9QW078Df+rH0MZtakgOKrRof3kV6FpOcXyceINlduvHNC3ACKb8VVg43m5uehJle1tXeUnE82bigk1BKqyIm/Xa+cZ8G0dS0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144189; c=relaxed/simple;
	bh=1dYEk+xXiNHgtfKnotAlvOozz/8sLdOyQCrt+LpQLNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUCE0fAOPIY9p04lfQC9xngNL1qeOx913+zG31Lxd4l/Z1teyaehocC56O4d4132EwZE5qtYumAHb8YOueu/h3pvYnyKq3GhBPUasXvTCGjuMGotXMy7PeQY3p7Mpv+rtAHp8WaTcL0FrPyY+FWuGH+mxykYoCGC6e+bJrYzKrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aPWe4Y3S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aPWe4Y3S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4DBC116B1;
	Tue, 16 Jul 2024 15:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144189;
	bh=1dYEk+xXiNHgtfKnotAlvOozz/8sLdOyQCrt+LpQLNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aPWe4Y3SQLmkOhZb3oLwVHbf0N7vw3aSzpXEWcH9pZ5Rhx+WzVq8IJCx3OES8QIeb
	 Rex5x4FQE9wlwC8mGrtvZ+T+IWW6BGzR4BPea4iLzOStohRiV61LlGtWDwPpLCOL6k
	 v53FU5s53+dBNuL4geV7zXKCpAewkOcLFRH0zCCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	He Zhe <zhe.he@windriver.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4.19 58/66] hpet: Support 32-bit userspace
Date: Tue, 16 Jul 2024 17:31:33 +0200
Message-ID: <20240716152740.376723496@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152738.161055634@linuxfoundation.org>
References: <20240716152738.161055634@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: He Zhe <zhe.he@windriver.com>

commit 4e60131d0d36af65ab9c9144f4f163fe97ae36e8 upstream.

hpet_compat_ioctl and read file operations failed to handle parameters from
32-bit userspace and thus samples/timers/hpet_example.c fails as below.

root@intel-x86-64:~# ./hpet_example-32.out poll /dev/hpet 1 2
-hpet: executing poll
hpet_poll: HPET_IRQFREQ failed

This patch fixes cmd and arg handling in hpet_compat_ioctl and adds compat
handling for 32-bit userspace in hpet_read.

hpet_example now shows that it works for both 64-bit and 32-bit.

root@intel-x86-64:~# ./hpet_example-32.out poll /dev/hpet 1 2
-hpet: executing poll
hpet_poll: info.hi_flags 0x0
hpet_poll: expired time = 0xf4298
hpet_poll: revents = 0x1
hpet_poll: data 0x1
hpet_poll: expired time = 0xf4235
hpet_poll: revents = 0x1
hpet_poll: data 0x1
root@intel-x86-64:~# ./hpet_example-64.out poll /dev/hpet 1 2
-hpet: executing poll
hpet_poll: info.hi_flags 0x0
hpet_poll: expired time = 0xf42a1
hpet_poll: revents = 0x1
hpet_poll: data 0x1
hpet_poll: expired time = 0xf4232
hpet_poll: revents = 0x1
hpet_poll: data 0x1

Cc: stable@vger.kernel.org
Signed-off-by: He Zhe <zhe.he@windriver.com>
Fixes: 54066a57c584 ("hpet: kill BKL, add compat_ioctl")
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20240606123908.738733-1-zhe.he@windriver.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/hpet.c |   34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -307,8 +307,13 @@ hpet_read(struct file *file, char __user
 	if (!devp->hd_ireqfreq)
 		return -EIO;
 
-	if (count < sizeof(unsigned long))
-		return -EINVAL;
+	if (in_compat_syscall()) {
+		if (count < sizeof(compat_ulong_t))
+			return -EINVAL;
+	} else {
+		if (count < sizeof(unsigned long))
+			return -EINVAL;
+	}
 
 	add_wait_queue(&devp->hd_waitqueue, &wait);
 
@@ -332,9 +337,16 @@ hpet_read(struct file *file, char __user
 		schedule();
 	}
 
-	retval = put_user(data, (unsigned long __user *)buf);
-	if (!retval)
-		retval = sizeof(unsigned long);
+	if (in_compat_syscall()) {
+		retval = put_user(data, (compat_ulong_t __user *)buf);
+		if (!retval)
+			retval = sizeof(compat_ulong_t);
+	} else {
+		retval = put_user(data, (unsigned long __user *)buf);
+		if (!retval)
+			retval = sizeof(unsigned long);
+	}
+
 out:
 	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&devp->hd_waitqueue, &wait);
@@ -689,12 +701,24 @@ struct compat_hpet_info {
 	unsigned short hi_timer;
 };
 
+/* 32-bit types would lead to different command codes which should be
+ * translated into 64-bit ones before passed to hpet_ioctl_common
+ */
+#define COMPAT_HPET_INFO       _IOR('h', 0x03, struct compat_hpet_info)
+#define COMPAT_HPET_IRQFREQ    _IOW('h', 0x6, compat_ulong_t)
+
 static long
 hpet_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct hpet_info info;
 	int err;
 
+	if (cmd == COMPAT_HPET_INFO)
+		cmd = HPET_INFO;
+
+	if (cmd == COMPAT_HPET_IRQFREQ)
+		cmd = HPET_IRQFREQ;
+
 	mutex_lock(&hpet_mutex);
 	err = hpet_ioctl_common(file->private_data, cmd, arg, &info);
 	mutex_unlock(&hpet_mutex);


