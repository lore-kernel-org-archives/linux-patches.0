Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4C91494D9;
	Tue, 26 Aug 2025 14:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218770; cv=none; b=os0MdGUG8eyX4SgG3ea9oJbyqDHFyhNa7cjFMeSjLv4HIdWkOTWoiOcyz3ELQKd0wyxkPmyQihGb/sibgU8Bvc3TL7RmATTzYy1rp3Svdt93N4snTRowhxp3R5FmE7omW0bI5a0C4UkNRo52a/u9a/CyFyFol9PQPc5y5SukCJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218770; c=relaxed/simple;
	bh=NMaiA8lPve8C0hOn7Vu5M7mV46pWuTlEE5RY1jrM3o4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k4amwBSqz1qxy8NTtlmPYF/odFX7Lqh0aCJR4RKStYxBWB6jn9QiLXlqik5y5kpmuyTBTgdz19FuZNZnOZdYXdVsSOoo82gplEhrQNUQiWMPa+lWa5eIJI/TXW8r7oBwmwaknt5Q40xa7h4rklM8fDjjj/XNhccozpn1Iz7zc1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aOhRpW/S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aOhRpW/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14E4C113CF;
	Tue, 26 Aug 2025 14:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218770;
	bh=NMaiA8lPve8C0hOn7Vu5M7mV46pWuTlEE5RY1jrM3o4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aOhRpW/SVtW5YJcyifnr5MARhWPx0HmymuaHI1CJoGcazUq3kMCowZ0SKtpUHol9W
	 c59wkKwPABC37ex+EEVp96VdD5qbheiNiTbqjX4lGDlPsjKjzIc4M2U2IkhY7jqQwt
	 CiaOy6Nq8lrFdeCmjLJTCWZ4HBvcpnighPPhv1vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 127/403] mtd: rawnand: atmel: Fix dma_mapping_error() address
Date: Tue, 26 Aug 2025 13:07:33 +0200
Message-ID: <20250826110910.248197283@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit e1e6b933c56b1e9fda93caa0b8bae39f3f421e5c ]

It seems like what was intended is to test if the dma_map of the
previous line failed but the wrong dma address was passed.

Fixes: f88fc122cc34 ("mtd: nand: Cleanup/rework the atmel_nand driver")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Rule: add
Link: https://lore.kernel.org/stable/20250702064515.18145-2-fourier.thomas%40gmail.com
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/atmel/nand-controller.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/atmel/nand-controller.c b/drivers/mtd/nand/raw/atmel/nand-controller.c
index 997910bec727..a54ad340f1e2 100644
--- a/drivers/mtd/nand/raw/atmel/nand-controller.c
+++ b/drivers/mtd/nand/raw/atmel/nand-controller.c
@@ -370,7 +370,7 @@ static int atmel_nand_dma_transfer(struct atmel_nand_controller *nc,
 	dma_cookie_t cookie;
 
 	buf_dma = dma_map_single(nc->dev, buf, len, dir);
-	if (dma_mapping_error(nc->dev, dev_dma)) {
+	if (dma_mapping_error(nc->dev, buf_dma)) {
 		dev_err(nc->dev,
 			"Failed to prepare a buffer for DMA access\n");
 		goto err;
-- 
2.39.5



