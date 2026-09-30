Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72C94F5E18;
	Wed, 30 Sep 2026 18:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791591; cv=none; b=DM3rJppWxnGS78c8FO7Rh6aDa55dIXyhx20xOyeDfY6bsdH6q2v2M1ty9X1nqYT6G9hsBRuF9uxvubEY8PZby08n7D77pUdMq0O9fC2WZKEiBZ/H+KaH47YQi7cxvISxJ0cE1+QtevUTC3OUIAkvKNUMVE+XhYsv9/ompO9YPJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791591; c=relaxed/simple;
	bh=TD30PGia5F4P+pDH56RFk/EDstLjgqRDQAuwIaeekF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CsJLA/FkXA8FRybuvxyk01/UkK/Av0pvv00wbcvmkOPF7VYnGVxj01GCu05CJw489X9nZbZi6qORzwoPyFoFH3JjKkH7ONwytpRLtDelsGacMTndnaDK5TNkZ7VeRoEEbjgaG33B+JcVPUDftVKcHnnnfVKOwi0JvFaQ6ZAf1/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rz3ZWmYV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rz3ZWmYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5C41F000FF;
	Wed, 30 Sep 2026 18:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791590;
	bh=+7+u6mJ8FOGOOQr8t93rnjex3b6cnRJ007T3X0Zbdko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rz3ZWmYVwBpVI104MOj2O1eW7+o9v/9I4UwcHLTouGvbFXQBiWl014GVNdD3LVMbR
	 V1aDb/PZRt9TCfrf1QE2uoPL8YeK2nVao01QyR7KrXvR72DWgpfQPYhLL9towvs146
	 Q0INUU3Npjc2g92n+LkkM3NapZKYa0YPvXm6TYEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 355/752] octeontx2-af: fix PF/CGX debugfs PCI bus lookup
Date: Wed, 30 Sep 2026 17:23:45 +0200
Message-ID: <20260930152405.965947993@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a65ffa0d3d6ef..f104ec6fd6034 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -406,19 +406,25 @@ static int rvu_dbg_rvu_pf_cgx_map_display(struct seq_file *filp, void *unused)
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
 	seq_printf(filp, "PCI dev\t\tRVU PF Func\tNIX block\t%s\tLMAC\n",
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



