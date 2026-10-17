Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062903CB2F6;
	Sat, 17 Oct 2026 17:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258422; cv=none; b=VeI3ZAVBZ3X1SIpnB7QTiAQVQlvrOxdh75xqz2ZUW9tQP1gF0DTyJJQbiRSEyR5UWSgnnuuRRAz7PZY769TL4bHo5SS3I24ZH3HytPhqlxAzhc+jPf2k1E6xAhM8tcoXVxDzNBfqJaBtGP17LfDBrtlG2EjEVw91qscCthCy0Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258422; c=relaxed/simple;
	bh=B02md2gKobO+Xjrr67JYGkm26Kl83P8NsHtK3saHBDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mM97QSuZIjeu33c0u2uOxEAZNGIhZPxS9iy3R0fnG+ihR3Ux6MsTp4x+GzLfdYLvxXe0YprCp9RzLK++5FyN7CtjceQp2cEdRnA4Nvf0J1z8WYq1o8pIGFvjeJy2qeS3qz3KWGQvh+IDHXJVNYc6EPQ67vmp7yCdL483TYZpm70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rSwE7bbL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSwE7bbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5901F000C4;
	Sat, 17 Oct 2026 17:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258421;
	bh=gLM13NAMrf1NoT0Oz8cqF/wn9rQyMiLfSxQW3NgnZD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rSwE7bbLcXyzezOSo0RWFjR+nq1xbl9B71mPW19HYM5z0KeHI+0A+vwVPWtdNzg7U
	 Jz9W2rTnXeFsEJL8W7Wp3WxRcpudpjv3CyGuAy4aDnAlEPMjlpkZ2MZbEbF2AzBw8a
	 5WJqB4xeCJZDrE4zX1I1XhZKynqz8DW3UVGTbRBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Yakovlev <vovchkir@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0878/1674] spi: spi-dw-dma: fix print error log when wait finish transaction
Date: Sat, 17 Oct 2026 17:52:30 +0200
Message-ID: <20261017160453.653271105@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Vladimir Yakovlev <vovchkir@gmail.com>

[ Upstream commit 3b46d61890632c8f8b117147b6923bff4b42ccb7 ]

If an error occurs, the device may not have a current message. In this
case, the system will crash.

In this case, it's better to use dev from the struct ctlr (struct spi_controller*).

Signed-off-by: Vladimir Yakovlev <vovchkir@gmail.com>
Link: https://patch.msgid.link/20260302222017.992228-2-vovchkir@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-dw-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-dw-dma.c b/drivers/spi/spi-dw-dma.c
index 96fe5fd0228ee..62fb031ada30f 100644
--- a/drivers/spi/spi-dw-dma.c
+++ b/drivers/spi/spi-dw-dma.c
@@ -271,7 +271,7 @@ static int dw_spi_dma_wait(struct dw_spi *dws, unsigned int len, u32 speed)
 					 msecs_to_jiffies(ms));
 
 	if (ms == 0) {
-		dev_err(&dws->host->cur_msg->spi->dev,
+		dev_err(&dws->host->dev,
 			"DMA transaction timed out\n");
 		return -ETIMEDOUT;
 	}
-- 
2.53.0



