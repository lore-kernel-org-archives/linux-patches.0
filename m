Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B4318801A;
	Tue, 30 Jul 2024 17:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358924; cv=none; b=cxDyaXxhdJ2RnHKO8kLx6dmhWYugGx1QJcb69L7fyanKRqcJ8hDOuB5UZwEwtI+UMUzZCtx64nr/LQkpxKSIqxtABmd7BH/RAVvAJPWL0746H0imbnNLzQ7uBltXyErLSrMeaxQUc0KhYgzNpl1IvktHu+SANMbnrHxNdO6s8Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358924; c=relaxed/simple;
	bh=rLhkJrm5LU49SX6bM3Nx9X6Zj2bV7Dl1Y+vwbGRVQhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XluzJYi7rJRstPCzWqHCDB1Rl6OrJbexYTZB5EN4CiAj9WD+nKWEmoAuLEfeNFXPd3jtZwdjWQcvhJvPZI/rA6VMO08telzntZ1LJgU+isLmJPOPv3ARtoTsMaHEBzPgrzuMnQtUXd4OCmNYpeVbBQpHsVS1clUYVnCM7S/W6Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rCetgRG9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rCetgRG9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC42C32782;
	Tue, 30 Jul 2024 17:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358924;
	bh=rLhkJrm5LU49SX6bM3Nx9X6Zj2bV7Dl1Y+vwbGRVQhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rCetgRG9p8gXF3u1XBs0cV/ctP5ULnsOBNz5O2CZ/ogAP4488RZjOLpxnD0+KFGh+
	 9/eJe3d9U9p6ufGsrnYhQhGimdHq3aJ/+Xq1i/g62Eb1kaQcB6Q2Bsa05wfvZBq6kW
	 tJLkTA6u0qEUdTEyXPmjhesJeRAffpNaRJ7V0sRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 6.6 409/568] media: imx-pxp: Fix ERR_PTR dereference in pxp_probe()
Date: Tue, 30 Jul 2024 17:48:36 +0200
Message-ID: <20240730151655.855368195@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

commit 57e9ce68ae98551da9c161aaab12b41fe8601856 upstream.

devm_regmap_init_mmio() can fail, add a check and bail out in case of
error.

Fixes: 4e5bd3fdbeb3 ("media: imx-pxp: convert to regmap")
Cc: stable@vger.kernel.org
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/20240514095038.3464191-1-harshit.m.mogalapalli@oracle.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx-pxp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/media/platform/nxp/imx-pxp.c
+++ b/drivers/media/platform/nxp/imx-pxp.c
@@ -1805,6 +1805,9 @@ static int pxp_probe(struct platform_dev
 		return PTR_ERR(mmio);
 	dev->regmap = devm_regmap_init_mmio(&pdev->dev, mmio,
 					    &pxp_regmap_config);
+	if (IS_ERR(dev->regmap))
+		return dev_err_probe(&pdev->dev, PTR_ERR(dev->regmap),
+				     "Failed to init regmap\n");
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)


