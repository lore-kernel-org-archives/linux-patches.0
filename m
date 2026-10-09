Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D3F3EC805;
	Fri,  9 Oct 2026 14:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556554; cv=none; b=D9u4jj0jhKhmY95rOp1WZsQSTpky4TzsZu79/6HhOpf9/Y4hhW1p+OdcUkgauhTaBCx3bXq/gSnIoJ5M7SXzGix8sLmyqqEWeKm+DMefIRg9ouz+x2YbyhsxB07H14eug4xLpqs5xb/KZZwkQpM/G9zRgLn6Ou4Q6Q3jRikAdY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556554; c=relaxed/simple;
	bh=80H8hs76CPnlyUijil13gVdx0mksUjcc3Ow6Pn60x+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oXc3RyWSM4PBh4j+NkusJ0aX8xu00ixvFvD9DVqUW9la4j4hyJBkc7vxn9EsX8uC6KufjIScUXlOnRut/k8CFR5IFby6WIpIONCabn2YHMS/opFyj2N2iRur0ZOFPXD6Y4gVnFD8Ke3sX6nOQI9uh89IHgGPn/DUGcCjDElQUmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vT5rI9Zh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vT5rI9Zh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C491F00893;
	Fri,  9 Oct 2026 14:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556553;
	bh=ljF25PEQTCD1y3xzheQlS3UZYdWygQv5lhwxMDZzU0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vT5rI9ZhwbuRSzeNR2F7vYUZpvXTDY38ZdbBRozfnIb66USwDAj9CntcuNY1QZGTB
	 BXmNwVEeLZvaKiv9uWsa21s1+LcNYuXcLm7gCg2+q7IDkrSpAmbf1oaQ8w67wInHSW
	 HNsVuOqjw11Wv+dCq2TPIjIF8LLY4l9CrZ0TH2UI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Xu <han.xu@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.18 254/403] mtd: spinand: Enable QE on all dies
Date: Fri,  9 Oct 2026 16:10:15 +0200
Message-ID: <20261009140958.114058362@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Han Xu <han.xu@nxp.com>

commit 63d6cace2c4a7f36c1cb44f1bb5e0f3ef19e5c7f upstream.

The QUAD ENABLE (QE) bit is stored in a per-die configuration
register on some SPI-NAND devices. When a device contains multiple
dies, updating the QE bit only on the currently selected die can
leave the remaining dies operating in non-quad mode.
 
Iterate over all targets and update the QE setting on each die
during initialization to ensure consistent quad I/O operation
across the entire device.

Tested on ISSI IS38SMW04G8B.

Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")
Cc: stable@vger.kernel.org
Signed-off-by: Han Xu <han.xu@nxp.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/spi/core.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -180,8 +180,26 @@ static int spinand_init_cfg_cache(struct
 static int spinand_init_quad_enable(struct spinand_device *spinand,
 				    bool enable)
 {
-	return spinand_upd_cfg(spinand, CFG_QUAD_ENABLE,
-			       enable ? CFG_QUAD_ENABLE : 0);
+	struct nand_device *nand = spinand_to_nand(spinand);
+	unsigned int target;
+	int ret;
+
+	/*
+	 * QE is a per-die setting on some devices. Program each target
+	 * individually when enabling or disabling quad I/O mode.
+	 */
+	for (target = 0; target < nand->memorg.ntargets; target++) {
+		ret = spinand_select_target(spinand, target);
+		if (ret)
+			return ret;
+
+		ret = spinand_upd_cfg(spinand, CFG_QUAD_ENABLE,
+				      enable ? CFG_QUAD_ENABLE : 0);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
 }
 
 static int spinand_ecc_enable(struct spinand_device *spinand,


