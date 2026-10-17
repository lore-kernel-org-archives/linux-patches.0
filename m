Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913F13AA4E8;
	Sat, 17 Oct 2026 17:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256964; cv=none; b=THJjOhk0nhrUTxN/IFwOQs9ymgHNbJFE12MlenIy68aiLEuLBkrabk8nud8RCps01GiXyVrJhRbuJ+GQ2+iPPlkOT0tlLK9aZ9ZmzF+ROdftNJwgLueCgdBKDr11Ud1bH3JXsj8PuDZRWFc1TGlQ14H5OttMiX4eN+fMPSIEsGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256964; c=relaxed/simple;
	bh=MMCSAyYCygYP2oMZn0HUoUxUeunA8a4H2Pc5scQjkpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M/J3ZWdam+kbvXH64LP92FZx7ZRNp4z9yK/J6g55hIb14raYIDES7VjxvRnL/o1mAHyzeud0RMRePIGQibP42LBHw1CC9xj5GsPgnVqlR9H03isz0PYf1ZYXN/G/HvArlKSrc06HDXG5td93CZchgkxx3pK9ZyWES/A3FXB4RwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aEg+aArq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aEg+aArq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD27B1F000C4;
	Sat, 17 Oct 2026 17:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256963;
	bh=Iw9Qz2xRhYc+PjSyxoEblYcZtanLH+UTeiWyQzLxLHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aEg+aArqTzWYxT+z8foQBd4/6OJh+0WgwzpWIKyq2QEogUedRaSLnSlsmrrHAtyaz
	 wX+Fyz4+Vlvy0IIIMlyyVFj/lwhanQzaqfyie8pPE8wmMlf1i+B9LNianSgfYMr0K3
	 Bmz0MdYI6wX+3+4dNlrUqhyhm0XyF7JRH0FrMgO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0408/1674] mtd: spinand: fix NULL pointer dereference with no ECC engine
Date: Sat, 17 Oct 2026 17:44:40 +0200
Message-ID: <20261017160441.593619988@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: replaced the new nand_ecc_is_pipelined() helper with an inline NULL check in spinand_create_dirmap() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/spi/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
index 04965f21c995f..9143553bc5704 100644
--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -884,7 +884,8 @@ static int spinand_create_dirmap(struct spinand_device *spinand,
 
 	spinand->dirmaps[plane].rdesc = desc;
 
-	if (nand->ecc.engine->integration != NAND_ECC_ENGINE_INTEGRATION_PIPELINED) {
+	if (!nand->ecc.engine ||
+	    nand->ecc.engine->integration != NAND_ECC_ENGINE_INTEGRATION_PIPELINED) {
 		spinand->dirmaps[plane].wdesc_ecc = spinand->dirmaps[plane].wdesc;
 		spinand->dirmaps[plane].rdesc_ecc = spinand->dirmaps[plane].rdesc;
 
-- 
2.53.0



