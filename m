Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408EF11193;
	Mon,  4 Mar 2024 21:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588604; cv=none; b=APAkMGaRYqs/m5EYRrfFG0ZN0RSL8CDXfsFTLk8CTIeCE/WTBebM4sYqNIEk+nYOd3E8rvP8hjvTehbvJLyr6dPyHYP6kh6afVYGisXnMHRUI8vxKoQVrclASw98+NCAFbmmpOGAvDNlXFrYugYk01qoxvnXeR9jwTtEtegx1qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588604; c=relaxed/simple;
	bh=3Nej5BOsFOl0JdURz2Tm7t7Vw3O6pBSN1J/nEIeo6tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WikzKWIV1XLl623mFu4ZabLBVIwYLEPX4eutZbaMWFhRWAt/o+oQNxAx9fjpMZA/1oOuwcDMibaDykuXn/OUWQcEwvZHD+vmD69bPubqTOcehAcgAYo0nDF0CzFz6x2couTttLW+faQmnu+8wdBOZ5ArNEuiEFBcKiC1H3FdRRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YqgTTzGb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YqgTTzGb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CD0C433C7;
	Mon,  4 Mar 2024 21:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588604;
	bh=3Nej5BOsFOl0JdURz2Tm7t7Vw3O6pBSN1J/nEIeo6tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YqgTTzGb3gnFPSEXssAieTXZf0ZsKEFK7DZwoOTTEOV3GgWB+hxMFd4DWiMVcGGx+
	 KczjV/pqVlufW5vdv5+ld0Ms9AnV5BoAYOx0TaxI/ppZSQRBQH15Jk3kanlunihYIU
	 Xp3fqv0yyElOG3kt4vP7NK6VYy47k7Z4MB79TV/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Xu <han.xu@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/215] mtd: spinand: gigadevice: Fix the get ecc status issue
Date: Mon,  4 Mar 2024 21:21:30 +0000
Message-ID: <20240304211557.853171772@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Han Xu <han.xu@nxp.com>

[ Upstream commit 59950610c0c00c7a06d8a75d2ee5d73dba4274cf ]

Some GigaDevice ecc_get_status functions use on-stack buffer for
spi_mem_op causes spi_mem_check_op failing, fix the issue by using
spinand scratchbuf.

Fixes: c40c7a990a46 ("mtd: spinand: Add support for GigaDevice GD5F1GQ4UExxG")
Signed-off-by: Han Xu <han.xu@nxp.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20231108150701.593912-1-han.xu@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/spi/gigadevice.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/spi/gigadevice.c b/drivers/mtd/nand/spi/gigadevice.c
index 6b043e24855fb..9116ee7f023ed 100644
--- a/drivers/mtd/nand/spi/gigadevice.c
+++ b/drivers/mtd/nand/spi/gigadevice.c
@@ -186,7 +186,7 @@ static int gd5fxgq4uexxg_ecc_get_status(struct spinand_device *spinand,
 {
 	u8 status2;
 	struct spi_mem_op op = SPINAND_GET_FEATURE_OP(GD5FXGQXXEXXG_REG_STATUS2,
-						      &status2);
+						      spinand->scratchbuf);
 	int ret;
 
 	switch (status & STATUS_ECC_MASK) {
@@ -207,6 +207,7 @@ static int gd5fxgq4uexxg_ecc_get_status(struct spinand_device *spinand,
 		 * report the maximum of 4 in this case
 		 */
 		/* bits sorted this way (3...0): ECCS1,ECCS0,ECCSE1,ECCSE0 */
+		status2 = *(spinand->scratchbuf);
 		return ((status & STATUS_ECC_MASK) >> 2) |
 			((status2 & STATUS_ECC_MASK) >> 4);
 
@@ -228,7 +229,7 @@ static int gd5fxgq5xexxg_ecc_get_status(struct spinand_device *spinand,
 {
 	u8 status2;
 	struct spi_mem_op op = SPINAND_GET_FEATURE_OP(GD5FXGQXXEXXG_REG_STATUS2,
-						      &status2);
+						      spinand->scratchbuf);
 	int ret;
 
 	switch (status & STATUS_ECC_MASK) {
@@ -248,6 +249,7 @@ static int gd5fxgq5xexxg_ecc_get_status(struct spinand_device *spinand,
 		 * 1 ... 4 bits are flipped (and corrected)
 		 */
 		/* bits sorted this way (1...0): ECCSE1, ECCSE0 */
+		status2 = *(spinand->scratchbuf);
 		return ((status2 & STATUS_ECC_MASK) >> 4) + 1;
 
 	case STATUS_ECC_UNCOR_ERROR:
-- 
2.43.0



