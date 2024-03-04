Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7D91C6AB;
	Mon,  4 Mar 2024 21:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589194; cv=none; b=cFeIXoh2BPlxsNgqIEvqwIVyX7hnB4/w98Um9jmUZYvxtcsH1du6dyrXDDz7OQ8ZBvMcsraJKxQjQ+TI4D7sguQGEhyT4hWGYQmXKxPV9e7tbiLmJNfpQlVuv/qZJk0KVVtNyU1oIYV6R/iDVLwbaZlw7Okh69+d6NkdNWLPvLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589194; c=relaxed/simple;
	bh=/gmwaJs/pB/mEAl29JQh7vcDV2Ap58pA4B5fD931v9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tfz8boMLCA6jLZgbZ4MWpTjN4Avfa0nwhrtXQSjmzJTXwthBkS0eLYV4SA8RRUPwv9N98ryeOCBElHukw6LeJ03UJBkoJxcs2HsB5UFNpDHXnwxk2JUpJwtTHnwyUC89XNHs1RfZ1buZ0aLUSC+g7Rn02aYDzzDDAwjtgJESOvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/6VHuiI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/6VHuiI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC99C433C7;
	Mon,  4 Mar 2024 21:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589194;
	bh=/gmwaJs/pB/mEAl29JQh7vcDV2Ap58pA4B5fD931v9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/6VHuiIUmkcDh87CHbCTQcrBx2oe596zG+8+yY0fNwAdZpn/5hOkMBNQlTfuuWB1
	 4ev1IqSmOSuEjzqpDZ6oe+cvjiKdqRlfzFM7DgAfB7tEt+yH/aw0oycB1Bu864qKci
	 YKft3JQ9+ohS7M07HHNCrfepK5uToMMCclTFfMPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Xu <han.xu@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 02/84] mtd: spinand: gigadevice: Fix the get ecc status issue
Date: Mon,  4 Mar 2024 21:23:35 +0000
Message-ID: <20240304211542.421558864@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index da77ab20296ea..56d1b56615f97 100644
--- a/drivers/mtd/nand/spi/gigadevice.c
+++ b/drivers/mtd/nand/spi/gigadevice.c
@@ -178,7 +178,7 @@ static int gd5fxgq4uexxg_ecc_get_status(struct spinand_device *spinand,
 {
 	u8 status2;
 	struct spi_mem_op op = SPINAND_GET_FEATURE_OP(GD5FXGQXXEXXG_REG_STATUS2,
-						      &status2);
+						      spinand->scratchbuf);
 	int ret;
 
 	switch (status & STATUS_ECC_MASK) {
@@ -199,6 +199,7 @@ static int gd5fxgq4uexxg_ecc_get_status(struct spinand_device *spinand,
 		 * report the maximum of 4 in this case
 		 */
 		/* bits sorted this way (3...0): ECCS1,ECCS0,ECCSE1,ECCSE0 */
+		status2 = *(spinand->scratchbuf);
 		return ((status & STATUS_ECC_MASK) >> 2) |
 			((status2 & STATUS_ECC_MASK) >> 4);
 
@@ -220,7 +221,7 @@ static int gd5fxgq5xexxg_ecc_get_status(struct spinand_device *spinand,
 {
 	u8 status2;
 	struct spi_mem_op op = SPINAND_GET_FEATURE_OP(GD5FXGQXXEXXG_REG_STATUS2,
-						      &status2);
+						      spinand->scratchbuf);
 	int ret;
 
 	switch (status & STATUS_ECC_MASK) {
@@ -240,6 +241,7 @@ static int gd5fxgq5xexxg_ecc_get_status(struct spinand_device *spinand,
 		 * 1 ... 4 bits are flipped (and corrected)
 		 */
 		/* bits sorted this way (1...0): ECCSE1, ECCSE0 */
+		status2 = *(spinand->scratchbuf);
 		return ((status2 & STATUS_ECC_MASK) >> 4) + 1;
 
 	case STATUS_ECC_UNCOR_ERROR:
-- 
2.43.0



