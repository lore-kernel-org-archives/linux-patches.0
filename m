Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C134B3B6356;
	Tue, 21 Jul 2026 21:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669305; cv=none; b=bE0uM98o1/k43qHtvgjME5ikKkqDOg7NJjMisiKOGyTPSXpfQkK9KJyVRS4EBqEFr6LU1dXXO2V91SizOER7YVSzVgfN8pexU7achXzBhAt1fQcFBWGw274KLaHhmitRjFDAJg93y9iqivJtN/aeHCnpg/e+jmewNFFmcjc8/y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669305; c=relaxed/simple;
	bh=BmpeID1qYttF5DaSO48+M9nFOyveP+sS5x2YPfH7z1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M6FAua8Eer5kUUQ6mdVn5wYT6oZuUSfHZPhtDiGELI3bJeE7xBrbFsP41HjFEF0NVhfFed8pIdjVlKPD5YBR84TZDES6ZGpJrTjtwn1TM0A2YB9K+WJvxF/+2x8Bga7zP/U/gDyQj+WeuFHKM0km55ueaEmgumJj2gWCupsOBgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ud8l9QYb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ud8l9QYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161EC1F00AC4;
	Tue, 21 Jul 2026 21:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669292;
	bh=CtqbmVZfVYhT4grp3sVj4XvicK9Zoj+Z1k4d9nQNNjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ud8l9QYb7EnIcoTJXaAok34uqPC+p6++0EYWfGaTY1jc8cXjXSpH3v0P0cWNBo8ca
	 Pjztl0XobhZqIVO1+Kl0IaVuIz6nGZ1ZUGleZOSE2sm7IXItsUbm9c5VbvGHGrbUde
	 ce4O48ENni+pc0zAv3Ie6mfpWvmbIi1z/b21WoV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0499/1067] dmaengine: imx-sdma: Refine spba bus searching in probe
Date: Tue, 21 Jul 2026 17:18:20 +0200
Message-ID: <20260721152435.776603223@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b926abe4fa43ac..2db37bb8a763a2 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -2301,7 +2301,9 @@ static int sdma_probe(struct platform_device *pdev)
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



