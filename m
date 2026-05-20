Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F0E3F20FF;
	Wed, 20 May 2026 17:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296760; cv=none; b=OKPzAphlY8GhBdBOfPRpmJ5wT86JjbXbqrTiQQLklZZa79Lsx8FKFUdBoxQQqCbYMPXqNPbdH8slEYnv4v+tKdaRxMtRG8Vp5jZpLhIEcQKuwWBi6O1fZQlic757mfSVvvISkGk7Pzqv3XojOoSlIuDPRR4Qek5YNb2mJLruAL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296760; c=relaxed/simple;
	bh=Wh6NjJ6D9HJf4JuzLBuoU9o14eskb3SvL9SALeR1jeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTeLtV9DK3LxkoJmmpuN+v//QvxZ5q6SCX36eloJBrUkbiyQhqtRkUUtpT5wU22AUCQD48KmMtelSWxCjZGIHKui1l+ZFIMv+nWyDOal48N7K8Nx57d4LJcxY0aOFnnceTNAfVmHHDoZNrNZhavSZdkm7iwrVcXbKCb4+hjolRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y+chJpIC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y+chJpIC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABCF11F000E9;
	Wed, 20 May 2026 17:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296759;
	bh=jlNCntuHsuTkFnerGxTJpRaIYEhZzVBYtkCztTXmzrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y+chJpICVB354u31cFSB2InVYwdGGtqar5XH2jkWcDAEpjmp2zR/k7OpbZs2Z4b1C
	 HkNLlcIAztI/K6mViNqr/QT4jYw+Z+rF/NOrkV/gpzkm+qZYGHqYAJplgTVZ5dcRLv
	 0rI+r08X360ZPW4Y1pPh0IWfSQ80qmCQxJRLXTlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0922/1146] mtd: spinand: winbond: Fix ODTR write VCR on W35NxxJW
Date: Wed, 20 May 2026 18:19:32 +0200
Message-ID: <20260520162209.106678349@linuxfoundation.org>
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

[ Upstream commit 135ac3b84bcedae1860e7a9512d63166f42b736e ]

In most scenarios this variant is actually unused (VCR is written in
SSDR mode), but we need to provide an octal variant. The address is 24
bits but is sent over 4 bytes MSB first. This means we need to shift the
register address by one extra byte for the address to be correct.

I didn't catch this initially because the volatile register region is
256 bytes wide, so the write-then-read procedure did work with the small
register addresses I was using at that time: 0 and 1.

Fixes: 44a2f49b9bdc ("mtd: spinand: winbond: W35N octal DTR support")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/spi/winbond.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/spi/winbond.c b/drivers/mtd/nand/spi/winbond.c
index ea62fecea661d..7cc0f0091430c 100644
--- a/drivers/mtd/nand/spi/winbond.c
+++ b/drivers/mtd/nand/spi/winbond.c
@@ -99,7 +99,7 @@ static SPINAND_OP_VARIANTS(update_cache_variants,
 
 #define SPINAND_WINBOND_WRITE_VCR_8D_8D_8D(reg, buf)			\
 	SPI_MEM_OP(SPI_MEM_DTR_OP_RPT_CMD(0x81, 8),			\
-		   SPI_MEM_DTR_OP_ADDR(4, reg, 8),			\
+		   SPI_MEM_DTR_OP_ADDR(4, reg << 8, 8),			\
 		   SPI_MEM_OP_NO_DUMMY,					\
 		   SPI_MEM_DTR_OP_DATA_OUT(2, buf, 8))
 
-- 
2.53.0



