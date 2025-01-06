Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D7786333;
	Mon,  6 Jan 2025 15:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178707; cv=none; b=QzZsvmfhX2xsBw5Xlac/MWtFQxKHPrrjEalpjcs5BKs5RKOjo+YOkNum4/KrYWu91UNMv7QSMzYMV8PLbB8XWZL4qcnBbVRFo72V6cEo4o72LI9zhvSZgT3b79KGg+AxUfLiOfKnKkSm4fWkfDNmLXDNPjJ7tZH8lx6Xdrx3eUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178707; c=relaxed/simple;
	bh=m2PZ4CqHIHTiFENN3syguppk0JZgd7bX53vq0nL/vUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AxaCppTGTlp21Q/zE+LVBVAAu70GsXkIAASQubPulp9EOf8dLD1h3mBJsCQxxcqm5E+XOxs5UekOrBpA4eg2vgWgu30mHnZb+1cX0m9pGL8eHgoy+dZx42YN7LWYA2P1IzDv/h9ztNQ0zxLDKPQV2SyKwXRcVIt8llfv9cp2Fd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FeBP+aTN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FeBP+aTN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3245C4CED2;
	Mon,  6 Jan 2025 15:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178705;
	bh=m2PZ4CqHIHTiFENN3syguppk0JZgd7bX53vq0nL/vUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FeBP+aTNZGFunouZVL4IQk1dv4oW6dW6psOdhZhUmxEtpS48i99b0lrBPxFkw7CDJ
	 jPRHZsOk8vHYRrdzsOOh2MTNnEySFMnAhve0kK5+wMlXucfCY3e+EmO3Jp45ZwnOZe
	 yXVBSJA1OZ4fI4cConD/jD/FPoYmTH8zgT1PpvmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zichen Xie <zichenxie0106@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 063/168] mtd: diskonchip: Cast an operand to prevent potential overflow
Date: Mon,  6 Jan 2025 16:16:11 +0100
Message-ID: <20250106151140.841371787@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zichen Xie <zichenxie0106@gmail.com>

commit 9b458e8be0d13e81ed03fffa23f8f9b528bbd786 upstream.

There may be a potential integer overflow issue in inftl_partscan().
parts[0].size is defined as "uint64_t"  while mtd->erasesize and
ip->firstUnit are defined as 32-bit unsigned integer. The result of
the calculation will be limited to 32 bits without correct casting.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Zichen Xie <zichenxie0106@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/diskonchip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/diskonchip.c
+++ b/drivers/mtd/nand/raw/diskonchip.c
@@ -1098,7 +1098,7 @@ static inline int __init inftl_partscan(
 		    (i == 0) && (ip->firstUnit > 0)) {
 			parts[0].name = " DiskOnChip IPL / Media Header partition";
 			parts[0].offset = 0;
-			parts[0].size = mtd->erasesize * ip->firstUnit;
+			parts[0].size = (uint64_t)mtd->erasesize * ip->firstUnit;
 			numparts = 1;
 		}
 


