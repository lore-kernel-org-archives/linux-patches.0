Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3585328D1;
	Wed, 23 Sep 2026 14:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173571; cv=none; b=pXpJyx1sEFkI3hHBceQFqaOQAh6q8QIJeBOCeJke5+ySWtgV51vrtfp5ar3bTRw4dyRXBFywnFs/5/zh9ueZ1aJGw/6j0xwiecZysvQdxuAZnRERx8+T6azoNORVbuR1hA5zj5HcPSJ2vbNfKhHiu5zYpUoO8HQZ7i3tin77mbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173571; c=relaxed/simple;
	bh=VbrGJIvMefhaxpizxhR9WgbgK45wJJUqQl56vyu0OFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVImckAEhj/BjiT4d8qKWaFT2IQ+7c4LyYU4recQC0Q+ss2eThQQePv+xyAmk23AiTPCe5TBwzP8QnW3Pctb5rSnwmgXrPeSvgHj6dikMZ9Ncm5PFmUQLbFgsCJdYxG6a1ev5V17tnN05+MMyp0GaJ9ovHhAaFhYn7ZcOSPS3Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q4rNPbnY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q4rNPbnY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618601F00893;
	Wed, 23 Sep 2026 14:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173569;
	bh=P99t7xV0PHkgL8t79VZpv332SubiJfOvZim+OooXnoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q4rNPbnYjipaMnJ3vHoOwllMDbrL2bcBQVDI3YFj1h3lnNFVSNawN0brTiz3930un
	 G1WZa8UKQljBF6/DIxDQ5wPYftOTBDBE8KHU642N0DiMkmQA5LVOjs/fLXC8sVijD4
	 ELZMUDUQOY3Tv6Hgj8SrOeeh/K7eHlSJst7s1qMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Daniel Drake <dan@reactivated.net>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.2 287/438] gpiolib: of: dont mark hog nodes OF_POPULATED before a chip is found
Date: Wed, 23 Sep 2026 16:05:08 +0200
Message-ID: <20260923140652.211765155@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

commit 1f1d0812f6a8ab8e6f709c599f137c99646512cc upstream.

When a gpio-hog node is attached by a device-tree overlay before its
parent GPIO chip has been registered, of_gpio_notify() sets
OF_POPULATED on the node via of_node_test_and_set_flag() and only then
discovers that there is no gpio_device for the parent, returning
NOTIFY_DONE without clearing the flag.

Since gpiochip_hog_lines() skips any hog child whose of_node carries
OF_POPULATED, the leaked flag makes the hog silently ignored when the
chip is registered later. Applying an overlay containing both a GPIO
controller node and its hog children - and populating devices only
after the overlay apply completes - hits this on every boot; the hog
is only applied if the chip driver is unbound (which clears the flag
in the remove path) and rebound.

Look up the parent gpio_device before claiming the node so that a hog
attached ahead of its chip stays unclaimed and is picked up normally
by gpiochip_hog_lines() at registration time.

Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Fixes: a23226b7c1f6 ("gpiolib: handle gpio-hogs only once")
Cc: stable@vger.kernel.org
Reviewed-by: Daniel Drake <dan@reactivated.net>
Link: https://patch.msgid.link/20260815-gpiolib-of-hog-flag-leak-v1-1-6126aac5f6f3@nexthop.ai
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-of.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 940b566946ce..f36e4b171fa7 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -788,13 +788,13 @@ static int of_gpio_notify(struct notifier_block *nb, unsigned long action,
 		if (!of_property_read_bool(rd->dn, "gpio-hog"))
 			return NOTIFY_DONE;	/* not for us */
 
-		if (of_node_test_and_set_flag(rd->dn, OF_POPULATED))
-			return NOTIFY_DONE;
-
 		gdev = of_find_gpio_device_by_node(rd->dn->parent);
 		if (!gdev)
 			return NOTIFY_DONE;	/* not for us */
 
+		if (of_node_test_and_set_flag(rd->dn, OF_POPULATED))
+			return NOTIFY_DONE;
+
 		ret = gpiochip_add_hog(gpio_device_get_chip(gdev), of_fwnode_handle(rd->dn));
 		if (ret < 0) {
 			pr_err("%s: failed to add hogs for %pOF\n", __func__,
-- 
2.55.0



