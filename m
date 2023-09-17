Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C00D53AB
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE62BC433C8;
	Sun, 17 Sep 2023 20:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694983216;
	bh=YNhDi8nh1SKSGl1/cnV8NVh/b7aX+uRBKmlvWr8gcoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k7uRoDgQ83AL8s75E/ruQOtebHmP0l5AML3N1H8lQbgMo3fQtDnGC6b3V0O8yKh4r
	 WGD0qbpuDPT02qlyqX3cVi/zB984dkn2+Th+1Htnr3jRXJmqqKGazROPNmUWXp8wQy
	 /BkSqRUvPZM4lsyfKnInaH/8RrvwGwLOfdo5j/U0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Zhang <william.zhang@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 478/511] mtd: rawnand: brcmnand: Fix potential out-of-bounds access in oob write
Date: Sun, 17 Sep 2023 21:15:05 +0200
Message-ID: <20230917191125.285479274@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

From: William Zhang <william.zhang@broadcom.com>

commit 5d53244186c9ac58cb88d76a0958ca55b83a15cd upstream.

When the oob buffer length is not in multiple of words, the oob write
function does out-of-bounds read on the oob source buffer at the last
iteration. Fix that by always checking length limit on the oob buffer
read and fill with 0xff when reaching the end of the buffer to the oob
registers.

Fixes: 27c5b17cd1b1 ("mtd: nand: add NAND driver "library" for Broadcom STB NAND controller")
Signed-off-by: William Zhang <william.zhang@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20230706182909.79151-5-william.zhang@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/brcmnand/brcmnand.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/raw/brcmnand/brcmnand.c
+++ b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
@@ -1432,19 +1432,33 @@ static int write_oob_to_regs(struct brcm
 			     const u8 *oob, int sas, int sector_1k)
 {
 	int tbytes = sas << sector_1k;
-	int j;
+	int j, k = 0;
+	u32 last = 0xffffffff;
+	u8 *plast = (u8 *)&last;
 
 	/* Adjust OOB values for 1K sector size */
 	if (sector_1k && (i & 0x01))
 		tbytes = max(0, tbytes - (int)ctrl->max_oob);
 	tbytes = min_t(int, tbytes, ctrl->max_oob);
 
-	for (j = 0; j < tbytes; j += 4)
+	/*
+	 * tbytes may not be multiple of words. Make sure we don't read out of
+	 * the boundary and stop at last word.
+	 */
+	for (j = 0; (j + 3) < tbytes; j += 4)
 		oob_reg_write(ctrl, j,
 				(oob[j + 0] << 24) |
 				(oob[j + 1] << 16) |
 				(oob[j + 2] <<  8) |
 				(oob[j + 3] <<  0));
+
+	/* handle the remaing bytes */
+	while (j < tbytes)
+		plast[k++] = oob[j++];
+
+	if (tbytes & 0x3)
+		oob_reg_write(ctrl, (tbytes & ~0x3), (__force u32)cpu_to_be32(last));
+
 	return tbytes;
 }
 


