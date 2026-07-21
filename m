Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03651415F02;
	Tue, 21 Jul 2026 18:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657088; cv=none; b=b2Oue0AyVa5UjxJEdUvlOklh13RM/rtxDGepPdwAPDz/q9r9YRO2ve48hIRiVEFYdrvpc8p6djxIShrSgDxZGVmecXzPjg0tMv2QKRgpMEHRju6ESA36A/xeaLtJTB0Zf8PFd1hM1vdQ3jHbLK1yoJSB2sJo2xMAf6kpKwljuBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657088; c=relaxed/simple;
	bh=g/KagMm92wr4h/MEQFPcxycRkLsZhiAyijQcT2x9d9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IBWE5miwqIB26vIR9CHky6Nxi2bedUSbw9frgSAl2TPIjpZwM30wHXh9hardVd5Ly4SKjf7chz5dc43R3ANJXNZ4N94NaaaH3DMz56T+7O+MZUJHRtvrOyn6chKWk9wVBH2XOMu3CDuX2y9DdRPywo+sHlJ8Bt6ICBmzo41Ch84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JSnVgQlA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JSnVgQlA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6978B1F000E9;
	Tue, 21 Jul 2026 18:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657086;
	bh=B4yc/xnSGENorHHDtA//iKlrQlaefPrNLiOrKs4xlmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JSnVgQlAgeII0F5E4thb6c1Vp53ZQji8p11aE69qJluokjL02DqdaAtnYmodpAtQE
	 h7zAJh16iTPvePy/BovDu/s9fYW2KVxZUArnd2BxdfFtIsayfGKXjvgtpNyr+jT5Lx
	 v4X53V5mC8GVSE1ebFWonT5+YTLpkMr5i4ytLoQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0632/1611] dmaengine: imx-sdma: Refine spba bus searching in probe
Date: Tue, 21 Jul 2026 17:12:28 +0200
Message-ID: <20260721152529.603752453@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit d52d42e2e5d9f13166e81ac837ebb023d1306e61 ]

There are multi spba-busses for i.MX8M* platforms, if only search for
the first spba-bus in DT, the found spba-bus may not the real bus of
audio devices, which cause issue for sdma p2p case, as the sdma p2p
script presently does not deal with the transactions involving two devices
connected to the AIPS bus.

Search the SDMA parent node first, which should be the AIPS bus, then
search the child node whose compatible string is spba-bus under that AIPS
bus for the above multi spba-busses case.

Fixes: 8391ecf465ec ("dmaengine: imx-sdma: Add device to device support")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260407032755.2758049-1-shengjiu.wang@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/imx-sdma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index ed9e56de5a9b94..b04d3218ddc90e 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -2376,7 +2376,9 @@ static int sdma_probe(struct platform_device *pdev)
 			goto err_register;
 		}
 
-		spba_bus = of_find_compatible_node(NULL, NULL, "fsl,spba-bus");
+		struct device_node *sdma_parent_np __free(device_node) = of_get_parent(np);
+
+		spba_bus = of_get_compatible_child(sdma_parent_np, "fsl,spba-bus");
 		ret = of_address_to_resource(spba_bus, 0, &spba_res);
 		if (!ret) {
 			sdma->spba_start_addr = spba_res.start;
-- 
2.53.0



