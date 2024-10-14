Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450C91AB521;
	Mon, 14 Oct 2024 14:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917675; cv=none; b=p3PSRGst37dCh0fQw1IInElTa/7hf6nepJyVcNZKuXrhDdoYClW7ts71Gi4tDTwg9Wyz9d3FoJ2J/5Wy7aGYy854qYX8POB9QByUQCMxzd1aipJK1WR7I/7cLZ9tWhaPOHEJ6U6uCFKsQClZwAtrctjclNeOW6EysVqNI471kLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917675; c=relaxed/simple;
	bh=nQ3klMLfqva7vOqjm0bkLvU9Blf8eXJ5YQsswAsoC5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SpmGqUjqRHbZy6zdkSX2Afw+NJKKl7m5EqgKDfON3+sfODauC+l3QBdkA87IUpju3PgS8Xzt5XH2WB3oA7v+7Ij6QQZLgSVVpJNKX78x/ScpcTQEuiXeCMYnldVEwkOCxjGWIX2eI8yUitQeyDAdnfF4Hl3W16StfQrCpRXwhEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O26zLfFH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O26zLfFH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701FFC4CEC3;
	Mon, 14 Oct 2024 14:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917674;
	bh=nQ3klMLfqva7vOqjm0bkLvU9Blf8eXJ5YQsswAsoC5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O26zLfFHL7p9IbcPyhPp+LbWl+RvAJSl3Olbkr2TDOI16YO9NM0T0An63qJVMOnMv
	 gj7/Mo0Avt9b70SOnl5gm9HMLai6kk3xmSChLFqvrfdhsFFtiXOzKdx6Dq1yzlRxMa
	 KGrcZ+s54E8fK/ffviOvZ7W7JpUV2Jow9euqe+oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Matthias Brugger <matthias.bgg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 101/798] mtd: rawnand: mtk: Fix init error path
Date: Mon, 14 Oct 2024 16:10:55 +0200
Message-ID: <20241014141221.899120640@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 2073ae37d550ea32e8545edaa94ef10b4fef7235 ]

Reviewing a series converting the for_each_chil_of_node() loops into
their _scoped variants made me realize there was no cleanup of the
already registered NAND devices upon error which may leak memory on
systems with more than a chip when this error occurs. We should call the
_nand_chips_cleanup() function when this happens.

Fixes: 1d6b1e464950 ("mtd: mediatek: driver for MTK Smart Device")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Matthias Brugger <matthias.bgg@kernel.org>
Link: https://lore.kernel.org/linux-mtd/20240826153019.67106-2-miquel.raynal@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/mtk_nand.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/mtk_nand.c b/drivers/mtd/nand/raw/mtk_nand.c
index 3a2b801937398..53fc19e1dc5b6 100644
--- a/drivers/mtd/nand/raw/mtk_nand.c
+++ b/drivers/mtd/nand/raw/mtk_nand.c
@@ -1480,8 +1480,10 @@ static int mtk_nfc_nand_chips_init(struct device *dev, struct mtk_nfc *nfc)
 
 	for_each_child_of_node_scoped(np, nand_np) {
 		ret = mtk_nfc_nand_chip_init(dev, nfc, nand_np);
-		if (ret)
+		if (ret) {
+			mtk_nfc_nand_chips_cleanup(nfc);
 			return ret;
+		}
 	}
 
 	return 0;
-- 
2.43.0



