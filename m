Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B8733993;
	Thu, 15 Jan 2026 16:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496140; cv=none; b=m4ymZfky9nAG0OMGOrk9PwOEIRNZpr4KdIXMFCdb76Yji4SNTwwrdh8HTGPInFCn0keo2z4kD1o5U+rq7LvUOVCtqLd3VJuXBZC4dKG8rJvBFDmQgpS1EIYS+gJI7JCLDhaXjkK3akksJ+HchD4HEJG8u6eKRFQrK/uzM5wqcms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496140; c=relaxed/simple;
	bh=h+iXgwIiCxYUiR2W7EPFK2OSQkExYjzSbq3+UOID7iU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aYHZFKX0GIaCE+suDvwjIXAuuOS/MiAyZdJRuEXq/vr93MUl9TIWrqtQi/Or15vlMi9fj9CombrenknViYcK5A181TPIUTwbPv2TF0+4HFmir02WkIQaq0wRISPAuiXrYALj/ZRVGNb47yfvrqktFcnIJmL3ysU2+q67H19+CJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v5RVm5/h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v5RVm5/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C895C116D0;
	Thu, 15 Jan 2026 16:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496139;
	bh=h+iXgwIiCxYUiR2W7EPFK2OSQkExYjzSbq3+UOID7iU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v5RVm5/hib3WgxKUZ8UxxoAXMwcowbkugXTiXvUzbajgrYwQKWdn7PgqARLLPkMtj
	 QdxVCzberapIdFZzZVaYQyKACn1/3iv0TAMaMNNoIGWo9gfWQ+ppAEOgbC1mmAvcfm
	 orqUxlZSRxDHKFwncNImTKUKbmZbywkYPQwAKz/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Lewalski <jakub.lewalski@nokia.com>,
	=?UTF-8?q?Pawe=C5=82=20Narewski?= <pawel.narewski@nokia.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 091/181] gpiolib: fix race condition for gdev->srcu
Date: Thu, 15 Jan 2026 17:47:08 +0100
Message-ID: <20260115164205.608551002@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paweł Narewski <pawel.narewski@nokia.com>

[ Upstream commit a7ac22d53d0990152b108c3f4fe30df45fcb0181 ]

If two drivers were calling gpiochip_add_data_with_key(), one may be
traversing the srcu-protected list in gpio_name_to_desc(), meanwhile
other has just added its gdev in gpiodev_add_to_list_unlocked().
This creates a non-mutexed and non-protected timeframe, when one
instance is dereferencing and using &gdev->srcu, before the other
has initialized it, resulting in crash:

[    4.935481] Unable to handle kernel paging request at virtual address ffff800272bcc000
[    4.943396] Mem abort info:
[    4.943400]   ESR = 0x0000000096000005
[    4.943403]   EC = 0x25: DABT (current EL), IL = 32 bits
[    4.943407]   SET = 0, FnV = 0
[    4.943410]   EA = 0, S1PTW = 0
[    4.943413]   FSC = 0x05: level 1 translation fault
[    4.943416] Data abort info:
[    4.943418]   ISV = 0, ISS = 0x00000005, ISS2 = 0x00000000
[    4.946220]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[    4.955261]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[    4.955268] swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000000038e6c000
[    4.961449] [ffff800272bcc000] pgd=0000000000000000
[    4.969203] , p4d=1000000039739003
[    4.979730] , pud=0000000000000000
[    4.980210] phandle (CPU): 0x0000005e, phandle (BE): 0x5e000000 for node "reset"
[    4.991736] Internal error: Oops: 0000000096000005 [#1] PREEMPT SMP
...
[    5.121359] pc : __srcu_read_lock+0x44/0x98
[    5.131091] lr : gpio_name_to_desc+0x60/0x1a0
[    5.153671] sp : ffff8000833bb430
[    5.298440]
[    5.298443] Call trace:
[    5.298445]  __srcu_read_lock+0x44/0x98
[    5.309484]  gpio_name_to_desc+0x60/0x1a0
[    5.320692]  gpiochip_add_data_with_key+0x488/0xf00
    5.946419] ---[ end trace 0000000000000000 ]---

Move initialization code for gdev fields before it is added to
gpio_devices, with adjacent initialization code.
Adjust goto statements  to reflect modified order of operations

Fixes: 47d8b4c1d868 ("gpio: add SRCU infrastructure to struct gpio_device")
Reviewed-by: Jakub Lewalski <jakub.lewalski@nokia.com>
Signed-off-by: Paweł Narewski <pawel.narewski@nokia.com>
[Bartosz: fixed a build issue, removed stray newline]
Link: https://lore.kernel.org/r/20251224082641.10769-1-bartosz.golaszewski@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 9a4395a29f68e..9aa6ddf6389cc 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1091,6 +1091,18 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 	gdev->ngpio = gc->ngpio;
 	gdev->can_sleep = gc->can_sleep;
 
+	rwlock_init(&gdev->line_state_lock);
+	RAW_INIT_NOTIFIER_HEAD(&gdev->line_state_notifier);
+	BLOCKING_INIT_NOTIFIER_HEAD(&gdev->device_notifier);
+
+	ret = init_srcu_struct(&gdev->srcu);
+	if (ret)
+		goto err_free_label;
+
+	ret = init_srcu_struct(&gdev->desc_srcu);
+	if (ret)
+		goto err_cleanup_gdev_srcu;
+
 	scoped_guard(mutex, &gpio_devices_lock) {
 		/*
 		 * TODO: this allocates a Linux GPIO number base in the global
@@ -1105,7 +1117,7 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 			if (base < 0) {
 				ret = base;
 				base = 0;
-				goto err_free_label;
+				goto err_cleanup_desc_srcu;
 			}
 
 			/*
@@ -1125,22 +1137,10 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 		ret = gpiodev_add_to_list_unlocked(gdev);
 		if (ret) {
 			gpiochip_err(gc, "GPIO integer space overlap, cannot add chip\n");
-			goto err_free_label;
+			goto err_cleanup_desc_srcu;
 		}
 	}
 
-	rwlock_init(&gdev->line_state_lock);
-	RAW_INIT_NOTIFIER_HEAD(&gdev->line_state_notifier);
-	BLOCKING_INIT_NOTIFIER_HEAD(&gdev->device_notifier);
-
-	ret = init_srcu_struct(&gdev->srcu);
-	if (ret)
-		goto err_remove_from_list;
-
-	ret = init_srcu_struct(&gdev->desc_srcu);
-	if (ret)
-		goto err_cleanup_gdev_srcu;
-
 #ifdef CONFIG_PINCTRL
 	INIT_LIST_HEAD(&gdev->pin_ranges);
 #endif
@@ -1150,11 +1150,11 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 
 	ret = gpiochip_set_names(gc);
 	if (ret)
-		goto err_cleanup_desc_srcu;
+		goto err_remove_from_list;
 
 	ret = gpiochip_init_valid_mask(gc);
 	if (ret)
-		goto err_cleanup_desc_srcu;
+		goto err_remove_from_list;
 
 	for (desc_index = 0; desc_index < gc->ngpio; desc_index++) {
 		struct gpio_desc *desc = &gdev->descs[desc_index];
@@ -1227,10 +1227,6 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 	of_gpiochip_remove(gc);
 err_free_valid_mask:
 	gpiochip_free_valid_mask(gc);
-err_cleanup_desc_srcu:
-	cleanup_srcu_struct(&gdev->desc_srcu);
-err_cleanup_gdev_srcu:
-	cleanup_srcu_struct(&gdev->srcu);
 err_remove_from_list:
 	scoped_guard(mutex, &gpio_devices_lock)
 		list_del_rcu(&gdev->list);
@@ -1240,6 +1236,10 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 		gpio_device_put(gdev);
 		goto err_print_message;
 	}
+err_cleanup_desc_srcu:
+	cleanup_srcu_struct(&gdev->desc_srcu);
+err_cleanup_gdev_srcu:
+	cleanup_srcu_struct(&gdev->srcu);
 err_free_label:
 	kfree_const(gdev->label);
 err_free_descs:
-- 
2.51.0



