Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50CF4071E3;
	Tue, 21 Jul 2026 19:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660410; cv=none; b=a2Q62Wp3LRhr9vBJ+vpSWiUiAgS4Vs9khU0twXGrhw46mAj8xjF4Uq6175wO/RPUyCkSyAptIRmNm+25TKPIDWBtkcfjamYlC19YeYFhR73zUFlQ5Dmcymd1oqeVQEpRr+GSk9Rm0tWkMvNE3LBGOqAbb+RiqNeOTp9BmNk6xhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660410; c=relaxed/simple;
	bh=JX5mXPKMSOyE9vvI2qTHcLSToNYrkGICCrMgYP9OR80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lTwXgHsQ29DcviDosMZ1e6S2tWBJMSaE4520ek+UM8jIU1FELPYyuVPd+00j/+OkCoh4GbV80/Dsvkm/2EyOVtX3jgwX8ZFuFyj3HeZ/xFWlIIKCx7Hw4Zl8s0+h2PMsLsOZ7cXOMyvf4wrXtl7rJTZjAU5P1VVoik5iyma9vm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZV/3UaKH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZV/3UaKH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A5E1F000E9;
	Tue, 21 Jul 2026 19:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660409;
	bh=i5x1DdSCdI2F2MwfypzHvvshfE1br7CTqQ6Vw6Wlr80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZV/3UaKHpjNpQrKw9OuvS0C7AVdkQlkeXVilxSLQT9dx7chd//baSQ3o6r3/fpl1F
	 kWTBuUH2H6sj0pn72mkBUN9KfVaIwN41ilQg/dH1JV1FEt28Klxufhjg654Hn1yVyu
	 BKIPMwzDWDvdj0UooeYd7S2Lt+EM3OD/9MHu5pX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0925/2077] dmaengine: imx-sdma: Refine spba bus searching in probe
Date: Tue, 21 Jul 2026 17:09:58 +0200
Message-ID: <20260721152614.630068217@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3d527883776b40..36368835a845c9 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -2364,7 +2364,9 @@ static int sdma_probe(struct platform_device *pdev)
 			return dev_err_probe(&pdev->dev, ret,
 					     "failed to register controller\n");
 
-		spba_bus = of_find_compatible_node(NULL, NULL, "fsl,spba-bus");
+		struct device_node *sdma_parent_np __free(device_node) = of_get_parent(np);
+
+		spba_bus = of_get_compatible_child(sdma_parent_np, "fsl,spba-bus");
 		ret = of_address_to_resource(spba_bus, 0, &spba_res);
 		if (!ret) {
 			sdma->spba_start_addr = spba_res.start;
-- 
2.53.0



