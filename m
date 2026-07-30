Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167F03451B3;
	Thu, 30 Jul 2026 15:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427017; cv=none; b=IEWDrW6e6ZPR4TvRXs3hMex1WW6TU++2AptnFNXNuTxHR0tiqI6MyLPaPeL3HUJ3mqjIpdgE9a7re1UuOT9YWvXFceM01ZdRBF8jHhNLvmYo/QBPQ10BbnWgyUt6n+kUON4GsvihzwjXr5+fede0t3GSrbX8YpEIq08YxkysM9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427017; c=relaxed/simple;
	bh=LesL4J/6AKRRoQLDrxSblVtZNlqUEmdKgGV2ToAYgUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KHmXLUMjGRbiNv5PshRraWF3hiRmmerzcu0x4Tuyra5FSw8+8XXrPi3Dxh040xl2AjGpaRx+tJURdqXERe0cwvnHBnjnFp7xIgXne1G96rvS4FriWy+iOlXquUp3hZhP98vJ6LWJlyDtPaLKo/NQUul2Q3Sd6npZSJYE5bqUxkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f0hX1RUw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f0hX1RUw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728E81F000E9;
	Thu, 30 Jul 2026 15:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427016;
	bh=sjoLukYfwkNQk40c+ctPqvQB3VBMSVli/WoKz16xejE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f0hX1RUwXeRBl+FosLhPle88OA0ssY4azfj6GouISli4P3VhcI29bCapBxlWxukwA
	 h/5zvq/ABf99g2Uj6rTMFEM8SV1JfeEDdhOoo3p1wTewL0miEPHI9m/0JtBuMIRi67
	 T1FBjQXL/qOcGe0e7lq+yp2QEsefi81Rn5wKz81I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Daniel Gibson <daniel@gibson.sh>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/484] platform/x86/amd/pmc: Dont log during intermediate wakeups
Date: Thu, 30 Jul 2026 16:08:22 +0200
Message-ID: <20260730141423.518433048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Link: https://patch.msgid.link/20260611150426.3683372-5-daniel@gibson.sh
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc/pmc.c | 39 ++++++++++++++++++++++++------
 drivers/platform/x86/amd/pmc/pmc.h |  1 +
 2 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/drivers/platform/x86/amd/pmc/pmc.c b/drivers/platform/x86/amd/pmc/pmc.c
index d5b543f74a22db..b0951236887797 100644
--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -811,6 +811,20 @@ static bool amd_pmc_intermediate_wakeup_need_delay(struct amd_pmc_dev *pdev)
 
 static bool amd_pmc_want_suspend_delay(struct amd_pmc_dev *pdev)
 {
+	/*
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
 	/*
 	 * Some Lenovo Laptops (like different IdeaPad 3 Slims) need some
 	 * me-time before sleeping or they get uncooperative after waking
@@ -829,17 +843,20 @@ static bool amd_pmc_want_suspend_delay(struct amd_pmc_dev *pdev)
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
@@ -852,6 +869,9 @@ static void amd_pmc_s2idle_prepare(void)
 	u8 msg;
 	u32 arg = 1;
 
+	/* Reset this variable because this is a fresh suspend */
+	pdev->is_first_check_after_suspend = true;
+
 	/* Reset and Start SMU logging - to monitor the s0i3 stats */
 	amd_pmc_setup_smu_logging(pdev);
 
@@ -891,6 +911,9 @@ static void amd_pmc_s2idle_check(void)
 	rc = amd_pmc_write_stb(pdev, AMD_PMC_STB_S2IDLE_CHECK);
 	if (rc)
 		dev_err(pdev->dev, "error writing to STB: %d\n", rc);
+
+	/* remember that first check after suspend is done (until next prepare) */
+	pdev->is_first_check_after_suspend = false;
 }
 
 static int amd_pmc_dump_data(struct amd_pmc_dev *pdev)
diff --git a/drivers/platform/x86/amd/pmc/pmc.h b/drivers/platform/x86/amd/pmc/pmc.h
index 5e7b8d5dc5d624..bea65810de5ab6 100644
--- a/drivers/platform/x86/amd/pmc/pmc.h
+++ b/drivers/platform/x86/amd/pmc/pmc.h
@@ -37,6 +37,7 @@ struct amd_pmc_dev {
 	struct dentry *dbgfs_dir;
 	struct quirk_entry *quirks;
 	bool disable_8042_wakeup;
+	bool is_first_check_after_suspend;
 };
 
 void amd_pmc_process_restore_quirks(struct amd_pmc_dev *dev);
-- 
2.53.0



