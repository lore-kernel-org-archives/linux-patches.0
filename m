Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E0A2EAE6;
	Mon, 23 Dec 2024 16:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969697; cv=none; b=cQyMGWkp/rZ9+ofLqacW2E7V3YE+mQjJIF7vFt6sVCCd8V3ksX4n5vjq65xf9dsftoIuq+huUTX4HUwRMIyYiX+w8LUCMWUfvquh0veQvrBtCCXxJ6iRAcbpGXsFzi632quqKNPlpX4uzCTHAWYeZouktnXs94byVxSgtguIc5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969697; c=relaxed/simple;
	bh=AdJhFPGU05E6T83M6xuAgrko2d2cyWFqIFl/owRFMGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EjaVgncgTA7NufY+5OLH3a0hZa1kFEMs785WMWDZ9ZZLXo3gIXNcgsn6S2L2yf7hSgWlBFLppS+brtkITmDsb4RwphW13qjMwVCg1H2OHLy4ml+BBLFy0uE4YJ2INmM3r4cfKT5lhm34Z8Q0HxFr88qFP1QXy6kuJQtYOovSVOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eEBFiWIR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eEBFiWIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576A0C4CED4;
	Mon, 23 Dec 2024 16:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969696;
	bh=AdJhFPGU05E6T83M6xuAgrko2d2cyWFqIFl/owRFMGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eEBFiWIRUgsD32lhPsbAe/HGuwVzL47k4HkG1KiHwd9VAGjSY02GCIYTc0j0FqVt/
	 UvkGlXoPRBCDfuClU7N0z8xDRcu9V3292/KDVm2OGabaAfctRtUu7GUQIahHvpnWTD
	 NGX889dpBUxXEswwarSDnkVoWIcMBHBXFI0olJWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 011/160] p2sb: Move P2SB hide and unhide code to p2sb_scan_and_cache()
Date: Mon, 23 Dec 2024 16:57:02 +0100
Message-ID: <20241223155409.088039007@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

[ Upstream commit 0286070c74ee48391fc07f7f617460479472d221 ]

To prepare for the following fix, move the code to hide and unhide the
P2SB device from p2sb_cache_resources() to p2sb_scan_and_cache().

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20241128002836.373745-4-shinichiro.kawasaki@wdc.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 360c400d0f56 ("p2sb: Do not scan and remove the P2SB device when it is unhidden")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/p2sb.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/platform/x86/p2sb.c b/drivers/platform/x86/p2sb.c
index 273ac90c8fbd..0bc6b21c4c20 100644
--- a/drivers/platform/x86/p2sb.c
+++ b/drivers/platform/x86/p2sb.c
@@ -97,6 +97,14 @@ static void p2sb_scan_and_cache_devfn(struct pci_bus *bus, unsigned int devfn)
 
 static int p2sb_scan_and_cache(struct pci_bus *bus, unsigned int devfn)
 {
+	/*
+	 * The BIOS prevents the P2SB device from being enumerated by the PCI
+	 * subsystem, so we need to unhide and hide it back to lookup the BAR.
+	 * Unhide the P2SB device here, if needed.
+	 */
+	if (p2sb_hidden_by_bios)
+		pci_bus_write_config_dword(bus, devfn, P2SBC, 0);
+
 	/* Scan the P2SB device and cache its BAR0 */
 	p2sb_scan_and_cache_devfn(bus, devfn);
 
@@ -104,6 +112,10 @@ static int p2sb_scan_and_cache(struct pci_bus *bus, unsigned int devfn)
 	if (devfn == P2SB_DEVFN_GOLDMONT)
 		p2sb_scan_and_cache_devfn(bus, SPI_DEVFN_GOLDMONT);
 
+	/* Hide the P2SB device, if it was hidden */
+	if (p2sb_hidden_by_bios)
+		pci_bus_write_config_dword(bus, devfn, P2SBC, P2SBC_HIDE);
+
 	if (!p2sb_valid_resource(&p2sb_resources[PCI_FUNC(devfn)].res))
 		return -ENOENT;
 
@@ -152,22 +164,11 @@ static int p2sb_cache_resources(void)
 	 */
 	pci_lock_rescan_remove();
 
-	/*
-	 * The BIOS prevents the P2SB device from being enumerated by the PCI
-	 * subsystem, so we need to unhide and hide it back to lookup the BAR.
-	 * Unhide the P2SB device here, if needed.
-	 */
 	pci_bus_read_config_dword(bus, devfn_p2sb, P2SBC, &value);
 	p2sb_hidden_by_bios = value & P2SBC_HIDE;
-	if (p2sb_hidden_by_bios)
-		pci_bus_write_config_dword(bus, devfn_p2sb, P2SBC, 0);
 
 	ret = p2sb_scan_and_cache(bus, devfn_p2sb);
 
-	/* Hide the P2SB device, if it was hidden */
-	if (p2sb_hidden_by_bios)
-		pci_bus_write_config_dword(bus, devfn_p2sb, P2SBC, P2SBC_HIDE);
-
 	pci_unlock_rescan_remove();
 
 	return ret;
-- 
2.39.5



