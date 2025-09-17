Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F011EF36C;
	Wed, 17 Sep 2025 12:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112950; cv=none; b=XmpwccHLf1rn8aEvA2AVT39UwzOqJD5kGpIaUkADwy7JRz/dGD1g9mzeJYCQmP6hepys1nnqdnNv76yJZumvFB7pRbaP9PDeap6dkYZXgCbmfTRmp8PlvGz6xhiEkbCFF7Pdl43Gcg70nWh2eApuAYqMfG+jWLu2ENuzlfbmAbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112950; c=relaxed/simple;
	bh=S6SGoRYIr6P3erehYfgo6QFkorGHMydX1/zQwUkAcVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJ2cH7/6YtNx7oGr3nwjlJ0hHSGKVu31nV0wVwIRhak7X7u1P+CcfLi1LzMcVLGAd7ZhmvFQ5QYSn+5K5KFhgr4VgrAndpH8wBs1ULTE6DRhElw+g/RiH65+tnukSIUPz01LPWJcOCIB1YFJgmKw9qStc6Tj9pZCbeA8PEgg9y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RyqfSV/i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RyqfSV/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11712C4CEF0;
	Wed, 17 Sep 2025 12:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112950;
	bh=S6SGoRYIr6P3erehYfgo6QFkorGHMydX1/zQwUkAcVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RyqfSV/iUQxHdnBxfEu8OeM7v0VGegzwBCYTugkKGCLJGQ1K49mUgpF5cy5YAmwcE
	 ZJGY1BGlxwTmwuRKkRzA6GLb9jYZ4M+VN7+0DxLbaveZDL4iTLIbiF10u2JfMhKLRW
	 q1qkmCPcaNhA22j9E7iUaleOWnkjIn/wrNjneg/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 125/189] mtd: rawnand: nuvoton: Fix an error handling path in ma35_nand_chips_init()
Date: Wed, 17 Sep 2025 14:33:55 +0200
Message-ID: <20250917123354.912614296@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 1eae113dd5ff5192cfd3e11b6ab7b96193b42c01 ]

If a ma35_nand_chip_init() call fails, then a reference to 'nand_np' still
needs to be released.

Use for_each_child_of_node_scoped() to fix the issue.

Fixes: 5abb5d414d55 ("mtd: rawnand: nuvoton: add new driver for the Nuvoton MA35 SoC")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/nuvoton-ma35d1-nand-controller.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/raw/nuvoton-ma35d1-nand-controller.c b/drivers/mtd/nand/raw/nuvoton-ma35d1-nand-controller.c
index c23b537948d5e..1a285cd8fad62 100644
--- a/drivers/mtd/nand/raw/nuvoton-ma35d1-nand-controller.c
+++ b/drivers/mtd/nand/raw/nuvoton-ma35d1-nand-controller.c
@@ -935,10 +935,10 @@ static void ma35_chips_cleanup(struct ma35_nand_info *nand)
 
 static int ma35_nand_chips_init(struct device *dev, struct ma35_nand_info *nand)
 {
-	struct device_node *np = dev->of_node, *nand_np;
+	struct device_node *np = dev->of_node;
 	int ret;
 
-	for_each_child_of_node(np, nand_np) {
+	for_each_child_of_node_scoped(np, nand_np) {
 		ret = ma35_nand_chip_init(dev, nand, nand_np);
 		if (ret) {
 			ma35_chips_cleanup(nand);
-- 
2.51.0



