Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78D0425CFA;
	Wed, 20 May 2026 18:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302342; cv=none; b=lXcDG/LCvFm78H+U17SMf+EJaAhWdKy79u52aEcfIANp6bXic0d4dOyzLOTkXTcv9biP3lkCZGybWAEc9IZumF9IqRP4s2KwTbd0XZTtPKcSZt7ux0LESzyGY96iOlSjqe2D3NK45H53k+W3bDtLRDNPvbw5MU3ouH1P/Z7Dc2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302342; c=relaxed/simple;
	bh=Lr7uEMkKZI2X7j6NpZU2TR9uW66KEl+Xzx2eQE6otdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJzDSytriwpCCKQqfBqlBmdyEm1Y+K8g4Ks/5BktkvVANgs/wLFUpeJnV1Qb/ompytrUeHUEEEsiTdSSSg8+au2oNPlSREp5qY9tt1PNCCVYV/evFi8Qcrp7wIoGLiIrpVEZgvfmrNjPuwHfbcghLMekRcw47UehxOjJMS5bx8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HVTRs3jY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HVTRs3jY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF6F1F008A7;
	Wed, 20 May 2026 18:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302340;
	bh=qSby1O+6yB39dGwg7N8sg3RbR4MJHdAg9bS2IXsKGLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HVTRs3jYXVz5WkqK3E7v5AuQSeRA+M/DuBh6cZykkU0cd6A4ghiNXrlQygvD5QKPw
	 0Cl5JDWp4vxIMzpcEc4z2cZlmzU66c6vaJYcEDj8S1uYOAgg9olri/Uxq0KAo/fghG
	 eJLlq69eGI0hNr1xnfRk356wgVY/+L6TOIE2cIBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiji Yang <yangshiji66@outlook.com>,
	Michael Walle <mwalle@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	"Pratyush Yadav (Google)" <pratyush@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 230/508] mtd: spi-nor: swp: check SR_TB flag when getting tb_mask
Date: Wed, 20 May 2026 18:20:53 +0200
Message-ID: <20260520162103.634325732@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a186d1fde8694..4f34283603587 100644
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



