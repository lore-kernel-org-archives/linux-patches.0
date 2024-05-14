Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7568B1386D5;
	Tue, 14 May 2024 10:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683577; cv=none; b=M4kDqGu0I4dD4KBybVbRYOVpdoQ/GzT0nf7oCrlx+AZ4S79U7agmuKeMThBtCt0TXVtPR339IboN+nZgZZ94Mkse25GIiNi9b1/t/5gKaGdAK3osB8JPhThXNPKBkEHYj9ovL5/8hPY7/Z7w2OmJXits1ZLt3USIcV9STA1hIp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683577; c=relaxed/simple;
	bh=syzqXA0BwuXQQqK1eatBjG4KMMBIqdrEGdSRAmo75oA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXp4Si8Tei4Jn/DJT+M8Hx8iRJCoyMNpPPCxpevd+GM6eXeF2tEvbumqcvapiMOLSXDUelouWGPHBMm6oy5h7DD740vhlBn17FCcYaLlCmQ/n9B4cRpluU2Z+h6RNe8mb7YwdeB+KoqJccnPyqj9/Rl4ChjNORL2n12Ss09l7nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XrJFrR37; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XrJFrR37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20AFC2BD10;
	Tue, 14 May 2024 10:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683577;
	bh=syzqXA0BwuXQQqK1eatBjG4KMMBIqdrEGdSRAmo75oA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XrJFrR37rLT2l5swn3bYOCEjogpaZ5/zbEgRG/6P++RRfKdeyuTB9MhvwEKHZS9vC
	 APNh+J/xFobvQ1KbDOFShfJDXjwII0EoKc/81yiilkbJN13IPHJhTOu+AGiTHkut1T
	 dshElMuYltvmHPvUVU5GOkxCDT2EPaizOJXYdT2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <quic_zhonhan@quicinc.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 238/336] gpiolib: cdev: Fix use after free in lineinfo_changed_notify
Date: Tue, 14 May 2024 12:17:22 +0200
Message-ID: <20240514101047.599487092@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhongqiu Han <quic_zhonhan@quicinc.com>

[ Upstream commit 02f6b0e1ec7e0e7d059dddc893645816552039da ]

The use-after-free issue occurs as follows: when the GPIO chip device file
is being closed by invoking gpio_chrdev_release(), watched_lines is freed
by bitmap_free(), but the unregistration of lineinfo_changed_nb notifier
chain failed due to waiting write rwsem. Additionally, one of the GPIO
chip's lines is also in the release process and holds the notifier chain's
read rwsem. Consequently, a race condition leads to the use-after-free of
watched_lines.

Here is the typical stack when issue happened:

[free]
gpio_chrdev_release()
  --> bitmap_free(cdev->watched_lines)                  <-- freed
  --> blocking_notifier_chain_unregister()
    --> down_write(&nh->rwsem)                          <-- waiting rwsem
          --> __down_write_common()
            --> rwsem_down_write_slowpath()
                  --> schedule_preempt_disabled()
                    --> schedule()

[use]
st54spi_gpio_dev_release()
  --> gpio_free()
    --> gpiod_free()
      --> gpiod_free_commit()
        --> gpiod_line_state_notify()
          --> blocking_notifier_call_chain()
            --> down_read(&nh->rwsem);                  <-- held rwsem
            --> notifier_call_chain()
              --> lineinfo_changed_notify()
                --> test_bit(xxxx, cdev->watched_lines) <-- use after free

The side effect of the use-after-free issue is that a GPIO line event is
being generated for userspace where it shouldn't. However, since the chrdev
is being closed, userspace won't have the chance to read that event anyway.

To fix the issue, call the bitmap_free() function after the unregistration
of lineinfo_changed_nb notifier chain.

Fixes: 51c1064e82e7 ("gpiolib: add new ioctl() for monitoring changes in line info")
Signed-off-by: Zhongqiu Han <quic_zhonhan@quicinc.com>
Link: https://lore.kernel.org/r/20240505141156.2944912-1-quic_zhonhan@quicinc.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-cdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib-cdev.c b/drivers/gpio/gpiolib-cdev.c
index 1438fdca0b748..0b94c398c0649 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -2800,11 +2800,11 @@ static int gpio_chrdev_release(struct inode *inode, struct file *file)
 	struct gpio_chardev_data *cdev = file->private_data;
 	struct gpio_device *gdev = cdev->gdev;
 
-	bitmap_free(cdev->watched_lines);
 	blocking_notifier_chain_unregister(&gdev->device_notifier,
 					   &cdev->device_unregistered_nb);
 	blocking_notifier_chain_unregister(&gdev->line_state_notifier,
 					   &cdev->lineinfo_changed_nb);
+	bitmap_free(cdev->watched_lines);
 	gpio_device_put(gdev);
 	kfree(cdev);
 
-- 
2.43.0



