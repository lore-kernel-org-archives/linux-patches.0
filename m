Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DC038910F;
	Tue, 21 Jul 2026 18:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660186; cv=none; b=qrQ/4OEiiVV10oIlsViFdVaVbdtHXEQatoQpW5QxzNX1+MqCPpFurQIo3aSmQ2Z/g5E2vUeeZqQFRtdksJ9L+EjGS+DpKWZ0WEm+K75Jq3M2ue3/FOy4Me/F5l4BB3dclVPr0aDQrsutO+9yxw/eI0r0Ij3hfWNQqRI4mWwLiJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660186; c=relaxed/simple;
	bh=g4DD4XZEdW1zx8kGsNZvJSRHeuCWBGzq9c/U0AguvfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UI9FjGmIXyqAXyg18rsgs3Xsp5ibw/uA52jsIzrpFBR+zjfG+3pKg1RKPRPtGESn67BxzxU0Ma6EOs3Tc4RGUEOkB2ITgT5PrSxiRSZpcub+AOz96YherD/BzZuI/XHExyBh78hSwz+H4Zl6wWSYC7mXFO2nQ9Kws9Q6mH1nJgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nQ92AZ8H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nQ92AZ8H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3E81F000E9;
	Tue, 21 Jul 2026 18:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660184;
	bh=iTDImu8ON3T2qVSTvqjkTLrNwLZZcuFUKCqqDk30F5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nQ92AZ8HOPASYAyDIK2hyaDaNI00XH78p6J6dB1WZ2Z0OTvv7VWwABysACgI+IW9o
	 /jJgyKK9CkI/fW3c7DDRPC7kX2Dz9fRZSylj+BzsECm23NUE9NcMnr7cumsQB2p0Ko
	 kCbVUAvPh7eVBxU6bPLCNwzphg3+3zuCCUP5Nv4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0885/2077] clk: microchip: mpfs-ccc: fix peripheral driver registration failures after oob fix
Date: Tue, 21 Jul 2026 17:09:18 +0200
Message-ID: <20260721152613.682690445@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit c8a3be5bc2b2f2d53c56a8b9cab731e917b95c07 ]

Commit 2f7ae8ab6aa73 ("clk: microchip: mpfs-ccc: fix out of bounds
access during output registration") fixed the out of bounds access, but
it did so by packing sparse indices into a linear space. When
peripheral drivers request clocks, they obviously don't care for this
compression and use the sparse indices, and therefore try to request the
wrong clocks or clocks that don't exist.

The most straightforward fix here seems to stop being clever with the
packing and just overallocate the array.

Fixes: 2f7ae8ab6aa73 ("clk: microchip: mpfs-ccc: fix out of bounds access during output registration")
Fixes: d39fb172760e ("clk: microchip: add PolarFire SoC fabric clock support")
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/microchip/clk-mpfs-ccc.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/clk/microchip/clk-mpfs-ccc.c b/drivers/clk/microchip/clk-mpfs-ccc.c
index 0a76a1aaa50f7f..40c17593e5941d 100644
--- a/drivers/clk/microchip/clk-mpfs-ccc.c
+++ b/drivers/clk/microchip/clk-mpfs-ccc.c
@@ -32,6 +32,7 @@
 #define MPFS_CCC_FIXED_DIV		4
 #define MPFS_CCC_OUTPUTS_PER_PLL	4
 #define MPFS_CCC_REFS_PER_PLL		2
+#define MPFS_CCC_NUM_CLKS		16
 
 struct mpfs_ccc_data {
 	void __iomem **pll_base;
@@ -178,7 +179,7 @@ static int mpfs_ccc_register_outputs(struct device *dev, struct mpfs_ccc_out_hw_
 			return dev_err_probe(dev, ret, "failed to register clock id: %d\n",
 					     out_hw->id);
 
-		data->hw_data.hws[out_hw->id - 2] = &out_hw->divider.hw;
+		data->hw_data.hws[out_hw->id] = &out_hw->divider.hw;
 	}
 
 	return 0;
@@ -231,17 +232,9 @@ static int mpfs_ccc_probe(struct platform_device *pdev)
 {
 	struct mpfs_ccc_data *clk_data;
 	void __iomem *pll_base[ARRAY_SIZE(mpfs_ccc_pll_clks)];
-	unsigned int num_clks;
 	int ret;
 
-	/*
-	 * If DLLs get added here, mpfs_ccc_register_outputs() currently packs
-	 * sparse clock IDs in the hws array
-	 */
-	num_clks = ARRAY_SIZE(mpfs_ccc_pll_clks) + ARRAY_SIZE(mpfs_ccc_pll0out_clks) +
-		   ARRAY_SIZE(mpfs_ccc_pll1out_clks);
-
-	clk_data = devm_kzalloc(&pdev->dev, struct_size(clk_data, hw_data.hws, num_clks),
+	clk_data = devm_kzalloc(&pdev->dev, struct_size(clk_data, hw_data.hws, MPFS_CCC_NUM_CLKS),
 				GFP_KERNEL);
 	if (!clk_data)
 		return -ENOMEM;
@@ -255,7 +248,7 @@ static int mpfs_ccc_probe(struct platform_device *pdev)
 		return PTR_ERR(pll_base[1]);
 
 	clk_data->pll_base = pll_base;
-	clk_data->hw_data.num = num_clks;
+	clk_data->hw_data.num = MPFS_CCC_NUM_CLKS;
 	clk_data->dev = &pdev->dev;
 
 	ret = mpfs_ccc_register_plls(clk_data->dev, mpfs_ccc_pll_clks,
-- 
2.53.0



