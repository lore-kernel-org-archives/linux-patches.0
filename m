Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F10A19E7E3;
	Tue, 16 Jul 2024 15:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145425; cv=none; b=X/lgnUFWVcPKC7ULKY0wxmylvhGIZrq1c2ITvSA9QPDepnNtIBCFD15fTMTq11igH0tz+hAy86bkMDgKJ+Ju1DQpZGkRfSbXLoUcwpRn9cdQnuxCwSm6hLv8leMTfg2QDrJhUonVPMyD7t7cZUlsX8EfkqquV/MTyghwE7OiTQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145425; c=relaxed/simple;
	bh=u2egr0Y59qKoGhneddsu++ZIHdbvLSgq+ln3XJgJLhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2EwJnlmK6Y5/iDWj5qNg1FuptkLE/KnkzGdpx4q7QFBKY3G8mlvmCm8nszU7rktUgMUNuenjrJvL9KzXlH+UAmYBm/k0eYUMivYF1Xx3d3vg4bTfJ/7bD9qhrR0PUN0vjvqypJO8C0M20qdghaj/ZUdlJZO/LxKnaZh46Si018=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bRvHgEKP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bRvHgEKP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8D2C116B1;
	Tue, 16 Jul 2024 15:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145425;
	bh=u2egr0Y59qKoGhneddsu++ZIHdbvLSgq+ln3XJgJLhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bRvHgEKPT+w2zYDeJQOeCOEcCgHc4aNnyyP+65PdDMMn+qjWwgUF/El6ZjTbrDcNY
	 uKHfLc4oMGeTyDdRvazi+MaJ1KcTOcRj4ryJblRs0QAAvwMrO+Ai+YjKti8xe+X6if
	 7dZj2DKCuQY6EHKwMEwE4T4uC2ogg+FgyaTlMFsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	He Zhe <zhe.he@windriver.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.1 60/96] hpet: Support 32-bit userspace
Date: Tue, 16 Jul 2024 17:32:11 +0200
Message-ID: <20240716152748.814786413@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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
@@ -289,8 +289,13 @@ hpet_read(struct file *file, char __user
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
 
@@ -314,9 +319,16 @@ hpet_read(struct file *file, char __user
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
@@ -671,12 +683,24 @@ struct compat_hpet_info {
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


