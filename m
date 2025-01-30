Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2900C1E522;
	Thu, 30 Jan 2025 14:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247192; cv=none; b=iED/d6iET4j64wkPslvzqatUW9x5GZaSfZs4MGseqWn1wfYkUwhHCvGlc1qIfbXFwPrCntI/kDZhedci6XEGpdE3kMvY79f5o2MYlPhB/UaGdtOgP2a52oqpjs80USaBYe1zXYYjxssmaH2tUwP+kcHqnq4HM73GfmuepMAqKb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247192; c=relaxed/simple;
	bh=P9JOufGnYVwfwba3QyNh765ejfMewHcW2532r1eYiBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eogrC7VEJivyIKTrAMLKV4EAw8bufC0tJ4zuIe7JdtmQj0nDl0vl35Y8AD1edcuK0wv6hxQFkBOsYX3P1IN1zazfWcme4r49iURHWllwZgtJJ/wt7MyDgh15FIguI8gBeQGoj11tGsemtAnS3eGf+fMp29k8Ifc2deFoixU2Ax4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nf2OoBVl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nf2OoBVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1CCC4CED2;
	Thu, 30 Jan 2025 14:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247192;
	bh=P9JOufGnYVwfwba3QyNh765ejfMewHcW2532r1eYiBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nf2OoBVlu6t5qKqOclsl4TgRXca18lzNNn8hRVYM2qZ0FNzU6PXffbJbLThX84goV
	 plsBVA/L0n5FcJi2g5nkKLq9F6IHsbtJIsdrm6ckAcCUbTxqlK/6dfkb2LR3cNrKj2
	 Vu2PZOLtUWscgKjpqoIOKhB3rqaMctXzCStJh3Cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <quic_zhonhan@quicinc.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Bruno VERNAY <bruno.vernay@se.com>,
	Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Subject: [PATCH 5.10 096/133] gpiolib: cdev: Fix use after free in lineinfo_changed_notify
Date: Thu, 30 Jan 2025 15:01:25 +0100
Message-ID: <20250130140146.394623527@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2352,9 +2352,9 @@ static int gpio_chrdev_release(struct in
 	struct gpio_chardev_data *cdev = file->private_data;
 	struct gpio_device *gdev = cdev->gdev;
 
-	bitmap_free(cdev->watched_lines);
 	blocking_notifier_chain_unregister(&gdev->notifier,
 					   &cdev->lineinfo_changed_nb);
+	bitmap_free(cdev->watched_lines);
 	put_device(&gdev->dev);
 	kfree(cdev);
 


