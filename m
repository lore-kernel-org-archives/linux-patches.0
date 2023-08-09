Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BF8171A6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:01:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0BDC433C7;
	Wed,  9 Aug 2023 11:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578883;
	bh=J8Etr6OZ8uVTd0lbk93PmgOhB8ZasD1aff4i4QOaYh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qYtA+DI17p3GTn6aY9P4Ed3lU2EloinRWOO0vOeKgNgW5A/Vrbu/yGN1pX9k3UB9X
	 cBFt0f+Y+phRnXOUC4TwixYw0ue3GNlq8MS4bTwOtZeuUhqxKDFfBiwbC+sN8QRsiZ
	 1Jn5VlSsKHCJM4PSUQZ8Rk3qk6HWTgcn0Xuu+7VI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 83/92] mtd: rawnand: fsl_upm: Fix an off-by one test in fun_exec_op()
Date: Wed,  9 Aug 2023 12:41:59 +0200
Message-ID: <20230809103636.408576920@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103633.485906560@linuxfoundation.org>
References: <20230809103633.485906560@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit c6abce60338aa2080973cd95be0aedad528bb41f ]

'op-cs' is copied in 'fun->mchip_number' which is used to access the
'mchip_offsets' and the 'rnb_gpio' arrays.
These arrays have NAND_MAX_CHIPS elements, so the index must be below this
limit.

Fix the sanity check in order to avoid the NAND_MAX_CHIPS value. This
would lead to out-of-bound accesses.

Fixes: 54309d657767 ("mtd: rawnand: fsl_upm: Implement exec_op()")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/cd01cba1c7eda58bdabaae174c78c067325803d2.1689803636.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/fsl_upm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/fsl_upm.c b/drivers/mtd/nand/raw/fsl_upm.c
index b3cc427100a22..636e65328bb32 100644
--- a/drivers/mtd/nand/raw/fsl_upm.c
+++ b/drivers/mtd/nand/raw/fsl_upm.c
@@ -135,7 +135,7 @@ static int fun_exec_op(struct nand_chip *chip, const struct nand_operation *op,
 	unsigned int i;
 	int ret;
 
-	if (op->cs > NAND_MAX_CHIPS)
+	if (op->cs >= NAND_MAX_CHIPS)
 		return -EINVAL;
 
 	if (check_only)
-- 
2.40.1



