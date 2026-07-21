Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2152EBB8D;
	Tue, 21 Jul 2026 20:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665988; cv=none; b=oFUTwPQ5KYqA36kgBlRkhXNm8c8lxzvFQqtG50N52R/IkhXzPDe7ud3B8ZygSYUul/h5yiRT99bSsT4XFEMrk2bLCMkmO5NaZbucMUSfy80XB5LhalZcAKaktk3ZdSdx+4yuFigd0oVXjAXbSWcTJew1GrrNVCK2/XqiDp9kPZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665988; c=relaxed/simple;
	bh=zqZjq8iwQb0wEstQGvToNmrKMLlutmlDMXwXvLI/XDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=caVfwv71D8HlTKSIjEJcp6PhgwmetkghoeYMo91gznGAaArdZQHILLev+gPvUHnN4s0bjdtgfbj6t3CRSnNF1b/o6UUXZ41ze7j8JxdAzplKG4ru97DzBdv/xvUmvFi7xqzW5OUt3N43n2I3oSmalaMZT572OL6PCDcFCcFeoFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ohC9o0+6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ohC9o0+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27591F000E9;
	Tue, 21 Jul 2026 20:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665987;
	bh=7cklesvD4CfqcNKfnI1htZQ/NxkDI2lVLbPtZfvuJkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ohC9o0+6xKmMMPNQWqzTqB4K8h6voKzXSSzcvJMv6fedv8FZzPH6D7IJ5wbdqg5d9
	 vxzeD+f0aJhmS8o3F7t/vwaXy79V2OnunlK/J/poNyaN1sRplt+GargjVLGF00+Rtt
	 I/DeMYtMHD+ZTRQwWJwUNmRGlPPit67kIfWqmNP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0513/1266] spi: ep93xx: fix double-free of zeropage on DMA setup failure
Date: Tue, 21 Jul 2026 17:15:50 +0200
Message-ID: <20260721152453.327754331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index a1d60e51c053e4..22677e37f47e19 100644
--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -625,6 +625,7 @@ static int ep93xx_spi_setup_dma(struct ep93xx_spi *espi)
 	espi->dma_rx = NULL;
 fail_free_page:
 	free_page((unsigned long)espi->zeropage);
+	espi->zeropage = NULL;
 
 	return ret;
 }
-- 
2.53.0



