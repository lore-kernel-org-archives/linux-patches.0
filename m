Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD483C870E;
	Wed, 20 May 2026 17:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298594; cv=none; b=LLxQbXB6p7TH0c3HMrbgY3apdu9ArxTG+lbIsC7CR/73LpqVMh5lf6jeXlW28Gd4gmtFsGxhNKOG5uid7kHXVdodSY77lsxA91MjWSVKsGV6s+mbHRal1hS8zCybvEz0zyrZqEisFVOlhDHBcrH8rR17WcJDn3E0cvKvh+tPr2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298594; c=relaxed/simple;
	bh=hQ4eXy84f6jI1hoyr9viyu6ufQ5j9dGmSpw7u7M0BKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcFlJph7dNsFj41GsBI679z/3iJXuZLsQ/sVA2Kx025yvgrZuSyspTHi3h+ANmOajCKMe8+2X4FAx2HOORo1eYM4IGlH87z6MuAmUa+3dBhfU8HgYeM0N49OVl5hjN5nB7WVQu/88O7RbidwNhO3nU62/pr6vVkRE+JMY9lXLXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WCKxlgEE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WCKxlgEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E38F1F000E9;
	Wed, 20 May 2026 17:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298593;
	bh=rfWhgWToEHhnvJ9AU9GiGKN4nKHfXIthBGlcBZ/g+1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WCKxlgEEOEUPgicVzAFccw3qm2gb0fR5S1o4zCMi8vCM1tSBaZGnw9zCR2m0Jj1jm
	 mVk6TSH80SNhA/qS6suwTBcKQPXZAooPWYM19ttFSDbcu/igfUYCt/RUQ5QMZWaGMh
	 r9nQR5+90cxDJfKU2zzVzpdhB0n+0vc0dLDzX6gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiji Yang <yangshiji66@outlook.com>,
	Michael Walle <mwalle@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	"Pratyush Yadav (Google)" <pratyush@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 469/957] mtd: spi-nor: swp: check SR_TB flag when getting tb_mask
Date: Wed, 20 May 2026 18:15:52 +0200
Message-ID: <20260520162144.696096719@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9b07f83aeac76..e67a81dbb6bf6 100644
--- a/drivers/mtd/spi-nor/swp.c
+++ b/drivers/mtd/spi-nor/swp.c
@@ -28,8 +28,10 @@ static u8 spi_nor_get_sr_tb_mask(struct spi_nor *nor)
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



