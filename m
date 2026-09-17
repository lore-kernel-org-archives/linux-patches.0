Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A904B44C5;
	Thu, 17 Sep 2026 15:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659966; cv=none; b=Dkd3HXzB4sUDCay5lCuSDRH0Zub4unbahv2ueN9neV2sw5hhRqxJZGj7o1jCKHwcCdeqKNwV1c8h7rvR2GhWy9Or004pg7x9wX2hv6AMbYs9JI8c0GJ84vrfKyaX5fgClELU63x1x6V9Ok4jytjl/SecTC3VQb5QCdm4Dq5L7Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659966; c=relaxed/simple;
	bh=M9jBDxA/leyu1vpcxazMS9kKu5wF4BCKV0phHF/Kgs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4EfEmBurYLiFYFyyZrraNaofHzB2mQorEYpnVq4NBhn7C75yKqkOiDMLXBT1EwubewUrO9fi+ZM0uvSNIS6aV9596Eb2nLV+sFYKsKUw+w4wbsYMe3LZKRbwB/07hbRgk2AFeHNnXYAJ+UEkoz0SHpdIGsZ0OSbCKbLnSE/D7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZNc0WjNw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZNc0WjNw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6131F000FF;
	Thu, 17 Sep 2026 15:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659958;
	bh=RpeDQfEgdZQ/oAVsg573R8qZsXzySHgEUekKjdPOgj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZNc0WjNwGsMtUC+GjfLXN5ccGwTgk6IB0PWTGCw61vqitofEljMbDhSFO63f7GzW9
	 /HMEU01mdaFkBPLSIm2ZzcVhU2BP3mdiC1xO3CB8T9IUFWyznYDAjr8DlXkPLfg/ZF
	 BZOi+FW5zgJBltTB0Kf0zXd2tPjwOjFxEPmI1BgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 431/733] octeontx2-af: fix PF/CGX debugfs PCI bus lookup
Date: Thu, 17 Sep 2026 16:12:19 +0100
Message-ID: <20260917151402.577392652@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 22ee996768796..904374baae6f3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -829,19 +829,25 @@ static int rvu_dbg_rvu_pf_cgx_map_display(struct seq_file *filp, void *unused)
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



