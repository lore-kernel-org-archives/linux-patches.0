Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC8635DA40;
	Tue, 21 Jul 2026 19:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662474; cv=none; b=WakT/0S0lJ8w/unYn34LJEs68Yt6BQ2FOj89GzepS0j/0AS7u04H4YeCYDzHD85y7LxkrKLIXcOYBnVjPGzwCMkS9KcAfIxBaeNzQLrmheu+FagFrzjwiVJbgUkiNOrv3Qxr8yypdziarksTOblaqb3y3Kyk3796jMdUizBIxn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662474; c=relaxed/simple;
	bh=5ThLTehFnEAs9cShMQX2djTOXREFRQkWqaikOIOH7uI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k70fBKlgwxp/XTFQHFkQFS7LJ9QKhAY7MkpWLdom+enmOu1CyOzRe3tpYzll+DfRjlgalmw0gMwOa8/5NpV5QkGFFCK+Sun68Qqr8aqLtknppBlCBO9+QYF2vCEGynXEomyhrjd2PwaoPDLP9WnfkNZazOWet1b3b2iYLV/H8ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YjxfJGEL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YjxfJGEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320881F000E9;
	Tue, 21 Jul 2026 19:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662472;
	bh=VfLFjIce2+HyDxv5vEq+iidnCMvo/6XylXrMA/Zb7EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YjxfJGELpdeBTFN2EfCqjZRfGB7jswPXaM6JsaV9FlWwcS/Wp7cSbMAXn2PTD3frd
	 TFWuYAyA26ef4TDyzL/H/8ud/9PsoAuQ7f2qy5nG3B0/W1zRGLiWdVsWRLSWsZ0m2/
	 vJSs06uoCtLJ938lMSZyDPPfJ/8lvtXHuQg66s3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0456/1276] dmaengine: imx-sdma: Refine spba bus searching in probe
Date: Tue, 21 Jul 2026 17:14:59 +0200
Message-ID: <20260721152456.307894295@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 72299a08af441b..3421712e397a7b 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -2377,7 +2377,9 @@ static int sdma_probe(struct platform_device *pdev)
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



