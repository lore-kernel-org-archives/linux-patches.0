Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0805E1C07DB;
	Tue, 15 Oct 2024 13:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997526; cv=none; b=PW0KC+2Vif6TTg7GT5aX5nOFVF8PT+f7RvAgSseS9dD2QFyes/DmJqYuZ/Qrh2bestWN7M4azdaTEnsM5tQy0/q482opAlGXqiaYFsTiUKbuuK0h8IYYTkS0x4lcDFdCNHaKxQyqrjOo5jSbc4RIr7iQZBl0hevPYr0IMVtY8MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997526; c=relaxed/simple;
	bh=IVjrxskALrJh07NIhL2Um4fxbzLC9U8y/DhZfGwkpQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtkFS4oLfCvV8mwruaTX8MNmEzaqjlokg2whmkUGQWehNfpqWoX5mzaOs0JuPS6IliieC5+3YaoVnbxCI2t4paNwqPoYq3xAlvhhn/AgN+RkEXN7l+IsplTzk4ZIq4VN3sbxwyB8D49p+MjpyBp1dGRQ2hHHJqdbz6iKHSXcH0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AKENEE3D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AKENEE3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C73C4CEC6;
	Tue, 15 Oct 2024 13:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997525;
	bh=IVjrxskALrJh07NIhL2Um4fxbzLC9U8y/DhZfGwkpQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AKENEE3DpcumoWfyYGOmrJpjMy/r56Hzn+Dv/I0ggZTkwE2U74Yk3jnFucvDXZLWz
	 K4OsveHG+gR8TqXc4ubSmRkSkEBFm3V+U1Vh9H+mvQZVcHgmTUaVQup/Z2zcnIpQyZ
	 UkFozJlZKB1dDhTWOQxcOQYJVB+l2EqV6bNGtknI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Subject: [PATCH 5.10 209/518] Input: goodix - use the new soc_intel_is_byt() helper
Date: Tue, 15 Oct 2024 14:41:53 +0200
Message-ID: <20241015123925.060062261@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hans de Goede <hdegoede@redhat.com>

commit d176708ffc20332d1c730098d2b111e0b77ece82 upstream.

Use the new soc_intel_is_byt() helper from linux/platform_data/x86/soc.h.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220131143539.109142-5-hdegoede@redhat.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
[Ricardo: Resolved minor cherry-pick conflict. The file linux/regulator/
 consumer.h is not #included in the upstream version but it is in
 v5.10.y. ]
Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/goodix.c |   18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -23,6 +23,7 @@
 #include <linux/delay.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
+#include <linux/platform_data/x86/soc.h>
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
@@ -718,21 +719,6 @@ static int goodix_reset(struct goodix_ts
 }
 
 #ifdef ACPI_GPIO_SUPPORT
-#include <asm/cpu_device_id.h>
-#include <asm/intel-family.h>
-
-static const struct x86_cpu_id baytrail_cpu_ids[] = {
-	{ X86_VENDOR_INTEL, 6, INTEL_FAM6_ATOM_SILVERMONT, X86_FEATURE_ANY, },
-	{}
-};
-
-static inline bool is_byt(void)
-{
-	const struct x86_cpu_id *id = x86_match_cpu(baytrail_cpu_ids);
-
-	return !!id;
-}
-
 static const struct acpi_gpio_params first_gpio = { 0, 0, false };
 static const struct acpi_gpio_params second_gpio = { 1, 0, false };
 
@@ -816,7 +802,7 @@ static int goodix_add_acpi_gpio_mappings
 		dev_info(dev, "Using ACPI INTI and INTO methods for IRQ pin access\n");
 		ts->irq_pin_access_method = IRQ_PIN_ACCESS_ACPI_METHOD;
 		gpio_mapping = acpi_goodix_reset_only_gpios;
-	} else if (is_byt() && ts->gpio_count == 2 && ts->gpio_int_idx == -1) {
+	} else if (soc_intel_is_byt() && ts->gpio_count == 2 && ts->gpio_int_idx == -1) {
 		dev_info(dev, "No ACPI GpioInt resource, assuming that the GPIO order is reset, int\n");
 		ts->irq_pin_access_method = IRQ_PIN_ACCESS_ACPI_GPIO;
 		gpio_mapping = acpi_goodix_int_last_gpios;


