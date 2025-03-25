Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CD5259CAD;
	Tue, 25 Mar 2025 12:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905755; cv=none; b=EL1eCvPiyK9sfjgSasyhDU7o9TGY4IV3HEZABVxa/XSMqloazDv6i5siwkE20QJrcXfWCHUO3CCpxi3sgplFM2SsP5k90XqzPF5nEV+erT54WsubYhQpvi2EYNeIcg1rEZM62HMn8ddR1CHurZcrnCwwQ2ZK/KVnofAT8ezzHvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905755; c=relaxed/simple;
	bh=8nGkRQ4PxxkblPCS66UXdFrKoXI7Ss0fsZOVnlsePEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CcZJXmReGpz0+rG58rFkjruBnaiO0aQghUTvRglf3Msa7QiDDFWGYVVHvc/CBDY+rMsgNUGESmNSN6qIalt8L3d7UhKdOTk8qZpN/fHM8wBWebAMTfHqtn5RpkPnzdXkXniKthd3wAyd4AY5wiV0VGlS7+zQnAfVhx2LFlX5V3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVQSxQPZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVQSxQPZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DF3C4CEE4;
	Tue, 25 Mar 2025 12:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905754;
	bh=8nGkRQ4PxxkblPCS66UXdFrKoXI7Ss0fsZOVnlsePEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fVQSxQPZgt5zWA2d4XLjkUV76QGXg5yhSG/VDKUXRIErrGGNguozCUoP41DVX3ly6
	 yVa2f2msWj/HBdYRDxjRBtTX5LEtu3Nkljvx0t0/npcOgIRhTLLPXfa68sP2SbeyDr
	 McGWLuuZfCBmD/zaJ7PzqfsSDsvvLvGJYTst52P0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 146/198] firmware: imx-scu: fix OF node leak in .probe()
Date: Tue, 25 Mar 2025 08:21:48 -0400
Message-ID: <20250325122200.487197831@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index dca79caccd01c..fa25c082109ac 100644
--- a/drivers/firmware/imx/imx-scu.c
+++ b/drivers/firmware/imx/imx-scu.c
@@ -279,6 +279,7 @@ static int imx_scu_probe(struct platform_device *pdev)
 		return ret;
 
 	sc_ipc->fast_ipc = of_device_is_compatible(args.np, "fsl,imx8-mu-scu");
+	of_node_put(args.np);
 
 	num_channel = sc_ipc->fast_ipc ? 2 : SCU_MU_CHAN_NUM;
 	for (i = 0; i < num_channel; i++) {
-- 
2.39.5



