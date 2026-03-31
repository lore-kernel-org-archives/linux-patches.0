Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B7E30C368;
	Tue, 31 Mar 2026 16:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974832; cv=none; b=BprDAuPNX74MSrjPFwfz4n1YJh0YeCa2xo6MF15/w4FMyPhCRT0IlpFRRdo50PfdTtNxLU/b+OUaX4Fkp1tDH605QYLskqcDBDZsrj2GeP82EAhZ+3KLmo2iYlUcRk4ePnYFQyLEiRyOjym67RQH6/D0DOAwGKiSqRrkDd4L7Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974832; c=relaxed/simple;
	bh=tXR6qTxd9KBXTyuDOeP3S6HCnNxOsdyMJULBoo5AuIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SzA8qmCJXZ3SDAzZzwy3dStA7c93QykPbeQb1Zcuc570wz8287K4NB4jPbAsjN7HuGn2R4UrLU8tmE3N4ZLMGLVYTG0Z4kHgT3ab1lWoVZWsPKz+yyqh+iz/QNv+EMbVUa5wG1c2ctjc37xq8Uqx4myRxeFI4oyfUAwH/a9xR9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tBUE12mg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tBUE12mg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F9BC19423;
	Tue, 31 Mar 2026 16:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974832;
	bh=tXR6qTxd9KBXTyuDOeP3S6HCnNxOsdyMJULBoo5AuIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tBUE12mgjZD0FXAHbgvhA6MSE/zKV03bepQubUf2yxlz0+8ipP6gXvVy5UlOibkbu
	 pUtYcOYJCficQrk3b7MRAHATAwO8APkDoyF0U4pTjoPMFG+FR+2tMZWlECIcYNlN1v
	 fyjMLDwN7Z73A2E5QempUcUQh5hMnf+3a2v+kCnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Yakovlev <vovchkir@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 054/342] spi: spi-dw-dma: fix print error log when wait finish transaction
Date: Tue, 31 Mar 2026 18:18:07 +0200
Message-ID: <20260331161800.887146041@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 65adec7c7524b..fe726b9b1780d 100644
--- a/drivers/spi/spi-dw-dma.c
+++ b/drivers/spi/spi-dw-dma.c
@@ -271,7 +271,7 @@ static int dw_spi_dma_wait(struct dw_spi *dws, unsigned int len, u32 speed)
 					 msecs_to_jiffies(ms));
 
 	if (ms == 0) {
-		dev_err(&dws->ctlr->cur_msg->spi->dev,
+		dev_err(&dws->ctlr->dev,
 			"DMA transaction timed out\n");
 		return -ETIMEDOUT;
 	}
-- 
2.51.0



