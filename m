Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CD74317D;
	Wed,  8 Apr 2026 18:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674530; cv=none; b=KVeW4MGgGSntYRdQBUE4X2eyFjwDmSukq6Dpc9CFsABilAJtD6inaYAlapqqWcE1pKAOqcYWILobq/9+sDjoEABuRUer0UNvXCUm4LQDS+22d/dYZkt1EX6SoiWf2BKt49LfmaRqBx3hiQRXBMcMYVnRhNrg7rXISLwYeZpN0+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674530; c=relaxed/simple;
	bh=nbKayHBrN+z+LS+zVq4dooOGSVJRbwGfb09MPz13IKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXlVmn0ZlLw7AqKb8igOw6no/eEnYxWwxxqFI1owscYcxPCAm4v4V+9rNneKWhSrytsVI10IkQx/9Ij9a3j5dkuZsUv02q0y8iGf7hpsmTgiQOgkAjBitW/cmvwBE+OJPoVfr5b0AjUw65iGibHQrViF2WkONqX+IuV8u4zBTsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jOKtxSFS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jOKtxSFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686A8C19421;
	Wed,  8 Apr 2026 18:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674530;
	bh=nbKayHBrN+z+LS+zVq4dooOGSVJRbwGfb09MPz13IKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jOKtxSFS84pUd8qwciJK6Mz6KMH+geisK4m18TwjPqMgqmqbjTSi/PlTqFvwLT5fd
	 ITkwV7iumEoyv5SE4lwZp2QplRk/sDqokpblp9BLjIikSVB9g+mrKWp6mREb3CvlQm
	 veDRqtp/sFamsHaOiDNp73YeMOIgHWGeMh9mEVS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 132/311] gpio: shared: handle pins shared by child nodes of devices
Date: Wed,  8 Apr 2026 20:02:12 +0200
Message-ID: <20260408175944.345279841@linuxfoundation.org>
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

[ Upstream commit ec42a3a90ae9ae64b16d01a2e5d32ec0865ca8cf ]

Shared GPIOs may be assigned to child nodes of device nodes which don't
themselves bind to any struct device. We need to pass the firmware node
that is the actual consumer to gpiolib-shared and compare against it
instead of unconditionally using the fwnode of the consumer device.

Fixes: a060b8c511ab ("gpiolib: implement low-level, shared GPIO support")
Reported-by: Jon Hunter <jonathanh@nvidia.com>
Closes: https://lore.kernel.org/all/921ba8ce-b18e-4a99-966d-c763d22081e2@nvidia.com/
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://patch.msgid.link/20260318-gpio-shared-xlate-v2-2-0ce34c707e81@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-shared.c | 6 +++---
 drivers/gpio/gpiolib-shared.h | 7 +++++--
 drivers/gpio/gpiolib.c        | 4 ++--
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/gpiolib-shared.c b/drivers/gpio/gpiolib-shared.c
index 6316ae5a1c310..9c31736d29b77 100644
--- a/drivers/gpio/gpiolib-shared.c
+++ b/drivers/gpio/gpiolib-shared.c
@@ -443,8 +443,8 @@ static bool gpio_shared_dev_is_reset_gpio(struct device *consumer,
 }
 #endif /* CONFIG_RESET_GPIO */
 
-int gpio_shared_add_proxy_lookup(struct device *consumer, const char *con_id,
-				 unsigned long lflags)
+int gpio_shared_add_proxy_lookup(struct device *consumer, struct fwnode_handle *fwnode,
+				 const char *con_id, unsigned long lflags)
 {
 	const char *dev_id = dev_name(consumer);
 	struct gpiod_lookup_table *lookup;
@@ -463,7 +463,7 @@ int gpio_shared_add_proxy_lookup(struct device *consumer, const char *con_id,
 			if (!ref->fwnode && strstarts(dev_name(consumer), "reset.gpio.")) {
 				if (!gpio_shared_dev_is_reset_gpio(consumer, entry, ref))
 					continue;
-			} else if (!device_match_fwnode(consumer, ref->fwnode)) {
+			} else if (fwnode != ref->fwnode) {
 				continue;
 			}
 
diff --git a/drivers/gpio/gpiolib-shared.h b/drivers/gpio/gpiolib-shared.h
index e11e260e1f590..15e72a8dcdb13 100644
--- a/drivers/gpio/gpiolib-shared.h
+++ b/drivers/gpio/gpiolib-shared.h
@@ -11,13 +11,15 @@
 struct gpio_device;
 struct gpio_desc;
 struct device;
+struct fwnode_handle;
 
 #if IS_ENABLED(CONFIG_GPIO_SHARED)
 
 int gpiochip_setup_shared(struct gpio_chip *gc);
 void gpio_device_teardown_shared(struct gpio_device *gdev);
-int gpio_shared_add_proxy_lookup(struct device *consumer, const char *con_id,
-				 unsigned long lflags);
+int gpio_shared_add_proxy_lookup(struct device *consumer,
+				 struct fwnode_handle *fwnode,
+				 const char *con_id, unsigned long lflags);
 
 #else
 
@@ -29,6 +31,7 @@ static inline int gpiochip_setup_shared(struct gpio_chip *gc)
 static inline void gpio_device_teardown_shared(struct gpio_device *gdev) { }
 
 static inline int gpio_shared_add_proxy_lookup(struct device *consumer,
+					       struct fwnode_handle *fwnode,
 					       const char *con_id,
 					       unsigned long lflags)
 {
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 0285142893642..fc7c4bf2de2be 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -4720,8 +4720,8 @@ struct gpio_desc *gpiod_find_and_request(struct device *consumer,
 			 * lookup table for the proxy device as previously
 			 * we only knew the consumer's fwnode.
 			 */
-			ret = gpio_shared_add_proxy_lookup(consumer, con_id,
-							   lookupflags);
+			ret = gpio_shared_add_proxy_lookup(consumer, fwnode,
+							   con_id, lookupflags);
 			if (ret)
 				return ERR_PTR(ret);
 
-- 
2.53.0



