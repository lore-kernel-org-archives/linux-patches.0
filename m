Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AF01DED60;
	Tue,  8 Oct 2024 12:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392272; cv=none; b=tXX4OkPCtSmwdCCXAo2XSx/1beJd4l+6j+UGC5V+6en2V6QMirsKGptjvBwrKAIPiMqRauOijT4kVrQPjIFTxEnebcO5YWRJhl8FboQ5994Kbkd4yr+ISPxR1nGpANq0croqwWbt2XNre6HUJfQilmTpCvFsXyT6nmBLSNZJe9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392272; c=relaxed/simple;
	bh=tY1RKcFiV/MRcvjcTB6bJOD7IZb2NSKefCtyxWzNMYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o1NYOUJZp8e0kYckTLajZyjmsL3TBSaFOsfaTC/v2FrCs2PFbjTF95vXmtt7sg+tKFrnggXDarcH2y2MnF6X/RDMIx4d2Nvok3rPOErkpWTK2+mon8ZwBqCGysjsuvThA2cZJQE9j3R1L9MxtoyRATE0/Cn6Ux6YbIrjkp5oULE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b//SF56i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b//SF56i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BB7C4CEC7;
	Tue,  8 Oct 2024 12:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392271;
	bh=tY1RKcFiV/MRcvjcTB6bJOD7IZb2NSKefCtyxWzNMYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b//SF56icJNNtJ4+/0xfdIlZxtm+U4QCW1Glt2reGlI3Ojh0s6o0KccuB08aK1IUX
	 LyRu3RJmx3Vv5LAclrzFRaJAzrVhwE6rAxE8d+q9XULWjNVksWDGfEuinO4xjVOxiu
	 owzUfhH0zhvRgiraWieU+ylTOvmi73vEKmsqoB+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Andrey Smirnov <andrew.smirnov@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.11 366/558] power: supply: Drop use_cnt check from power_supply_property_is_writeable()
Date: Tue,  8 Oct 2024 14:06:36 +0200
Message-ID: <20241008115716.699563927@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 78f281e5bdeb6476fab97a2c3fcece1094b42aaf upstream.

power_supply_property_is_writeable() gets called from the is_visible()
callback for the sysfs attributes of power_supply class devices and for
the sysfs attributes of power_supply core instantiated hwmon class devices.

These sysfs attributes get registered by the device_add() respectively
power_supply_add_hwmon_sysfs() calls in power_supply_register().

use_cnt gets initialized to 0 and is incremented only after these calls.
So when power_supply_property_is_writeable() gets called it always return
-ENODEV because of use_cnt == 0.

This causes all the attributes to have permissions of 444 even those which
should be writable. This used to be a problem only for hwmon sysfs
attributes but since commit be6299c6e55e ("power: supply: sysfs: use
power_supply_property_is_writeable()") this now also impacts power_supply
class sysfs attributes.

Fixes: be6299c6e55e ("power: supply: sysfs: use power_supply_property_is_writeable()")
Fixes: e67d4dfc9ff1 ("power: supply: Add HWMON compatibility layer")
Cc: stable@vger.kernel.org
Cc: Thomas Weißschuh <linux@weissschuh.net>
Cc: Andrey Smirnov <andrew.smirnov@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/stable/20240908185337.103696-1-hdegoede%40redhat.com
Link: https://lore.kernel.org/r/20240908185337.103696-1-hdegoede@redhat.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/power_supply_core.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -1232,11 +1232,7 @@ EXPORT_SYMBOL_GPL(power_supply_set_prope
 int power_supply_property_is_writeable(struct power_supply *psy,
 					enum power_supply_property psp)
 {
-	if (atomic_read(&psy->use_cnt) <= 0 ||
-			!psy->desc->property_is_writeable)
-		return -ENODEV;
-
-	return psy->desc->property_is_writeable(psy, psp);
+	return psy->desc->property_is_writeable && psy->desc->property_is_writeable(psy, psp);
 }
 EXPORT_SYMBOL_GPL(power_supply_property_is_writeable);
 


