Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A34C26F28D;
	Mon, 23 Mar 2026 14:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277290; cv=none; b=NgU0XVIvvTFjnOf5xPFT5svFC0V62MUm5+bBE2psJn2x4YGemjbS+MU0QwNCrDl7FoB9sGliIjvslrCxBDPhtLIu4x0B6z1fR3uZ7OYu+80YW1bUAhOfg5WbXclJWYLyqshODCvB9wVUvgC0MQug4VgLz1FERjoFUNpgqLD6WMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277290; c=relaxed/simple;
	bh=E2DSqW/v2QGmnlp2ALK3U88T3bOd2dE9sYAd3b7RjAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZ4ZYPPh22/dVJvm83SB6lP9RlEl6lEFa/bWkK3IVeWQYj8+vqKMjzS3unQTOal0N4Lg0G7lJAvRExnTIqjXaXOXdsXPapMT/nx+NPU7lWszEr7PfFuEFIdAfFf3twc696yD9bmjLUjjofHFqHsReeDqhl9o0CEJ7lprqaCBZKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0zbK09N1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0zbK09N1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2631C4CEF7;
	Mon, 23 Mar 2026 14:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277290;
	bh=E2DSqW/v2QGmnlp2ALK3U88T3bOd2dE9sYAd3b7RjAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0zbK09N1jSeKU1UuAq03uOL356+TTbTN5TQTOttEGrXIs8h0o4menJT1cJ9gxREXS
	 EIhWT1THzVTomq/GqigkLgS+OJt4X6ExFH9M3etXKaJH2iKvD6DkBstxP+Ad0qd7y0
	 bPclCo5weY0Eu8vYrDJ3KgW8VA0Oq86EI+Muq1GU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.12 341/460] mtd: rawnand: cadence: Fix error check for dma_alloc_coherent() in cadence_nand_init()
Date: Mon, 23 Mar 2026 14:45:37 +0100
Message-ID: <20260323134534.914333686@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Chen Ni <nichen@iscas.ac.cn>

commit 0410e1a4c545c769c59c6eda897ad5d574d0c865 upstream.

Fix wrong variable used for error checking after dma_alloc_coherent()
call. The function checks cdns_ctrl->dma_cdma_desc instead of
cdns_ctrl->cdma_desc, which could lead to incorrect error handling.

Fixes: ec4ba01e894d ("mtd: rawnand: Add new Cadence NAND driver to MTD subsystem")
Cc: stable@vger.kernel.org
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/cadence-nand-controller.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/cadence-nand-controller.c
+++ b/drivers/mtd/nand/raw/cadence-nand-controller.c
@@ -2878,7 +2878,7 @@ static int cadence_nand_init(struct cdns
 						  sizeof(*cdns_ctrl->cdma_desc),
 						  &cdns_ctrl->dma_cdma_desc,
 						  GFP_KERNEL);
-	if (!cdns_ctrl->dma_cdma_desc)
+	if (!cdns_ctrl->cdma_desc)
 		return -ENOMEM;
 
 	cdns_ctrl->buf_size = SZ_16K;


