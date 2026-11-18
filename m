Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060402;
	b=vyPSsGQdIWzXMWm9JLhidc4jG9sr7VXaBfImdtRC6S91Xk7lN6OskhQWdc5REUOeSKHq
	 1wwunZS61rH63TtbSbA6GYXvdaS8M+HO1GqUltrGl7jVg0JPL114EOfSlYRd6hNKpUokv
	 avlbUJLFM8maG1mj4+LIn1EvCoEqHlXetrs1Gkw4JPRm7MSsOIQSPN++G0cXxY6dhLLUv
	 ClQ15X64qrRlvtvRpRpm5KMU2pBcAICtI7s5ctxhcC1km2m0BM/azXI/K4zn6EMoPXEqt
	 05GiLrf4qJXk0kVf/GEgOZXu6JGSaCVxwcCuEgaie7O04n5rmQU+qBCHLM4Qnt8NDEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060402;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IQP5zqcpi0SaisotWsy+P7lrh8QZdKLC4lSukx4WLgI=;
	b=IIwozgxxz58GiQ+QjvQH0eXYgKglMr9AJb6lLQgic6QSivB/ZYENyP6C3PEDP+0j9Kt9
	 d0nNs44k9sagGPJOkG+43zWHVH6dR21LO9P4chDvMeImi/W0Us54uGTPWW+xkNd1hEg1C
	 GAA59xe67cSAbBMJmFkPoGKYhihzVjV35Dg+m0MzA+WB6q7AHJeGz1d0ipDC5XOBYXfXr
	 VFCuFagPH6wIXJtaDi/UQRjaiQYM1Uj/TIeQP0AkJYyHy64WxHxusHEx+GdSZEyRKfaMh
	 up1ZAicGcJCW/KEX5kEHZB7deq50Ui6FG9Tid1VH+eWXfV6r/mDOJUDeqeMIbKcBL8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iNrys4hM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554B8606A320;
	Thu, 19 Nov 2026 03:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iNrys4hM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753B91F000C4;
	Thu, 19 Nov 2026 03:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060402;
	bh=IQP5zqcpi0SaisotWsy+P7lrh8QZdKLC4lSukx4WLgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iNrys4hMxkQwFwLuvvEMeFruP/wM9sceMABHceM9Ix3ZrgyUg7oS14wkfnnBC+Ftq
	 Ag3WkB7oMPGNyJTo+LSwbhgKGiJcS4pU4oxRHj+X+g1dlwsWdoNFo30N2EETPYj+Js
	 00JzgU8RJJKTMj59X+OO9tCUteEINzWZiEgrpBZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1185/1848] dmaengine: img-mdc: Fix runtime PM usage counter leak
Date: Wed, 18 Nov 2026 15:53:43 +0100
Message-ID: <20261118150009.136102921@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 4a1a2d8b8529cc569b769b92fcd71c53805cbeb2 ]

pm_runtime_get_sync() leaves the IMG MDC device's usage counter
incremented when runtime resume fails. mdc_alloc_chan_resources() returns
that error to the DMA core, so the channel's client count is not
incremented and mdc_free_chan_resources() is not called to drop the
reference. Repeated allocation attempts can therefore accumulate usage
references and prevent runtime suspend.

Use pm_runtime_resume_and_get() so a failed resume does not retain a
usage reference while successful allocations remain paired with
mdc_free_chan_resources(). DMA core only treats negative return values as
allocation failures, so the helper's zero success return preserves
behavior.

This issue was found by a static analysis checker and confirmed by manual
source review.

Fixes: 56d355e6f586 ("dmaengine: img-mdc: Add runtime PM")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260813153143.3953303-1-ruoyuw560@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/img-mdc-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/img-mdc-dma.c b/drivers/dma/img-mdc-dma.c
index e4ea107ce78cd..fcc124e3e040a 100644
--- a/drivers/dma/img-mdc-dma.c
+++ b/drivers/dma/img-mdc-dma.c
@@ -739,7 +739,7 @@ static int mdc_alloc_chan_resources(struct dma_chan *chan)
 	struct mdc_chan *mchan = to_mdc_chan(chan);
 	struct device *dev = mdma2dev(mchan->mdma);
 
-	return pm_runtime_get_sync(dev);
+	return pm_runtime_resume_and_get(dev);
 }
 
 static void mdc_free_chan_resources(struct dma_chan *chan)
-- 
2.53.0



