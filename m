Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FADD47125D;
	Tue, 21 Jul 2026 18:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658953; cv=none; b=Kbj4njxlYDfeCQfO7Bugg/Q4C5rxVgTosjCIuGaUT1T+47rssdg966y/miGXDNVsiI7v9HRZvuS6GegiLEn2+SAv8AvbvQLuV+yah365D8fb1ZXGHidGXcjDN6DrI25Z7+8fLKdIOo8VdbdoAKw6i5EZh0nnekcYLJq/NHfnIpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658953; c=relaxed/simple;
	bh=XJGcOURoqG5hg7uJaL3Soqrtu8H9P1dUA9RgMKTh+W0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=quNFreuHq0seccIiebINRmUWNJY06Hp0DXIVRahwwPi9BgBomzrPGZZxZjn19WLsA1Lq4UzuXhnXCDWoUJ13tLFXwQEZ16inqPTiqJA6j9giWhkHI0R6m9g4kMyMX5Gpa9er16w2ob9tQKVKaycMvJLcDoR3XwtxrbHED3sLegY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RLwhGPG7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RLwhGPG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75ADD1F000E9;
	Tue, 21 Jul 2026 18:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658952;
	bh=NY9O4U8LmaQJL8fitACYIVD9Z6dr0NkO8VvDDYQxNRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RLwhGPG7TEdzIRK0LH/k9aYTLW1/1QKH/SsUlVv2kquX2mZqDJeAROKL8n0uxgb/G
	 A6AanFW6FMOU13a9nm8zPJw00l6h7MbKmshKS9fZZB+MoYFdEogDCLMzxEjufQooZM
	 +JvXYqULjE6X3i4IAXmEwWltjedJliRkxn34WO2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Daniel Gibson <daniel@gibson.sh>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 1301/1611] platform/x86/amd/pmc: Dont log during intermediate wakeups
Date: Tue, 21 Jul 2026 17:23:37 +0200
Message-ID: <20260721152544.709280850@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Daniel Gibson <daniel@gibson.sh>

commit 037f0b03c663a247366673a807834389107995b7 upstream.

The ECs in the IdeaPads that need the delay_suspend quirk send lots
of messages when charging, which not only causes intermediate wakeups
when suspended, but also prevents the device from reaching the deepest
suspend state.

Because of this amd_pmc_intermediate_wakeup_need_delay() returns false
during intermediate wakeups and amd_pmc_want_suspend_delay() is called.
So far it always logged its "Delaying suspend by 2.5s ..." messages
then, which spams dmesg. This commit makes sure that those messages are
only logged once per suspend.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221383
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Daniel Gibson <daniel@gibson.sh>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260611150426.3683372-5-daniel@gibson.sh
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/pmc/pmc.c |   39 +++++++++++++++++++++++++++++--------
 drivers/platform/x86/amd/pmc/pmc.h |    1 
 2 files changed, 32 insertions(+), 8 deletions(-)

--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -620,6 +620,20 @@ static bool amd_pmc_intermediate_wakeup_
 static bool amd_pmc_want_suspend_delay(struct amd_pmc_dev *pdev)
 {
 	/*
+	 * intermediate_wakeup implies that the machine didn't get to deepest sleep
+	 * state before - otherwise this function isn't called in amd_pmc_s2idle_check()
+	 * because amd_pmc_intermediate_wakeup_need_delay() returns true first.
+	 * On some IdeaPads that happens when charging, because the EC seems
+	 * to send lots of messages then that wake the machine.
+	 *
+	 * But even in that case, the sleep here is necessary (on those IdeaPads),
+	 * otherwise they wake up completely (resume) after a few seconds.
+	 * So this variable is only used to avoid spamming dmesg on each
+	 * intermediate wakeup.
+	 */
+	bool intermediate_wakeup = !pdev->is_first_check_after_suspend;
+
+	/*
 	 * Some Lenovo Laptops (like different IdeaPad 3 Slims) need some
 	 * me-time before sleeping or they get uncooperative after waking
 	 * up and don't send events for keyboard and lid switch anymore.
@@ -637,17 +651,20 @@ static bool amd_pmc_want_suspend_delay(s
 		 * disabled with disable_workarounds or delay_suspend=0
 		 */
 		if (delay_suspend == 1 || (delay_suspend == -1 && !disable_workarounds)) {
-			dev_info(pdev->dev, "Delaying suspend by 2.5s to avoid platform bug\n");
+			if (!intermediate_wakeup)
+				dev_info(pdev->dev, "Delaying suspend by 2.5s to avoid platform bug\n");
 			return true;
 		}
-		dev_info(pdev->dev, "Not delaying suspend because of module parameter, even though your device is assumed to need it!\n");
+		if (!intermediate_wakeup)
+			dev_info(pdev->dev, "Not delaying suspend because of module parameter, even though your device is assumed to need it!\n");
 	} else if (delay_suspend == 1) {
-		dev_info(pdev->dev, "Delaying suspend by 2.5s because delay_suspend=1. If this solves problems on your machine, please report this whole line to: platform-driver-x86@vger.kernel.org so it can be automatically detected as affected in the future. System Vendor: \"%s\" Product Name: \"%s\" Product Family: \"%s\" Board Vendor: \"%s\" Board Name: \"%s\"\n",
-			 dmi_get_system_info(DMI_SYS_VENDOR),
-			 dmi_get_system_info(DMI_PRODUCT_NAME),
-			 dmi_get_system_info(DMI_PRODUCT_FAMILY),
-			 dmi_get_system_info(DMI_BOARD_VENDOR),
-			 dmi_get_system_info(DMI_BOARD_NAME));
+		if (!intermediate_wakeup)
+			dev_info(pdev->dev, "Delaying suspend by 2.5s because delay_suspend=1. If this solves problems on your machine, please report this whole line to: platform-driver-x86@vger.kernel.org so it can be automatically detected as affected in the future. System Vendor: \"%s\" Product Name: \"%s\" Product Family: \"%s\" Board Vendor: \"%s\" Board Name: \"%s\"\n",
+				 dmi_get_system_info(DMI_SYS_VENDOR),
+				 dmi_get_system_info(DMI_PRODUCT_NAME),
+				 dmi_get_system_info(DMI_PRODUCT_FAMILY),
+				 dmi_get_system_info(DMI_BOARD_VENDOR),
+				 dmi_get_system_info(DMI_BOARD_NAME));
 		return true;
 	}
 	return false;
@@ -660,6 +677,9 @@ static void amd_pmc_s2idle_prepare(void)
 	u8 msg;
 	u32 arg = 1;
 
+	/* Reset this variable because this is a fresh suspend */
+	pdev->is_first_check_after_suspend = true;
+
 	/* Reset and Start SMU logging - to monitor the s0i3 stats */
 	amd_pmc_setup_smu_logging(pdev);
 
@@ -699,6 +719,9 @@ static void amd_pmc_s2idle_check(void)
 	rc = amd_stb_write(pdev, AMD_PMC_STB_S2IDLE_CHECK);
 	if (rc)
 		dev_err(pdev->dev, "error writing to STB: %d\n", rc);
+
+	/* remember that first check after suspend is done (until next prepare) */
+	pdev->is_first_check_after_suspend = false;
 }
 
 static int amd_pmc_dump_data(struct amd_pmc_dev *pdev)
--- a/drivers/platform/x86/amd/pmc/pmc.h
+++ b/drivers/platform/x86/amd/pmc/pmc.h
@@ -114,6 +114,7 @@ struct amd_pmc_dev {
 	struct dentry *dbgfs_dir;
 	struct quirk_entry *quirks;
 	bool disable_8042_wakeup;
+	bool is_first_check_after_suspend;
 	struct amd_mp2_dev *mp2;
 	struct stb_arg stb_arg;
 };


