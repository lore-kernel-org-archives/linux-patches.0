Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99602F12D1;
	Fri, 17 Oct 2025 15:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714573; cv=none; b=uLZHQ/u5ZjUd5s/jv4khD7dhswmmTOl4ME5zvKRSNLLjfVyzcNTlkvRaIvHyY0A00JiLN+1WLeMyFCaZMfi1eP7HT/ICeU7hi8hXTwV0S+tlxFZu7OeUQii6J1n6BfYt+YSe0TV9KsXtpmQI+HT3n2/sdZPAHpKNaRRmzpF8Hrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714573; c=relaxed/simple;
	bh=/cR7M66wyCAUXIyWtfLf6d7/Shj08HFfNezndlre/CE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ukj4dPdH4Llq7+GJHNhzuKlart19ZZgD/M/WXQzyNOgN9ZLlnxAQngJd6Pxc7AmDts8x7AtSIAwQ4Qzrd8+qkY9KVyMlHsCze0aUhaq9dzilHOHWHIgs79d1zxM1BHhmr9NIyMNUPud5XoqscNYd9P175cWG1DL4zLu5Vykeo+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JaQJrsVZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JaQJrsVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AEF4C4CEE7;
	Fri, 17 Oct 2025 15:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714573;
	bh=/cR7M66wyCAUXIyWtfLf6d7/Shj08HFfNezndlre/CE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JaQJrsVZamUMS+RpMXD64mI3slwH4etGKZSXZz6ov3VDX52BcVTmg1hI6ET7VVX3h
	 iqbahVi9WhnEdFMYVln7D2nJj5OoZRBCA/AAUPrt16OizeiyqknXTPAMY7Z7/exGf2
	 EfzK+W37oVFLiXa4/vMxSSELIMmP5JuFVBly64LE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratyush Yadav <pratyush@kernel.org>,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Santhosh Kumar K <s-k6@ti.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 192/277] spi: cadence-quadspi: Fix cqspi_setup_flash()
Date: Fri, 17 Oct 2025 16:53:19 +0200
Message-ID: <20251017145154.130808093@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Santhosh Kumar K <s-k6@ti.com>

commit 858d4d9e0a9d6b64160ef3c824f428c9742172c4 upstream.

The 'max_cs' stores the largest chip select number. It should only
be updated when the current 'cs' is greater than existing 'max_cs'. So,
fix the condition accordingly.

Also, return failure if there are no flash device declared.

Fixes: 0f3841a5e115 ("spi: cadence-qspi: report correct number of chip-select")
CC: stable@vger.kernel.org
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Théo Lebrun <theo.lebrun@bootlin.com>
Signed-off-by: Santhosh Kumar K <s-k6@ti.com>
Message-ID: <20250905185958.3575037-4-s-k6@ti.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cadence-quadspi.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1673,12 +1673,10 @@ static const struct spi_controller_mem_c
 
 static int cqspi_setup_flash(struct cqspi_st *cqspi)
 {
-	unsigned int max_cs = cqspi->num_chipselect - 1;
 	struct platform_device *pdev = cqspi->pdev;
 	struct device *dev = &pdev->dev;
 	struct cqspi_flash_pdata *f_pdata;
-	unsigned int cs;
-	int ret;
+	int ret, cs, max_cs = -1;
 
 	/* Get flash device data */
 	for_each_available_child_of_node_scoped(dev->of_node, np) {
@@ -1691,10 +1689,10 @@ static int cqspi_setup_flash(struct cqsp
 		if (cs >= cqspi->num_chipselect) {
 			dev_err(dev, "Chip select %d out of range.\n", cs);
 			return -EINVAL;
-		} else if (cs < max_cs) {
-			max_cs = cs;
 		}
 
+		max_cs = max_t(int, cs, max_cs);
+
 		f_pdata = &cqspi->f_pdata[cs];
 		f_pdata->cqspi = cqspi;
 		f_pdata->cs = cs;
@@ -1704,6 +1702,11 @@ static int cqspi_setup_flash(struct cqsp
 			return ret;
 	}
 
+	if (max_cs < 0) {
+		dev_err(dev, "No flash device declared\n");
+		return -ENODEV;
+	}
+
 	cqspi->num_chipselect = max_cs + 1;
 	return 0;
 }


