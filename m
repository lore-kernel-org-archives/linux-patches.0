Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D210755E4C;
	Tue,  9 Jul 2024 11:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524726; cv=none; b=WV58KdESCjdph4QS2QBBkdILhpfpEsL1VWptsXH5+wwsjOXItjMY2cR9a1mrQD8C7CFqQpilu1qIeV8WIUoRiYNvo3ZLOLwaeGsZxFldBFO4AyY6o9cbrq5qsXXBs2XfBaG7Hd+hAiFiO7aQ3p4n0RgFcJ0WsTA6tYuk03+7WgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524726; c=relaxed/simple;
	bh=z1K0snIm+ziAbvWd1mV6gJJDEPx0FDrBKeDrY+Q/lJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IjG2Z/pttIRRjC7ljBWcXYV+3izLF9473++vJt1Xp27AZEWxJQiqDuiLNJKLQWyYAvxvHSlgSEoMe2DJIFo6ibbd8dcxTE4W6qmcrCQaNukEAs1Y+txcsHXqn4tR/sTi4KCcXJQ1ysF2/YcW/WzQPC/R/2wawxBbiV3DNxFrKMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GNkCel3R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GNkCel3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B06C3277B;
	Tue,  9 Jul 2024 11:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524726;
	bh=z1K0snIm+ziAbvWd1mV6gJJDEPx0FDrBKeDrY+Q/lJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GNkCel3RzdedsNTfn0thCP9rcJixAOBz0Vm3kbWh0gYaof439vaiDfbC2PlP+4y9P
	 MUMDgBuTBmcqKXHMqgtwIXg663JGKhU5g3IK1AxwhWTK2zmmcZSDTyKENPv3imgVTZ
	 jLM2s8Hce6K2o57njL7UvCwk2OwAc3P6cpJD1QA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.1 080/102] mtd: rawnand: rockchip: ensure NVDDR timings are rejected
Date: Tue,  9 Jul 2024 13:10:43 +0200
Message-ID: <20240709110654.489623850@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

From: Val Packett <val@packett.cool>

commit b27d8946b5edd9827ee3c2f9ea1dd30022fb1ebe upstream.

.setup_interface first gets called with a "target" value of
NAND_DATA_IFACE_CHECK_ONLY, in which case an error is expected
if the controller driver does not support the timing mode (NVDDR).

Fixes: a9ecc8c814e9 ("mtd: rawnand: Choose the best timings, NV-DDR included")
Signed-off-by: Val Packett <val@packett.cool>
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20240519031409.26464-1-val@packett.cool
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/rockchip-nand-controller.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/mtd/nand/raw/rockchip-nand-controller.c
+++ b/drivers/mtd/nand/raw/rockchip-nand-controller.c
@@ -421,13 +421,13 @@ static int rk_nfc_setup_interface(struct
 	u32 rate, tc2rw, trwpw, trw2c;
 	u32 temp;
 
-	if (target < 0)
-		return 0;
-
 	timings = nand_get_sdr_timings(conf);
 	if (IS_ERR(timings))
 		return -EOPNOTSUPP;
 
+	if (target < 0)
+		return 0;
+
 	if (IS_ERR(nfc->nfc_clk))
 		rate = clk_get_rate(nfc->ahb_clk);
 	else


