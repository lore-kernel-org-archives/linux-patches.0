Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C5C40244D;
	Tue, 21 Jul 2026 17:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654655; cv=none; b=pdn44OmuUGLw4YVYCDSeURfsgk9c1eU4lcTP/jQwIg/J8N++3eIjt67oBYFvblczDK1Kc9lCIEpNe61mtb9gEzYr7pezOt5H5sBtpGw1ajdJVAGj9MiRpcebEjS+KStNaTghqbxqY0l/ZYaYVVrCapmQOTAT3vkZwIrYkXHi+JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654655; c=relaxed/simple;
	bh=ST4Tox/+tQOptQc5mC9jrN78Fy4R9JGdPECz1ZGqfhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UnyP2cLb/0v7rSvow/J/L6wdMYkXhbyIAEJWr+4b3EtKcwypFeKws4AytSdt2IhxvPuYFTEs+LpcZet7ZfwmtrHZSM6VugO9IKcw4mXirW6yE6VpEvK0oee5gV8CKbbrYlrxyVTgbHoB0IVfgSSvDmiGctxqG6bWgpT/dzwjDPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jr78cvVh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jr78cvVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0ACF1F000E9;
	Tue, 21 Jul 2026 17:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654654;
	bh=WBtnY1Krnd7L3V5GXTIM/7RHKTRCR7i81IxoqB1/Jlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jr78cvVhWrug/ZBmZMYIOYCHbPVHcO0AoHITxO8OX42HYKv3xETg2s6qlWBQZA611
	 dTqavpyZvH4wIcA+sfCELImsjB7YLLc5NsRa81AOdgqWIuKzJ2vg9zsgjRPHoX9BKi
	 yFvP64hrVyJjvJL/ce2MiC8Bw0AiRwc4bpIiXMaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Daniel Gibson <daniel@gibson.sh>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 7.1 1786/2077] platform/x86/amd/pmc: Add delay_suspend module parameter
Date: Tue, 21 Jul 2026 17:24:19 +0200
Message-ID: <20260721152634.872378216@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Gibson <daniel@gibson.sh>

commit 428b9fd2dce50b4dc5cd9ade10b92efcf57ce7aa upstream.

Enabling the new delay_suspend module parameter delays suspend for
2.5 seconds which is known to help for some AMD-based Lenovo Laptops
that otherwise failed to send/receive events for key presses or the
lid switch after s2idle. Apparently the EC needs to do some things
in the background before suspend or it gets into a bad state.

There are many reports of AMD-based laptops (mostly but not exclusively
IdeaPads) about similar issues on the web; this parameter gives
affected users an easy way to try out if their issues have the same
root cause and to work around them until their specific device is added
to the quirks list.

The parameter description has a note encouraging users to report
their device so it can be added to the quirks list, inspired by a
similar request in parameter descriptions of the ideapad-laptop module.

The module parameter can be set to "1" to explicitly enable it,
"0" to disable it even on devices that are assumed to be affected,
or -1 (the default) to enable it if the device is assumed to be affected
(according to fwbug_list[])

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221383
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Daniel Gibson <daniel@gibson.sh>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260611150426.3683372-4-daniel@gibson.sh
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/pmc/pmc.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -16,6 +16,7 @@
 #include <linux/bits.h>
 #include <linux/debugfs.h>
 #include <linux/delay.h>
+#include <linux/dmi.h>
 #include <linux/io.h>
 #include <linux/iopoll.h>
 #include <linux/limits.h>
@@ -89,6 +90,11 @@ static bool disable_workarounds;
 module_param(disable_workarounds, bool, 0644);
 MODULE_PARM_DESC(disable_workarounds, "Disable workarounds for platform bugs");
 
+static int delay_suspend = -1;
+module_param(delay_suspend, int, 0644);
+MODULE_PARM_DESC(delay_suspend,
+		 "Delays s2idle by 2.5 seconds to work around buggy ECs, often causing keyboard issues after suspend. 0: don't delay, 1: do delay, -1 (default): let amd_pmc decide. If you need this please report this to: platform-driver-x86@vger.kernel.org");
+
 static struct amd_pmc_dev pmc;
 
 static inline u32 amd_pmc_reg_read(struct amd_pmc_dev *dev, int reg_offset)
@@ -625,8 +631,23 @@ static bool amd_pmc_want_suspend_delay(s
 	 *
 	 * See https://bugzilla.kernel.org/show_bug.cgi?id=221383
 	 */
-	if (!disable_workarounds && amd_pmc_quirk_need_suspend_delay(pdev)) {
-		dev_info(pdev->dev, "Delaying suspend by 2.5s to avoid platform bug\n");
+	if (amd_pmc_quirk_need_suspend_delay(pdev)) {
+		/*
+		 * delay_suspend=1 force-enables this, otherwise it can be
+		 * disabled with disable_workarounds or delay_suspend=0
+		 */
+		if (delay_suspend == 1 || (delay_suspend == -1 && !disable_workarounds)) {
+			dev_info(pdev->dev, "Delaying suspend by 2.5s to avoid platform bug\n");
+			return true;
+		}
+		dev_info(pdev->dev, "Not delaying suspend because of module parameter, even though your device is assumed to need it!\n");
+	} else if (delay_suspend == 1) {
+		dev_info(pdev->dev, "Delaying suspend by 2.5s because delay_suspend=1. If this solves problems on your machine, please report this whole line to: platform-driver-x86@vger.kernel.org so it can be automatically detected as affected in the future. System Vendor: \"%s\" Product Name: \"%s\" Product Family: \"%s\" Board Vendor: \"%s\" Board Name: \"%s\"\n",
+			 dmi_get_system_info(DMI_SYS_VENDOR),
+			 dmi_get_system_info(DMI_PRODUCT_NAME),
+			 dmi_get_system_info(DMI_PRODUCT_FAMILY),
+			 dmi_get_system_info(DMI_BOARD_VENDOR),
+			 dmi_get_system_info(DMI_BOARD_NAME));
 		return true;
 	}
 	return false;


