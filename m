Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B2E13B2B4;
	Tue, 27 Feb 2024 14:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043382; cv=none; b=d22k0G4kKyUB9Qso11mk9MUa0IgG/SOrNBSA7PIRFqt19oM5TriGcN85T/XbzXR5rJOxq7UXLHB4b+2W0D+SGFV3jBWN6L1Fuv0aEP9uqVsTwy1ec2LvLIDTnQ5bEUaOZUGkCyboHC3VjWGQDTiyij51SIzainRZk+2rfq6VFQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043382; c=relaxed/simple;
	bh=gTp+3R39XdD1G2SC+nYyJtme4k3HswfXpMk9XWJL57I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lnF5FCJclRb4gM7yNWN/JVXkwFeMtwxfgvLzZ52QVpCJkyV2jb9UglHeXBLxl7JShpUCsidkF3XoUaRU/WfVEpK+I4JUiViWDEQhpEY9lfNJkVne43QtMPCybZ5fcfMgTSLaYlrfNwksqvRMznT5L3ci6YWRX7OJBaMuHkv3whs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rT9nxzYK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rT9nxzYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A450C433F1;
	Tue, 27 Feb 2024 14:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043382;
	bh=gTp+3R39XdD1G2SC+nYyJtme4k3HswfXpMk9XWJL57I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rT9nxzYK+LJZLy0QehkxhSa1VB/lmSaO7QnpoGOV9O3WFbL8ag613AGVtEThG9KEL
	 dI2wDL+/rZOlupZ1pGOu7gfBus9tLNuR/56JUe1HA5oCcsi+6rLFC0IgGxK2dqjnTx
	 WpFvg/y9tecd9x+vfKbBieBnDgGLYylzpw9E47ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.1 087/195] ata: libata-core: Do not try to set sleeping devices to standby
Date: Tue, 27 Feb 2024 14:25:48 +0100
Message-ID: <20240227131613.356006274@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 4b085736e44dbbe69b5eea1a8a294f404678a1f4 upstream.

In ata ata_dev_power_set_standby(), check that the target device is not
sleeping. If it is, there is no need to do anything.

Fixes: aa3998dbeb3a ("ata: libata-scsi: Disable scsi device manage_system_start_stop")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2005,6 +2005,10 @@ void ata_dev_power_set_active(struct ata
 	struct ata_taskfile tf;
 	unsigned int err_mask;
 
+	/* If the device is already sleeping, do nothing. */
+	if (dev->flags & ATA_DFLAG_SLEEPING)
+		return;
+
 	/*
 	 * Issue READ VERIFY SECTORS command for 1 sector at lba=0 only
 	 * if supported by the device.


