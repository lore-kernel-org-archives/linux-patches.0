Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFAA1EA99;
	Mon,  4 Mar 2024 21:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588216; cv=none; b=a6fz0lsky4+4WRjVBYyh+er3PsspYlg7Ul8OkG6XYwro8xGJcGDmgpITYav+pmpOBRrXwvTlVuW/XyhVaJE0a7QQ4yNX3HGTeXD2RkfmB7s2BG1yGo1IIkxwt8eIakgqL4/WwApnju5GP1N5ehUE1hzMcFsSBAvUfI3qYMyzBBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588216; c=relaxed/simple;
	bh=lYBBIvZQKmtxtF3OvQTOe5KAd+B+lD0RZg887JSAc+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S6XnRe+1CdU8uTg4b9bt1WZp3i4SZETPHrcUb/ftIZn7rKHFo2cVbdg/kUEJ/gkvsmZOTk+A5yQ8FMpGoG3Wz084YSKWbeWoZpXjGV5UXawoF7I9sHTNRAJhIY+bbg3msYqmdz4XGDphuXIakIlFmReMikiEBEZV31oIFE36Big=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HYW3nLo7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HYW3nLo7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3390EC433C7;
	Mon,  4 Mar 2024 21:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588216;
	bh=lYBBIvZQKmtxtF3OvQTOe5KAd+B+lD0RZg887JSAc+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HYW3nLo7Ms82ldpun9YrQSwwVfwab4hwoo++EwAFO0gyzZBKfdPevWCv92KFTzn7b
	 SFGZhjugxLalkdjJ+AC8Up3cBzl34T258/jiXSmyW0dGBKtR2B1/7/CjBu55Bwuw4I
	 cK2HljxF287utP/Hy6uBPxBQJfphZN8BUcpQAtP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Xu <han.xu@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/143] mtd: spinand: gigadevice: Fix the get ecc status issue
Date: Mon,  4 Mar 2024 21:22:06 +0000
Message-ID: <20240304211550.109612067@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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
index 987710e09441a..6023cba748bb8 100644
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



