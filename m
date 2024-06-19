Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06EC01494A6;
	Wed, 19 Jun 2024 13:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803327; cv=none; b=onUIp8A2YTLz5CEPrpa6+YCqIWMhW1NcxJDIU0AOO4Rwvt2vri+YKZdy0impJWWjY3AYtbs6Sv+e2FKsBbLctsHYkkGbz+4BYdUt/yCsI2YT/VQ7u6zCRjqqXu/c5Ut6394GQKF+RLhoUG8Kg/FftzJ6yiPFjeLgJRXDksdl1HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803327; c=relaxed/simple;
	bh=Kt1ztgtZO0jFSN9TXceS3RP1qTDsibzFpEMnKfiWhAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlRMaIWa5qBlyCF2kEyDbWtDrb1cR8neMzkdxuUsGvVdrdZ5dpOcvBbt0XH9Afeirpvlj/jDaZAFOR1t2byoLBBwU+kA9na/yHVGUNk7Iit8oWi7D7EtJ5gDHdhcvMn3tj/qHbNCVIVtuDwwxywjpSw5HTdWAE5Q/dxRjuBsCs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ui09mds; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ui09mds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427CBC2BBFC;
	Wed, 19 Jun 2024 13:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803326;
	bh=Kt1ztgtZO0jFSN9TXceS3RP1qTDsibzFpEMnKfiWhAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ui09mdsv8DavrfqO4CNI0I2+7zBjz/Yf0gT9hbJ2Os/BHx8fzHd22aSD07RoqMR5
	 5t+Whs4XDaNhFCrMpkargmvDOBBp0V3OSaixVUZ4OfU9GnmA7EX3c+DrWAGEeZ6G7z
	 PVswMkOL0Cu70e0s10IYcsVkpcCUGhLbYQtz5Wp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Teichmann <teichmanntim@outlook.de>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.9 229/281] ata: libata-core: Add ATA_HORKAGE_NOLPM for Apacer AS340
Date: Wed, 19 Jun 2024 14:56:28 +0200
Message-ID: <20240619125618.772859914@linuxfoundation.org>
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

commit 3cb648c4dd3e8dde800fb3659250ed11f2d9efa5 upstream.

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

The problem is that Apacer AS340 drives do not handle low power modes
correctly. The problem was most likely not seen before because no one
had used this drive with a AHCI controller with LPM enabled.

Add a quirk so that we do not enable LPM for this drive, since we see
command timeouts if we do (even though the drive claims to support DIPM).

Fixes: 7627a0edef54 ("ata: ahci: Drop low power policy board type")
Cc: stable@vger.kernel.org
Reported-by: Tim Teichmann <teichmanntim@outlook.de>
Closes: https://lore.kernel.org/linux-ide/87bk4pbve8.ffs@tglx/
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4199,6 +4199,9 @@ static const struct ata_blacklist_entry
 						ATA_HORKAGE_ZERO_AFTER_TRIM |
 						ATA_HORKAGE_NOLPM },
 
+	/* Apacer models with LPM issues */
+	{ "Apacer AS340*",		NULL,	ATA_HORKAGE_NOLPM },
+
 	/* These specific Samsung models/firmware-revs do not handle LPM well */
 	{ "SAMSUNG MZMPC128HBFU-000MV", "CXM14M1Q", ATA_HORKAGE_NOLPM },
 	{ "SAMSUNG SSD PM830 mSATA *",  "CXM13D1Q", ATA_HORKAGE_NOLPM },


