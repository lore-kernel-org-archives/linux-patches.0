Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056FE1A76AE;
	Tue, 30 Jul 2024 17:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360149; cv=none; b=e4SVX5OeYDpnP8X1mR0HsYgRDLi9FhxGmPTHjfwotMen4Tc84fRYpANXsSzht0h7AHLhg/pPP29lLgISD92B7T3Q6yKnTSLTFldVo/chb1Q1VEKRPr6DYa4RQr8h8ljmXby/FnIFAcs9YwvxM7Ks7y0xXhcgTcaEJ4bJXYxzt50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360149; c=relaxed/simple;
	bh=Wohn2bEDfdYIoBGzQMmGE/+4+L+vKnfBSgMqACIZfrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AC7rahLtbzRPYl6XJvyap8pkoGiIDmrndKvFA8KmXTT1GwCqhiIhjlfaMmKUqnj9t3q74ULvl/GIE1EcDNSo0MTFUggVKMOTBSGloP6vnjzUrDn2c2DUkUehOU9yCHKDNfj9fKLltDGL9RlF6f0f8Rnsobu0/QdEzUITeMBfSOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nn4u6M0E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nn4u6M0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8310DC32782;
	Tue, 30 Jul 2024 17:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360148;
	bh=Wohn2bEDfdYIoBGzQMmGE/+4+L+vKnfBSgMqACIZfrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nn4u6M0EtJ7gdxaumrk5TyR5q0GMp0swulJ7ICAIuOmoloPq7CfVQNEJm3dBw6NnT
	 WOQX5glmkx2UCUy3LmwzdX2N5Ed9J3ZArXa5wAwEanWTAKNzovcp80AtTlUnEr+98x
	 681bP4ilHet1FqG5/UG+OGkvJzIpPCX4uG8DGICs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 6.10 611/809] media: imx-pxp: Fix ERR_PTR dereference in pxp_probe()
Date: Tue, 30 Jul 2024 17:48:07 +0200
Message-ID: <20240730151748.971273527@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


