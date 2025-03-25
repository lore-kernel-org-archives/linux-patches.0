Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DB12561A2;
	Tue, 25 Mar 2025 12:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906089; cv=none; b=VJ+aIJZK7Ocq4JA0ogb7Xu0UM6bF92dgPNyES1BUpcNkgMgaiwUJx3pmvHN9e1r5fAuTF1tFafIzWxh8irXygNAjnxqn+Pup5iiJwvkkp9xX2Iee35/6GaomQUX2pWZE5wwwwWPdEVETqDqKWYhlT2BbFrhfx7HM0sf/nC5m5YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906089; c=relaxed/simple;
	bh=NXVcfym7y3uoOUTbTWfxad3KgtpCEEVBxUxqn+SGNIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PoEodKq5FMCY6YzJB6JWg3xazFw2YAgWkj9yDdp4I0tsILrKSUYdfLBLM0MvkITCNKF4OXhg3HFiTiQ+R4fKba0+rpPmndvQlfWA0qBDCub+ayQaoXXoTJAYQ/gNsz7hLZFgp4hg46yPNg5slFotSGCn/IXJ1Z/i7YitZ62SXro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GIeBko1Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GIeBko1Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1C5C4CEE9;
	Tue, 25 Mar 2025 12:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906088;
	bh=NXVcfym7y3uoOUTbTWfxad3KgtpCEEVBxUxqn+SGNIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GIeBko1ZTA5zxAQlUelsGjaLip3Dwnk9wL2jJaNqNblusP5i3tl7atwxQhwWe3c/l
	 J6zZqcq7Y5+pHOFpMnRnv8gWux9l6t7REEEbrB2A07heXS3/PeYCXG7wPt3uDScuMj
	 t2ffvKwiw0vYzXV6Yi2opZz+r7tr8U1oDs1hfCUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 01/77] firmware: imx-scu: fix OF node leak in .probe()
Date: Tue, 25 Mar 2025 08:21:56 -0400
Message-ID: <20250325122144.305047508@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit fbf10b86f6057cf79300720da4ea4b77e6708b0d ]

imx_scu_probe() calls of_parse_phandle_with_args(), but does not
release the OF node reference obtained by it. Add a of_node_put() call
after done with the node.

Fixes: f25a066d1a07 ("firmware: imx-scu: Support one TX and one RX")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/imx/imx-scu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/imx/imx-scu.c b/drivers/firmware/imx/imx-scu.c
index 1dd4362ef9a3f..8c28e25ddc8a6 100644
--- a/drivers/firmware/imx/imx-scu.c
+++ b/drivers/firmware/imx/imx-scu.c
@@ -280,6 +280,7 @@ static int imx_scu_probe(struct platform_device *pdev)
 		return ret;
 
 	sc_ipc->fast_ipc = of_device_is_compatible(args.np, "fsl,imx8-mu-scu");
+	of_node_put(args.np);
 
 	num_channel = sc_ipc->fast_ipc ? 2 : SCU_MU_CHAN_NUM;
 	for (i = 0; i < num_channel; i++) {
-- 
2.39.5



