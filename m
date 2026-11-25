Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625064;
	b=E/fLNuEiODK13y0wniArNJIeUd3bnOEiz1pUFZSkh5Q0/8sbeyUBRwt6WJSXhX+d9rdS
	 /E/0xH+jqGoPesZXI4TxPWNnzY8ccAV6qlUJqQOyWV1PgFBq8UEVLT4vS0BzKzOxYyGxS
	 apNSqOtxhfTEnx4q/hOgmqpCEYuzIG+cG5daIxsBt3gGzBqj2B2wfZYcJrFWmcB4SdDPU
	 Yna1cf3N60wOkb7EbeLZepa4bdkJzeBMi4PyUS8tjIcccWzGjF3686n6rlIcMJNpwFlnc
	 IHmYg7rhJTrlt160aQpPlm93hgE3VZrTjabi4YVEtP5oIJRuAuysbFR0uJQdDDNh3wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625064;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X+OLY2iXAyhPrO5RNNQuz3aSwYvlBths6f5PMbVgyiw=;
	b=lmMlavShIsawWKZpV2AMNdLX8aiSpHJ2WCh0cNabaEB1pR6YJq8fIlS0HFhex4N9TQf1
	 x62FSr370smgy67L+14uDDVqsB61w2sFMT1JnSRX9sq6OMS6pv/QdrarSehkKUb7vVktp
	 cXTMV7WJY2QfaKwAfDlofH/87qxqmOsJS6j5e3wJT/EsaoOtBXseo8zQhO+BkoktMBJRe
	 /ZPgEn3j3jYTnH43u/hOqXznR6EGd9WFy2no/nD1fOhkx4VnVT8t8QZb2LUKregHie0VC
	 czwxcbV2ndfZO6kJ6xeXV2s2U3twUH6tGBOIJ2y/lV8s+RSiOlnJZREAXb+d7XAKwmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GggvLH8M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A4C606A32D;
	Wed, 25 Nov 2026 16:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GggvLH8M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5BA1F000C4;
	Wed, 25 Nov 2026 16:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625064;
	bh=X+OLY2iXAyhPrO5RNNQuz3aSwYvlBths6f5PMbVgyiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GggvLH8MgdZaf92WY721+Kf559xgmvDmxFLegr4qbo6NesI75t45AxBnZU74LQvb8
	 mH7qADWgRIdrYXnym1LLbucExutMLHDACZuI/tGw4GaRYoVSnEyOpG02TrP1BQ6U5c
	 5uDnw5LjSWQACh9roNsbYN/P0PVjXCOFQ6U5dKyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Golla Nagendra <nagendra.golla@amd.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 395/816] dmaengine: zynqmp_dma: Fix PM rollback on sw_desc_pool alloc failure
Date: Wed, 25 Nov 2026 15:32:23 +0100
Message-ID: <20261125143858.343097389@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Golla Nagendra <nagendra.golla@amd.com>

[ Upstream commit f2f44b952ea6e0c600e92ea21fcaa83cafeedf6e ]

If sw_desc_pool allocation fails after pm_runtime_resume_and_get()
succeeds in zynqmp_dma_alloc_chan_resources(), the error path returns
without dropping the runtime PM reference.

Route that failure path through err_pm so the runtime PM reference is
balanced before returning the error.

Fixes: 8982d48af36d ("dmaengine: zynqmp_dma: Fix PM reference leak in zynqmp_dma_alloc_chan_resourc()")
Signed-off-by: Golla Nagendra <nagendra.golla@amd.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260814045616.1661199-2-nagendra.golla@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
[ sashal: Kept this branch's older kcalloc() call instead of upstream's kzalloc_objs() context line, and applied the err_pm rollback change unchanged. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/zynqmp_dma.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/xilinx/zynqmp_dma.c b/drivers/dma/xilinx/zynqmp_dma.c
index 235c60e1e320e..594086b264941 100644
--- a/drivers/dma/xilinx/zynqmp_dma.c
+++ b/drivers/dma/xilinx/zynqmp_dma.c
@@ -484,8 +484,10 @@ static int zynqmp_dma_alloc_chan_resources(struct dma_chan *dchan)
 
 	chan->sw_desc_pool = kcalloc(ZYNQMP_DMA_NUM_DESCS, sizeof(*desc),
 				     GFP_KERNEL);
-	if (!chan->sw_desc_pool)
-		return -ENOMEM;
+	if (!chan->sw_desc_pool) {
+		ret = -ENOMEM;
+		goto err_pm;
+	}
 
 	chan->idle = true;
 	chan->desc_free_cnt = ZYNQMP_DMA_NUM_DESCS;
@@ -517,6 +519,10 @@ static int zynqmp_dma_alloc_chan_resources(struct dma_chan *dchan)
 	}
 
 	return ZYNQMP_DMA_NUM_DESCS;
+
+err_pm:
+	pm_runtime_put_autosuspend(chan->dev);
+	return ret;
 }
 
 /**
-- 
2.53.0



