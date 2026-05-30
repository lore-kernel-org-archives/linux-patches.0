Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5C8350A05;
	Sat, 30 May 2026 17:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161399; cv=none; b=osceEYIo84wMS/NamwjvCb4EPx9tOlxKnV5zJgGXy6lTTHVnprjLktLjdxaMav+Jp8EwxacsJfw4iALBYeR3iH8f8xfIV710BcccPNoZEQQt2HyntVCBCbIf4z/hGfeB6vfDgk69xYHoiO0/0RDu0AJ2Y3NCC1PBmIVoSZU6HXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161399; c=relaxed/simple;
	bh=53RdUUjwBma+Z1PHyL79YokSMsDg7T1F6Ya+Ac5Jc94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HWWWQi2VoK5RSElIKcB3/ndq4FnzLjR1lixLmNKSmiz1zcaf1enL+GGDgu6m8avIevKHucFwFva9MhXoTco5ztnxzlOI+QXY498XZuOAluhbu/ZXFp5zg1X1o6VfWu2eDpu4FtbHiX3LxgvtepV4HcK6G5XAd5tVx8LgOMCxq5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YZSZE3Cm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YZSZE3Cm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9C81F00893;
	Sat, 30 May 2026 17:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161398;
	bh=75XavC23mfP5wtNVtstd1vR0idrF2JBwsQwhlVNakUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YZSZE3CmnJ2s79uy6ztjqXFWqnaF0xw/lm7yyZD827Gm/lpG0DqZlkMonJNHJDjGn
	 iJmw+zImJBJV9CPkAE5dAG2FPDqtL0m7nY5t+vmchv1zW+DdjRIU3yV+dUVr3PuU/6
	 ZtEQfEKspUw0MYBKpWVVMtBgjn1yRUF5RQArFwBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiji Yang <yangshiji66@outlook.com>,
	Michael Walle <mwalle@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	"Pratyush Yadav (Google)" <pratyush@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 613/969] mtd: spi-nor: swp: check SR_TB flag when getting tb_mask
Date: Sat, 30 May 2026 18:02:17 +0200
Message-ID: <20260530160317.358586895@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shiji Yang <yangshiji66@outlook.com>

[ Upstream commit 94645aa41bf9ecb87c2ce78b1c3405bfb6074a37 ]

When the chip does not support top/bottom block protect, the tb_mask
must be set to 0, otherwise SR1 bit5 will be unexpectedly modified.

Signed-off-by: Shiji Yang <yangshiji66@outlook.com>
Fixes: 3dd8012a8eeb ("mtd: spi-nor: add TB (Top/Bottom) protect support")
Reviewed-by: Michael Walle <mwalle@kernel.org>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/swp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/spi-nor/swp.c b/drivers/mtd/spi-nor/swp.c
index e63cdae6dd745..a587561dd476e 100644
--- a/drivers/mtd/spi-nor/swp.c
+++ b/drivers/mtd/spi-nor/swp.c
@@ -27,8 +27,10 @@ static u8 spi_nor_get_sr_tb_mask(struct spi_nor *nor)
 {
 	if (nor->flags & SNOR_F_HAS_SR_TB_BIT6)
 		return SR_TB_BIT6;
-	else
+	else if (nor->flags & SNOR_F_HAS_SR_TB)
 		return SR_TB_BIT5;
+	else
+		return 0;
 }
 
 static u64 spi_nor_get_min_prot_length_sr(struct spi_nor *nor)
-- 
2.53.0



