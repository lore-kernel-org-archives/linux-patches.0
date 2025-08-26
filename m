Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D401DE8BE;
	Tue, 26 Aug 2025 14:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217439; cv=none; b=SnKN96WFypoFaeSXDuLp3vZ+5U3wYLOpZf3UZdJltIDFPEAa4h/XQWTKUhDNoS4Rh1y0ccWMt4XDz18vAwflTKE1eEMWS/o9scHv/+aDmiLn6LhmTG4EgsMUFUnAaq5H8De96p7deeSmqXFnmXHLLTGCu+hkbfJ5/3HadLbIZyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217439; c=relaxed/simple;
	bh=KNZP8Oz79PgMJjvvr4eixlvfuaemHdd4FWPAuezlf1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LTpN8qs53WkqPIXzidB7dYR9f9cjJJnT+NZ+AdzLLywYyqfxI5R9r9g6m2es0ppgUNnKZ6YAnP+8h/6+hJ0Gpw5dWepGySjn3UiajCSX5RUWmP4uWAPLIzE7Ql996n+2eyMgMP7SMUi9jNlXrJiXmZT444TqbBmy5T9bCWUYeOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bm5+FxEa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bm5+FxEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F789C116B1;
	Tue, 26 Aug 2025 14:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217439;
	bh=KNZP8Oz79PgMJjvvr4eixlvfuaemHdd4FWPAuezlf1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bm5+FxEaCJZUJ82hK4LlEi9q2hg/wtm9ES16qOsRL5U9s69oF3PKsq/JK58RZWE5k
	 4ohpkue6dollm4yiPKkP1HXS+dE+D/tOoxYcA22gssTk9goBL/Wbk1FGmi9YNFh4rq
	 OI6dGCABPVsXN1dAHVZNckrI0uwYIH+6mbKc20xE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 144/523] mtd: rawnand: atmel: Fix dma_mapping_error() address
Date: Tue, 26 Aug 2025 13:05:54 +0200
Message-ID: <20250826110928.044621843@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0d84f8156d8e..3468cc329399 100644
--- a/drivers/mtd/nand/raw/atmel/nand-controller.c
+++ b/drivers/mtd/nand/raw/atmel/nand-controller.c
@@ -373,7 +373,7 @@ static int atmel_nand_dma_transfer(struct atmel_nand_controller *nc,
 	dma_cookie_t cookie;
 
 	buf_dma = dma_map_single(nc->dev, buf, len, dir);
-	if (dma_mapping_error(nc->dev, dev_dma)) {
+	if (dma_mapping_error(nc->dev, buf_dma)) {
 		dev_err(nc->dev,
 			"Failed to prepare a buffer for DMA access\n");
 		goto err;
-- 
2.39.5



