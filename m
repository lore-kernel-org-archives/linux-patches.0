Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011F74E50D5;
	Fri,  9 Oct 2026 14:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557205; cv=none; b=rHIGoXL0DFW4T/iqCmwjqsfpsumsOI5getBJKMzWkyyqZ9BB5ryjL8Vvc0KLhtYkG4j3rGOk++kb6sFNG4rSAK+xZF8Yha3XRZd0srm1Z7xcVjCpsMf/fRjcn2RKpz+XEyfv4aUsOFikD8TtFNhYTVEPpEbTsVgGGCyAgz7TuBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557205; c=relaxed/simple;
	bh=Ke4iBV2MvlMgLfYODFdDB5vdbBKV49s/kLHFa+fdQDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jaVGTAv0lko8Oer69fT9jcRqJm03jPVruO/5L8ejsWFPyLuuMWHvyK1kROaNvbI0FBCw7bCmSNOYq3pLYpQQFnA4mJ4UtpGpno9BfICCDhcSV3KiJTWwgBbdVR2+3GqEjWh8hwmOlUfLXtr+RQlnwfafakJM+RIVR1TZlxSqtvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2BM3gLaz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2BM3gLaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EFB81F000FF;
	Fri,  9 Oct 2026 14:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557203;
	bh=JtUa3m89bAHZBn9OlbYLUVy/gTORiO6kDgpdbhDPqmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2BM3gLazFFKNtrdubNn5iXMmXZ/RtyqaqUHJMZQvptgWvGGPZ+2MirsoWklATA3ck
	 xn5aW4HxEYZGcQE0uNboqRZOARNlazTtDf4FDDknRZkpxO1kFiX7tKgNPUOlwsAEWy
	 xrL0eagaAgRBwKu7Sl2jyjW2TZvVEvV2rP2K3bhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 7.2 308/428] mtd: spinand: fix NULL pointer dereference with no ECC engine
Date: Fri,  9 Oct 2026 16:10:45 +0200
Message-ID: <20261009140952.885831886@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sá <nuno.sa@analog.com>

commit b890e6163761ddb580cc74f43e15f8bbde15647e upstream.

When "nand-no-ecc-engine" is set in DT, nanddev_get_ecc_engine() takes
the NAND_ECC_ENGINE_TYPE_NONE path and returns success while leaving
nand->ecc.engine NULL. The SPI-NAND code nevertheless dereferences it
unconditionally to test for a pipelined engine, so probing such a
device oopses immediately.

Rather than open-coding the test three times, add a
nand_ecc_is_pipelined() helper to the NAND core that folds the NULL
check into the integration comparison, and use it everywhere. Future
callers then cannot reintroduce the problem.

Fixes: f9d7c7265bcf ("mtd: spinand: Create direct mapping descriptors for ECC operations")
Cc: stable@vger.kernel.org
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/ecc.c      |    7 +++++++
 drivers/mtd/nand/spi/core.c |    8 +++-----
 include/linux/mtd/nand.h    |    2 ++
 3 files changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/mtd/nand/ecc.c
+++ b/drivers/mtd/nand/ecc.c
@@ -159,6 +159,13 @@ int nand_ecc_finish_io_req(struct nand_d
 }
 EXPORT_SYMBOL(nand_ecc_finish_io_req);
 
+bool nand_ecc_is_pipelined(const struct nand_device *nand)
+{
+	return nand->ecc.engine &&
+	       nand->ecc.engine->integration == NAND_ECC_ENGINE_INTEGRATION_PIPELINED;
+}
+EXPORT_SYMBOL(nand_ecc_is_pipelined);
+
 /* Define default OOB placement schemes for large and small page devices */
 static int nand_ooblayout_ecc_sp(struct mtd_info *mtd, int section,
 				 struct mtd_oob_region *oobregion)
--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -526,8 +526,7 @@ static int spinand_read_from_cache_op(st
 	else
 		rdesc->info.op_tmpl = &rdesc->info.primary_op_tmpl;
 
-	if (nand->ecc.engine->integration == NAND_ECC_ENGINE_INTEGRATION_PIPELINED &&
-	    req->mode != MTD_OPS_RAW)
+	if (nand_ecc_is_pipelined(nand) && req->mode != MTD_OPS_RAW)
 		rdesc->info.op_tmpl->data.ecc = true;
 	else
 		rdesc->info.op_tmpl->data.ecc = false;
@@ -621,8 +620,7 @@ static int spinand_write_to_cache_op(str
 
 	wdesc = spinand->dirmaps[req->pos.plane].wdesc;
 
-	if (nand->ecc.engine->integration == NAND_ECC_ENGINE_INTEGRATION_PIPELINED &&
-	    req->mode != MTD_OPS_RAW)
+	if (nand_ecc_is_pipelined(nand) && req->mode != MTD_OPS_RAW)
 		wdesc->info.op_tmpl->data.ecc = true;
 	else
 		wdesc->info.op_tmpl->data.ecc = false;
@@ -1279,7 +1277,7 @@ static int spinand_create_dirmap(struct
 	struct spi_mem_dirmap_desc *desc;
 	bool enable_ecc = false, secondary_op = false;
 
-	if (nand->ecc.engine->integration == NAND_ECC_ENGINE_INTEGRATION_PIPELINED)
+	if (nand_ecc_is_pipelined(nand))
 		enable_ecc = true;
 
 	if (spinand->cont_read_possible && spinand->op_templates->cont_read_cache)
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -305,6 +305,8 @@ int nand_ecc_prepare_io_req(struct nand_
 			    struct nand_page_io_req *req);
 int nand_ecc_finish_io_req(struct nand_device *nand,
 			   struct nand_page_io_req *req);
+bool nand_ecc_is_pipelined(const struct nand_device *nand);
+
 bool nand_ecc_is_strong_enough(struct nand_device *nand);
 
 #if IS_REACHABLE(CONFIG_MTD_NAND_CORE)


