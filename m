Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A7D43CE45;
	Mon, 17 Aug 2026 14:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978020; cv=none; b=N76oBe7tS2fL8WBSuitj/rZCBybBCOjacbVlbggy2CJXMpyN+2ABAyb5cEpYyuMOz5+tfQfXhNQX+fKhocBdsZy3BbITAYERMXnhCIrd9nYzbmIqL9ZBCHfSyG+YJmHREdn7dFxLMgM/qIOcH/dSa3e4wwHSQInP+Nno1m0iDsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978020; c=relaxed/simple;
	bh=xsDiha/QRX5iJFMMNejW+/c/SXKG5Bpdz/7QhMY/cAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAgis3cqUiGJpR/4f04T+RkRCywm8K/2f/+SQMYR63fEs8hWJOTb2TpgNd3hXq+hUYoAegfrbFC8df7QcLcLeOMfmU5Me4zWZ/uAh3YgfE2g3m7IZIod/9ou/mn5s+9YIKNKYpsLdZeytJ9RLeryt2MiQuBWLrOGm7LRymL7nhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DOvJW7+z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DOvJW7+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD4F1F00A3E;
	Mon, 17 Aug 2026 14:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978019;
	bh=esQT/0xCf74vtP9jhe5mn27vDjpuXS9jercrT8/yzkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DOvJW7+zCX87MBoHD4zTwS7CElIVeSEwxlnGExwNcrCkCBE9YlBJsYfGumeKWBvdW
	 P3B/XgfmI+4Pw9lOXIghuq3FMBlZiRDPC1rZZe26nWKJR/3pbTidYx1KfixCFk0t/V
	 8PNv+A9s/auMsa1yShSzaTO1TvdeQxiYp9wopTS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 072/181] mtd: spinand: repeat reading in regular mode if continuous reading fails
Date: Mon, 17 Aug 2026 15:32:46 +0200
Message-ID: <20260817132538.278350659@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

From: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>

[ Upstream commit 010dc7f2dd6a0078ade3f88f627ed5fbf45ceb94 ]

Continuous reading may result in multiple flash pages reading in one
operation. Unfortunately, not all spinand controllers support such
large reading. They will read less data. Unfortunately, the operation
can't be continued.

In this case:
 * disable continuous reading on this (not good enough) spi controller
 * repeat reading in regular mode.

Cc: stable@vger.kernel.org
Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/spi/core.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
index 10339209e7322..bf16901b77b64 100644
--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -427,8 +427,16 @@ static int spinand_read_from_cache_op(struct spinand_device *spinand,
 		 * Dirmap accesses are allowed to toggle the CS.
 		 * Toggling the CS during a continuous read is forbidden.
 		 */
-		if (nbytes && req->continuous)
-			return -EIO;
+		if (nbytes && req->continuous) {
+			/*
+			 * Spi controller with broken support of continuous
+			 * reading was detected. Disable future use of
+			 * continuous reading and return -EAGAIN to retry
+			 * reading within regular mode.
+			 */
+			spinand->cont_read_possible = false;
+			return -EAGAIN;
+		}
 	}
 
 	if (req->datalen)
@@ -849,10 +857,19 @@ static int spinand_mtd_read(struct mtd_info *mtd, loff_t from,
 
 	old_stats = mtd->ecc_stats;
 
-	if (spinand_use_cont_read(mtd, from, ops))
+	if (spinand_use_cont_read(mtd, from, ops)) {
 		ret = spinand_mtd_continuous_page_read(mtd, from, ops, &max_bitflips);
-	else
+		if (ret == -EAGAIN && !spinand->cont_read_possible) {
+			/*
+			 * Spi controller with broken support of continuous
+			 * reading was detected (see spinand_read_from_cache_op()),
+			 * repeat reading in regular mode.
+			 */
+			ret = spinand_mtd_regular_page_read(mtd, from, ops, &max_bitflips);
+		}
+	} else {
 		ret = spinand_mtd_regular_page_read(mtd, from, ops, &max_bitflips);
+	}
 
 	if (ops->stats) {
 		ops->stats->uncorrectable_errors +=
-- 
2.53.0



