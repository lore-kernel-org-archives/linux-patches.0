Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693AA10A1E;
	Wed, 28 Jan 2026 15:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614461; cv=none; b=muHV9HK47ieu8s7y5BjzIjnQG9/LxTT6rX9Kt5NCGsb2u9vmkAw41vhCvHMPtV6SS9I1WyjZO/8k4qPhphwLyqqJUAjgZg+T7tFM51gy8TG4STRqKej1xy5m54kiJDgj4s15uxrkGbhguINV7Bb1dUYP0cTnCRwIibaSSSt6ecQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614461; c=relaxed/simple;
	bh=wCtur0ox20ecDJx5QUowtsjN4fqZjcbZLpk6f0l9zqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iIUaJPGX1rHEyRYPn2jPC3IXey3w+Z4qZmP5hzRINZZnXdAUSFGT03oNYmcXVIfKnJdS2m3zXtBz27oav1sMn46Ts20xeeXsyrMz7Sx3pcpvfLTSBJIHSQZnum+dvprkAcR6MKMfachRNSpMgI+Ynv/HGvsQ8meVfL28mmg58U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Be+iDrUk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Be+iDrUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98FFC4CEF1;
	Wed, 28 Jan 2026 15:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614461;
	bh=wCtur0ox20ecDJx5QUowtsjN4fqZjcbZLpk6f0l9zqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Be+iDrUk908Dq4gYeeVrYk9796xpUxwMMWtgNNP0mKCuhTUxirR39dJ5nJIwpcloL
	 9eHmsp95lvy+gbhXbADzFCmYSnt42eoz+o9t6o8jTZKMeolcAC5XGvqVDPBAREpmqb
	 UkGV1e1SksMC12MPFRFGq5zIdDKYIav5n85QbeCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 112/254] ata: libata-core: Introduce ata_dev_config_lpm()
Date: Wed, 28 Jan 2026 16:21:28 +0100
Message-ID: <20260128145348.854141808@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit d360121832d8a36871249271df5b9ff05f835f62 ]

If the port of a device does not support Device Initiated Power
Management (DIPM), that is, the port is flagged with ATA_FLAG_NO_DIPM,
the DIPM feature of a device should not be used. Though DIPM is disabled
by default on a device, the "Software Settings Preservation feature"
may keep DIPM enabled or DIPM may have been enabled by the system
firmware.

Introduce the function ata_dev_config_lpm() to always disable DIPM on a
device that supports this feature if the port of the device is flagged
with ATA_FLAG_NO_DIPM. ata_dev_config_lpm() is called from
ata_dev_configure(), ensuring that a device DIPM feature is disabled
when it cannot be used.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Link: https://lore.kernel.org/r/20250701125321.69496-2-dlemoal@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Stable-dep-of: c8c6fb886f57 ("ata: libata: Print features also for ATAPI devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index f332835156dbc..b748c8ead39de 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2780,6 +2780,30 @@ static void ata_dev_config_cpr(struct ata_device *dev)
 	kfree(buf);
 }
 
+/*
+ * Configure features related to link power management.
+ */
+static void ata_dev_config_lpm(struct ata_device *dev)
+{
+	struct ata_port *ap = dev->link->ap;
+	unsigned int err_mask;
+
+	/*
+	 * Device Initiated Power Management (DIPM) is normally disabled by
+	 * default on a device. However, DIPM may have been enabled and that
+	 * setting kept even after COMRESET because of the Software Settings
+	 * Preservation feature. So if the port does not support DIPM and the
+	 * device does, disable DIPM on the device.
+	 */
+	if (ap->flags & ATA_FLAG_NO_DIPM && ata_id_has_dipm(dev->id)) {
+		err_mask = ata_dev_set_feature(dev,
+					SETFEATURES_SATA_DISABLE, SATA_DIPM);
+		if (err_mask && err_mask != AC_ERR_DEV)
+			ata_dev_err(dev, "Disable DIPM failed, Emask 0x%x\n",
+				    err_mask);
+	}
+}
+
 static void ata_dev_print_features(struct ata_device *dev)
 {
 	if (!(dev->flags & ATA_DFLAG_FEATURES_MASK) && !dev->cpr_log)
@@ -2949,6 +2973,7 @@ int ata_dev_configure(struct ata_device *dev)
 			ata_dev_config_chs(dev);
 		}
 
+		ata_dev_config_lpm(dev);
 		ata_dev_config_fua(dev);
 		ata_dev_config_devslp(dev);
 		ata_dev_config_sense_reporting(dev);
-- 
2.51.0



