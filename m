Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AE52E64F;
	Fri, 24 Nov 2023 18:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SickaHX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410CCC433C8;
	Fri, 24 Nov 2023 18:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851843;
	bh=Zs/wBK1Dba6nkul5Nuilvfbgl3/BapJeJ+kV/PlFvik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SickaHX54yD0QzlycaRZvX27fPKNKKKA/tS2embOMpMGWzoIHQHzDbV7su9UScxop
	 DPq1ID4SmnPscZg+yeB3NxFQPaCWA5yzjHcM1GcgU8eW3E2VDk4SbXPHR2uXghPQJY
	 pNrxuYGsc519SsWoZr3kBA41wUyiANuMb++Hqj8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Yang <yiyang13@huawei.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 118/372] mtd: rawnand: intel: check return value of devm_kasprintf()
Date: Fri, 24 Nov 2023 17:48:25 +0000
Message-ID: <20231124172014.418826441@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Yang <yiyang13@huawei.com>

[ Upstream commit 74ac5b5e2375f1e8ef797ac7770887e9969f2516 ]

devm_kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure. Ensure the allocation was successful by
checking the pointer validity.

Fixes: 0b1039f016e8 ("mtd: rawnand: Add NAND controller support on Intel LGM SoC")
Signed-off-by: Yi Yang <yiyang13@huawei.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20231019065537.318391-1-yiyang13@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/intel-nand-controller.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/mtd/nand/raw/intel-nand-controller.c b/drivers/mtd/nand/raw/intel-nand-controller.c
index 6f4cea81f97c0..1f8a33fb84607 100644
--- a/drivers/mtd/nand/raw/intel-nand-controller.c
+++ b/drivers/mtd/nand/raw/intel-nand-controller.c
@@ -619,6 +619,11 @@ static int ebu_nand_probe(struct platform_device *pdev)
 	ebu_host->cs_num = cs;
 
 	resname = devm_kasprintf(dev, GFP_KERNEL, "nand_cs%d", cs);
+	if (!resname) {
+		ret = -ENOMEM;
+		goto err_of_node_put;
+	}
+
 	ebu_host->cs[cs].chipaddr = devm_platform_ioremap_resource_byname(pdev,
 									  resname);
 	if (IS_ERR(ebu_host->cs[cs].chipaddr)) {
@@ -655,6 +660,11 @@ static int ebu_nand_probe(struct platform_device *pdev)
 	}
 
 	resname = devm_kasprintf(dev, GFP_KERNEL, "addr_sel%d", cs);
+	if (!resname) {
+		ret = -ENOMEM;
+		goto err_cleanup_dma;
+	}
+
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, resname);
 	if (!res) {
 		ret = -EINVAL;
-- 
2.42.0



