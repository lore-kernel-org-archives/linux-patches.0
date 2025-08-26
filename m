Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B8F29CB32;
	Tue, 26 Aug 2025 11:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207208; cv=none; b=qgw74OKzDes93FGWTIrLvUQ/QiCpj4ejhEPCfjhw6iU+sSrzPhmw4Nj/LQRk3biamcrJd9KpcG1lLAsP6WvAbyWKl0Gl52/y8kd5QnXgsOr2aOCa/P1ErZ25dJF06nOmIw4JQ8eJGUFnDsTIA6Ei5mrcwoF6Muiss8gLFY9Cb0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207208; c=relaxed/simple;
	bh=3KhNv339V30gP3z58/gs49840k+JoTz9/itbaXbOk4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P9F8+BVQ2ipfBvFnE00ursHayyv6ZH5uxmmcJ9Bj7UX9ztARk99UHrY2Mvu8ISn2z92hizjnRDrSB285z1eJZC0vlLff0KKRrGiyl6FrfX+i26j9fNQIrRVmhB6kgWMcu9aLPw1BgnVMqPP9CswbabJD9oeCfh2Ns0dHt6WtPXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R7IrDTWZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R7IrDTWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE27C4CEF4;
	Tue, 26 Aug 2025 11:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207208;
	bh=3KhNv339V30gP3z58/gs49840k+JoTz9/itbaXbOk4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R7IrDTWZMlVikTi5JQV5ninps6Aps2l9tdv14+3gV5EyFlR9I5P6jQ550HU8Dt73t
	 nDXkwmSe7u8sQtjO0tXmng3E+bWlWZHj3+WwGdwFe3c0aWZGfi9R7IlQ9dzM2T+kTX
	 3qBq7NKT0nPp4eYGgJSLGB22sn7rVhOGfYJEbLdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.16 093/457] mtd: rawnand: fsmc: Add missing check after DMA map
Date: Tue, 26 Aug 2025 13:06:17 +0200
Message-ID: <20250826110939.676766065@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

commit 6c4dab38431fee3d39a841d66ba6f2890b31b005 upstream.

The DMA map functions can fail and should be tested for errors.

Fixes: 4774fb0a48aa ("mtd: nand/fsmc: Add DMA support")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Rule: add
Link: https://lore.kernel.org/stable/20250702065806.20983-2-fourier.thomas%40gmail.com
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/fsmc_nand.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mtd/nand/raw/fsmc_nand.c
+++ b/drivers/mtd/nand/raw/fsmc_nand.c
@@ -503,6 +503,8 @@ static int dma_xfer(struct fsmc_nand_dat
 
 	dma_dev = chan->device;
 	dma_addr = dma_map_single(dma_dev->dev, buffer, len, direction);
+	if (dma_mapping_error(dma_dev->dev, dma_addr))
+		return -EINVAL;
 
 	if (direction == DMA_TO_DEVICE) {
 		dma_src = dma_addr;


