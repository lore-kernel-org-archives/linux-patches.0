Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92A32E3B06;
	Tue, 12 Aug 2025 18:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022671; cv=none; b=dsyiOXjzUhPxdMouzalpVu2SLnUcdE1Iag/lwo+VaQWE2Dchx7yNUWc/xhsFLqYqWtOkQyG2uZk++gohCJDI8OAdREHVYe0v5b3pZ+M3BsKrrP3KXJV6VTYDKceLYfwpJuBf3czogXunFnJd23Qg2K4ZoSSOF1P10+eSBAqAQDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022671; c=relaxed/simple;
	bh=yljkFY5qh9NcIryY9Hrh+cWo58atkLae5TZAZ2RdMwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYWj3BhuKECZhToF/LmyuPyfdY+QW3wVRTOclkn21CajLWNBawOe4Owt8fwH9/W76+TpUlp2jkd6vMGVZ8XB0q9rXocYhK6HOYmnRKF/3dsS8zoRjgoDy1VnfLXPTWSFNeBE6u2n5xUW/1K1KcIE+2X/oh1veKD8hO+mR/QDr9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wRWOEmig; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wRWOEmig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B11C4CEF0;
	Tue, 12 Aug 2025 18:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022671;
	bh=yljkFY5qh9NcIryY9Hrh+cWo58atkLae5TZAZ2RdMwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wRWOEmignJPSpAySywuwqqpKJcfWDFfgCD468IswSMM+Ot9Y3IrK0ylgyW39nJben
	 5jlatDiLB64VQoHZW8jeSTZZgaIbtm9lqPpF8vc1sxF/eAL6HWfu1Kq6rM/AH5YauM
	 UiqC5uo+XVrrY/fht0uAz4lCI7aDMTJHe3tnL70k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 225/369] mtd: rawnand: atmel: Fix dma_mapping_error() address
Date: Tue, 12 Aug 2025 19:28:42 +0200
Message-ID: <20250812173023.221104674@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f9ccfd02e804..6f8eb7fa4c59 100644
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



