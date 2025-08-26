Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5584230AAD2;
	Tue, 26 Aug 2025 13:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214883; cv=none; b=iSs+FQiwJyhivxOcFD/Wxpgek8wU0iyF4uVeXLhTCMGg6iRL95BoM4IvySURyRxUlQetFGAfnvBnq5MjXeg8w+cSTUUnVmkAZKANifz/WVgEyXINggZ2TXP2zoHW2GCohzaJ6VlYdyRapm2LFM+UFsqz+S9tLZdr29jsiLQwYXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214883; c=relaxed/simple;
	bh=gSWwHx5SEE8Ibt8xihQVgq1NLRDunj+W+yF82teH1Xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJFZOOk10LnuuE1JX/bf0pr8SIQlL7wfbDcctNkTwT10AFf5x7BHpmMCakBBCXpDiLC7gRnn3idkOZzbcyMXu4wYTh7zCdYjyFnxzG2ouIFwgsQc6IT+kWm1rEeHQtgEHl6XCtXLHBHsMP/sSqkhckywoyxfjjqUvamuMGtT1kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9i+Xrs8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9i+Xrs8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E10C4CEF1;
	Tue, 26 Aug 2025 13:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214882;
	bh=gSWwHx5SEE8Ibt8xihQVgq1NLRDunj+W+yF82teH1Xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X9i+Xrs8DW1za+0AXMYLw2QXYUF5j3Qgo0Pozb79TQlVT4MTqzRE9dP4VWA6fK4Pu
	 QSlvSEj0yFMXwixj3WxLFDcV5nwze+5GfCKOsEPejNnIFSjWbAvcvEom/eijEJbU39
	 f2cAVI+aeNDTlGZkH3rfM87YIqKvbiIkNjIkgowo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.1 305/482] mtd: rawnand: fsmc: Add missing check after DMA map
Date: Tue, 26 Aug 2025 13:09:18 +0200
Message-ID: <20250826110938.334824391@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


