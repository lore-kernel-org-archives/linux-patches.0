Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678251D0487;
	Wed,  2 Oct 2024 14:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879570; cv=none; b=BDsFZneCS3i0PQYn4kmBCo6wW5R/u9lxHLIctIhox4bng0qCaFCHfOZXRJ0CAwCb9q/xxqWNAbpRoYFcpvdLVDN895JmUSt9Sk6+G3JVT9V7GRSE5PH+rrofcOGBu5SZovNbp+IWWOjzO3PqqEmlYK8K7qSWqf5snN8Vfi5E9DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879570; c=relaxed/simple;
	bh=u9DuwXbHdMMRnmlyfJtZwZBoHqz2nhZVggufw8VYqUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q//7RNuj2xacCv8+gWfm5OrZjIzoOyigWUwdutKeydxIH4tfPh1S7eivGXtmfi+fL6lTFerYvj7f0AsZkpcZMGaFJgNT4k3ZYKtFc4/er2p1oKAwNe5GIcoAYPTZfIeJHXMcgVUe0freBxNyIgx8YtGeoXtA07BdVbRZExudgSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJhX6JNM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJhX6JNM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0EA3C4CEC2;
	Wed,  2 Oct 2024 14:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879570;
	bh=u9DuwXbHdMMRnmlyfJtZwZBoHqz2nhZVggufw8VYqUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJhX6JNMdhb3JaDi2is/MGMEagCu7DV74pQ1Qlzo3M8WRQQyTEDOM311CHsUORghE
	 NQYqVB+mCdfZOjtUBoHSQh9VUObIM7gF4U1bARTzvkDQ57iuU2RowYuGGgTpC7ZTY0
	 KgZpPHnUCmhtjxNiZRz4808omBiLfEEFrDNUgAMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Matthias Brugger <matthias.bgg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 133/538] mtd: rawnand: mtk: Fix init error path
Date: Wed,  2 Oct 2024 14:56:12 +0200
Message-ID: <20241002125757.489488142@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
index 3fb32a59fdf61..161a409ca4ed2 100644
--- a/drivers/mtd/nand/raw/mtk_nand.c
+++ b/drivers/mtd/nand/raw/mtk_nand.c
@@ -1453,8 +1453,10 @@ static int mtk_nfc_nand_chips_init(struct device *dev, struct mtk_nfc *nfc)
 
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



