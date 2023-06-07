Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEBF3922F
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDDCC433EF;
	Wed,  7 Jun 2023 20:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171492;
	bh=9ad7ZqI0JW+a0d0z29ZE8gLVc6qUfEiBBEvkrZOGYaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WKsXdXHZNuKyEpxSVQzo3/Umrub+iAsx8m5gsCW73wekgMA/tRcOk3/F8x35qgO73
	 mmVLyeaUSK4ryQLnqimnSSx5UW6T24VUSJT6m/uF1/fI5yaumvpQcUnh+WrdCVGCe0
	 mIvczFXb/OMzYc4u0nry+lpr1VGqEGXwcWtCHuNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Packham <chris.packham@alliedtelesis.co.nz>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/159] mtd: rawnand: marvell: dont set the NAND frequency select
Date: Wed,  7 Jun 2023 22:15:41 +0200
Message-ID: <20230607200904.915907775@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
References: <20230607200903.652580797@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

[ Upstream commit c4d28e30a8d0b979e4029465ab8f312ab6ce2644 ]

marvell_nfc_setup_interface() uses the frequency retrieved from the
clock associated with the nand interface to determine the timings that
will be used. By changing the NAND frequency select without reflecting
this in the clock configuration this means that the timings calculated
don't correctly meet the requirements of the NAND chip. This hasn't been
an issue up to now because of a different bug that was stopping the
timings being updated after they were initially set.

Fixes: b25251414f6e ("mtd: rawnand: marvell: Stop implementing ->select_chip()")
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20230525003154.2303012-2-chris.packham@alliedtelesis.co.nz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/marvell_nand.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/mtd/nand/raw/marvell_nand.c b/drivers/mtd/nand/raw/marvell_nand.c
index 95dee54fe079c..9f662d5cf7fac 100644
--- a/drivers/mtd/nand/raw/marvell_nand.c
+++ b/drivers/mtd/nand/raw/marvell_nand.c
@@ -2885,10 +2885,6 @@ static int marvell_nfc_init(struct marvell_nfc *nfc)
 		regmap_update_bits(sysctrl_base, GENCONF_CLK_GATING_CTRL,
 				   GENCONF_CLK_GATING_CTRL_ND_GATE,
 				   GENCONF_CLK_GATING_CTRL_ND_GATE);
-
-		regmap_update_bits(sysctrl_base, GENCONF_ND_CLK_CTRL,
-				   GENCONF_ND_CLK_CTRL_EN,
-				   GENCONF_ND_CLK_CTRL_EN);
 	}
 
 	/* Configure the DMA if appropriate */
-- 
2.39.2



