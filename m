Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CC9330B0F;
	Fri, 17 Oct 2025 15:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715669; cv=none; b=kfyM2qEVaDyr5Xa7xPKsi1mitoyWahU2ebSsY92wWdLSdH7+IzZxYuQsSKBN1wLyzPH3xeTzm6kbuFqrMwtQjjtczZCgIzgZUDFuuMzfIso67e+18EZOqLkYd0YUjOZmRd7iO+7VEtndM/8OtRUnPZSVp39l8hHkUrMIoVBmn3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715669; c=relaxed/simple;
	bh=R59IotaoH+w3l/RqawE2jH+p8vj73VWN+R3I3or9MMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NbrqcbBQjF0gAjDmuq4xNINVndZFeUUhcdKy9QUxjuPnTgu9ryXBx3HaeVwZW374Psc0ud3gq6iCfBKiDOpmmRnxgRdCkO1DpgCsONriYtaw2jM0i/gVAkJ7udZ5RnNOqbqYvO4JNfgrfJof9QGB1gnpBG4s2eXD/8mRCOX0vxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P8nwqm73; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P8nwqm73"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E180BC4CEFE;
	Fri, 17 Oct 2025 15:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715669;
	bh=R59IotaoH+w3l/RqawE2jH+p8vj73VWN+R3I3or9MMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P8nwqm73Pju3zVEpq5xUa0NjkZEGdpQw1eaPjMYWv2JiEqoZFUu7jBiEF9LN0NIIo
	 gJf6gGJ2Ra6vPXJ1ChT/yCfCHfnzLkCe0wlaqX9ZXFKqZOh67pn1q/rELSrDytp/Xf
	 +G2U/RpbG9EGlj9YmyzCqrdU1gSB/3qrsSfqF/hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratyush Yadav <pratyush@kernel.org>,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Santhosh Kumar K <s-k6@ti.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.17 296/371] spi: cadence-quadspi: Fix cqspi_setup_flash()
Date: Fri, 17 Oct 2025 16:54:31 +0200
Message-ID: <20251017145212.783076698@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1727,12 +1727,10 @@ static const struct spi_controller_mem_c
 
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
@@ -1745,10 +1743,10 @@ static int cqspi_setup_flash(struct cqsp
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
@@ -1758,6 +1756,11 @@ static int cqspi_setup_flash(struct cqsp
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


