Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E709379979;
	Wed, 23 Sep 2026 14:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173843; cv=none; b=JrHG9/GBgnxAji3mMl820/uep2xFpspV6+FKjzj//LEnzXow77Gw97LRbgADkny1kWzpMr2HoLx9Ez4/CuonIjmh8rPs4at4mPz4GHHfNKSDKKVYCSitVa2Paqus5+zulWy7qcM8oqdMur+qsdIR3nsB9sJFVG0e/mQ6xGia2hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173843; c=relaxed/simple;
	bh=PBduvR4tyJt0Ga4EqdspUPBfxVhhqS9OESIFi2RTROQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GCRhTeJUR78E83n59V0CIYRwIwu4Fww7ADwOlyLLwKxS31hLhOCZLrIQHLIIywpmkACZ8sXWLFGF6wou+MiAovdJHRAXXHDKO0xCCtKv6vaCZ/J1pefv399n6EZt46j3Trqzjpu2UUY2DEpUG4KZa2TdO/1I4CemlU81p6DtLCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=frSImWnZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="frSImWnZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55A31F000FF;
	Wed, 23 Sep 2026 14:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173842;
	bh=0QApSaKRxAt6O+Lnddkh2f/UtmQSMJ06sHms7fNkRCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=frSImWnZVcx0SwRtAu4cjSBrXSlXpWgl76IH8+jFJOs8WWaFQns85B5CUFLnWN1mW
	 plN0N4Upsi0a2vw+0eJMbzWmazG+pe1UA7Hgi9LNd1Tm0e26H5q64wTOdjHqxS42t+
	 YEFFzavnQZfdaSwufAUvQ0U1RprSLgFp7R6cyeOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Lebedev <lsa.uz@pm.me>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.2 360/438] Input: soc_button_array - fix MS Surface Pro 11 probe failure
Date: Wed, 23 Sep 2026 16:06:21 +0200
Message-ID: <20260923140654.180711432@linuxfoundation.org>
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

From: Hans de Goede <johannes.goede@oss.qualcomm.com>

commit ed22ad5fdbdbf9b4cb4ad3003f60314b5a5eb89d upstream.

On the MS Surface Pro 11 soc_button_array probing races with the GPIO
driver probing. If soc_button_array wins the race then gpiod_get() returns
EPROBE_DEFER, which should normally take care of retrying later, but
the soc_button_array code deliberately ignores EPROBE_DEFER causing it
to fail its probe() which causes the volume and power buttons to now work.

The ignoring of EPROBE_DEFER is there to deal with a problem specific to
older Bay Trail (BYT) and Cherry Trail (CHT) tablets which often use this
driver. Modify the error handling to only ignore EPROBE_DEFER on BYT and
CHT platforms and propagate EPROBE_DEFER normally on other platforms.

Fixes: bcf059578980 ("Input: soc_button_array - partial revert of support for newer surface devices")
Cc: stable@vger.kernel.org
Reported-by: Sergey Lebedev <lsa.uz@pm.me>
Closes: https://lore.kernel.org/lkml/20260830141355.55898-1-lsa.uz@pm.me/
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Tested-by: Sergey Lebedev <lsa.uz@pm.me>
Link: https://patch.msgid.link/20260909093934.29411-1-johannes.goede@oss.qualcomm.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/soc_button_array.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/input/misc/soc_button_array.c
+++ b/drivers/input/misc/soc_button_array.c
@@ -16,6 +16,7 @@
 #include <linux/gpio/consumer.h>
 #include <linux/gpio_keys.h>
 #include <linux/gpio.h>
+#include <linux/platform_data/x86/soc.h>
 #include <linux/platform_device.h>
 
 static bool use_low_level_irq;
@@ -160,7 +161,7 @@ soc_button_device_create(struct platform
 	struct gpio_keys_platform_data *gpio_keys_pdata;
 	const struct dmi_system_id *dmi_id;
 	int invalid_acpi_index = -1;
-	int error, gpio, irq;
+	int error, gpio, irq = 0;
 	int n_buttons = 0;
 
 	for (info = button_info; info->name; info++)
@@ -191,8 +192,9 @@ soc_button_device_create(struct platform
 		error = soc_button_lookup_gpio(&pdev->dev, info->acpi_index, &gpio, &irq);
 		if (error || irq < 0) {
 			/*
-			 * Skip GPIO if not present. Note we deliberately
-			 * ignore -EPROBE_DEFER errors here. On some devices
+			 * Propagate -EPROBE_DEFER, skip button on other errors.
+			 *
+			 * -EPROBE_DEFER is ignored on Bay & Cherry Trail. Here
 			 * Intel is using so called virtual GPIOs which are not
 			 * GPIOs at all but some way for AML code to check some
 			 * random status bits without need a custom opregion.
@@ -201,6 +203,12 @@ soc_button_device_create(struct platform
 			 * we do not have a driver for these so they will never
 			 * show up, therefore we ignore -EPROBE_DEFER.
 			 */
+			if ((error == -EPROBE_DEFER || irq == -EPROBE_DEFER) &&
+			    !(soc_intel_is_byt() || soc_intel_is_cht())) {
+				error = -EPROBE_DEFER;
+				goto err_free_mem;
+			}
+
 			continue;
 		}
 


