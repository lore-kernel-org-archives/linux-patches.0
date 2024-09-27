Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937F018A6C3;
	Fri, 27 Sep 2024 12:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440039; cv=none; b=noxnlgauDh7yPOix+/vWXXzcAfdy82jvKQC1K8PHjVDjfSiDQnt5oneMB6U25lmkpLnKbHOqtH94wV19je+4Pb7wDvjHU9v4Z35dCBNknpEpB+b1FJg4uZZKd831RoR+Ba09Oy8DzhnZ5GyvQxczmlhgVNBfQS/HYIvTbGUVJJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440039; c=relaxed/simple;
	bh=Mb35LydMRHdu566M4v0yyAM4mAoLee8pmvB5zrL2fWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UYpLMpzd6bjkUXkgeCXdWNuyTiGzzSl37t4g4rs9aLbnmYvbEDi6HUAIaMd8HsfEa11IqA/XtYtDSnJjFf0eid3T65JUe9HBCt2wBID6uFUA3B3KNIYfs+Bi0D6TPRAc/XJ4uOv/GVkXlh8wn9FLRitmvOxzu+FcHle55YO0sKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gt0Xn99N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gt0Xn99N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF49C4CEC4;
	Fri, 27 Sep 2024 12:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440039;
	bh=Mb35LydMRHdu566M4v0yyAM4mAoLee8pmvB5zrL2fWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gt0Xn99NLDbDg1HhDRaGbirJ9x9pEvjNjooqXZrxBOAd6F1MMa/afpuTmgmTXucTE
	 oQVeD14/WWpA93uhgti8CzJC4WK3p/oKQyQmxH2HR2vG83k0DKP0iajOwllSigrfrH
	 BNemUyuz8QZHSty6hkd4bzeiTwLYkgR7nLWt4j3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Fenniak <mathieu@fenniak.net>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 11/58] platform/x86: asus-wmi: Fix spurious rfkill on UX8406MA
Date: Fri, 27 Sep 2024 14:23:13 +0200
Message-ID: <20240927121719.248996451@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathieu Fenniak <mathieu@fenniak.net>

[ Upstream commit 9286dfd5735b9cceb6a14bdf15e13400ccb60fe7 ]

The Asus Zenbook Duo (UX8406MA) has a keyboard which can be
placed on the laptop to connect it via USB, or can be removed from the
laptop to reveal a hidden secondary display in which case the keyboard
operates via Bluetooth.

When it is placed on the secondary display to connect via USB, it emits
a keypress for a wireless disable. This causes the rfkill system to be
activated disconnecting the current wifi connection, which doesn't
reflect the user's true intention.

Detect this hardware and suppress any wireless switches from the
keyboard; this keyboard does not have a wireless toggle capability so
these presses are always spurious.

Signed-off-by: Mathieu Fenniak <mathieu@fenniak.net>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20240823135630.128447-1-mathieu@fenniak.net
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 20 +++++++++++++++++++-
 drivers/platform/x86/asus-wmi.h    |  1 +
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index fceffe2082ec5..ed3633c5955d9 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -145,6 +145,10 @@ static struct quirk_entry quirk_asus_ignore_fan = {
 	.wmi_ignore_fan = true,
 };
 
+static struct quirk_entry quirk_asus_zenbook_duo_kbd = {
+	.ignore_key_wlan = true,
+};
+
 static int dmi_matched(const struct dmi_system_id *dmi)
 {
 	pr_info("Identified laptop model '%s'\n", dmi->ident);
@@ -516,6 +520,15 @@ static const struct dmi_system_id asus_quirks[] = {
 		},
 		.driver_data = &quirk_asus_ignore_fan,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUS Zenbook Duo UX8406MA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "UX8406MA"),
+		},
+		.driver_data = &quirk_asus_zenbook_duo_kbd,
+	},
 	{},
 };
 
@@ -630,7 +643,12 @@ static void asus_nb_wmi_key_filter(struct asus_wmi_driver *asus_wmi, int *code,
 	case 0x32: /* Volume Mute */
 		if (atkbd_reports_vol_keys)
 			*code = ASUS_WMI_KEY_IGNORE;
-
+		break;
+	case 0x5D: /* Wireless console Toggle */
+	case 0x5E: /* Wireless console Enable */
+	case 0x5F: /* Wireless console Disable */
+		if (quirks->ignore_key_wlan)
+			*code = ASUS_WMI_KEY_IGNORE;
 		break;
 	}
 }
diff --git a/drivers/platform/x86/asus-wmi.h b/drivers/platform/x86/asus-wmi.h
index cc30f18538472..d02f15fd3482f 100644
--- a/drivers/platform/x86/asus-wmi.h
+++ b/drivers/platform/x86/asus-wmi.h
@@ -40,6 +40,7 @@ struct quirk_entry {
 	bool wmi_force_als_set;
 	bool wmi_ignore_fan;
 	bool filter_i8042_e1_extended_codes;
+	bool ignore_key_wlan;
 	enum asus_wmi_tablet_switch_mode tablet_switch_mode;
 	int wapf;
 	/*
-- 
2.43.0



