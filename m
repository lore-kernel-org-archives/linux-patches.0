Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3781D19CC0F;
	Fri,  4 Sep 2026 05:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499860; cv=none; b=rh7AuVGWLa346e9q+4J0IsmUbhAutjsRek8i91RhjhJ0N4x7le5pOvFlFEdemKwWj5Ag0/BPICsVYeudTiUv0SFvaSj08HmEDscFO7y7ZZAcKFgH/mrPs0uz0EsxNPiY9eE8pyLkivEX7LdwXt59RAwyyBM04pQ9ZyhKaY7pK+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499860; c=relaxed/simple;
	bh=D+/L3HWNFuRIsECBeCGjKUr5U8cjZpsqxj87qGyUeGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qVRMHmR2OHTrsVWhGfm1yRYgGJ9IujZ5b1gdRZlv3vyRdDW1eLbMx7tRStVdsbwyTh080nPN1kOK47JuZ4RIMjaTKkT+eAVpK7la7udCUz905xqgJb9qXH/KmB9Oazh5o2vMNVAUv7Be5f2VtvA8ltLmkNiOiMn8+KU8muELZuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uXW00cFf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uXW00cFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902221F00A3D;
	Fri,  4 Sep 2026 05:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499859;
	bh=Kz6/3SoPImM+YOmTdV58uqWYJNMg+7mo4rR1MSib5VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uXW00cFfU7LKp+PwBqDseFEU9iOAA1otxh7L/JCu1HSkRdgAkElL3uwa7DW6Xbr9k
	 YdZ5/TFpX2EDgtzRqW57myr8idB7DhoMJ6VTRlnnERpSJ8fGG9rml/5t2lSfSpAz7m
	 W7eECJYTcep2SG147azr61qvZuE6JYPi5t+VLyX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Haarmann <julian.haarmann@student.kit.edu>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 7.2 566/713] platform/x86: lenovo/ymc: Only match lower byte in WMI lid switch query response
Date: Fri,  4 Sep 2026 06:58:54 +0200
Message-ID: <20260904045816.505766256@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Haarmann <julian.haarmann@student.kit.edu>

commit bbc497b5231829d32c3a53b6e66be1add76c0064 upstream.

On newer Lenovo Yoga devices like the "Yoga 9 2-in-1 14IPH11 - Type 83SE",
the hinge switch WMI query returns extra data in the upper bits
(e.g. 0x50001 laptop mode, 0x50002 tablet mode, ect.).

The driver previously checked for exact matches (0x01 laptop, 0x02 tablet,
ect.) causing newer switches to not work.

Mask the WMI query result to only match the lower byte and ignore upper
bits.

Signed-off-by: Julian Haarmann <julian.haarmann@student.kit.edu>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260614203235.235724-1-julian.haarmann@student.kit.edu
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/lenovo/ymc.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/lenovo/ymc.c
+++ b/drivers/platform/x86/lenovo/ymc.c
@@ -8,6 +8,8 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/acpi.h>
+#include <linux/bitfield.h>
+#include <linux/bits.h>
 #include <linux/dmi.h>
 #include <linux/input.h>
 #include <linux/input/sparse-keymap.h>
@@ -20,6 +22,8 @@
 #define LENOVO_YMC_QUERY_INSTANCE 0
 #define LENOVO_YMC_QUERY_METHOD 0x01
 
+#define LENOVO_YMC_STATE_MASK GENMASK(7, 0)
+
 static bool force;
 module_param(force, bool, 0444);
 MODULE_PARM_DESC(force, "Force loading on boards without a convertible DMI chassis-type");
@@ -85,7 +89,9 @@ static void lenovo_ymc_notify(struct wmi
 			"WMI event data is not an integer\n");
 		goto free_obj;
 	}
-	code = obj->integer.value;
+
+	/* strip upper bits (e.g. 0x50000) on newer devices */
+	code = FIELD_GET(LENOVO_YMC_STATE_MASK, obj->integer.value);
 
 	if (!sparse_keymap_report_event(priv->input_dev, code, 1, true))
 		dev_warn(&wdev->dev, "Unknown key %d pressed\n", code);


