Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC6328853A;
	Wed,  4 Feb 2026 15:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217818; cv=none; b=Fs4S9W7TBa4Qw2Jq/zrN3tORWcU2LITA8b3vr7u06bgrFnTRhFgz29AOap8sxaS65DXBZdqTYrjbyEVuuDNjs4TvCFKMKku/Oto2/LeHglhNrgyylj3ai/kEnyPRPvfe7gyXQS9pVwB1/xGj9CuuAzGA4EhIQggTL/bDwrqEgQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217818; c=relaxed/simple;
	bh=0jrabtnSDjSzHPa8jsyuz/pLr9/FlGiYQPPRZpQe7U8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3ABKn/dyOWRNNV+PDknz1tbiPfO45RLsmRxt66h979Z7AbrHKBt8pqIIfSgPaMcmcs7OG90H4JdNd54I8qPLmTSwt/4WZTNWWpHA9X4vrlEvGhFyn4p3j+nJkb+n08Im/+xKaXug+3j3VnTgN1ZwNiJ0i4F55yjE3WDvGriNhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1LWTdaUy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1LWTdaUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CD7C116C6;
	Wed,  4 Feb 2026 15:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217818;
	bh=0jrabtnSDjSzHPa8jsyuz/pLr9/FlGiYQPPRZpQe7U8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1LWTdaUyddNST6yNaCA0CtCk/SJEPKA+KBvfGJu6ujrBfHy+dTxexnX99/nfqI7c6
	 HCPL5JlxRPt99aLDRkoKVBkr4FI9ApcLhPY4CPN+/iXp0P6ZwdqLUgptWSjpH7Zz/3
	 Lm7jeIxhFNTiQcvQKRKVfGDsvS8NCcWIUtGaTywM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/280] ata: libata-core: Introduce ata_dev_config_lpm()
Date: Wed,  4 Feb 2026 15:37:48 +0100
Message-ID: <20260204143913.036919814@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 31c8156a4f3d3..1277b80726535 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2617,6 +2617,30 @@ static void ata_dev_config_cpr(struct ata_device *dev)
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
@@ -2785,6 +2809,7 @@ int ata_dev_configure(struct ata_device *dev)
 			ata_dev_config_chs(dev);
 		}
 
+		ata_dev_config_lpm(dev);
 		ata_dev_config_fua(dev);
 		ata_dev_config_devslp(dev);
 		ata_dev_config_sense_reporting(dev);
-- 
2.51.0



