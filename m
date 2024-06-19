Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B2914E2D9;
	Wed, 19 Jun 2024 13:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803332; cv=none; b=A+VdbNMdcv2ukLSzsBYQ+sXbtNcwSUOZgZkvHBLG4NuO6jl9lXjxb7ske8o3w/ayYRlzlBszlp632JL17X1dl/4ke2eusNbUbd5pG1cP+7foEsKDjF0H8VrzYhXquwpMuvqj/4rh92SUOt6sKapcj7rVIi9bCuT5z1Jjs4WGzYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803332; c=relaxed/simple;
	bh=9+Vp+joVmH88zVOLXRD6jCUvCAM7Ni5GtN/4db1SPwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3JYiLE3Nr/LrRNNj8UUjBFe1bOeDS6IUv38zAjt2IHknYD+DDpCfRNmhL6FuIufI0dP//CHkh7R0fEijuQuqVvVydLdG/y9a5j0IhFrPUv/KgwrjT3uCDCL5mhk3S6VrvDqW94uRoifWbV1FI5HkSOBAXD3F6SWEgBd+B7QFLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1OmiKbJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1OmiKbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D956C2BBFC;
	Wed, 19 Jun 2024 13:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803332;
	bh=9+Vp+joVmH88zVOLXRD6jCUvCAM7Ni5GtN/4db1SPwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u1OmiKbJZYzTMsP5cC0qYWmgdeL2iaSWaUwiZu0bv4zznYxXn2QeOWemzmIK/p9Cp
	 1XRxCSfawp9f74/jN3GKB3/24tJDW/mDGXqfKNo297g5dpj0wv+psSyZlaBfH11xZ1
	 SU226ZbNP3lUvu40FrbIHqYxG1Qudn809kI+PiXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doru Iorgulescu <doru.iorgulescu1@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.9 231/281] ata: libata-core: Add ATA_HORKAGE_NOLPM for AMD Radeon S3 SSD
Date: Wed, 19 Jun 2024 14:56:30 +0200
Message-ID: <20240619125618.853084633@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

commit 473880369304cfd4445720cdd8bae4c6f1e16e60 upstream.

Commit 7627a0edef54 ("ata: ahci: Drop low power policy board type")
dropped the board_ahci_low_power board type, and instead enables LPM if:
-The AHCI controller reports that it supports LPM (Partial/Slumber), and
-CONFIG_SATA_MOBILE_LPM_POLICY != 0, and
-The port is not defined as external in the per port PxCMD register, and
-The port is not defined as hotplug capable in the per port PxCMD
 register.

Partial and Slumber LPM states can either be initiated by HIPM or DIPM.

For HIPM (host initiated power management) to get enabled, both the AHCI
controller and the drive have to report that they support HIPM.

For DIPM (device initiated power management) to get enabled, only the
drive has to report that it supports DIPM. However, the HBA will reject
device requests to enter LPM states which the HBA does not support.

The problem is that AMD Radeon S3 SSD drives do not handle low power modes
correctly. The problem was most likely not seen before because no one
had used this drive with a AHCI controller with LPM enabled.

Add a quirk so that we do not enable LPM for this drive, since we see
command timeouts if we do (even though the drive claims to support both
HIPM and DIPM).

Fixes: 7627a0edef54 ("ata: ahci: Drop low power policy board type")
Cc: stable@vger.kernel.org
Reported-by: Doru Iorgulescu <doru.iorgulescu1@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218832
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4203,6 +4203,9 @@ static const struct ata_blacklist_entry
 	/* Apacer models with LPM issues */
 	{ "Apacer AS340*",		NULL,	ATA_HORKAGE_NOLPM },
 
+	/* AMD Radeon devices with broken LPM support */
+	{ "R3SL240G",			NULL,	ATA_HORKAGE_NOLPM },
+
 	/* These specific Samsung models/firmware-revs do not handle LPM well */
 	{ "SAMSUNG MZMPC128HBFU-000MV", "CXM14M1Q", ATA_HORKAGE_NOLPM },
 	{ "SAMSUNG SSD PM830 mSATA *",  "CXM13D1Q", ATA_HORKAGE_NOLPM },


