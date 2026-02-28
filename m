Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43884371449
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301482; cv=none; b=AIl6r5hMm6OltgKUyrBBKK5Z06o+gnPFe7IfLeJRuEunLDSZQAVDK4eV7Pig2624XiZqdUo8OLuEl7Mz/dbvTZNzYKZqqecx+tPPurdsY7J9kCYbJ59HdM5odxpfVR0omRb4tY/yXAdNaPatqRF/48eOzGlO+2yz4q4P8QjaUQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301482; c=relaxed/simple;
	bh=Y8XpSHB5fFtmQz5KqQGt2nNLe7eX8r+4h6XtvAwSy/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQf7+XxFnK27Zu5xEbku0PTXfv5FFF7eaXIFvESh768wh+K0Adg5iPcuFPc0MR/nS/lkEVgD+oqc6M8rHfwEgRqiRR6/l4y+03aLjDiTS5Ut+zwrCS70yIC7dDt78996LZ33n1prP+MBEkrI7tPJX8ThuhaNz8gSsQxUGsVS57o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oxHi0+X3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oxHi0+X3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D5EC116D0;
	Sat, 28 Feb 2026 17:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301482;
	bh=Y8XpSHB5fFtmQz5KqQGt2nNLe7eX8r+4h6XtvAwSy/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oxHi0+X3CSka64Y1CJ7Iatx1ZMTDEINTc60AxkMkCUXNtSm7jiz2ePCohaf3NJWdT
	 V95xu076g+pa7axVOLTZW7X67sxjjdDJkCe7/2cN/lotmCjDsXV96NK4aQpc9MDynI
	 hlNjeHqKPohgISvZR/4eNkFp6pvKJ1dt/gim5V3dc+oIvpmW4rJNixitZMdNnz86gk
	 h453EZrBhUETJMxjN07hwSgMoh5BJUxIZ+JTX0kVGw2+n5umnamztCBogbgfZWyxYe
	 Xk0Sbj3q38xSffc4WWa+69UJEaezSbLAYb2z/G47KGnrlhuI4BaLa40vov2d63VAAk
	 86SuSwT/L2fgQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Andrea Scian <andrea.scian@dave.eu>,
	stable@kernel.org,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 667/752] mtd: rawnand: pl353: Fix software ECC support
Date: Sat, 28 Feb 2026 12:46:18 -0500
Message-ID: <20260228174750.1542406-667-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Andrea Scian <andrea.scian@dave.eu>

[ Upstream commit 89b831ebdaca0df4ca3b226f7e7a1d1db1629060 ]

We need to set also write_page_raw in ecc structure to allow
choosing SW ECC instead of HW one, otherwise write operation fail.

Fixes: 08d8c62164a322 ("mtd: rawnand: pl353: Add support for the ARM PL353 SMC NAND controller")
Signed-off-by: Andrea Scian <andrea.scian@dave.eu>
Cc: stable@kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/pl35x-nand-controller.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/nand/raw/pl35x-nand-controller.c b/drivers/mtd/nand/raw/pl35x-nand-controller.c
index 11bd90e3f18cb..7f012b7c3eaec 100644
--- a/drivers/mtd/nand/raw/pl35x-nand-controller.c
+++ b/drivers/mtd/nand/raw/pl35x-nand-controller.c
@@ -976,6 +976,7 @@ static int pl35x_nand_attach_chip(struct nand_chip *chip)
 		fallthrough;
 	case NAND_ECC_ENGINE_TYPE_NONE:
 	case NAND_ECC_ENGINE_TYPE_SOFT:
+		chip->ecc.write_page_raw = nand_monolithic_write_page_raw;
 		break;
 	case NAND_ECC_ENGINE_TYPE_ON_HOST:
 		ret = pl35x_nand_init_hw_ecc_controller(nfc, chip);
-- 
2.51.0

