Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F901EE7C6;
	Mon, 23 Jun 2025 21:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714522; cv=none; b=j4pOvURT8lJAe7V7un6PCoxvk5H5Mbi/f02dyB+fwKF8fCiVXd4u/1yqJL6O+cmpYuj2H2MPWEz5PIbI00UHI0R3ZXTlUPZtlegFB1oy9V4eAJGbP8rrnmOy6Vqf4CwWtFAt7SOKTbctQ/U1b4pZdMcyemBqD0rphHjWxe5kb/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714522; c=relaxed/simple;
	bh=z1AmzGk33VAEYgdE6esMIn80JXSXA5hSS6d500AckE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OuALavwAFxol36AI3+FBGs/tPLsBYsSEy5bPBf+4xFFZoWtBO+q07K9nwk8nFxPTj5U113avsZkLfq3zKv0RWpnSStPMBEtSd2uR7bwSma0XxCXTS3pMAeYCwSJRYZM9vylppQPdZiFO6j4LjLfeDK1PvTYmHr7im3+iWbw4QfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=khvB4TIb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="khvB4TIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F448C4CEEA;
	Mon, 23 Jun 2025 21:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714521;
	bh=z1AmzGk33VAEYgdE6esMIn80JXSXA5hSS6d500AckE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=khvB4TIbBVUk6mQSimjBCF4bT+Ppa+VFhr+eKD3JW0jhAfowXTrDGhmMi9npfQa/y
	 8jKxpImSXyxq8SRrfPq/1SjkKFjwzi9UUaI8+ZpoGpvkLfHaf+hu6QiDvqRIGYQQXd
	 //idI7wpVblbwP8fi1jqLhNttU88HPek44+0HR5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 420/592] wifi: ath11k: determine PM policy based on machine model
Date: Mon, 23 Jun 2025 15:06:18 +0200
Message-ID: <20250623130710.426390590@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit ce8669a27016354dfa8bf3c954255cb9f3583bae ]

To handle the Lenovo unexpected wakeup issue [1], previously we revert
commit 166a490f59ac ("wifi: ath11k: support hibernation"). So currently
WLAN target is put into WoWLAN mode during suspend. This is a temporary
solution as it does not work on machines where WLAN power is cut off.

The thought here is that we do WoWLAN suspend on Lenovo machines while
do non-WoWLAN suspend (which is done in the reverted commit) on other
machines. This requires us to identify Lenovo machines from others.
For that purpose, read board vendor and product name from DMI interface,
match it against all known affected machines. If there is a match, choose
WoWLAN suspend mode, else choose non-WoWLAN mode. Save the mode in ab
for later reference.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=219196

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.30

Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Tested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Link: https://patch.msgid.link/20250328-ath11k-bring-hibernation-back-v3-1-23405ae23431@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/core.c | 55 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath11k/core.h |  7 ++++
 2 files changed, 62 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index 22eb1b0377ffe..0281ce6fb7177 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -907,6 +907,52 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 	},
 };
 
+static const struct dmi_system_id ath11k_pm_quirk_table[] = {
+	{
+		.driver_data = (void *)ATH11K_PM_WOW,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21J4"),
+		},
+	},
+	{
+		.driver_data = (void *)ATH11K_PM_WOW,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21K4"),
+		},
+	},
+	{
+		.driver_data = (void *)ATH11K_PM_WOW,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21K6"),
+		},
+	},
+	{
+		.driver_data = (void *)ATH11K_PM_WOW,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21K8"),
+		},
+	},
+	{
+		.driver_data = (void *)ATH11K_PM_WOW,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21KA"),
+		},
+	},
+	{
+		.driver_data = (void *)ATH11K_PM_WOW,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21F9"),
+		},
+	},
+	{}
+};
+
 static inline struct ath11k_pdev *ath11k_core_get_single_pdev(struct ath11k_base *ab)
 {
 	WARN_ON(!ab->hw_params.single_pdev_only);
@@ -2334,8 +2380,17 @@ EXPORT_SYMBOL(ath11k_core_pre_init);
 
 int ath11k_core_init(struct ath11k_base *ab)
 {
+	const struct dmi_system_id *dmi_id;
 	int ret;
 
+	dmi_id = dmi_first_match(ath11k_pm_quirk_table);
+	if (dmi_id)
+		ab->pm_policy = (kernel_ulong_t)dmi_id->driver_data;
+	else
+		ab->pm_policy = ATH11K_PM_DEFAULT;
+
+	ath11k_dbg(ab, ATH11K_DBG_BOOT, "pm policy %u\n", ab->pm_policy);
+
 	ret = ath11k_core_soc_create(ab);
 	if (ret) {
 		ath11k_err(ab, "failed to create soc core: %d\n", ret);
diff --git a/drivers/net/wireless/ath/ath11k/core.h b/drivers/net/wireless/ath/ath11k/core.h
index 529aca4f40621..81a8fe7bed448 100644
--- a/drivers/net/wireless/ath/ath11k/core.h
+++ b/drivers/net/wireless/ath/ath11k/core.h
@@ -894,6 +894,11 @@ struct ath11k_msi_config {
 	u16 hw_rev;
 };
 
+enum ath11k_pm_policy {
+	ATH11K_PM_DEFAULT,
+	ATH11K_PM_WOW,
+};
+
 /* Master structure to hold the hw data which may be used in core module */
 struct ath11k_base {
 	enum ath11k_hw_rev hw_rev;
@@ -1060,6 +1065,8 @@ struct ath11k_base {
 	} testmode;
 #endif
 
+	enum ath11k_pm_policy pm_policy;
+
 	/* must be last */
 	u8 drv_priv[] __aligned(sizeof(void *));
 };
-- 
2.39.5



