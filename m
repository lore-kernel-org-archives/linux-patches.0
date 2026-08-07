Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F15A2F8E8B;
	Fri,  7 Aug 2026 14:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114588; cv=none; b=CeWcIeYBhmjTVO+xh+FRAoLZ/ovY3mdJlZeXQtbg6m5K9b/tVNSQr/+NlZ0FQCl848TPyXZ99BR37+1rgDLBJFTYtMjbKBv2XyQYqFTBidRsUard2fgBMg7qt/7WXpW8kaC5NF/eo340+gz/yewgz3//vxwfiL0Za5XYmvES374=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114588; c=relaxed/simple;
	bh=HE0g9rSRCbU5K5E+RqgEOczwpdkwEGVAaQesgxe3/AA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t/ovWQlycyZemCVVl207/buIv/xWWa6vj1AoqlMk/KgpiWoPwec33vqr61QiN+rCdUZ+kB48IP0+6EnYzcta+LTQE1SZ6UINBkKz9H4UMp/Sijj2C58BbAi39y1KGbU9iQMpn0uRtla5UTvKdGXhdj2Bggql+o6f0NcJOMYQ2d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pStCATrE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pStCATrE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC211F00A3A;
	Fri,  7 Aug 2026 14:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114581;
	bh=zI8z3NVE4VtTFGFvQR8rsHJIueJkjeeaK77uGF126gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pStCATrE8PQF90fMxeOcRCPzA38yMpvgXY3BUXEantsk9Hrziqn/BzBC774KvukHn
	 1YYoRt4GGl5zKI8SSREaGDHCxItItDH6xLyjUHkEGyvQRQ4uzlCQJHOsJ0v8S+Nvvz
	 D+pPpyytHeqiPY8aO4St4sirdVdcoC/it8MMYaXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.12 270/337] ata: ahci: Make ahci_ignore_port() handle empty mask_port_map
Date: Fri,  7 Aug 2026 16:37:53 +0200
Message-ID: <20260807143424.392911142@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Niklas Cassel <cassel@kernel.org>

commit 130ff5c8b78e6fd05270a04985c50bce6a3de6c1 upstream.

Commit 8c87215dd3a2 ("ata: libahci_platform: support non-consecutive port
numbers") added a skip to ahci_platform_enable_phys() for ports that are
not in mask_port_map.

The code in ahci_platform_get_resources(), will currently set mask_port_map
for each child "port" node it finds in the device tree.

However, device trees that do not have any child "port" nodes will not have
mask_port_map set, and for non-device tree platforms mask_port_map will
only exist as a quirk for specific PCI device + vendor IDs, or as a kernel
module parameter, but will not be set by default.

Therefore, the common thing is that mask_port_map is only set if you do not
want to use all ports (as defined by Offset 0Ch: PI – Ports Implemented
register), but instead only want to use the ports in mask_port_map. If
mask_port_map is not set, all ports are available.

Thus, ahci_ignore_port() must be able to handle an empty mask_port_map.

Fixes: 8c87215dd3a2 ("ata: libahci_platform: support non-consecutive port numbers")
Fixes: 2c202e6c4f4d ("ata: libahci_platform: Do not set mask_port_map when not needed")
Fixes: c9b5be909e65 ("ahci: Introduce ahci_ignore_port() helper")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Closes: https://lore.kernel.org/linux-ide/10b31dd0-d0bb-4f76-9305-2195c3e17670@samsung.com/
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Co-developed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20250225141612.942170-2-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/ahci.h    |    8 ++++++--
 drivers/ata/libahci.c |    1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -387,8 +387,12 @@ struct ahci_host_priv {
 static inline bool ahci_ignore_port(struct ahci_host_priv *hpriv,
 				    unsigned int portid)
 {
-	return portid >= hpriv->nports ||
-		!(hpriv->mask_port_map & (1 << portid));
+	if (portid >= hpriv->nports)
+		return true;
+	/* mask_port_map not set means that all ports are available */
+	if (!hpriv->mask_port_map)
+		return false;
+	return !(hpriv->mask_port_map & (1 << portid));
 }
 
 extern int ahci_ignore_sss;
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -542,6 +542,7 @@ void ahci_save_initial_config(struct dev
 		hpriv->saved_port_map = port_map;
 	}
 
+	/* mask_port_map not set means that all ports are available */
 	if (hpriv->mask_port_map) {
 		dev_warn(dev, "masking port_map 0x%lx -> 0x%lx\n",
 			port_map,


