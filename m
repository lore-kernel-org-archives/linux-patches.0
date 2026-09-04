Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294363A7F4C;
	Fri,  4 Sep 2026 05:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501488; cv=none; b=BwVC2O/ZKCSMDAX7KLblmvC/FYvGrrjLjwOupUXgzEz2ncRTSHHDVg/utOA3K5+1aQI1J1S+7NJPR4xks1F8r4rWAr/5Yrv/+R/fMUGv9aD1VCnQEYMVTj9SK10Nu6JjEZqt9qQQMu5HFfxRZecpY2r0eRp0KkjvXlm4IpMF+bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501488; c=relaxed/simple;
	bh=An6vFAsQb0i8KqxESEPFgTgciG+znpEiVeOlNSHa1z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p+0kMn3f+GcitjyUy0MR9F8jM5X7EeetMG1fB5vx8tTc6LKNlcdUa2Le+RhAJOzz8YnSkdTa1jNFFceHEzg6nwRET3n+Ou7IzIpr1WZ0MAkCVUVzVl7YZSCDN+sI6MyqmqX8rVAWYkROVZrwMXK2EK+waKyy+adiIXPsgnUk/aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XaHwAYfW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XaHwAYfW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C22A1F00A3D;
	Fri,  4 Sep 2026 05:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501486;
	bh=y9BOGJa7uSXZjzi5MAS2W5oG0Gz4wNC/itD7miQLrrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XaHwAYfW7bJLmYw+N6+nH6WE4v1A32YNCUf00hqilsxmqaoefkjZVyoZ0FGcjjUuW
	 PV1gu8wbxqQvydmE58TEEL725TTdlkxBmn2n/lomLQc+30f4cFYGDUTxLzMknJ3tHK
	 p/uIKxsV10vgAkWDjexBW+YralJgW2WBEPdjtVKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Haarmann <julian.haarmann@student.kit.edu>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 426/552] platform/x86: lenovo/ymc: Only match lower byte in WMI lid switch query response
Date: Fri,  4 Sep 2026 06:59:43 +0200
Message-ID: <20260904045800.257351529@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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


