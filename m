Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CF12580F1;
	Thu, 17 Apr 2025 18:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915267; cv=none; b=XS6fI1pGkNXRFEFJ8zmDY3+AErKHWhrVUUPwPahl0NrDhQFdLNVD9NN+dvQ7b3Qlb9HMftzGY8gjfUyiuTRA/sagsoYczpk0iA6dyW4lvUBCN3pDwYBVzYITg40sD3xz5FvJ+pDPN/+SHswwIH4Z2XL18OeRBoSdyNPyErBOi0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915267; c=relaxed/simple;
	bh=f6K5HyvHvaa13X5WOIlRql0tAmV8Xk8A+uBcGjadR6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etHWCqGrNyOr2tBgYklqfCKzWPgMrkAR6MJweyh554lT3JhXx9qx5q7kNd46HujKjAvCj47g7m2595vUR1BjKo935wWa1AiBjnzPBBZSeWziR4HgtwF9VEODSnwWj4hbHcodK89kWekTre9HFs4f4wAGsDeuB1vCsubIuXPdT08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Y+NeD5V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Y+NeD5V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F47C4CEE4;
	Thu, 17 Apr 2025 18:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915267;
	bh=f6K5HyvHvaa13X5WOIlRql0tAmV8Xk8A+uBcGjadR6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Y+NeD5VzlNTG9eFcxV0jINbKjRDm7TRhMg/O/qzPIgFgYzcW984xkC78dQ3o/mYH
	 pEATfc33qBacqAVnXeDOrc4A6ut12Ab3cYpaFYjXeZ4leY5hqBPp056DegKBPmIZ7W
	 znm9BRD2g25HrSW2A9W95POG1tSy4ajFlRGDoQJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Mikityanskiy <maxtram95@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/393] ALSA: hda: intel: Add Lenovo IdeaPad Z570 to probe denylist
Date: Thu, 17 Apr 2025 19:48:02 +0200
Message-ID: <20250417175110.531780886@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxim Mikityanskiy <maxtram95@gmail.com>

[ Upstream commit becc794c5e46f4dfca59f2385f78d83fc9e84700 ]

Lenovo IdeaPad Z570 with NVIDIA GeForce Ge 540M doesn't have sound on
the discrete GPU. The HDA controller in DGPU is disabled by BIOS, but
then reenabled by quirk_nvidia_hda(). The probe fails and ends up with
the "GPU sound probed, but not operational" error.

Add this laptop to DMI-based denylist to prevent probe early. DMI is
used, because the audio device has zero subsystem IDs, and this entry
would be too much, blocking all 540M chips:
    PCI_DEVICE_SUB(0x10de, 0x0bea, 0x0000, 0x0000)
Also, this laptop comes in a variety of modifications with different
NVIDIA GPUs, so the DMI check will cover them all.

Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Link: https://patch.msgid.link/20250208214602.39607-3-maxtram95@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index b511563bbb6ba..25b1984898ab2 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -37,6 +37,7 @@
 #include <linux/completion.h>
 #include <linux/acpi.h>
 #include <linux/pgtable.h>
+#include <linux/dmi.h>
 
 #ifdef CONFIG_X86
 /* for snoop control */
@@ -2084,6 +2085,27 @@ static const struct pci_device_id driver_denylist[] = {
 	{}
 };
 
+static struct pci_device_id driver_denylist_ideapad_z570[] = {
+	{ PCI_DEVICE_SUB(0x10de, 0x0bea, 0x0000, 0x0000) }, /* NVIDIA GF108 HDA */
+	{}
+};
+
+/* DMI-based denylist, to be used when:
+ *  - PCI subsystem IDs are zero, impossible to distinguish from valid sound cards.
+ *  - Different modifications of the same laptop use different GPU models.
+ */
+static const struct dmi_system_id driver_denylist_dmi[] = {
+	{
+		/* No HDA in NVIDIA DGPU. BIOS disables it, but quirk_nvidia_hda() reenables. */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "Ideapad Z570"),
+		},
+		.driver_data = &driver_denylist_ideapad_z570,
+	},
+	{}
+};
+
 static const struct hda_controller_ops pci_hda_ops = {
 	.disable_msi_reset_irq = disable_msi_reset_irq,
 	.position_check = azx_position_check,
@@ -2094,6 +2116,7 @@ static DECLARE_BITMAP(probed_devs, SNDRV_CARDS);
 static int azx_probe(struct pci_dev *pci,
 		     const struct pci_device_id *pci_id)
 {
+	const struct dmi_system_id *dmi;
 	struct snd_card *card;
 	struct hda_intel *hda;
 	struct azx *chip;
@@ -2106,6 +2129,12 @@ static int azx_probe(struct pci_dev *pci,
 		return -ENODEV;
 	}
 
+	dmi = dmi_first_match(driver_denylist_dmi);
+	if (dmi && pci_match_id(dmi->driver_data, pci)) {
+		dev_info(&pci->dev, "Skipping the device on the DMI denylist\n");
+		return -ENODEV;
+	}
+
 	dev = find_first_zero_bit(probed_devs, SNDRV_CARDS);
 	if (dev >= SNDRV_CARDS)
 		return -ENODEV;
-- 
2.39.5



