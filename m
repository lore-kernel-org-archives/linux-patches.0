Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EDF44AB7B;
	Tue, 21 Jul 2026 22:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671736; cv=none; b=XhWAF1ES/vLOHjixVvkvCUlX7k24K0rwMm4QepgrSXI6BMxCv+jUJQuVdEPz3tz4TvoGtzGGkE2Z7N6mlhkdgW5qKq9HjU8xdqfOqwDo1m8rrxTTulEhYfdwP/raH9K6Vasijiqm8ScbeC+gLBfwku5s3ivJR/2pFOtxSN5NhcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671736; c=relaxed/simple;
	bh=23KMT/jBUHnpredp3AAJ9cF7EhT0NiMO30qcPcpBCyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMCykiuotHuI5YoqMoC07sVbwQSgdDGlIm2btWSUANNDJiolPndxiQRoJ/9CTNbY4/oG9PicCZPMWdCBAvwJxzCA7yw+IkFh62UHw96dzlRYPAEeQoQk2ezZ6/HUotB1l+c5CHFtpLXMw33H4bQ1dCHf1Ka+UX1FbDbMOBUt9QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HaHAfZ+Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HaHAfZ+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534DB1F00A3A;
	Tue, 21 Jul 2026 22:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671735;
	bh=YUzNMbk509AzjbHFLVp9BzPC954FRCAMoPT0ziRfct0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HaHAfZ+YYcGxdTSHZKnP1V/hssdS04v+0eGvblX9h86thr97jZvQnwuPNwuAnFWUR
	 XyrIuZn0QJ8wmlcdNf2ql1Oi+hwbR+xVFg5N6bK1GwjBpISz/MGnId1alEMhchWosW
	 a5lOEpCCIy+TyE0Jy+TMbAMmKOVPgErtQ2Z05NF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 316/843] spi: ep93xx: fix double-free of zeropage on DMA setup failure
Date: Tue, 21 Jul 2026 17:19:11 +0200
Message-ID: <20260721152413.129423721@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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
index 5896a7b2fade0c..9b694cd5361d93 100644
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



