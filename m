Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482DE3D890F;
	Wed,  8 Apr 2026 18:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674528; cv=none; b=hHloBY1k2uPRfXRBsopvmSl09jIcbgKJ4NuL2fvfyqcYqSWX0GAmXm3iiraOw1tO/2iKxPFzIXjKoagyo+iKXYmFfpjFweK3Ug4sCdeZmuR7MkGPxIDsc/VoUsGIk9QmCmpgzwSrDjoTblOBpyzK367dllUicrb11s6XDcSFOh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674528; c=relaxed/simple;
	bh=02Ey/LAuGf0JU/2YynBYyYkvtOAARtIksyLSxKoUGgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cOFOS4KAIn8z3SCVJXzFMb4Wzydzyl4MV0eW0R0vcbHfT5EMPuTklL3WnRreZx4p/t/IpMk7wVJi/BhH26Fll8j+CQWiw0lLrw2frHaZr8zyFtXXHpyvoYphN1/RxJyJjyIhoey0htBSMvd0ZfIqEsCjUEJWMfZkCs7mzl9JUds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sP4Sg9V2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sP4Sg9V2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2939C19421;
	Wed,  8 Apr 2026 18:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674528;
	bh=02Ey/LAuGf0JU/2YynBYyYkvtOAARtIksyLSxKoUGgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sP4Sg9V2rirVe9f0+h7A0PAnokTup9cM+kWGTOuyzWr8UzdQjlsHLnFS3y4lRn0sv
	 xE7ODdsHPXrmqqIejQ0pSPthP39bFSX0LSOOYMzEke+vu/F+0W/vWot+4+V3CIzbnn
	 cRYbUQE7+kC+zym3hWrQeuiplakK6t5tBU72SlXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 131/311] gpio: shared: call gpio_chip::of_xlate() if set
Date: Wed,  8 Apr 2026 20:02:11 +0200
Message-ID: <20260408175944.307661583@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

[ Upstream commit 710abda58055ed5eaa8958107633cc12a365c328 ]

OF-based GPIO controller drivers may provide a translation function that
calculates the real chip offset from whatever devicetree sources
provide. We need to take this into account in the shared GPIO management
and call of_xlate() if it's provided and adjust the entry->offset we
initially set when scanning the tree.

To that end: modify the shared GPIO API to take the GPIO chip as
argument on setup (to avoid having to rcu_dereference() it from the GPIO
device) and protect the access to entry->offset with the existing lock.

Fixes: a060b8c511ab ("gpiolib: implement low-level, shared GPIO support")
Reported-by: Jon Hunter <jonathanh@nvidia.com>
Closes: https://lore.kernel.org/all/921ba8ce-b18e-4a99-966d-c763d22081e2@nvidia.com/
Reviewed-by: Linus Walleij <linusw@kernel.org>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://patch.msgid.link/20260318-gpio-shared-xlate-v2-1-0ce34c707e81@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-shared.c | 27 ++++++++++++++++++++++++++-
 drivers/gpio/gpiolib-shared.h |  4 ++--
 drivers/gpio/gpiolib.c        |  2 +-
 3 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpiolib-shared.c b/drivers/gpio/gpiolib-shared.c
index e16f467b72e7a..6316ae5a1c310 100644
--- a/drivers/gpio/gpiolib-shared.c
+++ b/drivers/gpio/gpiolib-shared.c
@@ -511,8 +511,9 @@ static void gpio_shared_remove_adev(struct auxiliary_device *adev)
 	auxiliary_device_uninit(adev);
 }
 
-int gpio_device_setup_shared(struct gpio_device *gdev)
+int gpiochip_setup_shared(struct gpio_chip *gc)
 {
+	struct gpio_device *gdev = gc->gpiodev;
 	struct gpio_shared_entry *entry;
 	struct gpio_shared_ref *ref;
 	struct gpio_desc *desc;
@@ -537,12 +538,34 @@ int gpio_device_setup_shared(struct gpio_device *gdev)
 	 * exposing shared pins. Find them and create the proxy devices.
 	 */
 	list_for_each_entry(entry, &gpio_shared_list, list) {
+		guard(mutex)(&entry->lock);
+
 		if (!device_match_fwnode(&gdev->dev, entry->fwnode))
 			continue;
 
 		if (list_count_nodes(&entry->refs) <= 1)
 			continue;
 
+#if IS_ENABLED(CONFIG_OF)
+		if (is_of_node(entry->fwnode) && gc->of_xlate) {
+			/*
+			 * This is the earliest that we can tranlate the
+			 * devicetree offset to the chip offset.
+			 */
+			struct of_phandle_args gpiospec = { };
+
+			gpiospec.np = to_of_node(entry->fwnode);
+			gpiospec.args_count = 2;
+			gpiospec.args[0] = entry->offset;
+
+			ret = gc->of_xlate(gc, &gpiospec, NULL);
+			if (ret < 0)
+				return ret;
+
+			entry->offset = ret;
+		}
+#endif /* CONFIG_OF */
+
 		desc = &gdev->descs[entry->offset];
 
 		__set_bit(GPIOD_FLAG_SHARED, &desc->flags);
@@ -580,6 +603,8 @@ void gpio_device_teardown_shared(struct gpio_device *gdev)
 	struct gpio_shared_ref *ref;
 
 	list_for_each_entry(entry, &gpio_shared_list, list) {
+		guard(mutex)(&entry->lock);
+
 		if (!device_match_fwnode(&gdev->dev, entry->fwnode))
 			continue;
 
diff --git a/drivers/gpio/gpiolib-shared.h b/drivers/gpio/gpiolib-shared.h
index 40568ef7364cc..e11e260e1f590 100644
--- a/drivers/gpio/gpiolib-shared.h
+++ b/drivers/gpio/gpiolib-shared.h
@@ -14,14 +14,14 @@ struct device;
 
 #if IS_ENABLED(CONFIG_GPIO_SHARED)
 
-int gpio_device_setup_shared(struct gpio_device *gdev);
+int gpiochip_setup_shared(struct gpio_chip *gc);
 void gpio_device_teardown_shared(struct gpio_device *gdev);
 int gpio_shared_add_proxy_lookup(struct device *consumer, const char *con_id,
 				 unsigned long lflags);
 
 #else
 
-static inline int gpio_device_setup_shared(struct gpio_device *gdev)
+static inline int gpiochip_setup_shared(struct gpio_chip *gc)
 {
 	return 0;
 }
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 04068f4eb3422..0285142893642 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1211,7 +1211,7 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 	if (ret)
 		goto err_remove_irqchip_mask;
 
-	ret = gpio_device_setup_shared(gdev);
+	ret = gpiochip_setup_shared(gc);
 	if (ret)
 		goto err_remove_irqchip;
 
-- 
2.53.0



