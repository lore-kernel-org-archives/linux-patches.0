Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218EF1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:23:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97082C433C7;
	Tue, 25 Jul 2023 11:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284188;
	bh=osTU8VaMeeAPJAOvL23dF96TpX1KkjF6/vMDUWUI52U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aSl+qVIqRwW04OsFc1+WekmV4EndL7F5+SU5mN5pJwvyqUqty+ClwqDbl4bcWPJpx
	 Zii7PqSERi3kRpQN4Ku2VT3DWHzGfaAxUsLNObr0mHgPCW6T+ABP9I5PmBQ2svH7c0
	 RGHTOFMmUIqeKv8kATOoR3J309G58/fe6RKYQ/cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Sunil Goutham <sgoutham@marvell.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 266/509] octeontx2-af: Fix mapping for NIX block from CGX connection
Date: Tue, 25 Jul 2023 12:43:25 +0200
Message-ID: <20230725104605.929616666@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
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
index fc6d785b98ddd..ec9a291e866c7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -20,6 +20,7 @@
 #define	PCI_DEVID_OCTEONTX2_RVU_AF		0xA065
 
 /* Subsystem Device ID */
+#define PCI_SUBSYS_DEVID_98XX                  0xB100
 #define PCI_SUBSYS_DEVID_96XX                  0xB200
 
 /* PCI BAR nos */
@@ -403,6 +404,16 @@ static inline bool is_rvu_96xx_B0(struct rvu *rvu)
 		(pdev->subsystem_device == PCI_SUBSYS_DEVID_96XX);
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
index 6c6b411e78fd8..83743e15326d7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -84,7 +84,7 @@ static void rvu_map_cgx_nix_block(struct rvu *rvu, int pf,
 	p2x = cgx_lmac_get_p2x(cgx_id, lmac_id);
 	/* Firmware sets P2X_SELECT as either NIX0 or NIX1 */
 	pfvf->nix_blkaddr = BLKADDR_NIX0;
-	if (p2x == CMR_P2X_SEL_NIX1)
+	if (is_rvu_supports_nix1(rvu) && p2x == CMR_P2X_SEL_NIX1)
 		pfvf->nix_blkaddr = BLKADDR_NIX1;
 }
 
-- 
2.39.2



