Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C846812C487;
	Tue, 30 Apr 2024 10:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473880; cv=none; b=ANz1J8pJ/11o/pZGDdgumuzgIi1EJMSwh2Ynnpks/YBjcV/eRIyGZGxW+vALEW4k6vq6c/pyrCKu9vmv7mDyEvqc6XFfbeLvQGzKYYlt6BNCZG/oiq8zcUC6Wj3Gq2RYhSfMMsUdsr1kkj5WG0driysRgZaZcp6AMLQdQXr3JSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473880; c=relaxed/simple;
	bh=4uO/oMX7byzZBqIcvKa818s368Ea7A8uA86QpxkVCIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bMb8e5Xwxh17XxWs2wJz5wXEGzQeEkRfzp+iJXUgHXtI/HKo0XqKu8x1pXVDVF/gjW6LnNQD5x67N2fOR4iVIBiKHUo8g6XQW9jPeqQwww+HuulW8eOatDU4kNXMHSF0x3NSyuvJsIBDTlBb6YjnqIHZSCPF7EFRCZtyBLhUSAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hDvcYrNU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDvcYrNU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489E2C2BBFC;
	Tue, 30 Apr 2024 10:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473880;
	bh=4uO/oMX7byzZBqIcvKa818s368Ea7A8uA86QpxkVCIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hDvcYrNUrF8MUmWX1+Mgx2c3jLpf0iXdUwOMCINdvGfQiSo0P5y2IknRYNn/z+Eqg
	 bbhvzRrO00ayTahtq2MSnoMGcYsYv8/AmIO7yhUXEDcankis+BqhmI2nlFN12Pgc6O
	 k4ChjCV7zpCUEDfY52w/Cb7lFc0+gsZqQgdeiC0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Peter Korsgaard <peter@korsgaard.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 70/77] dmaengine: owl: fix register access functions
Date: Tue, 30 Apr 2024 12:39:49 +0200
Message-ID: <20240430103043.205649839@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index da5050ab7f387..c12968075abc9 100644
--- a/drivers/dma/owl-dma.c
+++ b/drivers/dma/owl-dma.c
@@ -230,7 +230,7 @@ static void pchan_update(struct owl_dma_pchan *pchan, u32 reg,
 	else
 		regval &= ~val;
 
-	writel(val, pchan->base + reg);
+	writel(regval, pchan->base + reg);
 }
 
 static void pchan_writel(struct owl_dma_pchan *pchan, u32 reg, u32 data)
@@ -254,7 +254,7 @@ static void dma_update(struct owl_dma *od, u32 reg, u32 val, bool state)
 	else
 		regval &= ~val;
 
-	writel(val, od->base + reg);
+	writel(regval, od->base + reg);
 }
 
 static void dma_writel(struct owl_dma *od, u32 reg, u32 data)
-- 
2.43.0



