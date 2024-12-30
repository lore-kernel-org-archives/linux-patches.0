Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8445715E8B;
	Mon, 30 Dec 2024 15:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573528; cv=none; b=eWAV5pSq13tpp32TCXO4fzPZCOv6XDMZulq33VsqBlCyoiJ9qbd4Lc57Y/ldWA9N0mmtqomslovS3kUHYCRdS1dp9r8PD6Vanyw0c5mYYE/GgvUmfKkzyWSWoeCO4PJ7ROW/VtxTTXDlmyNXCPps5E5DRD3cb07ZG6ptFIoI5vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573528; c=relaxed/simple;
	bh=I8LTZlqmD7Op6Itfvgi05/2RU6PN9qjRNK+zn7pmsUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YWqxpUT8XjQXiNFVPxEfA8AzPrntgYqkrK+nSVQNoefUqEuaUlGJ2SnP0lH94TUUqheevaXV/V9KpTOx0aiLbxzWyQgeGcbCv2hJkYEDgXE/1RLzJukxf8T2LHRNlB5F+zGzjfeh/UAYOAO2Ms3G73wIOCyALR45wegyZFgunfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hbwb/cYP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hbwb/cYP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E275C4CED0;
	Mon, 30 Dec 2024 15:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573528;
	bh=I8LTZlqmD7Op6Itfvgi05/2RU6PN9qjRNK+zn7pmsUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hbwb/cYPjmZI0y/gRBO1XUPD5oCL+reItIX7uDbf18vj6QEcGtlhFXVNBgsibUDu7
	 jhI55B21gpY0USzWPmCi9TP2wGpq/fzLI+/49rMwItbBBqwBsoroqSRCm6QFxzWk1k
	 B5ceM9ZzZwsJjyBsx08CztBfe4WfpW3eX6no4tbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zichen Xie <zichenxie0106@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.1 07/60] mtd: diskonchip: Cast an operand to prevent potential overflow
Date: Mon, 30 Dec 2024 16:42:17 +0100
Message-ID: <20241230154207.562916979@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


