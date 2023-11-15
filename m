Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D00C3DBAF
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oyZD6mzm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BA4C433C9;
	Wed, 15 Nov 2023 20:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078400;
	bh=0BwuQrU7f+mnwFRQqIXGI+MaRBucOa4q/GiHgYm3/YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oyZD6mzmjwOi3ZsaMhd1da3DDMCC3RdzGZ5YI8yhXuxGtwI6DQB/6tiumHh9oRU3i
	 77xFOWp4BZSq5EXAr64ZZxcd5nQBGXVY0gEefRZbf93Ra7QiLMiru7KHG1iYeisBc6
	 MCKm62T2Y5FSWWBkNXDyegWr2+71Tg/46tioEPII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 275/379] dmaengine: pxa_dma: Remove an erroneous BUG_ON() in pxad_free_desc()
Date: Wed, 15 Nov 2023 14:25:50 -0500
Message-ID: <20231115192701.380042493@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 83c761f568733277ce1f7eb9dc9e890649c29a8c ]

If pxad_alloc_desc() fails on the first dma_pool_alloc() call, then
sw_desc->nb_desc is zero.
In such a case pxad_free_desc() is called and it will BUG_ON().

Remove this erroneous BUG_ON().

It is also useless, because if "sw_desc->nb_desc == 0", then, on the first
iteration of the for loop, i is -1 and the loop will not be executed.
(both i and sw_desc->nb_desc are 'int')

Fixes: a57e16cf0333 ("dmaengine: pxa: add pxa dmaengine driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/c8fc5563c9593c914fde41f0f7d1489a21b45a9a.1696676782.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/pxa_dma.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/dma/pxa_dma.c b/drivers/dma/pxa_dma.c
index 22a392fe6d32b..04c1f2ee874a5 100644
--- a/drivers/dma/pxa_dma.c
+++ b/drivers/dma/pxa_dma.c
@@ -722,7 +722,6 @@ static void pxad_free_desc(struct virt_dma_desc *vd)
 	dma_addr_t dma;
 	struct pxad_desc_sw *sw_desc = to_pxad_sw_desc(vd);
 
-	BUG_ON(sw_desc->nb_desc == 0);
 	for (i = sw_desc->nb_desc - 1; i >= 0; i--) {
 		if (i > 0)
 			dma = sw_desc->hw_desc[i - 1]->ddadr;
-- 
2.42.0



