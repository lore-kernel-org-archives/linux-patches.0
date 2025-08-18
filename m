Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE43335BAA;
	Mon, 18 Aug 2025 13:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523206; cv=none; b=TEm4CMjN+08WaQ+bXURKFqfl5h7Sx5YF2mvIMt5NH7SkJR7ruslNyfIwwKf8LZ9LV8rz2cCrHefaTvO70SdrjSKqDpaAxRt2lgAQQkX3GoAnVNiLd9GnInki2UQK8T4gSVY68SEf63aVxPFM6cOoBA35gy+0gDB0T+D9SfWH7Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523206; c=relaxed/simple;
	bh=0iuCLH+F3y47IYrC3dcopIgemH7mCXqqg7spMBtOrEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJgV8VHJA70RfdOA2n9hH9+lPtGXDQ39jANncK+qlBEpS1kV/rBmzXGaIVLHIKrok8f0JzFI7hOKxuzNdHruVepEoux/mb3uu1ZDhH/hk/UJZVM9/GieH5xgEJT18pQQphtqTvcKNaTKjaQyyMaZdJJY+aQQO88WMr90eHVt4+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QuKr+wOE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QuKr+wOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81125C4CEEB;
	Mon, 18 Aug 2025 13:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523206;
	bh=0iuCLH+F3y47IYrC3dcopIgemH7mCXqqg7spMBtOrEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QuKr+wOE05hR/ubnrsR3flMX02CsK2Xb7vbQX2XW12uUI7DmbDeZ3Gejew3AoIMu/
	 fRYzO+FyvfzYth3gZ3eEQsTb10ZF/6W0Gxg1Kbq2jgzOs61SujzyCV3mu8zW3wzovT
	 Ir7LKo7BJcResH9yqDOqJG9jg2qhGy8pxu5C5ivA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 102/515] ata: libata-sata: Disallow changing LPM state if not supported
Date: Mon, 18 Aug 2025 14:41:28 +0200
Message-ID: <20250818124502.298940831@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit 413e800cadbf67550d76c77c230b2ecd96bce83a ]

Modify ata_scsi_lpm_store() to return an error if a user attempts to set
a link power management policy for a port that does not support LPM,
that is, ports flagged with ATA_FLAG_NO_LPM.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Link: https://lore.kernel.org/r/20250701125321.69496-6-dlemoal@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-sata.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index 2e4463d3a356..00b7123192e7 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -924,6 +924,11 @@ static ssize_t ata_scsi_lpm_store(struct device *device,
 
 	spin_lock_irqsave(ap->lock, flags);
 
+	if (ap->flags & ATA_FLAG_NO_LPM) {
+		count = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
 	ata_for_each_link(link, ap, EDGE) {
 		ata_for_each_dev(dev, &ap->link, ENABLED) {
 			if (dev->quirks & ATA_QUIRK_NOLPM) {
-- 
2.39.5



