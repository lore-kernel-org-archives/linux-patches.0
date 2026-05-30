Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588C723392B;
	Sat, 30 May 2026 18:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164282; cv=none; b=gcpK2GQhFXxfTG9cW8TKjEbOIaF2WpGqPXa6IcJXbVbsG2oSB/s/vc3hPaRu+gWh08cF6CWRluLd7v/kohHXIcYhhSo2JfsLPRUSE850jug6TnBCz2VKBsWBMRYmTl+osXrN59ZFOmfkh0IPdvlRju3s22CXSCtjoW3AYteesgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164282; c=relaxed/simple;
	bh=BaPX27TO80bDt3veyzPr8tiC47hTyfzu5olbTmFT7CE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XI3pI3VZ3y6JvjBrvVAGg0MxeLjimwVH2dufqKZnH2/uvfPVafZQfCRL9hLhKA1iPrUltCBw4pru2ReYqQLr9A+w2UXIVcspDKRaaS9299XJjM/qIKmj6MaSDH1DSjEe8Hg7gSG1Zb2ep780sHNfrLhVnTEzMNqAoSlTWxaE7pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WRH7V5tS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WRH7V5tS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5DF1F00893;
	Sat, 30 May 2026 18:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164281;
	bh=AxO226SuH6fmoU/k43FRQS4WM50+p4GbkUjiRLxODRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WRH7V5tSuB6Wi6rvlg4x0eFz+zbrcGMLch+wHukuq3TLUmykYowIkN2zpdwyYFtFi
	 bd+sjlLdl0IxO4CGTne3JijG3oK/n7YUpjEv3GtwB9ObA0ZqJIgQTEKE+rUNHnjKFz
	 KM67rk8XHnHL49NyZxIQS4YCg4DhsM4nERPX6/Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiji Yang <yangshiji66@outlook.com>,
	Michael Walle <mwalle@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	"Pratyush Yadav (Google)" <pratyush@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 508/776] mtd: spi-nor: swp: check SR_TB flag when getting tb_mask
Date: Sat, 30 May 2026 18:03:42 +0200
Message-ID: <20260530160253.400527332@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8594bcbb7dbe0..f29779a761136 100644
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



