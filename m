Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A9F1F472D;
	Tue, 21 Jan 2025 18:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482691; cv=none; b=Z11fDbpwArxEwfxcUF9I7+oyfwn/YDRxaiN8IfRD9PRYuu+Or2qXOlmIAywCBcpVcfTl4vQ+SOC2Zcu4Emyj/uK63nqfjt5YYO8bzRKyrwalDUjY5aGTUQH0uIevbadSJm2h7QXdVTjShGhLIjRrOHocCmSv3qpAFgF+UkxZcDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482691; c=relaxed/simple;
	bh=8hqvfw4LVyRrJoFAQFI8kCZ/STF449EKTtM0RkhEVGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=msANcA/l5g1qZU33jw+7vw7YVLJCIvh3d1HWGz15hRNZaV9e73f0ZNDFmQVp59/ci8rWCOVlD3nb7IF2ZjB65IHVkacG0Rf+JjMhqQUfZhbM2WbimK8UL4wMPaNYLJ8xaLh0Ofr6tRtWjo0kFtdlb/N9BqIjeS4fH04v+6C8NFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jSGMNtMZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jSGMNtMZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A64C4CEDF;
	Tue, 21 Jan 2025 18:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482691;
	bh=8hqvfw4LVyRrJoFAQFI8kCZ/STF449EKTtM0RkhEVGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jSGMNtMZLOmbxzVpMH0b9MOsIUaMpKL1AO3Nb7sMpJ5C2FfJ4QaR9gzy2mSB9zpwK
	 VLwCCtu5i2c1+BaJgR4qtIFjhC1ZxNVn/DCIXGX1lctubl3U07CvgrG7wwkRTDROh9
	 JTqZ0IZJJKIwTRBWUQct3pCkPMDj3YH9tQs2EW8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <quic_zhonhan@quicinc.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Bruno VERNAY <bruno.vernay@se.com>,
	Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Subject: [PATCH 6.1 41/64] gpiolib: cdev: Fix use after free in lineinfo_changed_notify
Date: Tue, 21 Jan 2025 18:52:40 +0100
Message-ID: <20250121174523.122432737@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhongqiu Han <quic_zhonhan@quicinc.com>

commit 02f6b0e1ec7e0e7d059dddc893645816552039da upstream.

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
Signed-off-by: Bruno VERNAY <bruno.vernay@se.com>
Signed-off-by: Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-cdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -2860,9 +2860,9 @@ static int gpio_chrdev_release(struct in
 	struct gpio_chardev_data *cdev = file->private_data;
 	struct gpio_device *gdev = cdev->gdev;
 
-	bitmap_free(cdev->watched_lines);
 	blocking_notifier_chain_unregister(&gdev->notifier,
 					   &cdev->lineinfo_changed_nb);
+	bitmap_free(cdev->watched_lines);
 	put_device(&gdev->dev);
 	kfree(cdev);
 


