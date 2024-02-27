Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11FA13B295;
	Tue, 27 Feb 2024 13:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041003; cv=none; b=k75b/LVdpECv8Zr6dQfXuIYXjkbGETQD8KbC9L4nvwFEg6ELoQLIH2ekx3764Ox/Il0rNMpQbrp1uzex34G0Xzhm4AL+u9U5ZKckLc2tp5zIyirQVzVzMfiUPyAzK2t0FZVcWSZuJG1GcVy4ALAMvnfJKWXLOTOUyQCrH3icpiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041003; c=relaxed/simple;
	bh=25sFedtMhfuwShsPp6/ncZAlRSMZ/osQ6Xlu2fo9NkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXBvNsj5u40mBPY4VQd/6No1UusV6OWQ1mzt/JcNJlP/M+xMAsXO7xqGecZnQGQhVRuPDLF9FQj48CgT9f5oUl+cX6ilI12M+Y8Y/XpF6E7o9tam+LnuVAtI7kmzVWpCpQHZfNAKM7629BJc0CSUjzXgA0JcWMIaK8+d1pqmVEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E4Y2leNR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E4Y2leNR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31479C43390;
	Tue, 27 Feb 2024 13:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041002;
	bh=25sFedtMhfuwShsPp6/ncZAlRSMZ/osQ6Xlu2fo9NkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E4Y2leNRLk+ahg6StTVVpHfNXxCvYiQrdwDfrl4b8fU+V4l03gJogfhlVRanLy1Mm
	 HMoBWdNF+qBDl0KwDWWUVpYtoFzy4rLIjqbll96mjglO1AITyq42OQHeGUpHc+TQm1
	 8ClXzOlt6FHkEp9gyXHSjTssTsi2XEuUp2IRzVl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.7 156/334] ata: libata-core: Do not call ata_dev_power_set_standby() twice
Date: Tue, 27 Feb 2024 14:20:14 +0100
Message-ID: <20240227131635.500998589@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 9cec467d0502b24660f413a0e8fc782903b46d5b upstream.

For regular system shutdown, ata_dev_power_set_standby() will be
executed twice: once the scsi device is removed and another when
ata_pci_shutdown_one() executes and EH completes unloading the devices.

Make the second call to ata_dev_power_set_standby() do nothing by using
ata_dev_power_is_active() and return if the device is already in
standby.

Fixes: 2da4c5e24e86 ("ata: libata-core: Improve ata_dev_power_set_active()")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |   59 +++++++++++++++++++++++-----------------------
 1 file changed, 30 insertions(+), 29 deletions(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2001,6 +2001,33 @@ bool ata_dev_power_init_tf(struct ata_de
 	return true;
 }
 
+static bool ata_dev_power_is_active(struct ata_device *dev)
+{
+	struct ata_taskfile tf;
+	unsigned int err_mask;
+
+	ata_tf_init(dev, &tf);
+	tf.flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_ISADDR;
+	tf.protocol = ATA_PROT_NODATA;
+	tf.command = ATA_CMD_CHK_POWER;
+
+	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0, 0);
+	if (err_mask) {
+		ata_dev_err(dev, "Check power mode failed (err_mask=0x%x)\n",
+			    err_mask);
+		/*
+		 * Assume we are in standby mode so that we always force a
+		 * spinup in ata_dev_power_set_active().
+		 */
+		return false;
+	}
+
+	ata_dev_dbg(dev, "Power mode: 0x%02x\n", tf.nsect);
+
+	/* Active or idle */
+	return tf.nsect == 0xff;
+}
+
 /**
  *	ata_dev_power_set_standby - Set a device power mode to standby
  *	@dev: target device
@@ -2017,8 +2044,9 @@ void ata_dev_power_set_standby(struct at
 	struct ata_taskfile tf;
 	unsigned int err_mask;
 
-	/* If the device is already sleeping, do nothing. */
-	if (dev->flags & ATA_DFLAG_SLEEPING)
+	/* If the device is already sleeping or in standby, do nothing. */
+	if ((dev->flags & ATA_DFLAG_SLEEPING) ||
+	    !ata_dev_power_is_active(dev))
 		return;
 
 	/*
@@ -2046,33 +2074,6 @@ void ata_dev_power_set_standby(struct at
 			    err_mask);
 }
 
-static bool ata_dev_power_is_active(struct ata_device *dev)
-{
-	struct ata_taskfile tf;
-	unsigned int err_mask;
-
-	ata_tf_init(dev, &tf);
-	tf.flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_ISADDR;
-	tf.protocol = ATA_PROT_NODATA;
-	tf.command = ATA_CMD_CHK_POWER;
-
-	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0, 0);
-	if (err_mask) {
-		ata_dev_err(dev, "Check power mode failed (err_mask=0x%x)\n",
-			    err_mask);
-		/*
-		 * Assume we are in standby mode so that we always force a
-		 * spinup in ata_dev_power_set_active().
-		 */
-		return false;
-	}
-
-	ata_dev_dbg(dev, "Power mode: 0x%02x\n", tf.nsect);
-
-	/* Active or idle */
-	return tf.nsect == 0xff;
-}
-
 /**
  *	ata_dev_power_set_active -  Set a device power mode to active
  *	@dev: target device


