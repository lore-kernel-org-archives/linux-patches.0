Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858B041A547;
	Tue, 21 Jul 2026 19:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661978; cv=none; b=OkQB5hwD33r34U1KfRYt2c32svZWqRShqN1jH9dwfQq82aeo4ePq7Zsb1nVwvxTIhoU/j/A1Dq/+SHDUH9vNo6aZ49BxAQYp5kAgVfh3mj5rccyLWEHPBF0WK/AHlOmvNwl5BT/gjSoJMsji6OFTZc21sKwfuDSFZQ7tium32UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661978; c=relaxed/simple;
	bh=qEiWErqqooRrwOkj2ocTj8aMlUYHQvE5FU0b9z9eiMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TIU9Ectccbonm3OhAYiDboD6itOXwo8dYJ1zScTObuuOy//3SfEwTZvhqITsmkn2wY3eycNp6Sw7TFpmuhUyYNWVJQhEI5K7nzMyWJgTb7geiUm41NkR8Xu0Q6aoe4UgeIHA+lbuSEoh+wHu+3xIEf6iIZAv+27LzzaLigMqV6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zF00FPwu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zF00FPwu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22E01F000E9;
	Tue, 21 Jul 2026 19:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661977;
	bh=d34Ks8BxZVaaUKtJoVo65xfRZi5/CTv3JItpuWTJH9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zF00FPwukrLtI6BDeAKhCrVnZvj9CMfimSfugpN4WVBpDcxf5fibM73swuvydCEDY
	 63rwaDUmH62ApXNxr5TAXsqTS/ALh5/CaTaBfSIWxel0BI/Kq/eB88dyF9ZQkxHeVM
	 gnWdYZsi1KX0+s2nrjtzxTTspAcyzegg8PXBusvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0268/1276] spi: ep93xx: fix double-free of zeropage on DMA setup failure
Date: Tue, 21 Jul 2026 17:11:51 +0200
Message-ID: <20260721152452.077831549@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 7886054b06f762f62054957a8f6de0f14e6b7541 ]

If DMA setup fails after allocating the zeropage, the error path frees
the page but leaves espi->zeropage dangling. A subsequent call to
ep93xx_spi_release_dma() sees the non-NULL pointer and frees the page
again.

Clear the pointer after freeing in the error path of
ep93xx_spi_setup_dma().

Fixes: 626a96db1169 ("spi/ep93xx: add DMA support")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260529-ep93xx-v1-1-9185070ca1fc@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-ep93xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
index 0b42eeccd42ea6..fdf72636b66ad9 100644
--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -600,6 +600,7 @@ static int ep93xx_spi_setup_dma(struct device *dev, struct ep93xx_spi *espi)
 	espi->dma_rx = NULL;
 fail_free_page:
 	free_page((unsigned long)espi->zeropage);
+	espi->zeropage = NULL;
 
 	return ret;
 }
-- 
2.53.0



