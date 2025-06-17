Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA012DFF09;
	Tue, 17 Jun 2025 15:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175930; cv=none; b=WN/PGOLFN0M8L5QnIRyLnK5viSvtXClmFv/G1ceTgJxcwY8JBoLc78ZUAUDU+WXeL0sKX89W9RAbVI2hr7TP1qLfXgXS01ro9v6KEGgxc6cvvgm3bVdseh7PftYps5MkaXNit3S9rSzOquU7DwMIj6mcvvGPvAcMDubFan5Sn0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175930; c=relaxed/simple;
	bh=aFvb5J7jKeJ9IegFk0Y2igdjN0f6LkaHVagZ+OGJt8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2q9tbirIsd94x04HiYaabcNQEvDMZZB2cA/rsYP8hotY04MpeSorLojktWumpZ4cCql+nCLj0XMgAuNQn1/381eIxzOSWbu2NGHTS34Ewr8NOpvi2Yi0WNCRz0H+bBPTM+8SDBf4HthH6UsJpjqlkf83aJp/XTRVLTpkbMf4z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ojYhDZLn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ojYhDZLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC746C4CEF0;
	Tue, 17 Jun 2025 15:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175930;
	bh=aFvb5J7jKeJ9IegFk0Y2igdjN0f6LkaHVagZ+OGJt8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ojYhDZLnyUCwHXwo5oREQCajcWwGgED3PfflgvZ6G2AVsQtPAewugeha6U9T1LIO3
	 brMc91ue2etXaX1n6+UMt+DOi0tAP333RKjyPXMZQzxJhfrIeTndy7MsEEFbWZw3B5
	 IOVEU0FfKDfzUjKlskQbKC0sVythN5OaX2vUsYWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Arkhipov <m.arhipov@rosa.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 203/356] mtd: nand: ecc-mxic: Fix use of uninitialized variable ret
Date: Tue, 17 Jun 2025 17:25:18 +0200
Message-ID: <20250617152346.381416802@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

From: Mikhail Arkhipov <m.arhipov@rosa.ru>

[ Upstream commit d95846350aac72303036a70c4cdc69ae314aa26d ]

If ctx->steps is zero, the loop processing ECC steps is skipped,
and the variable ret remains uninitialized. It is later checked
and returned, which leads to undefined behavior and may cause
unpredictable results in user space or kernel crashes.

This scenario can be triggered in edge cases such as misconfigured
geometry, ECC engine misuse, or if ctx->steps is not validated
after initialization.

Initialize ret to zero before the loop to ensure correct and safe
behavior regardless of the ctx->steps value.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 48e6633a9fa2 ("mtd: nand: mxic-ecc: Add Macronix external ECC engine support")
Signed-off-by: Mikhail Arkhipov <m.arhipov@rosa.ru>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/ecc-mxic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/ecc-mxic.c b/drivers/mtd/nand/ecc-mxic.c
index 47e10945b8d27..63cb206269dd9 100644
--- a/drivers/mtd/nand/ecc-mxic.c
+++ b/drivers/mtd/nand/ecc-mxic.c
@@ -614,7 +614,7 @@ static int mxic_ecc_finish_io_req_external(struct nand_device *nand,
 {
 	struct mxic_ecc_engine *mxic = nand_to_mxic(nand);
 	struct mxic_ecc_ctx *ctx = nand_to_ecc_ctx(nand);
-	int nents, step, ret;
+	int nents, step, ret = 0;
 
 	if (req->mode == MTD_OPS_RAW)
 		return 0;
-- 
2.39.5



