Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5115D44BCB8;
	Thu, 30 Jul 2026 15:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425155; cv=none; b=Q8A0i0qGmQ0gl7UDVJpDVlZoAXciIxMqDBbahyi5AOZhZcGpVE3o7sSxO55Wb1Km9dqVdnY34uWE1kEmfQE48FjnOgVC3qPUSHtbQPHmQW62lddjpYbQC4g0lvAP+2T/ntNUyP0FUrf0AegZWhlB2WdXAdXf6QIMC014a7fe39M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425155; c=relaxed/simple;
	bh=AnL+31h7EAU6sR7hg92s8ULqECgdF5ttEUnyfJWxReo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fc/PYLkeF/TzylXaZJYKcg/PmQPkvvkRt3PrjCbagY9m9qkMhNvs4jzojFTolusqoruZFI8hY/OYh3pq7E1KsgF2FBBJB4OoWnUebFwsnj3oXp5c1FC/PAVeyiC9j5HmpJPi2DIY7Qy0o/COPsIMWfRKDD75c66kRhI2vyuliA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sxJQqSmI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sxJQqSmI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A2B1F000E9;
	Thu, 30 Jul 2026 15:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425153;
	bh=+kv1Sp6xitnl70ON5QWbBSD7HgbS7uMAWIIxIKSoFEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sxJQqSmIjImNLXnlJ8yy3nipHNG3hDmrHJLzkz8DFxB+73BZY0tH4T4IZMwx7t/FB
	 dRj/pfIf5q7iOJDl4w8yeLXwlb3Wmd5/Ys1LjybRte27eLicA9b4PvKf89KNQdiMRK
	 ZH2bSeNEtHJff4Uf8WKO3OQjhDfID+isMbX441ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 641/675] dmaengine: dw-edma: Fix confusing cleanup.h syntax
Date: Thu, 30 Jul 2026 16:16:11 +0200
Message-ID: <20260730141458.754085017@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit f9ef8dedee34e2d7828d5a6a0643cd969aaa8437 ]

Initializing automatic __free variables to NULL without need (e.g.
branches with different allocations), followed by actual allocation is
in contrary to explicit coding rules guiding cleanup.h:

"Given that the "__free(...) = NULL" pattern for variables defined at
the top of the function poses this potential interdependency problem the
recommendation is to always define and assign variables in one statement
and not group variable definitions at the top of the function when
__free() is used."

Code does not have a bug, but is less readable and uses discouraged
coding practice, so fix that by moving declaration to the place of
assignment.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20251208020729.4654-2-krzysztof.kozlowski@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 11d7cfe0c119 ("dmaengine: dw-edma-pcie: Reject devices without driver data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/dw-edma/dw-edma-pcie.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/dma/dw-edma/dw-edma-pcie.c
+++ b/drivers/dma/dw-edma/dw-edma-pcie.c
@@ -161,13 +161,13 @@ static int dw_edma_pcie_probe(struct pci
 			      const struct pci_device_id *pid)
 {
 	struct dw_edma_pcie_data *pdata = (void *)pid->driver_data;
-	struct dw_edma_pcie_data *vsec_data __free(kfree) = NULL;
 	struct device *dev = &pdev->dev;
 	struct dw_edma_chip *chip;
 	int err, nr_irqs;
 	int i, mask;
 
-	vsec_data = kmalloc(sizeof(*vsec_data), GFP_KERNEL);
+	struct dw_edma_pcie_data *vsec_data __free(kfree) =
+		kmalloc(sizeof(*vsec_data), GFP_KERNEL);
 	if (!vsec_data)
 		return -ENOMEM;
 


