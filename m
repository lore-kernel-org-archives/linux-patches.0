Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C5F1684BE;
	Fri, 13 Feb 2026 13:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770991047; cv=none; b=iqbU1On66xenPitRIksv4i65oBHhZOHUAnD5pOgPILCrMirTlIVZ12JB2/3CfsNxrHUufvxfs5QOzxJouHsk8Ssa1n2NY0G2BXhiyzNoo5Wdso0tcssS8Ws2l/Nujd/h9qYKEh2MnV6dAi4bIZO12IqJDwEq9dpSkBeTrL1JJCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770991047; c=relaxed/simple;
	bh=3ergQln+7S2NtjhGVnGS0dmu0F3pdbros+dy49ecO2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYnl1AkukxkCQgEEWITkZmhe5wGPSheDAET0YNrk43mjJxPFVKz9FbNZqGczslH98IBpAywftkZm3k/i6HKOpirFhCoQYbm3JbTTDYzhO05nEueliNuGVEokRdgocFrHCQIgoHMAefPUa18bXnwKUm/ZZgJpb7eCWP8xIS10m/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xc3FKti2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xc3FKti2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB9FC19423;
	Fri, 13 Feb 2026 13:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770991047;
	bh=3ergQln+7S2NtjhGVnGS0dmu0F3pdbros+dy49ecO2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xc3FKti2QEGlk2ADcPgLK8gV5nlAOpniMT91ygs++qf2+NI6vbtUTPM4BjcTvlvjt
	 hXjd9e0FpEF9/HuR+gZwMtYjvz/vpmR9ukuw+RIjChrYayv1u8uxj8DQEGPN3SYb5m
	 3q4S1XCMCY9/BbZG3OOO8BI5LyOSw5HnvxUVFeWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.6 25/25] gpio: omap: do not register driver in probe()
Date: Fri, 13 Feb 2026 14:48:51 +0100
Message-ID: <20260213134704.795896468@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134703.882698935@linuxfoundation.org>
References: <20260213134703.882698935@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -799,10 +799,13 @@ static struct platform_device omap_mpuio
 
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
@@ -1575,13 +1578,24 @@ static struct platform_driver omap_gpio_
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
 


