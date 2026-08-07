Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D12431A22;
	Fri,  7 Aug 2026 15:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116630; cv=none; b=nNx617CYZV8VlJzBUk9w8f8bVPIBs+G+sZUMqMrqgHmGdD0zw9JMDE7i4A8MduTbUCJsIIyx2D8iKwViqd+qgF9pdEaBMUl3ey0m1agnwVYLr9bVYbGmx6DWf+u1rpbfV9pZe3Nn8JFJ41bDFQG2DArbXrj4zeJi0AxD/AbImQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116630; c=relaxed/simple;
	bh=/jhv+zRr3N0CE6qPpW3OfRI2yGTM1QXolXKktLhKu5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cdjpDFEwf8CI0NFWodYLpgzY/TQzDxMpPPs7nnZ/F1MM1TxXF6BftVKdnsLqGdKkvB4FqXbCgXrEh8zS4aqwKABSB64xBImqHT+0LcBgo27Fc3Hhcv/Laq6yFGZBzac33fgFsYB9KEbYXZyZQ4TyPTDJQYLvONwduZrDGxNR6sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SmLUouti; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SmLUouti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C86D1F000E9;
	Fri,  7 Aug 2026 15:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116628;
	bh=3Bu5GoXuEWmUmHT3losP1VviGiE2bNig0MTLzbvreJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SmLUoutiBpQvKBKIxDEgp3lqgDiUXv3fJ5but4AmeCunoKxQjETsxyEoBB47np4X2
	 pNlqXILYTBY2MJAM2qhbWo3UBW3VW2SnMMoX6WW96pEFsEYcnj5nBYGCdUxVMU4T+X
	 U5shE9hRG/AwnA342DXaMv9UjcQW91+Vu2nDSLRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 036/438] phy: zynqmp: fix runtime PM leak on probe allocation failure
Date: Fri,  7 Aug 2026 16:33:52 +0200
Message-ID: <20260807143428.775326353@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index c8230f2bda629..2138f5399821a 100644
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



