Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B24DF59;
	Wed,  5 Feb 2025 14:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767202; cv=none; b=GpoVeBMZdVyX3UzoMKeWLfJqrZuvFyCzxmcyf3oxo0ziAmdLgRoCiScTzyUqmdCsSuS+/aLOZEcHZ7TOEv6qTWWqaU2fBsZjhAsAkjf0z8pmrt/2j5gUb/eWE/tXdEEBZPmd6s11sjYpw4suuaGsG3hVOMr8ffzQkcNHUBBKZo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767202; c=relaxed/simple;
	bh=nDqsEHn+50BA2cB2H7eniHdlbXO8Q/vTn4UKESXNap0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AMpJzlgsDpSXi/eJ181wYUlntm177xN+mmlNnHJ//IOisM2NUNcjQvSsPMXMhk3mJBFelemDmN0bNuaECEmrp+a1HW4BM1Luk+onTgTo3RlBhtOBFZVGvb6Z3QQn37ZGa9KEboyanNilbbOcNAJyzrkyfRXZehSQVLUiKkIjeeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vY0XAAuv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vY0XAAuv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C31FC4CED1;
	Wed,  5 Feb 2025 14:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767201;
	bh=nDqsEHn+50BA2cB2H7eniHdlbXO8Q/vTn4UKESXNap0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vY0XAAuvGllGCIgI8HunPfOb+V85C3FOTO7ErV1J7iBYI73eHpgf+HNeUwbE7M8a9
	 KEmzSY/ALfMid8Lj84UeEPX03GMOtGjpZGKLu4sVBNOIoexIub6IL0cd9gPcOLm43O
	 R+6LPvMClhl5axNe8z2D1rGJe6XmtGXYl2ihwCjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	david regan <dregan@broadcom.com>,
	William Zhang <william.zhang@broadcom.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 418/590] mtd: rawnand: brcmnand: fix status read of brcmnand_waitfunc
Date: Wed,  5 Feb 2025 14:42:53 +0100
Message-ID: <20250205134511.257526300@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: david regan <dregan@broadcom.com>

[ Upstream commit 03271ea36ea7a58d30a4bde182eb2a0d46220467 ]

This change fixes an issue where an error return value may be mistakenly
used as NAND status.

Fixes: f504551b7f15 ("mtd: rawnand: Propagate error and simplify ternary operators for brcmstb_nand_wait_for_completion()")
Signed-off-by: david regan <dregan@broadcom.com>
Reviewed-by: William Zhang <william.zhang@broadcom.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/brcmnand/brcmnand.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/mtd/nand/raw/brcmnand/brcmnand.c b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
index 1b2ec0fec60c7..e76df6a00ed4f 100644
--- a/drivers/mtd/nand/raw/brcmnand/brcmnand.c
+++ b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
@@ -2342,6 +2342,11 @@ static int brcmnand_write(struct mtd_info *mtd, struct nand_chip *chip,
 		brcmnand_send_cmd(host, CMD_PROGRAM_PAGE);
 		status = brcmnand_waitfunc(chip);
 
+		if (status < 0) {
+			ret = status;
+			goto out;
+		}
+
 		if (status & NAND_STATUS_FAIL) {
 			dev_info(ctrl->dev, "program failed at %llx\n",
 				(unsigned long long)addr);
-- 
2.39.5



