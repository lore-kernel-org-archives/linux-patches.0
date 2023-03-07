Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4C1BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F809C4339B;
	Tue,  7 Mar 2023 18:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215060;
	bh=Rth3ys//X/3BQOQQ9pX9iuhFpE6ggyVXiBSREELyUU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GOHaNgUDspJ8EqIytGM5F2kNMGy0rcK9cjzx1bpw7WMtoo4U5wl0ZU19KLuIKDlz2
	 oZ0wVASCWOdQHFNy+cdWad9XCQwD2BFud2ivXD1G6L1byz+Uh2w8I27pQNtb7Y+PI7
	 vagChdRrVcNz2zr1uhcT5gSpTfW5u1d1MEYhdjOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 121/567] leds: led-class: Add missing put_device() to led_put()
Date: Tue,  7 Mar 2023 17:57:37 +0100
Message-Id: <20230307165911.151561747@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 445110941eb94709216363f9d807d2508e64abd7 ]

led_put() is used to "undo" a successful of_led_get() call,
of_led_get() uses class_find_device_by_of_node() which returns
a reference to the device which must be free-ed with put_device()
when the caller is done with it.

Add a put_device() call to led_put() to free the reference returned
by class_find_device_by_of_node().

And also add a put_device() in the error-exit case of try_module_get()
failing.

Fixes: 699a8c7c4bd3 ("leds: Add of_led_get() and led_put()")
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20230120114524.408368-2-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/led-class.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index f4bb02f6e0428..6e88df4c87fa8 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -241,8 +241,10 @@ struct led_classdev *of_led_get(struct device_node *np, int index)
 
 	led_cdev = dev_get_drvdata(led_dev);
 
-	if (!try_module_get(led_cdev->dev->parent->driver->owner))
+	if (!try_module_get(led_cdev->dev->parent->driver->owner)) {
+		put_device(led_cdev->dev);
 		return ERR_PTR(-ENODEV);
+	}
 
 	return led_cdev;
 }
@@ -255,6 +257,7 @@ EXPORT_SYMBOL_GPL(of_led_get);
 void led_put(struct led_classdev *led_cdev)
 {
 	module_put(led_cdev->dev->parent->driver->owner);
+	put_device(led_cdev->dev);
 }
 EXPORT_SYMBOL_GPL(led_put);
 
-- 
2.39.2



