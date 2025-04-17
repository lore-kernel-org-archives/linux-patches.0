Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6C52571C6;
	Thu, 17 Apr 2025 18:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915559; cv=none; b=p2166VN+aE41uGOxBIqh6qJwz1P04uBfVry/0PxUfpWDH4Kfa9hJAvlxZNsqlXjYWMiHx6PFkVx0CAgh8zsWH5AaVCKIhbDjg18uLvDHXQCcBzoEVVb9lzsNKUfqlPCsvF4exVVmGYNjIB+txVIlUEOxznvwC8ap2e1JVok5XXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915559; c=relaxed/simple;
	bh=NF+D5MCr+EFJVcCkphIyPdi+NsaFzSlVqBgWtHzexLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nZoghAOv5xWwT5y8JI81vgrKQK2qrQk5ZFLGpNDrRt1tOX3vGFl85owsoz5DceXdtB6Yyye4Zmp97QJwB4LF0fszSF4HMUE5RuIbKpo/gxC8LvOM+1xLmv/5JczGVVx2OlGJo5xrnzDWh/z0oYA/PdWdNO+gWWB+bh9LP1/0c1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w40hdu6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w40hdu6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BE8C4CEEA;
	Thu, 17 Apr 2025 18:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915558;
	bh=NF+D5MCr+EFJVcCkphIyPdi+NsaFzSlVqBgWtHzexLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w40hdu6g4jfKECE+B20CwkysPLzNyf9AHV071KE2GV3jTxYCGYDv3c7v1GAuklxVX
	 7CGkhjh/pcxzpRZ+ysOZ5FodON1bZGo6cABomAeqzbiJcb3iQ/sZw0a/RUh8559l5j
	 EUQbKVDW3ErhpLDf2R3/qAlIC2ADWb+LoZSeIAIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	=?UTF-8?q?Micha=C5=82=20Kope=C4=87?= <michal@nozomi.space>,
	Paul Dino Jones <paul@spacefreak18.xyz>,
	=?UTF-8?q?Crist=C3=B3ferson=20Bueno?= <cbueno81@gmail.com>,
	Pablo Cisneros <patchkez@protonmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 166/393] HID: pidff: Clamp PERIODIC effect period to devices logical range
Date: Thu, 17 Apr 2025 19:49:35 +0200
Message-ID: <20250417175114.267487576@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit f538183e997a9fb6087e94e71e372de967b9e56a ]

This ensures the effect can actually be played on the connected force
feedback device. Adds clamping functions used instead of rescaling, as we
don't want to change the characteristics of the periodic effects.

Fixes edge cases found on Moza Racing and some other hardware where
the effects would not play if the period is outside the defined
logical range.

Changes in v6:
- Use in-kernel clamp macro instead of a custom solution

Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Reviewed-by: Michał Kopeć <michal@nozomi.space>
Reviewed-by: Paul Dino Jones <paul@spacefreak18.xyz>
Tested-by: Paul Dino Jones <paul@spacefreak18.xyz>
Tested-by: Cristóferson Bueno <cbueno81@gmail.com>
Tested-by: Pablo Cisneros <patchkez@protonmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hid-pidff.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index 25dbed076f530..6b55345ce75ac 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -15,10 +15,9 @@
 #include <linux/input.h>
 #include <linux/slab.h>
 #include <linux/usb.h>
-
 #include <linux/hid.h>
+#include <linux/minmax.h>
 
-#include "usbhid.h"
 
 #define	PID_EFFECTS_MAX		64
 #define	PID_INFINITE		0xffff
@@ -192,6 +191,16 @@ struct pidff_device {
 	u32 quirks;
 };
 
+/*
+ * Clamp value for a given field
+ */
+static s32 pidff_clamp(s32 i, struct hid_field *field)
+{
+	s32 clamped = clamp(i, field->logical_minimum, field->logical_maximum);
+	pr_debug("clamped from %d to %d", i, clamped);
+	return clamped;
+}
+
 /*
  * Scale an unsigned value with range 0..max for the given field
  */
@@ -372,7 +381,11 @@ static void pidff_set_periodic_report(struct pidff_device *pidff,
 	pidff_set_signed(&pidff->set_periodic[PID_OFFSET],
 			 effect->u.periodic.offset);
 	pidff_set(&pidff->set_periodic[PID_PHASE], effect->u.periodic.phase);
-	pidff->set_periodic[PID_PERIOD].value[0] = effect->u.periodic.period;
+
+	/* Clamp period to ensure the device can play the effect */
+	pidff->set_periodic[PID_PERIOD].value[0] =
+		pidff_clamp(effect->u.periodic.period,
+			pidff->set_periodic[PID_PERIOD].field);
 
 	hid_hw_request(pidff->hid, pidff->reports[PID_SET_PERIODIC],
 			HID_REQ_SET_REPORT);
-- 
2.39.5



