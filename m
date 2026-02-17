Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9472D46D6;
	Tue, 17 Feb 2026 20:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771360971; cv=none; b=bjWdQHJzU0KgUOF5svR7EcAodBEuY2DskT/qA7sAQafdzGrbXpAxVDO+6VfDWtaO+GHF7/wfUgjU0FrTTG4KHuVkQHvk6hb0YKhqaHoapkB0omjaCgdkv9u1q5nktqJ0QPMWuNofmgcaNPxDtPBU6XVFwqx0sSsvmRSSTSV7zyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771360971; c=relaxed/simple;
	bh=hvb15pf7IFHHiAZNnrFKhzSNnnWq0aAnUjQSbREWpJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OdaGnsglC1fmA3SmTNbwWsTonZcLl0MbsfbvfTN2B1CuXwi1mxVV813BT0EK2kktG3Mo/NIeqOsYKsbO/0VeWFPmPPTTohVvzc+w4a1PbV9isQo5632J9+SRe92oyanUeviwxJ4XG7Wa+m9nwdcyGjaxdvP/LU/S3iFYtpkSHoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KGcjLePP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KGcjLePP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04C1C4CEF7;
	Tue, 17 Feb 2026 20:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771360971;
	bh=hvb15pf7IFHHiAZNnrFKhzSNnnWq0aAnUjQSbREWpJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KGcjLePP5HBU+j2lQ7Sr0WJrn5298x9cswzQ7P7IKfNvBKSCglrU0mN92Pd0IRzDb
	 r5nuXi9EwZfrDw7Z9Xs31g6mQ9y9IRepYxbvm85L/5WOSu6XUo5+fdSwc+7x2h1kJ6
	 EtUI/vHMPbAIHEU/vYmg5PKjZcKiRQWIw15Sxyag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 5.10 07/24] gpio: omap: do not register driver in probe()
Date: Tue, 17 Feb 2026 21:31:20 +0100
Message-ID: <20260217200000.993314575@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200000.708219618@linuxfoundation.org>
References: <20260217200000.708219618@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

commit 730e5ebff40c852e3ea57b71bf02a4b89c69435f upstream.

Commit 11a78b794496 ("ARM: OMAP: MPUIO wake updates") registers the
omap_mpuio_driver from omap_mpuio_init(), which is called from
omap_gpio_probe().

However, it neither makes sense to register drivers from probe()
callbacks of other drivers, nor does the driver core allow registering
drivers with a device lock already being held.

The latter was revealed by commit dc23806a7c47 ("driver core: enforce
device_lock for driver_match_device()") leading to a potential deadlock
condition described in [1].

Additionally, the omap_mpuio_driver is never unregistered from the
driver core, even if the module is unloaded.

Hence, register the omap_mpuio_driver from the module initcall and
unregister it in module_exit().

Link: https://lore.kernel.org/lkml/DFU7CEPUSG9A.1KKGVW4HIPMSH@kernel.org/ [1]
Fixes: dc23806a7c47 ("driver core: enforce device_lock for driver_match_device()")
Fixes: 11a78b794496 ("ARM: OMAP: MPUIO wake updates")
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Link: https://patch.msgid.link/20260127201725.35883-1-dakr@kernel.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-omap.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -763,10 +763,13 @@ static struct platform_device omap_mpuio
 
 static inline void omap_mpuio_init(struct gpio_bank *bank)
 {
-	platform_set_drvdata(&omap_mpuio_device, bank);
+	static bool registered;
 
-	if (platform_driver_register(&omap_mpuio_driver) == 0)
-		(void) platform_device_register(&omap_mpuio_device);
+	platform_set_drvdata(&omap_mpuio_device, bank);
+	if (!registered) {
+		(void)platform_device_register(&omap_mpuio_device);
+		registered = true;
+	}
 }
 
 /*---------------------------------------------------------------------*/
@@ -1579,13 +1582,24 @@ static struct platform_driver omap_gpio_
  */
 static int __init omap_gpio_drv_reg(void)
 {
-	return platform_driver_register(&omap_gpio_driver);
+	int ret;
+
+	ret = platform_driver_register(&omap_mpuio_driver);
+	if (ret)
+		return ret;
+
+	ret = platform_driver_register(&omap_gpio_driver);
+	if (ret)
+		platform_driver_unregister(&omap_mpuio_driver);
+
+	return ret;
 }
 postcore_initcall(omap_gpio_drv_reg);
 
 static void __exit omap_gpio_exit(void)
 {
 	platform_driver_unregister(&omap_gpio_driver);
+	platform_driver_unregister(&omap_mpuio_driver);
 }
 module_exit(omap_gpio_exit);
 


