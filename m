Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD8B7082A;
	Mon,  6 Jan 2025 15:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178235; cv=none; b=tsLjcW8ZCx9W+Uf9mSGHZfyzqubZhk59EmlFttUR/Cp6kdfNhWZoRDeDaZRdUhllUe5aKtnZ/o3puqO43EdeuPG/Ur7pYlHid0T7Gp3z6eXUTWRMgkUclUWE41bn940sgXnfXP/bLEGuYXKzdDEjUUUSbu+WEqYv4vwsBwrRRe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178235; c=relaxed/simple;
	bh=gyAGZq/6yV7/2P+aa/d6NEgpvFxN80M+plXJf3O2wq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fdVPy5FV6E6+c+FXONUStKX+fxHZygh/Jby8jkCU2EdNVmBnXye27WOasTBT2jbiRszcOAueujB8LC7KMXtFRMlQbxVX+EJmFqvpA0pYi8cjjYVWR//19qpOtokyMZ/dNEfSTxFLH6+IWtN3n8QqLG0tM9QwFilbkcgKaWwb3ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uFTqSB52; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uFTqSB52"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B23C4CED2;
	Mon,  6 Jan 2025 15:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178234;
	bh=gyAGZq/6yV7/2P+aa/d6NEgpvFxN80M+plXJf3O2wq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uFTqSB52xvPfttfY3LSzOIdjTvKNadQQ0oHXoOhLMKtUCOl36li2jAf0ePawlRPTn
	 vUSA8AiXrFEkHdIAzqxtYxYuhvdSHi0MfLz6KX7lnResC38IxVGKtr6S2ZROb99CnX
	 ATRTjAfP9CAYG/7xRCNicXxVy0UCMzWHDFBx0tFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zichen Xie <zichenxie0106@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 049/138] mtd: diskonchip: Cast an operand to prevent potential overflow
Date: Mon,  6 Jan 2025 16:16:13 +0100
Message-ID: <20250106151135.092589760@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


