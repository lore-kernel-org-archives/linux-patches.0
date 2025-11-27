Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79E928135D;
	Thu, 27 Nov 2025 15:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255819; cv=none; b=Ho9QSbdZj4IlfmL25h7WH1OSdWFq0h6vH1FvYOX38G3OzYqwTk56yzJu54Qkh4F0rTPzSi54p1Xyez9LiV4Oud9cTAnYNMrSrK2n8zQm/IbbGSCEIURfhDUfxSXx6bWl6StDj1ovydvERHBOQvNZekjwFnqTG7k3xXxw7a7j+S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255819; c=relaxed/simple;
	bh=4nWTGwLSGIdyEJveC/1LyNq6uxRZ5pFQHfCrF5wvSo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kIlUc4HASWHbR8rXLk2FlUF20WzowU2YkdnS8dWosEjjqK7WQYBppIkWbh/Vnv3CE+kVmgXldyC6sPykW2ZtRYwxRIwL9dIKHIXcjndMH49oX8afvSYuCMIo2rhr7j8ckqSojVMxFMkQeMYXoUFRAQgQHg5amuR+gBbH7wPhasU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DTqineFY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DTqineFY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F98EC4CEF8;
	Thu, 27 Nov 2025 15:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255819;
	bh=4nWTGwLSGIdyEJveC/1LyNq6uxRZ5pFQHfCrF5wvSo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DTqineFYaAX+FGRdU+eoARz+QG2k7WyGNA7rYky19dyCOskRxBe7T6Gj5PhhWWPFI
	 THTPdg7RLiBnvO3KJKY4r3p4lc24OgNmyQK3YSlVHIe/1Qds58hubMjpCe51Qfk31h
	 KqkY8Azd4aoQ3bE/9lDbNfgppBz3PSxOTpoLclQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 125/175] gpio: cdev: make sure the cdev fd is still active before emitting events
Date: Thu, 27 Nov 2025 15:46:18 +0100
Message-ID: <20251127144047.524330658@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit d4cd0902c156b2ca60fdda8cd8b5bcb4b0e9ed64 ]

With the final call to fput() on a file descriptor, the release action
may be deferred and scheduled on a work queue. The reference count of
that descriptor is still zero and it must not be used. It's possible
that a GPIO change, we want to notify the user-space about, happens
AFTER the reference count on the file descriptor associated with the
character device went down to zero but BEFORE the .release() callback
was called from the workqueue and so BEFORE we unregistered from the
notifier.

Using the regular get_file() routine in this situation triggers the
following warning:

  struct file::f_count incremented from zero; use-after-free condition present!

So use the get_file_active() variant that will return NULL on file
descriptors that have been or are being released.

Fixes: 40b7c49950bd ("gpio: cdev: put emitting the line state events on a workqueue")
Reported-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Closes: https://lore.kernel.org/all/5d605f7fc99456804911403102a4fe999a14cc85.camel@siemens.com/
Tested-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Link: https://lore.kernel.org/r/20251117-gpio-cdev-get-file-v1-1-28a16b5985b8@linaro.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-cdev.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib-cdev.c b/drivers/gpio/gpiolib-cdev.c
index e6a289fa0f8fd..6a52d812e4e7c 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -2548,10 +2548,17 @@ static int lineinfo_changed_notify(struct notifier_block *nb,
 		container_of(nb, struct gpio_chardev_data, lineinfo_changed_nb);
 	struct lineinfo_changed_ctx *ctx;
 	struct gpio_desc *desc = data;
+	struct file *fp;
 
 	if (!test_bit(gpio_chip_hwgpio(desc), cdev->watched_lines))
 		return NOTIFY_DONE;
 
+	/* Keep the file descriptor alive for the duration of the notification. */
+	fp = get_file_active(&cdev->fp);
+	if (!fp)
+		/* Chardev file descriptor was or is being released. */
+		return NOTIFY_DONE;
+
 	/*
 	 * If this is called from atomic context (for instance: with a spinlock
 	 * taken by the atomic notifier chain), any sleeping calls must be done
@@ -2575,8 +2582,6 @@ static int lineinfo_changed_notify(struct notifier_block *nb,
 	/* Keep the GPIO device alive until we emit the event. */
 	ctx->gdev = gpio_device_get(desc->gdev);
 	ctx->cdev = cdev;
-	/* Keep the file descriptor alive too. */
-	get_file(ctx->cdev->fp);
 
 	INIT_WORK(&ctx->work, lineinfo_changed_func);
 	queue_work(ctx->gdev->line_state_wq, &ctx->work);
-- 
2.51.0



