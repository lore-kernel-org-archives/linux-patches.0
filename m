Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0923A8825;
	Sat, 30 Dec 2023 12:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XiXpxZe+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E957C433C7;
	Sat, 30 Dec 2023 12:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937849;
	bh=sgYkFvJxnua7AZ2QzFhREMkW97kvSCuGOkQSs1uzifg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XiXpxZe+nHK84fC2XSS1ba6JDmdP6tLeJUH2VWLwP1hhhItuqvXiSx/R2KxNnXwDO
	 mp0lBYJ3nvaJfTbXH6ltiNl+lEM0FFmwKOA8LQFbGISgJ2ue6hfWjag5k//WnLuSZG
	 ykTRPMwVvE8CZ0Czj+SdU0flqkI9kFw7mEoIgfp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Gibson <warthog618@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/156] gpiolib: cdev: add gpio_device locking wrapper around gpio_ioctl()
Date: Sat, 30 Dec 2023 11:58:53 +0000
Message-ID: <20231230115814.942396772@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

From: Kent Gibson <warthog618@gmail.com>

[ Upstream commit 1d656bd259edb89dc1d9938ec5c5389867088546 ]

While the GPIO cdev gpio_ioctl() call is in progress, the kernel can
call gpiochip_remove() which will set gdev->chip to NULL, after which
any subsequent access will cause a crash.

gpio_ioctl() was overlooked by the previous fix to protect syscalls
(bdbbae241a04), so add protection for that.

Fixes: bdbbae241a04 ("gpiolib: protect the GPIO device against being dropped while in use by user-space")
Fixes: d7c51b47ac11 ("gpio: userspace ABI for reading/writing GPIO lines")
Fixes: 3c0d9c635ae2 ("gpiolib: cdev: support GPIO_V2_GET_LINE_IOCTL and GPIO_V2_LINE_GET_VALUES_IOCTL")
Fixes: aad955842d1c ("gpiolib: cdev: support GPIO_V2_GET_LINEINFO_IOCTL and GPIO_V2_GET_LINEINFO_WATCH_IOCTL")
Signed-off-by: Kent Gibson <warthog618@gmail.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-cdev.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpiolib-cdev.c b/drivers/gpio/gpiolib-cdev.c
index e39d344feb289..4f3e66ece7f78 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -2482,10 +2482,7 @@ static int lineinfo_unwatch(struct gpio_chardev_data *cdev, void __user *ip)
 	return 0;
 }
 
-/*
- * gpio_ioctl() - ioctl handler for the GPIO chardev
- */
-static long gpio_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static long gpio_ioctl_unlocked(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct gpio_chardev_data *cdev = file->private_data;
 	struct gpio_device *gdev = cdev->gdev;
@@ -2522,6 +2519,17 @@ static long gpio_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	}
 }
 
+/*
+ * gpio_ioctl() - ioctl handler for the GPIO chardev
+ */
+static long gpio_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct gpio_chardev_data *cdev = file->private_data;
+
+	return call_ioctl_locked(file, cmd, arg, cdev->gdev,
+				 gpio_ioctl_unlocked);
+}
+
 #ifdef CONFIG_COMPAT
 static long gpio_ioctl_compat(struct file *file, unsigned int cmd,
 			      unsigned long arg)
-- 
2.43.0



