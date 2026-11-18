Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039563;
	b=Xk8fbVTpIg654PU6VGZop28IrDdIE0tJZFxm+SeDpDwyzpGxmBRKIzuEfjTTIH73eQLe
	 kx/OkX2ws9ZaPkv6ETg0VUZ/vD2yavQxUfk9OttG5JuYSqcrF3Nd3w5JNMpT30gWmG9uG
	 yj2p+0Sv7hcsShRuL6kaN8N2RfFDix+MxAHhJ5RjJ/SESf7s9THWc6q/sscAQ743Bj1pT
	 gFcllAm2BvF/XuTbYnn9rSOTGL5zunPO5SuNYZzUa/CglCwBrbA9i3zyn0mgdzAqHkq+6
	 71R3TsbklfP1tnCFPo2b1VXpaNdQYKkKYbQFSrIRZ7K6FcCFy9JQGZIoboAz479mtuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039563;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QNNVyP1FOeUYg3lMko0r51I9bEBRRWD+CnMkrRyQvtE=;
	b=X3sPQnGbGYf2DwPW8W98WSOmKTEWmd5CGVlgRihDUkygDMme8JjBgxCh8VD5AqKrfsKv
	 wW3OADsGWo7Y0MBI02XX4I7o4QG0zHR8H4/NHNrotejJkhpXOy7/jngOCQ5G6TlQ1gK3t
	 HHMIuWog8CIDYjX2qfZyWSo55nAC2LlU4/UQPMrYxUZGgkdu6sdjtkjhuSTi/pZpBxYYv
	 Rpx8k2qeqfkvLBHcHnr5zCJBi1uv150Qqxd4MgsOzbxIwkhsEWBM66WaCYJ2S8HzM8g1A
	 K+2OsedPsyoxRiLbUrAGCO00uZXTMxVnW/16OIiMRm3LOujAoS/XsnNLr0DI0lY7D6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ikNz4A2n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40604606A320;
	Wed, 18 Nov 2026 22:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ikNz4A2n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12971F000C4;
	Wed, 18 Nov 2026 22:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039563;
	bh=QNNVyP1FOeUYg3lMko0r51I9bEBRRWD+CnMkrRyQvtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ikNz4A2nh1TWzrCY1i2MIMV3iJ0yOnyrr8aCT9ob0buQCZV6v/ZCHKNsYEuLAJnRs
	 OWsVwNV5psf+fsm7CPAZowlDPxLVmzmIoKkgYDMfheZGH+p6ScQww1BOVKZR/5DAFe
	 tyehhXuwsFrdLdYKA7iP6S7IizSswbmx2e1e1C8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2093/3318] dmaengine: img-mdc: Fix runtime PM usage counter leak
Date: Wed, 18 Nov 2026 15:45:15 +0100
Message-ID: <20261118150424.885400154@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9be0d3226e199..159ddf5bb81d0 100644
--- a/drivers/dma/img-mdc-dma.c
+++ b/drivers/dma/img-mdc-dma.c
@@ -738,7 +738,7 @@ static int mdc_alloc_chan_resources(struct dma_chan *chan)
 	struct mdc_chan *mchan = to_mdc_chan(chan);
 	struct device *dev = mdma2dev(mchan->mdma);
 
-	return pm_runtime_get_sync(dev);
+	return pm_runtime_resume_and_get(dev);
 }
 
 static void mdc_free_chan_resources(struct dma_chan *chan)
-- 
2.53.0



