Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054812;
	b=W/AXPRuY7w8e48qTJHVB2mq60HGMvASnKug99jfeWGzBMK1jWh1E/CHzgkqEeE1Cet/n
	 9mjvzFmxY6ae89LQJqv4hjHAKJM3GdaIEclgXwhPDXUAH8OIp1V14vNhlBTufeWjluTpg
	 yEckxA7XmDJDHDbSdh9YLclfDuWoLjWkTHRkpQpL15bZSUOgVRcGOI2my8hAkpkTrB0fj
	 nwarT/GBIXDy3y1Ue5U0cq+BeMcKL/e0N10OcgFdrVaiDOkvxgHqkkocdF9/oP9oihtcq
	 8qnCeIJscZPryuOyB1kJqay6/pUPsYuPUcsI1aVQ+InOwAfzU0NIE0uiV8yg5BUs5xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054812;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bW67o9fJ1Es/hJLo2EbpUUsdWa3xP6NcDWQPwbMXwyA=;
	b=G594hkn75qUiw2qwX7yYwkHGqxxZlvIyUMNtTUARUjH4NfE/tHPeXv6yG9zWyo/6ZYuf
	 pwUNVJOzxH6ETUvFBl2oV5z4DXOBDTH6EDw3suUyc83Q+eqd79V69K1qEjprCApG4carE
	 3SVq84zUyXMOgRB20VgmGRLUTSVWLEBc60OYMEI1ZBXf7C30XQKgsklB18UEK0Ens/6V4
	 pGSdg6nEMYoVn2UgorEy1eQSA+F5B6LdSFGHG4lVtJRYcxYVYytCdOU/ZwbkGRag+iiRd
	 4FMGMEhiRWpui6M+zyid2WZcxA27liRaOImQ4jEXXH3dsEAV/sRqJyqJTcdaDnDDRCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N9yK2TXm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90EB6606A320;
	Thu, 19 Nov 2026 02:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N9yK2TXm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CC91F000C7;
	Thu, 19 Nov 2026 02:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054812;
	bh=bW67o9fJ1Es/hJLo2EbpUUsdWa3xP6NcDWQPwbMXwyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N9yK2TXmF1lZvW+ccNPl5euKsW6DqWXPA5R0Yf46w72l1A68p7q4RgWrGQ9O6kqWc
	 wqUy7htKIucs6/OSiLEeGzTKr0zum4yJjwm4ozUjpkqJANKPuUlaW+jWHXsHvHoKbD
	 6riCliz+/m4r5uFwNqElEomGRcILwjdR8WaXc6oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1407/2214] dmaengine: img-mdc: Fix runtime PM usage counter leak
Date: Wed, 18 Nov 2026 15:51:23 +0100
Message-ID: <20261118150107.551893673@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



