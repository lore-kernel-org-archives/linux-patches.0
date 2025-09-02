Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A338304BA4;
	Tue,  2 Sep 2025 13:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819645; cv=none; b=OdGkavk3boT++W2VtuC1534vhIagb/Ko1/x5hrCWnW//Sawnj9htczaB+fBQJkRAyadYF8lR+LVv/4x0drzRwxjJYH6ANxHe9D/hRSuN7jVR1xBvGvgyNrCAlLzVgcdUmiTYGhT2jHvsjI5rMpWAjjaI+aqVKm6pprhMvKot8UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819645; c=relaxed/simple;
	bh=/ICPWVRSuVy6bLexbL9c9hp44yy2D67bKbzxasNjgfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOH6CtvPbUw80jmasomCR3+WsbUNTpaqvj7EQ3S3lgwFojH2aXWQoa9ZzJ3hKykKSl1baQHG2gWjrLwKPA6LPkEboZFZ3pLtmtTWn+mpPc1Q9XYWXC8a0ESMqnRFf4GHLHen4qglkyyHcVZXIb0V/iliZd0eN77EV+aEw6595SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ieqhBDbL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ieqhBDbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36F9C4CEED;
	Tue,  2 Sep 2025 13:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819645;
	bh=/ICPWVRSuVy6bLexbL9c9hp44yy2D67bKbzxasNjgfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ieqhBDbLyp3UpyXZ6Uqu/Zxg8G5vsoCgqhuCEWG1S/XRPuT7O7pONKJFMqgwmr/nm
	 zVx3qck4HdS51aJ6uQhodTVYjZZt10wJk9xL6nO7t1Hcc2iklWkrLwBz9iMcX4SvwS
	 Q2fM9s8b6oIqPIbuHCn5b8Z/3Jpf8gi215OB7dv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 065/142] Octeontx2-af: Fix NIX X2P calibration failures
Date: Tue,  2 Sep 2025 15:19:27 +0200
Message-ID: <20250902131950.749846564@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit d280233fc86692f495d5e08092e5422bc2f583a8 ]

Before configuring the NIX block, the AF driver initiates the
"NIX block X2P bus calibration" and verifies that NIX interfaces
such as CGX and LBK are active and functioning correctly.

On few silicon variants(CNF10KA and CNF10KB), X2P calibration failures
have been observed on some CGX blocks that are not mapped to the NIX block.

Since both NIX-mapped and non-NIX-mapped CGX blocks share the same
VENDOR,DEVICE,SUBSYS_DEVID, it's not possible to skip probe based on
these parameters.

This patch introuduces "is_cgx_mapped_to_nix" API to detect and skip
probe of non NIX mapped CGX blocks.

Fixes: aba53d5dbcea ("octeontx2-af: NIX block admin queue init")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Link: https://patch.msgid.link/20250822105805.2236528-1-hkelam@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c |  7 +++++++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h | 14 ++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 971993586fb49..442305463cc0a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -1940,6 +1940,13 @@ static int cgx_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_release_regions;
 	}
 
+	if (!is_cn20k(pdev) &&
+	    !is_cgx_mapped_to_nix(pdev->subsystem_device, cgx->cgx_id)) {
+		dev_notice(dev, "CGX %d not mapped to NIX, skipping probe\n",
+			   cgx->cgx_id);
+		goto err_release_regions;
+	}
+
 	cgx->lmac_count = cgx->mac_ops->get_nr_lmacs(cgx);
 	if (!cgx->lmac_count) {
 		dev_notice(dev, "CGX %d LMAC count is zero, skipping probe\n", cgx->cgx_id);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 5c179df1f1673..9cdb7431f558c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -761,6 +761,20 @@ static inline bool is_cn10kb(struct rvu *rvu)
 	return false;
 }
 
+static inline bool is_cgx_mapped_to_nix(unsigned short id, u8 cgx_id)
+{
+	/* On CNF10KA and CNF10KB silicons only two CGX blocks are connected
+	 * to NIX.
+	 */
+	if (id == PCI_SUBSYS_DEVID_CNF10K_A || id == PCI_SUBSYS_DEVID_CNF10K_B)
+		return cgx_id <= 1;
+
+	return !(cgx_id && !(id == PCI_SUBSYS_DEVID_96XX ||
+			     id == PCI_SUBSYS_DEVID_98XX ||
+			     id == PCI_SUBSYS_DEVID_CN10K_A ||
+			     id == PCI_SUBSYS_DEVID_CN10K_B));
+}
+
 static inline bool is_rvu_npc_hash_extract_en(struct rvu *rvu)
 {
 	u64 npc_const3;
-- 
2.50.1



