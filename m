Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0F5DF59;
	Wed,  5 Feb 2025 15:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767799; cv=none; b=Wm36OSIBJMq0OwHY16CSiuMWcldEl0bxn2t3G/ZV1B637T3q35KbY6btnQ8IXdM5tBzj4hPSROozSp5mx13suJUV3eYc2LBNiM6jE3Ng+YLEwxkweVMdsSlgp0oR69zMA/0JxfsfduG428imxtXBs0HzxXyeENIwA2gVBYlGbLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767799; c=relaxed/simple;
	bh=vZF0gbK35GVxrkkQ9u2B7gU0Yp4JVcxTWp7NKdHsTw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfM7pQdmANnD+B+sn0kdPcrsNNXxoR6czSisscQnYPc0dbqkndu3V7ZZyWmIA4xPBPeJHSyN0IimLtu19hzmsn+7wm7Mq5aaJJRDlZvK8BORwGiPkN1ax1B1iKqupfc7HGZBbv1rC2zSv1t8Xv4cZzltG+138wCUzKG8UneE5Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0idiXOYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0idiXOYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AADAC4CED1;
	Wed,  5 Feb 2025 15:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767798;
	bh=vZF0gbK35GVxrkkQ9u2B7gU0Yp4JVcxTWp7NKdHsTw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0idiXOYka2/bsqcWgDklzxq7Fu7sFCxFmLCCcgmLUlI37iTTfHdZjIYvuB9W/xkZO
	 lPzbVoKHFYgwNx2gxdkpAydP4tSnBuTRP8/2QRngOIm20ragPZMJfEwYndFm6HBAet
	 EeIADodfbg964f9xAtr00dK+h8CKmos5heiuyv/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	david regan <dregan@broadcom.com>,
	William Zhang <william.zhang@broadcom.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 455/623] mtd: rawnand: brcmnand: fix status read of brcmnand_waitfunc
Date: Wed,  5 Feb 2025 14:43:17 +0100
Message-ID: <20250205134513.623369563@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 9c253a511e45a..fea5b61199563 100644
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



