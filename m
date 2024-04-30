Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52A612D209;
	Tue, 30 Apr 2024 11:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475755; cv=none; b=g+euNloa5UVITbxUHjoPskSjmo84GB3o44CDHS+8L5MfKn/1incoy2FYdH1kxkljGszEchhMEZ6BdGPAcok3O2sgjULLaA6kQmxvN+XzGO+Kafbskiy5SJZ1TixxKP3fEoCcgyNT+UKpqWcB4MFDDJKIz0XAQWIGH47VlbigyiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475755; c=relaxed/simple;
	bh=yoEf/jLkskwEwiUGktfhWNELYT8knpZ8ZgCjdMamZBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yf6ttyCwQYkaO3YEDWXTlQ/1O2OwCh9z0jJNN5v6qQBlpz8X6d55Uyby1RZl1pmMuSOgH2tli7RKBT74dEJLpIbiBFy+C34CUcx8byqv23aDiqcEiVGQYG8rblScXgWm5jYJjc/uAoPWvxTWeQkgNx7VHTBN9LP8wy6+xFV8SEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h2fL8qBV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h2fL8qBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD01C2BBFC;
	Tue, 30 Apr 2024 11:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475755;
	bh=yoEf/jLkskwEwiUGktfhWNELYT8knpZ8ZgCjdMamZBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h2fL8qBVnLqZ9fLHhkjLK74qlv80NqrUFOFCxPFPgZCnq5KY/25b/yFYGRdF+TXDq
	 8LaG0IVfB5yW6yzv70pK0Tw1u0CnJd6IprvtR7yoC3HScV2JTsp9fecrc0ouJLGasI
	 s6iCMwvVaMqzaZ+wfVr7TnWSn1FoXibg0fHKVCyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Peter Korsgaard <peter@korsgaard.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 158/186] dmaengine: owl: fix register access functions
Date: Tue, 30 Apr 2024 12:40:10 +0200
Message-ID: <20240430103102.620125596@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 43c633ef93a5d293c96ebcedb40130df13128428 ]

When building with 'make W=1', clang notices that the computed register
values are never actually written back but instead the wrong variable
is set:

drivers/dma/owl-dma.c:244:6: error: variable 'regval' set but not used [-Werror,-Wunused-but-set-variable]
  244 |         u32 regval;
      |             ^
drivers/dma/owl-dma.c:268:6: error: variable 'regval' set but not used [-Werror,-Wunused-but-set-variable]
  268 |         u32 regval;
      |             ^

Change these to what was most likely intended.

Fixes: 47e20577c24d ("dmaengine: Add Actions Semi Owl family S900 DMA driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Peter Korsgaard <peter@korsgaard.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20240322132116.906475-1-arnd@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/owl-dma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/owl-dma.c b/drivers/dma/owl-dma.c
index 384476757c5e3..3bcf73ef69dc7 100644
--- a/drivers/dma/owl-dma.c
+++ b/drivers/dma/owl-dma.c
@@ -250,7 +250,7 @@ static void pchan_update(struct owl_dma_pchan *pchan, u32 reg,
 	else
 		regval &= ~val;
 
-	writel(val, pchan->base + reg);
+	writel(regval, pchan->base + reg);
 }
 
 static void pchan_writel(struct owl_dma_pchan *pchan, u32 reg, u32 data)
@@ -274,7 +274,7 @@ static void dma_update(struct owl_dma *od, u32 reg, u32 val, bool state)
 	else
 		regval &= ~val;
 
-	writel(val, od->base + reg);
+	writel(regval, od->base + reg);
 }
 
 static void dma_writel(struct owl_dma *od, u32 reg, u32 data)
-- 
2.43.0



