Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FEF33F5BC;
	Tue, 13 Oct 2026 12:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895544; cv=none; b=dIvwl/sZVYIgsdt/xyW2LTcwIo/Xc9s7gkF11qHB5P07rVOJNiut03fhxa1gPW1aETjAe3gpofRf9EBHsGzDdxv0h4S5X1V8tfwhq2h6WsM2vFeiu0jGM6wTmjiK+P+up1msDlJ6bLT2GSgzEtBPAxVFSa4c8YMINpW0a+ufcPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895544; c=relaxed/simple;
	bh=cqpVcbxdlEgwEuVTA0NYh5X2TxHn7KE0im5brt0+Wek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mQsJinRtxb3j5C9h/CUekPd5TUFO5kPRNOzVqE+j3Uv0buNqWx4DZSllDQOOjnAglnUtU2T2pBL9+qXDhR3dh0sgoVAjKSAPO4tohmYW53xIV9Sdg/yGbv6kdKalx43dKA9nEex+JhNH5cGGzZiYqmoXBPhIIypWg9ICi1l3jlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1691KR38; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1691KR38"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1206C1F000FF;
	Tue, 13 Oct 2026 12:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895543;
	bh=QSR39lNPaLVC4vrmzjFYj5B3HwLMhjeP4ouPCA1q2Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1691KR389sYV5p58/Z5FqtLeXE0RakOm5PQYnMWWkmXe4Y69pMjuM3zTS4X/LQ7L7
	 lsvzpR6guVsMtNLdbo+S6V0tNBetkGM0Y2VkQSTC1dgP6qT7UFxeM7Bsuk7ro4qE0D
	 jm63/LSR64LhWNjH5zsTN/r0joteLiFnv7EfmLGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 309/497] mtd: spinand: fix NULL pointer dereference with no ECC engine
Date: Tue, 13 Oct 2026 13:37:56 +0200
Message-ID: <20261013112915.235676381@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit b890e6163761ddb580cc74f43e15f8bbde15647e ]

When "nand-no-ecc-engine" is set in DT, nanddev_get_ecc_engine() takes
the NAND_ECC_ENGINE_TYPE_NONE path and returns success while leaving
nand->ecc.engine NULL. The SPI-NAND code nevertheless dereferences it
unconditionally to test for a pipelined engine, so probing such a
device oopses immediately.

Rather than open-coding the test three times, add a
nand_ecc_is_pipelined() helper to the NAND core that folds the NULL
check into the integration comparison, and use it everywhere. Future
callers then cannot reintroduce the problem.

Fixes: f9d7c7265bcf ("mtd: spinand: Create direct mapping descriptors for ECC operations")
Cc: stable@vger.kernel.org
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
[ sashal: Replaced the nand_ecc_is_pipelined() helper with an inline NULL guard in spinand_create_dirmap(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/spi/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
index a41f2fd47379c..cb10cc573d9ae 100644
--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -1108,7 +1108,8 @@ static int spinand_create_dirmap(struct spinand_device *spinand,
 
 	spinand->dirmaps[plane].rdesc = desc;
 
-	if (nand->ecc.engine->integration != NAND_ECC_ENGINE_INTEGRATION_PIPELINED) {
+	if (!nand->ecc.engine ||
+	    nand->ecc.engine->integration != NAND_ECC_ENGINE_INTEGRATION_PIPELINED) {
 		spinand->dirmaps[plane].wdesc_ecc = spinand->dirmaps[plane].wdesc;
 		spinand->dirmaps[plane].rdesc_ecc = spinand->dirmaps[plane].rdesc;
 
-- 
2.53.0



