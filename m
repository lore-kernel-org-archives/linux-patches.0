Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D19C12D1F1;
	Mon, 23 Dec 2024 16:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970207; cv=none; b=jXVMpO2uamHKZW36PE1W0yZyOjtEAMRMppqT7LjnfxZ1BG6DbJhVVTwBgUwZVqg8NzdYDcFGQ7cIgNtGqzThE1Xc+HXWWixc63WkyaAX2nNl9rW0dr5B4b+GPs0IxYU72x436LJ0c3dl+xW/ErjhJhRAp5ZCzf5Kn4PBm1OqX+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970207; c=relaxed/simple;
	bh=yJ70cLoTJCcTvffA3nBTAOHMDlyo/7JsMhHFqPgq05E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DquRd+W7ukMGoK9yeea0xhOjD/oN8ZAkc42RfcJUk0AzWbr8p1lemGGnP+QdPa26P87zAEd4meK/uRN8Oyis4esIRQlrkM+1MuysZlIoNl4ebIZRNpvBj6hERajDBOgeT2eurmLvl+FHEIqP8rAXM3/fhNUVEnlwg7ra3sFzIrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zqCoRbmX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zqCoRbmX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4921C4CED3;
	Mon, 23 Dec 2024 16:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970207;
	bh=yJ70cLoTJCcTvffA3nBTAOHMDlyo/7JsMhHFqPgq05E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zqCoRbmXsN2LXriSp2zvulyzZC+RAZONMd2PjPKTkgop0JI5oVc5WfkCHaV/lr2xF
	 Bu7/9//ZuXXvL8q5s7L5Oa2I973dgfU0SqR3dEDshpfvNVKrszQtCYo87M1a4JfuED
	 mrxJXOAbj5SYHPKYL2NFHagS9CurE9BHg49VnGYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/116] p2sb: Move P2SB hide and unhide code to p2sb_scan_and_cache()
Date: Mon, 23 Dec 2024 16:58:06 +0100
Message-ID: <20241223155400.184079507@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d015ddc9f30e..6fb76b82ecce 100644
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



