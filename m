Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0517142E77;
	Tue, 17 Dec 2024 17:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456203; cv=none; b=uJthfy5z1pw7sIYUz/Va8wq/tn2YBCGiZtkPUl2LgFPoz67RSnqK+wihUwdzao3x0NrJ14QodnWsvLKnAVLh+tz0y4JAIh9HuY9E/IsjYW5IYzb0b52RGvAjxNSOc/QVt2mWnMcoToDI+t2WBffLgQXnDZdUnwsoqoCI4hfGB3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456203; c=relaxed/simple;
	bh=0jJT6W6W8/rGR6bKL9khl757ZymMslBTunHJDh/aVH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=us9vdFPbLO0OydMmVnxkddoN/zYorpG+5o6Ks0S3oRI+vgIU3GkHUKz1cvExNzc1iGHHsk4949kyhvHoDe8xDpBtKqYnlwBTYl8C3h/7dT3FGEHK1ccy3wxGvU+H5tV9QoVmYDOLW7PUfE2Zz5voQa8k0jX65J4Fdyy1jpwqkGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t6x8pRwW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t6x8pRwW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A51C4CED3;
	Tue, 17 Dec 2024 17:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456202;
	bh=0jJT6W6W8/rGR6bKL9khl757ZymMslBTunHJDh/aVH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t6x8pRwWJDkx+kIZ77V2pAdpfhIryYaVtDrmJjBLyZBUKapruwJA5glv5rkuML+B5
	 QrVxy5w7rbF0uMkHK/mF4e1Ek9Bv/NI1dkL5ggF5jWTZHd4HcPMMaiemqcXvnpXb0w
	 1ZmTrtUNXad107opYH60j2Ew6son1C2Q8aSNY4L8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Van Gavere <jesse.vangavere@scioteq.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/109] net: dsa: microchip: KSZ9896 register regmap alignment to 32 bit boundaries
Date: Tue, 17 Dec 2024 18:08:16 +0100
Message-ID: <20241217170537.235524249@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

From: Jesse Van Gavere <jesseevg@gmail.com>

[ Upstream commit 5af53577c64fa84da032d490b701127fe8d1a6aa ]

Commit 8d7ae22ae9f8 ("net: dsa: microchip: KSZ9477 register regmap
alignment to 32 bit boundaries") fixed an issue whereby regmap_reg_range
did not allow writes as 32 bit words to KSZ9477 PHY registers, this fix
for KSZ9896 is adapted from there as the same errata is present in
KSZ9896C as "Module 5: Certain PHY registers must be written as pairs
instead of singly" the explanation below is likewise taken from this
commit.

The commit provided code
to apply "Module 6: Certain PHY registers must be written as pairs instead
of singly" errata for KSZ9477 as this chip for certain PHY registers
(0xN120 to 0xN13F, N=1,2,3,4,5) must be accessed as 32 bit words instead
of 16 or 8 bit access.
Otherwise, adjacent registers (no matter if reserved or not) are
overwritten with 0x0.

Without this patch some registers (e.g. 0x113c or 0x1134) required for 32
bit access are out of valid regmap ranges.

As a result, following error is observed and KSZ9896 is not properly
configured:

ksz-switch spi1.0: can't rmw 32bit reg 0x113c: -EIO
ksz-switch spi1.0: can't rmw 32bit reg 0x1134: -EIO
ksz-switch spi1.0 lan1 (uninitialized): failed to connect to PHY: -EIO
ksz-switch spi1.0 lan1 (uninitialized): error -5 setting up PHY for tree 0, switch 0, port 0

The solution is to modify regmap_reg_range to allow accesses with 4 bytes
boundaries.

Fixes: 5c844d57aa78 ("net: dsa: microchip: fix writes to phy registers >= 0x10")
Signed-off-by: Jesse Van Gavere <jesse.vangavere@scioteq.com>
Link: https://patch.msgid.link/20241211092932.26881-1-jesse.vangavere@scioteq.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz_common.c | 42 +++++++++++---------------
 1 file changed, 18 insertions(+), 24 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 1c3f18649998..997c225dfba4 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -892,10 +892,9 @@ static const struct regmap_range ksz9896_valid_regs[] = {
 	regmap_reg_range(0x1030, 0x1030),
 	regmap_reg_range(0x1100, 0x1115),
 	regmap_reg_range(0x111a, 0x111f),
-	regmap_reg_range(0x1122, 0x1127),
-	regmap_reg_range(0x112a, 0x112b),
-	regmap_reg_range(0x1136, 0x1139),
-	regmap_reg_range(0x113e, 0x113f),
+	regmap_reg_range(0x1120, 0x112b),
+	regmap_reg_range(0x1134, 0x113b),
+	regmap_reg_range(0x113c, 0x113f),
 	regmap_reg_range(0x1400, 0x1401),
 	regmap_reg_range(0x1403, 0x1403),
 	regmap_reg_range(0x1410, 0x1417),
@@ -922,10 +921,9 @@ static const struct regmap_range ksz9896_valid_regs[] = {
 	regmap_reg_range(0x2030, 0x2030),
 	regmap_reg_range(0x2100, 0x2115),
 	regmap_reg_range(0x211a, 0x211f),
-	regmap_reg_range(0x2122, 0x2127),
-	regmap_reg_range(0x212a, 0x212b),
-	regmap_reg_range(0x2136, 0x2139),
-	regmap_reg_range(0x213e, 0x213f),
+	regmap_reg_range(0x2120, 0x212b),
+	regmap_reg_range(0x2134, 0x213b),
+	regmap_reg_range(0x213c, 0x213f),
 	regmap_reg_range(0x2400, 0x2401),
 	regmap_reg_range(0x2403, 0x2403),
 	regmap_reg_range(0x2410, 0x2417),
@@ -952,10 +950,9 @@ static const struct regmap_range ksz9896_valid_regs[] = {
 	regmap_reg_range(0x3030, 0x3030),
 	regmap_reg_range(0x3100, 0x3115),
 	regmap_reg_range(0x311a, 0x311f),
-	regmap_reg_range(0x3122, 0x3127),
-	regmap_reg_range(0x312a, 0x312b),
-	regmap_reg_range(0x3136, 0x3139),
-	regmap_reg_range(0x313e, 0x313f),
+	regmap_reg_range(0x3120, 0x312b),
+	regmap_reg_range(0x3134, 0x313b),
+	regmap_reg_range(0x313c, 0x313f),
 	regmap_reg_range(0x3400, 0x3401),
 	regmap_reg_range(0x3403, 0x3403),
 	regmap_reg_range(0x3410, 0x3417),
@@ -982,10 +979,9 @@ static const struct regmap_range ksz9896_valid_regs[] = {
 	regmap_reg_range(0x4030, 0x4030),
 	regmap_reg_range(0x4100, 0x4115),
 	regmap_reg_range(0x411a, 0x411f),
-	regmap_reg_range(0x4122, 0x4127),
-	regmap_reg_range(0x412a, 0x412b),
-	regmap_reg_range(0x4136, 0x4139),
-	regmap_reg_range(0x413e, 0x413f),
+	regmap_reg_range(0x4120, 0x412b),
+	regmap_reg_range(0x4134, 0x413b),
+	regmap_reg_range(0x413c, 0x413f),
 	regmap_reg_range(0x4400, 0x4401),
 	regmap_reg_range(0x4403, 0x4403),
 	regmap_reg_range(0x4410, 0x4417),
@@ -1012,10 +1008,9 @@ static const struct regmap_range ksz9896_valid_regs[] = {
 	regmap_reg_range(0x5030, 0x5030),
 	regmap_reg_range(0x5100, 0x5115),
 	regmap_reg_range(0x511a, 0x511f),
-	regmap_reg_range(0x5122, 0x5127),
-	regmap_reg_range(0x512a, 0x512b),
-	regmap_reg_range(0x5136, 0x5139),
-	regmap_reg_range(0x513e, 0x513f),
+	regmap_reg_range(0x5120, 0x512b),
+	regmap_reg_range(0x5134, 0x513b),
+	regmap_reg_range(0x513c, 0x513f),
 	regmap_reg_range(0x5400, 0x5401),
 	regmap_reg_range(0x5403, 0x5403),
 	regmap_reg_range(0x5410, 0x5417),
@@ -1042,10 +1037,9 @@ static const struct regmap_range ksz9896_valid_regs[] = {
 	regmap_reg_range(0x6030, 0x6030),
 	regmap_reg_range(0x6100, 0x6115),
 	regmap_reg_range(0x611a, 0x611f),
-	regmap_reg_range(0x6122, 0x6127),
-	regmap_reg_range(0x612a, 0x612b),
-	regmap_reg_range(0x6136, 0x6139),
-	regmap_reg_range(0x613e, 0x613f),
+	regmap_reg_range(0x6120, 0x612b),
+	regmap_reg_range(0x6134, 0x613b),
+	regmap_reg_range(0x613c, 0x613f),
 	regmap_reg_range(0x6300, 0x6301),
 	regmap_reg_range(0x6400, 0x6401),
 	regmap_reg_range(0x6403, 0x6403),
-- 
2.39.5



