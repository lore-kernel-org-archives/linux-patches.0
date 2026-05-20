Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B7F3D75CB;
	Wed, 20 May 2026 16:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296053; cv=none; b=c5SlJ7mHld9cQwYK8MAfG/GTR96q98o96hL1f6m2AOclmBdC/hZxsRpe07RdLcmHT7k6FeV0aiHu1uRFQBDBBXVlXWM/kXWYXd7zragrLEC3DLjtNjIi9kDzArQhzcFvz0fL2YwakZxuknNxyKNwqcdrlHifVdVNnUsP3ZbmxxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296053; c=relaxed/simple;
	bh=lxKtf5Ar/6lK2dQCXGBOyBp+NP9ZE9qi/lPA4YiId6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1ZynEf/CNdFvQQkj5NIevOhzxr2azGd48tzvL6ldIuDmC2yiH0R++wCxDNhL2fv0p1UNoS3S+3jA8A2JY+lu0BfRkEkAPfP+mB/O3Sc4ubq6Bf31DbcfGn7qI9btbFJK1RGntw4r0VwcFL5Q6Y7M3P7yOXDEXwa6N9YXtm68yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gXati9+F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gXati9+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7ED51F000E9;
	Wed, 20 May 2026 16:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296052;
	bh=VXMuArV/7JTV6ioeBjqrii2EADH2IaAiCroiMMtsCyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gXati9+FsddIEKh6coR+yP0sKIav0v7xueYJJAmIkftpT5FhDkiEEsd3fpE90n9rf
	 bvqS9mbM0qGmnRbbpKELa+O2FVRer0hV6bru+EmqpP7a05UKXVeN0L8Q3VynVG7SFF
	 qu265eks1Z49dIcoukpRg1BGWYKsrE31/KXvLoWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0602/1146] mtd: spinand: winbond: Clarify when to enable the HS bit
Date: Wed, 20 May 2026 18:14:12 +0200
Message-ID: <20260520162201.802560067@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 25a915fad503c2678902075565d47ddc2aa45db9 ]

Above 104MHz when in fast dual or quad I/O reads, the delay between
address and data cycles is too short. It is possible to reach higher
frequencies, up to 166MHz, by adding a few more dummy cycles through the
setting of the HS bit. Improve the condition for enabling this bit, and
also make sure we set it at soon as we go over 104MHz.

Fixes: f1a91175faaa ("mtd: spinand: winbond: Enable high-speed modes on w25n0xjw")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/spi/winbond.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/nand/spi/winbond.c b/drivers/mtd/nand/spi/winbond.c
index 4f9f1854e0cfe..ad22774096e61 100644
--- a/drivers/mtd/nand/spi/winbond.c
+++ b/drivers/mtd/nand/spi/winbond.c
@@ -337,16 +337,19 @@ static int w25n0xjw_hs_cfg(struct spinand_device *spinand,
 	if (iface != SSDR)
 		return -EOPNOTSUPP;
 
+	/*
+	 * SDR dual and quad I/O operations over 104MHz require the HS bit to
+	 * enable a few more dummy cycles.
+	 */
 	op = spinand->op_templates->read_cache;
 	if (op->cmd.dtr || op->addr.dtr || op->dummy.dtr || op->data.dtr)
 		hs = false;
-	else if (op->cmd.buswidth == 1 && op->addr.buswidth == 1 &&
-		 op->dummy.buswidth == 1 && op->data.buswidth == 1)
+	else if (op->cmd.buswidth != 1 || op->addr.buswidth == 1)
 		hs = false;
-	else if (!op->max_freq)
-		hs = true;
-	else
+	else if (op->max_freq && op->max_freq <= 104 * HZ_PER_MHZ)
 		hs = false;
+	else
+		hs = true;
 
 	ret = spinand_read_reg_op(spinand, W25N0XJW_SR4, &sr4);
 	if (ret)
-- 
2.53.0



