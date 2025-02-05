Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720FC14A088;
	Wed,  5 Feb 2025 14:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765703; cv=none; b=jxd37/F++UyIVEshRpkdWHjQ5EmwF2bk0KlXw3eVDROHIxUgfEbgp3jykBYnmZRvNYovf4no2Z/drHHv8KQ5vxB99GAo7P18iyfBL3aTDx8tSVBP0Vq0ZjwtJayyZkcMbTDRelIUviGYBK5gwgLrWyWkmHn4sK8wlsa8/yrGw3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765703; c=relaxed/simple;
	bh=sAeRCAPQ93Xq+gCLekQXp09BN6s74nrvsaGDp/YBpmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AlCfaDpe9qNwITq56WTjdFWOibQYn7r5asR/byrC+TO5d1rw1enMq47eFB4VkiLhhtxdCpED0vvaL3EBzKcN4WSrQBX0LTd4U4pUTqNRyhiWJ9559Gq2+qrYHiPNqtIvEmMh21e4Qvmon3tjhRKLa2uIc6QYftmjTnxv1LFXzP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFUF/Jl6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFUF/Jl6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC11C4CED1;
	Wed,  5 Feb 2025 14:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765703;
	bh=sAeRCAPQ93Xq+gCLekQXp09BN6s74nrvsaGDp/YBpmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFUF/Jl6rvhHqKvWK01Wz4ZLgrcmnqT0mQqXN0wlksExxc7kfbCbU943ZxXFv1tSs
	 WGfXhevqple10/BENpcu+T34uLCPiZKHuB66GdVdqVPSHX9C7rhzw4iZNzaPZhZEmx
	 liOU6Iieol7wuUUxvchklO6Hn3HXMKxLQ7qCc/h8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	david regan <dregan@broadcom.com>,
	William Zhang <william.zhang@broadcom.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 291/393] mtd: rawnand: brcmnand: fix status read of brcmnand_waitfunc
Date: Wed,  5 Feb 2025 14:43:30 +0100
Message-ID: <20250205134431.446338199@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 440bef477930c..085a16148a68d 100644
--- a/drivers/mtd/nand/raw/brcmnand/brcmnand.c
+++ b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
@@ -2450,6 +2450,11 @@ static int brcmnand_write(struct mtd_info *mtd, struct nand_chip *chip,
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



