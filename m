Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9165F46D088;
	Tue, 21 Jul 2026 17:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656430; cv=none; b=BXVFQsD6RHwlHZ+vxdomo3vP7Ys5/0cPNs1L6itmmh2zbdqI7KM9AKK5ElmHBerf2K7hiNh0Dy+uzeEnHOAifFavomXtitYkTCyqUKsYwyB6Y2L2KQAH9EGTG5A2EMz/xoo0E1+XWRcqG81xxL/OpbRvEnnCn/BI1UcFejVW69Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656430; c=relaxed/simple;
	bh=ITWsyrbQOeeJmEE8D0+Ww9ajE2VWRz9vRGxCrXRlkqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puKSt/Ntqzrr1Ny5Nix2+dtc45jfplr+iaQRRZot3wBLP75dDQCKk6YIgX9twmL1UAMBfYydgMUDcyuJgs4/aUcs4vbzYlvUR9I/EnmHrbCbwlt14cWrfm1k8DKx9JhNtWWC3+sB5kSKdtyEO0MWXEcH7NTMzXkMzDFqyGjhEho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fgYXoMeM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fgYXoMeM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18351F000E9;
	Tue, 21 Jul 2026 17:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656429;
	bh=nZZRAhLYSppaHKR4n7UQtjLKokcsDXP+4oNvFy9i0CE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fgYXoMeMNwS/WfEA+rmtNVfwipp1muo95hXs0oFC+GDX9mYWZNNUNUt6E2govoLVG
	 pELEDbJAzDqr5AViI9lSQ7KmjI/DSb/1nnnljGutBRN1suQHy+Er0kCGezWylQ8t5K
	 x+rb2rGRLtiZ2R04Ego1SFqfkmUCcR3LnXxC26gI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0385/1611] spi: ep93xx: fix double-free of zeropage on DMA setup failure
Date: Tue, 21 Jul 2026 17:08:21 +0200
Message-ID: <20260721152523.868212569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 52d2f8920cd750..a8ddd3d388de0c 100644
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



