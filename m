Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C272FE56B;
	Tue, 12 Aug 2025 18:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021648; cv=none; b=M+N5g/mPrzZa/PauZiHbRNX7LfUQkcncWZHHNljy/d2AuSbDdoRzyvticCJMnpqXjr5MxAU4v0x7wVTT0G1WeuB9pHF2T5sJFKoDgIexL1sK8JflGOautSY8/yY7Yl4nAYdKBYdKJIfqfhbtGxB/wE5c+k4EKvZiKH37/8jdv3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021648; c=relaxed/simple;
	bh=q1kmf0i1xPAW0uMuM5F08Z0H/7zookg53dw4Pkal9Mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apvK/15na4RuEJFMaAGT4FgtkA8z8mq8orf22Chs8vyC6t6dujkUQ5h7L4v/vhzu6yNEUXLGUO5ssAdqqrVPCof90WiTa7odK1lmJ6jJ13mR47CFCiguvWpT4CCjGTgHwqkfJzWCuL+de7mXEBX9i3wpJJN1JepLQJ50s/7xhYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=co4CJG8i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="co4CJG8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3813BC4CEF0;
	Tue, 12 Aug 2025 18:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021648;
	bh=q1kmf0i1xPAW0uMuM5F08Z0H/7zookg53dw4Pkal9Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=co4CJG8idtsZPTmqonTE0B+xPQQRuPjm4ohmBomPFk3oZ8mXgb9LIqmBINay6z8pU
	 lRH86OvPynndj0MivLaaVZ1hLcNZLlsu9KWEvtJYo7BOmGBmNaJYpw1rgntebupCRN
	 QmWmgosNUocwp6HoqARIhU7K+fqUoUMYhKFusvkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 156/262] mtd: rawnand: atmel: Fix dma_mapping_error() address
Date: Tue, 12 Aug 2025 19:29:04 +0200
Message-ID: <20250812172959.744754752@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3f494f7c7ecb..d4fd1302008e 100644
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



