Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D3D31E0F5;
	Mon, 18 Aug 2025 12:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521658; cv=none; b=MnVWz1pJsPEXaZhEQHMS817Q3q4I1RvsKNe7mbAEhKqMN90QEDXzls/ayhk3xkM3SUVPKE8ZfulH34L0B6iyrec4dt8fM2oda0e2UsVQX4//0fYWmG5/rk0EofJ7bZ1iR2xiMrYMFewlZBCK33H7JVcVtM9pJjwkdB7zh5JlluI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521658; c=relaxed/simple;
	bh=lU9S8QwJOndeIwQJQw1h4rm13u+W/nqkaXHC95hO1/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PQOaIUdUiWYuJ9pP941UC6ZJ094Qi0QLKmiHulX0YJGuAV26Wzl+ihF04F56JVaYDQX81Yv6og2IYJHw/mY0lhe7E7ae6/XbULuwsyDoexDCOGmGLl3LzIjZhvIQB3ekkJ8nX4DsHmDYNk8GG+hOliqf1zXNcc16TWMMIToXGLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UwTbK8HU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UwTbK8HU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D9DEC116D0;
	Mon, 18 Aug 2025 12:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521657;
	bh=lU9S8QwJOndeIwQJQw1h4rm13u+W/nqkaXHC95hO1/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UwTbK8HUx1BUpbLabrtaVcpKtR3nyoP4b+xXneOk1fORmVmyvMZeSrpYdLt8Fs+0w
	 U9ypVxL31vcSdPlJ9hCK42RNpd5dflncyAxbs0oDnosIKU3rQbKIUefz6B9gN1V/2g
	 RWcnMeI/t7ZIm4+TDHyH93psVG7G0JlMF+yDQO1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 085/444] ata: ahci: Disable DIPM if host lacks support
Date: Mon, 18 Aug 2025 14:41:51 +0200
Message-ID: <20250818124452.137120579@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit f7870e8d345cdabfb94bcbdcba6a07e050f8705e ]

The AHCI specification version 1.3.1 section 8.3.1.4 (Software
Requirements and Precedence) states that:

If CAP.SSC or CAP.PSC is cleared to ‘0’, software should disable
device-initiated power management by issuing the appropriate SET
FEATURES command to the device.

To satisfy this constraint and force ata_dev_configure to disable the
device DIPM feature, modify ahci_update_initial_lpm_policy() to set the
ATA_FLAG_NO_DIPM flag on ports that have a host with either the
ATA_HOST_NO_PART flag set or the ATA_HOST_NO_SSC flag set.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.de.>
Link: https://lore.kernel.org/r/20250701125321.69496-7-dlemoal@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ahci.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 61d34ca0d9f4..944e44caa260 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1781,6 +1781,13 @@ static void ahci_update_initial_lpm_policy(struct ata_port *ap)
 		return;
 	}
 
+	/* If no Partial or no Slumber, we cannot support DIPM. */
+	if ((ap->host->flags & ATA_HOST_NO_PART) ||
+	    (ap->host->flags & ATA_HOST_NO_SSC)) {
+		ata_port_dbg(ap, "Host does not support DIPM\n");
+		ap->flags |= ATA_FLAG_NO_DIPM;
+	}
+
 	/* If no LPM states are supported by the HBA, do not bother with LPM */
 	if ((ap->host->flags & ATA_HOST_NO_PART) &&
 	    (ap->host->flags & ATA_HOST_NO_SSC) &&
-- 
2.39.5



