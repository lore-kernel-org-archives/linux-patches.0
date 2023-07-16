Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2B08F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D276C433C8;
	Sun, 16 Jul 2023 20:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539094;
	bh=KZYMOEhtKyDQ2hpfcAvFIytXS/O4O04IaSeOaYzUJsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qLcWP8uUs5qL6FnW7b4gnymR4wYr7XsJl8m6z1kdqjPXGuVo3XAbCJ3azWrkHETH5
	 4bc86iujLxLo5iBKHcZC9AFVy2H6y35V0zasN3EBVgrM5HRsNvL9tniR894gc5iUYH
	 jaHBAjfjF5fb7CGZKu3AXOYyJHclfyDbfEPKUZ3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Sunil Goutham <sgoutham@marvell.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 685/800] octeontx2-af: Fix mapping for NIX block from CGX connection
Date: Sun, 16 Jul 2023 21:48:58 +0200
Message-ID: <20230716195005.035837883@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 2e7bc57b976bb016c6569a54d95c1b8d88f9450a ]

Firmware configures NIX block mapping for all MAC blocks.
The current implementation reads the configuration and
creates the mapping between RVU PF  and NIX blocks. But
this configuration is only valid for silicons that support
multiple blocks. For all other silicons, all MAC blocks
map to NIX0.

This patch corrects the mapping by adding a check for the same.

Fixes: c5a73b632b90 ("octeontx2-af: Map NIX block from CGX connection")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h     | 11 +++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c |  2 +-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index d655bf04a483d..68ff3244a84a2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -23,6 +23,7 @@
 #define	PCI_DEVID_OCTEONTX2_LBK			0xA061
 
 /* Subsystem Device ID */
+#define PCI_SUBSYS_DEVID_98XX                  0xB100
 #define PCI_SUBSYS_DEVID_96XX                  0xB200
 #define PCI_SUBSYS_DEVID_CN10K_A	       0xB900
 #define PCI_SUBSYS_DEVID_CNF10K_B              0xBC00
@@ -669,6 +670,16 @@ static inline u16 rvu_nix_chan_cpt(struct rvu *rvu, u8 chan)
 	return rvu->hw->cpt_chan_base + chan;
 }
 
+static inline bool is_rvu_supports_nix1(struct rvu *rvu)
+{
+	struct pci_dev *pdev = rvu->pdev;
+
+	if (pdev->subsystem_device == PCI_SUBSYS_DEVID_98XX)
+		return true;
+
+	return false;
+}
+
 /* Function Prototypes
  * RVU
  */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 83b342fa8d753..48611e6032284 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -114,7 +114,7 @@ static void rvu_map_cgx_nix_block(struct rvu *rvu, int pf,
 	p2x = cgx_lmac_get_p2x(cgx_id, lmac_id);
 	/* Firmware sets P2X_SELECT as either NIX0 or NIX1 */
 	pfvf->nix_blkaddr = BLKADDR_NIX0;
-	if (p2x == CMR_P2X_SEL_NIX1)
+	if (is_rvu_supports_nix1(rvu) && p2x == CMR_P2X_SEL_NIX1)
 		pfvf->nix_blkaddr = BLKADDR_NIX1;
 }
 
-- 
2.39.2



