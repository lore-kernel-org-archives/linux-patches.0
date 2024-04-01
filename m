Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D4F481D5;
	Mon,  1 Apr 2024 16:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989823; cv=none; b=BXUqocZuQPMQiamqP9H2kUVgmoRKsPnLPJh4r81r6XfKbwqe+4sM+e4jeX6CYSt9rzSazLVtPGgKqp9FKRtD0r2zuYGumzPuYpscudeFUzmSqJriPZ+DZZWtw949QXPhoITR4ZAgOY9Mmjm1YZ5DIIrezLsT/3Mu9WYn/4YPC1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989823; c=relaxed/simple;
	bh=tNKCUkBTmNgZwIsR9hk+qI4QjW5m/CloCQqBWQTpvAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qriaffNWIgF8oCIsENYeDJJ9vU+iAhtl4kMKJ3tCjxSyv0zVtOrWTS3C9HaCW4LN+FdgB1NHKnowyLAsBjRAs28vZvqI/mwRttgxhTQpzvwIS6sL1p3xcsWg0Q6UxfzSTRJ6g8PaH4z4rggMsLqr0OyWWe33iiXFk3UXX4Jjr4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G2UniMoX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G2UniMoX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23AAC43394;
	Mon,  1 Apr 2024 16:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989823;
	bh=tNKCUkBTmNgZwIsR9hk+qI4QjW5m/CloCQqBWQTpvAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G2UniMoXzOWGcwsbHNbz4pE2qQXi5aR8UHsL/w0yEOEonBSSEem+n+dK2mY6G+bf9
	 KwjYgIJwL4jPctQQJ5Uy/v+vB3uzGMjBN7ir/KrKl3Nl8c1+i0x4t3yXxE6vcctfxy
	 dTNW4MKjCnRxNkWlHLdjgcdSOs4tRz0zA7h+DE48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Kerello <christophe.kerello@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 164/396] mtd: rawnand: Constrain even more when continuous reads are enabled
Date: Mon,  1 Apr 2024 17:43:33 +0200
Message-ID: <20240401152552.829681324@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

[ Upstream commit 78ffbefba8d7822b232585570b293de5bc397da6 ]

As a matter of fact, continuous reads require additional handling at the
operation level in order for them to work properly. The core helpers do
have this additional logic now, but any time a controller implements its
own page helper, this extra logic is "lost". This means we need another
level of per-controller driver checks to ensure they can leverage
continuous reads. This is for now unsupported, so in order to ensure
continuous reads are enabled only when fully using the core page
helpers, we need to add more initial checks.

Also, as performance is not relevant during raw accesses, we also
prevent these from enabling the feature.

This should solve the issue seen with controllers such as the STM32 FMC2
when in sequencer mode. In this case, the continuous read feature would
be enabled but not leveraged, and most importantly not disabled, leading
to further operations to fail.

Reported-by: Christophe Kerello <christophe.kerello@foss.st.com>
Fixes: 003fe4b9545b ("mtd: rawnand: Support for sequential cache reads")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Tested-by: Christophe Kerello <christophe.kerello@foss.st.com>
Link: https://lore.kernel.org/linux-mtd/20240307115315.1942678-1-miquel.raynal@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/nand_base.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/nand_base.c b/drivers/mtd/nand/raw/nand_base.c
index 9118b5753c553..c059ac4c19f11 100644
--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -3578,7 +3578,8 @@ static int nand_do_read_ops(struct nand_chip *chip, loff_t from,
 	oob = ops->oobbuf;
 	oob_required = oob ? 1 : 0;
 
-	rawnand_enable_cont_reads(chip, page, readlen, col);
+	if (likely(ops->mode != MTD_OPS_RAW))
+		rawnand_enable_cont_reads(chip, page, readlen, col);
 
 	while (1) {
 		struct mtd_ecc_stats ecc_stats = mtd->ecc_stats;
@@ -5196,6 +5197,15 @@ static void rawnand_late_check_supported_ops(struct nand_chip *chip)
 	if (!nand_has_exec_op(chip))
 		return;
 
+	/*
+	 * For now, continuous reads can only be used with the core page helpers.
+	 * This can be extended later.
+	 */
+	if (!(chip->ecc.read_page == nand_read_page_hwecc ||
+	      chip->ecc.read_page == nand_read_page_syndrome ||
+	      chip->ecc.read_page == nand_read_page_swecc))
+		return;
+
 	rawnand_check_cont_read_support(chip);
 }
 
-- 
2.43.0



