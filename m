Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2D91BE22B;
	Tue,  2 Jul 2024 17:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941359; cv=none; b=tzBDirfozYpiKgGH1bG5J0wi/79sY4Z0RtiRdL33rU/16Mehogyg6vI1TblaCw6F6W13ZiCszb5TWUScIaz9ATbA7+7ZfuMbOGGa3OC82HQGiYTVa8y9fChCQQFh6OMYNNeQ6bCr/8WtQMyo1b+3X12EZQzCLOu+u73HMQ3OVK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941359; c=relaxed/simple;
	bh=OKvF8MkyCF97k5rwbRrPIBV4lYic/b1naMTsxPMSnCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TpYuPhRxnEO7fJaJPupIYqu4pbiDq6Tj5nkO6YDBVNa9Sc4bwaBYE0q2CgIY1Ieb1cE72gt6SSTl3G4cxFx/7NlC6ZBLGln2Q1mchGkkM3kMFYRv3W/orWtGYxpgyyF5dJ4CNOP9FLU8HS1K+7OYg4s5p+xTDp3GWdooYb7isE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VdMlXSIT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VdMlXSIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFFCC116B1;
	Tue,  2 Jul 2024 17:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941359;
	bh=OKvF8MkyCF97k5rwbRrPIBV4lYic/b1naMTsxPMSnCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VdMlXSITmikyq1d2GsVECBU77t1DaFgW1RIFQZoGN2jqEPUawpgc9qRx8i/H2Z/tH
	 kPFusRX8/4KZQROOOwvVniCyXh42a7NWPykU05B0RBxKVQaUx5PSeXX2bZU2OwAiKX
	 tBt/5NLDWO4Jf4arZJtjKSaz+s0ckt8wtQiR/3ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/128] mtd: partitions: redboot: Added conversion of operands to a larger type
Date: Tue,  2 Jul 2024 19:04:02 +0200
Message-ID: <20240702170227.788724575@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

From: Denis Arefev <arefev@swemel.ru>

[ Upstream commit 1162bc2f8f5de7da23d18aa4b7fbd4e93c369c50 ]

The value of an arithmetic expression directory * master->erasesize is
subject to overflow due to a failure to cast operands to a larger data
type before perfroming arithmetic

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Denis Arefev <arefev@swemel.ru>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20240315093758.20790-1-arefev@swemel.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/parsers/redboot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/parsers/redboot.c b/drivers/mtd/parsers/redboot.c
index a16b42a885816..3b55b676ca6b9 100644
--- a/drivers/mtd/parsers/redboot.c
+++ b/drivers/mtd/parsers/redboot.c
@@ -102,7 +102,7 @@ static int parse_redboot_partitions(struct mtd_info *master,
 			offset -= master->erasesize;
 		}
 	} else {
-		offset = directory * master->erasesize;
+		offset = (unsigned long) directory * master->erasesize;
 		while (mtd_block_isbad(master, offset)) {
 			offset += master->erasesize;
 			if (offset == master->size)
-- 
2.43.0



