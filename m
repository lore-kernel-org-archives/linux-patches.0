Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1EAA412C05;
	Fri,  7 Aug 2026 14:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113809; cv=none; b=u5p4u3RDTMOgr6AWzahxMONhh0G4sVdp7PprHZ+4Zrcqpf25jYPHqKbtV8bRix51RDtrkYZBn7y8sOJm06cp1FJbSl+y30wwf6h58GpuQzAAoHQ7Laz2+er/UtFHD6+0Cg6bxvdto/YXchU8JtLwkktYbIxc8gYRiENiFgyDxo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113809; c=relaxed/simple;
	bh=9UxOV6MB6AIfTe8Hj5Wtm7Ars73pcSrOf2hb8nmALYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ioQJjKDJHLgy6a1KMPAR/85BNbSoqdgdy8TOYvJyjCXiJX1Oo6a6zXyAYefWiIoySB+nErkDpyNCK1uunmpJzMUzaz8XpIB9xZPx5BeMDQ10ZYAFZchn1CgQuWrNwnHynPv7yS2a9MiKVUotF00HUH7uR40hp2L0aSCq1A2Zj48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AlREf4p3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AlREf4p3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF13B1F00ADE;
	Fri,  7 Aug 2026 14:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113791;
	bh=6L0uJDuOugR4vgraVSg/14HaD0tQ9WlSamttK2Ty5X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AlREf4p3OAEPP8qUVo33qSVF1qfnv0FcwJwauQWofcLiJbi311CXcq7bIN3t5qaMT
	 DW+AjIvD35pYBeeuaDB7erolq4CzREWF/sc2qKe3cFC6S2WFr+RZymUd6v2+EgQTPx
	 j7aaNxjj2wDFMsOxykgjAtz+AeLUS2DycEyDmQvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/337] phy: zynqmp: fix runtime PM leak on probe allocation failure
Date: Fri,  7 Aug 2026 16:34:00 +0200
Message-ID: <20260807143419.321749008@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5039b0e89cba4..1ec5722ac427c 100644
--- a/drivers/phy/xilinx/phy-zynqmp.c
+++ b/drivers/phy/xilinx/phy-zynqmp.c
@@ -1044,6 +1044,12 @@ static int xpsgtr_probe(struct platform_device *pdev)
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
 
@@ -1053,12 +1059,6 @@ static int xpsgtr_probe(struct platform_device *pdev)
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



