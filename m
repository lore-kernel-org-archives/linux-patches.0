Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0575717592;
	Tue, 30 Apr 2024 11:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476308; cv=none; b=S9r7vGZbL4J+yr/geF8Idtv7SueakKWofO5sEHxrR3YJqxI66dOuArwHhvF9/R3cfclmmkJ1bSFdtGSYI6g7x33a+BaOgZDZdDBmSAfdaPA7aYo3HxirHfZ2DtmaV7s+g75corCHRYmzhnNdnBwt1xrKIXPM2C4I7ABh9m4ApAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476308; c=relaxed/simple;
	bh=rMgRMbReZJ4SKrtFD7J/pEbF0mN+RvzUweNjfTWfH5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XAgkgWaOXIF/aukcwcdHYLP+SFUaJtw2Sdmkku8W9Kg6jn5Nw1CyEA5obn+wfJBPRbmOg+47DHq6lQu3BSL6k0KsF8PVlxr9ivo1UmCYcdknhdU3M5b68nVuO4r5QqxdcLfCD7U6AQZap9JTHmoBlur6JiYq0qYQSKoCy4eUi6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NqIdHto5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NqIdHto5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696E8C2BBFC;
	Tue, 30 Apr 2024 11:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476307;
	bh=rMgRMbReZJ4SKrtFD7J/pEbF0mN+RvzUweNjfTWfH5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NqIdHto528dBXfX3oeJCjFGtpsG661xFyC0Hj3btKkhdGl2lXoml7p7CQDZkMvyn3
	 Y8alJ4dthYi+6saKJ4qOnoS1UlMCKl8moEGl55kgXWfzcXMryiKvKgfd+ZlQuGdKvM
	 nYnAtrWFpCpq97HZkbbyGBqtKMy8cMAPwF7f1D7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Peter Korsgaard <peter@korsgaard.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 100/107] dmaengine: owl: fix register access functions
Date: Tue, 30 Apr 2024 12:41:00 +0200
Message-ID: <20240430103047.609775874@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index bb9c361e224bc..3e4ade21cf413 100644
--- a/drivers/dma/owl-dma.c
+++ b/drivers/dma/owl-dma.c
@@ -238,7 +238,7 @@ static void pchan_update(struct owl_dma_pchan *pchan, u32 reg,
 	else
 		regval &= ~val;
 
-	writel(val, pchan->base + reg);
+	writel(regval, pchan->base + reg);
 }
 
 static void pchan_writel(struct owl_dma_pchan *pchan, u32 reg, u32 data)
@@ -262,7 +262,7 @@ static void dma_update(struct owl_dma *od, u32 reg, u32 val, bool state)
 	else
 		regval &= ~val;
 
-	writel(val, od->base + reg);
+	writel(regval, od->base + reg);
 }
 
 static void dma_writel(struct owl_dma *od, u32 reg, u32 data)
-- 
2.43.0



