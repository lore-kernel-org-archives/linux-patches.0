Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF8E281369;
	Fri,  7 Aug 2026 15:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115950; cv=none; b=Ebdpeegz3aXOsHcc7nQObakUzrsRgeXpIrg/P1K1PDfcSmzunzGyPT8EqpcKBdL33NDpVnozu7vRlStUiZvfugiwUjfdRe9TK5K5a3M2KDOZ3XUKTxpzPQ95Sq+fcnjRlBV+rZtbSvfbZmlisNYkbwzrD5qLAS95y4WRpLCTYgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115950; c=relaxed/simple;
	bh=hXAcsnGaiacKFGoo2XZJU546Hcal/LpvgzLoLKF6xwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MlyxlIhwxkiaX0hl8wacLwOZgZ2IfMSnLpVPSTBGC5O9M2fJLHTGkRod6D5gGqH+tlf+tSZdA96Nc8/XwA4m/oYP1SLhjpN/b5DzncirBwMAPgvZgMdUVpAT6z4ootpjd/P5lrgdSaAAQ3xOA2YBy/Xj6LDzlmVZE0/wW3+AYAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qs7fPGvk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qs7fPGvk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F321F000E9;
	Fri,  7 Aug 2026 15:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115949;
	bh=AhrKKmsdAxPKbp2pkt19GSPFWnTvDPnndODgKp5qQ0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qs7fPGvkOYnbkcIqBWNjH8r+4T3n87Mwfu47tI1EaaoGQhzyekeUD4aHUUe77bF1c
	 K9PkSiEaVTbG8WDGPq7WaywRWp5Qo4WQm7eRklD93K0UDLCu6c8bM7QdoWCYddc83F
	 wpuFJEOI2E9l0Q/eNMKBT40SCEfFj9qqn+YnwmMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/261] phy: zynqmp: fix runtime PM leak on probe allocation failure
Date: Fri,  7 Aug 2026 16:36:19 +0200
Message-ID: <20260807143415.848487104@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>

[ Upstream commit f3506e15cf72e94f62d5f2d173e5b7008f644cde ]

Allocate saved_regs before pm_runtime_resume_and_get() so a
devm_kmalloc() failure does not leave an unreleased runtime PM usage
counter.

Fixes: 5af9b304bc60 ("phy: xilinx: phy-zynqmp: Fix SGMII linkup failure on resume")
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Reviewed-by: Michal Simek <michal.simek@amd.com>
Link: https://patch.msgid.link/20260720153832.1130006-3-radhey.shyam.pandey@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/xilinx/phy-zynqmp.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/phy/xilinx/phy-zynqmp.c b/drivers/phy/xilinx/phy-zynqmp.c
index bf2a06a7f606f..b6fc72287cd99 100644
--- a/drivers/phy/xilinx/phy-zynqmp.c
+++ b/drivers/phy/xilinx/phy-zynqmp.c
@@ -1045,6 +1045,12 @@ static int xpsgtr_probe(struct platform_device *pdev)
 		return PTR_ERR(provider);
 	}
 
+	gtr_dev->saved_regs = devm_kmalloc(gtr_dev->dev,
+					   sizeof(save_reg_address),
+					   GFP_KERNEL);
+	if (!gtr_dev->saved_regs)
+		return -ENOMEM;
+
 	pm_runtime_set_active(gtr_dev->dev);
 	pm_runtime_enable(gtr_dev->dev);
 
@@ -1054,12 +1060,6 @@ static int xpsgtr_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	gtr_dev->saved_regs = devm_kmalloc(gtr_dev->dev,
-					   sizeof(save_reg_address),
-					   GFP_KERNEL);
-	if (!gtr_dev->saved_regs)
-		return -ENOMEM;
-
 	return 0;
 }
 
-- 
2.53.0



