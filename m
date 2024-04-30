Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2BB12C801;
	Tue, 30 Apr 2024 11:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475130; cv=none; b=V0BEo2SMim7y2wZrqwJEJUCrtynhzeY76KxxSt5TTIzG/TdsbUGgkiv2lvOAYFm6IIn6P9TUfhSIu6qtBk8NT42dEZcxVz2ie/zp/LCZZ2EdgJMGDTskYLzm61vaYNG7OuOZXaSX0asqcmsbq/whGWMsajWyj21ukvPFo4VJqGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475130; c=relaxed/simple;
	bh=iB59wscB3ghAW2/pvLhZC229GDMrFl0RROsb7iBwKT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KL9CZZX0XwyhdDJN3VS4sN819dIjm8n3UK6fqVhDq0+VAu9H1tAKeYf4KvdfAdHXi8bnNSAPcd9VUp93X7IQK8GySjX5EO0WaTGgqWVQsiQvDF2sfFHcg/kmPhWah6ZPa2sr5s59iFkF5bRnzb4q4QxgzwS8nUbjhj2YGrw4X8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/OD/j5c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/OD/j5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733F1C2BBFC;
	Tue, 30 Apr 2024 11:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475129;
	bh=iB59wscB3ghAW2/pvLhZC229GDMrFl0RROsb7iBwKT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y/OD/j5cmbid4XTWGcH4HT5GCGbor0QplCjrh1f5yO5Le7OHGQI6oC0KTAe/PBYpg
	 dmFg1W0KfYml2yYaFmia8r/NncOuodsarO+wd0//trzwnbgC1zNgdUPLjkV7Vmsw2s
	 Px6z1FInkoGDc0XyvWxictHqmZdOO3sn7H/EyrlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Peter Korsgaard <peter@korsgaard.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 128/138] dmaengine: owl: fix register access functions
Date: Tue, 30 Apr 2024 12:40:13 +0200
Message-ID: <20240430103053.170724812@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 04202d75f4eed..695feb3443d80 100644
--- a/drivers/dma/owl-dma.c
+++ b/drivers/dma/owl-dma.c
@@ -249,7 +249,7 @@ static void pchan_update(struct owl_dma_pchan *pchan, u32 reg,
 	else
 		regval &= ~val;
 
-	writel(val, pchan->base + reg);
+	writel(regval, pchan->base + reg);
 }
 
 static void pchan_writel(struct owl_dma_pchan *pchan, u32 reg, u32 data)
@@ -273,7 +273,7 @@ static void dma_update(struct owl_dma *od, u32 reg, u32 val, bool state)
 	else
 		regval &= ~val;
 
-	writel(val, od->base + reg);
+	writel(regval, od->base + reg);
 }
 
 static void dma_writel(struct owl_dma *od, u32 reg, u32 data)
-- 
2.43.0



