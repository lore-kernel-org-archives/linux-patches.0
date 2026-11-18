Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047956;
	b=lyae9/3ujPpJni5P1vZoKxe/cGcCC845yrOI+qB5UgMnOKF94ENl8AXTYBWHTJwsqMdx
	 1N2vb76QlSciHJkI6oMic1M1WabUoDIcqNS0dWlalxJm0Yfqn3I4oxmISZexuxEf4HB65
	 6QtabtQKNfBshRjxc4A1Eh4nUxoqJ1VyW2WcYoakZhoJB45CZ6f/9Cc2H15D52wvRIXLF
	 +jmtgpWn2bIrZWpxp5X5EwYethNWfd7PgEdbKdeUHvyREPIQNIygxFIVNuTGV/z9Vy3Z+
	 Txdy+ys9qp8hBxarUQUvucpziPgUgvBLrlp0UGy2he7pdQ2yMLxIumF0fCKlKMF86BQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047956;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GHBoAJXr5P0SrhRg43yA31W4Y+r+6p6Gsmxpyf5f7bA=;
	b=o6jsHXbfUOX6IAT2Kiakn2KdMhIOrybWt7UJ0GGwa1Kbenxc7ZzBtXw3597buepnTma8
	 Q5yaIseQqQouZlhOykDgxhr7CtNEF7xdlmCN51A9MplWBteZR8csiIWysBC56B+7h3AIH
	 xiGts0ItAMbZU+66AdtGA95Rz9q7IsKF20MYxVO2tB13kCHrfhOcwpawqVMvJ47R8pAMx
	 h24e18H5wwU176lH6bXmmswg75dSW768Z3oVlIRM9aGmkAyq7KDi3vNkOCID5rdjIj4HI
	 Dtm0/gWiXnaCWLqesJZkvqEw5C4rVurbphP76M+Fv7frlhexYkrcZBnNtViQW8OEr2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=icrvHYVw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BDE606A31C;
	Thu, 19 Nov 2026 00:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=icrvHYVw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5011F000C4;
	Thu, 19 Nov 2026 00:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047956;
	bh=GHBoAJXr5P0SrhRg43yA31W4Y+r+6p6Gsmxpyf5f7bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=icrvHYVw8Hrkgj2KU0yleK3bY4G7x9Gm4VkGNYioaB9eIATi4kHMFmcgscxUXWAAB
	 ViL1d6hqWEQT9dKykcRrNEC2Nc/qob+QOT4Z8zMQAND6wyVnQ3lDg3Z21I8fq8vPe8
	 4oqPAr45rS7EKBPxclaccVl4RNg1PiFzyirM0mA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1824/2857] dmaengine: img-mdc: Fix runtime PM usage counter leak
Date: Wed, 18 Nov 2026 15:47:38 +0100
Message-ID: <20261118150306.938879247@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



