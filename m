Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAF44E4C54;
	Thu, 17 Sep 2026 17:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666142; cv=none; b=PAFtmRDHfYxiPYUJ7pNalTjauXv27Ieb5nq5uQaslluLspsNkRxmA59amkEo9a+7VZMInXJgSsBz0mndKSPmEjvyULfBU2kMtpOe0vGtrhH9eaS5SHsbNcMRqwFWYce42j60Zs6lioMGnt0fMoXCM2xbYUpG08BquZi9juZbgeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666142; c=relaxed/simple;
	bh=S35+X6EULtu4kkc1PqgaXwaXqD5z4rsf41mDGZ5Fm04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MFKr3KAuefrqVKVvKEGbqEcCWZWAUBf2ZwsWRa68IapWOajxQlgG4FAjagoGEohmJAyShiQBpW6r6oJNIWQ22/jqzeXqG1HEX87VsMiGb9v1ZWs9XxOJaTLmWNfxqhcNSui0sScmV8591L5x+G4LkUxAzoPaDmFF6zYxmWJbiqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y184UFBx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y184UFBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9427C1F000FF;
	Thu, 17 Sep 2026 17:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666141;
	bh=21RMkaHaFBJa0XXK//UgJPnsNUxeHMLgK3SfQr9YMbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y184UFBxUIoOE6wgfE1ihQG04TabQabSKx4tkOY8yL61/Gy2xkNtsYcb4zi5UJ0Qt
	 h26KJSBht9FnoOH/cRUkDs0ft9PuAss1bdQl9WkaStIJxqXFZWz4nSFeqktv6Frbt6
	 JVs8dXnVR3E9O5MjiJEHQ+8ghLYQsEhpQzpG6HMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0936/1250] octeontx2-af: fix PF/CGX debugfs PCI bus lookup
Date: Thu, 17 Sep 2026 16:12:11 +0100
Message-ID: <20260917151617.385595008@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ratheesh Kannoth <rkannoth@marvell.com>

[ Upstream commit 4f4b743c2d2bbc336cb164d9d3d2ed6956ad8437 ]

rvu_dbg_rvu_pf_cgx_map_display() locates each RVU PF PCI device via
pci_get_domain_bus_and_slot() when printing the PF-to-CGX map. It
assumed PF0 always sits on PCI bus 1 and derived other PF bus numbers
as pf + 1, but the AF device can be enumerated on a different bus.

Use rvu->pdev->bus->number as the base bus instead, so each PF lookup
uses pf + start on systems where RVU functions are on contiguous buses
but do not start at bus 1.

Fixes: e2fb373038654 ("octeontx2-af: Display CGX, NIX and PF map in debugfs.")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260904085114.3385530-1-rkannoth@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/af/rvu_debugfs.c    | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 91a9ad0d37c0a..0a1c778d14b69 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -825,19 +825,25 @@ static int rvu_dbg_rvu_pf_cgx_map_display(struct seq_file *filp, void *unused)
 	int pf, domain, blkid;
 	u8 cgx_id, lmac_id;
 	u16 pcifunc;
+	u8 start;
 
-	domain = 2;
+	domain = pci_domain_nr(rvu->pdev->bus);
 	mac_ops = get_mac_ops(rvu_first_cgx_pdata(rvu));
 	/* There can be no CGX devices at all */
 	if (!mac_ops)
 		return 0;
 	seq_printf(filp, "PCI dev\t\tRVU PF Func\tNIX block\t%s\tLMAC\tCHAN\n",
 		   mac_ops->name);
+
+	/* All the PF devices are on contiguous PCI bus numbers, but the PF0(AF)
+	 * may not start from 1 always. Hence get domain and bus from PCI device.
+	 */
+	start = rvu->pdev->bus->number;
 	for (pf = 0; pf < rvu->hw->total_pfs; pf++) {
 		if (!is_pf_cgxmapped(rvu, pf))
 			continue;
 
-		pdev =  pci_get_domain_bus_and_slot(domain, pf + 1, 0);
+		pdev =  pci_get_domain_bus_and_slot(domain, pf + start, 0);
 		if (!pdev)
 			continue;
 
-- 
2.53.0



