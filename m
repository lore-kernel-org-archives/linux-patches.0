Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0243268697;
	Tue, 25 Mar 2025 12:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905888; cv=none; b=tjwHFvMAA9pOpr6DfdCs9iYTsH+4XADJKiKRokQ1LS6wH1OxGnGT+HBSGdFPnk67ErxwlHAMnh8k+jE195A3w8qhWPkDW1yhis3yj9ASf/z9m4XWnGicAzlj2G6VAwlVwTeZsJzjrBIbFuDsTlyAPdtPLXzale2X/QMLA8BvzRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905888; c=relaxed/simple;
	bh=YLQG7YsQ4SqZY9zN0VOjhohw8csLi1U5eL5L0d4yL8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KnE9BqkhJRl92iEKm6j5EBLu4Q4SSDkM6a0clNah1/fuHGVdNdHFeLFPh+5sun8Yixvvt0I5T2KpEe+46m4C5qx0nlJx8IdmBKKL5pGzYdFiQTdIojbDnu5kdG9Aq7lxT2FVZqljOvrVXHcD6fCL7NFytV6xTZmZXxYjxGH/fMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tc+imzCV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tc+imzCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75970C4CEE4;
	Tue, 25 Mar 2025 12:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905888;
	bh=YLQG7YsQ4SqZY9zN0VOjhohw8csLi1U5eL5L0d4yL8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tc+imzCVPG0T9Ossgt2IMVq2YM+lbr9Ewt3Gxih/C1UtWt6fPWfrMu3R69xpBLhpN
	 BnmGgQQqKgXaKGUIIjUkKwK2iyYvg97vzSq7eOwNEQa9Wn0wA43OFBhxHmx+GAlYZJ
	 mX7EwsrBx8/KOM0Y060Lx4ngDGhCFgCAhiH6c4r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 002/119] firmware: imx-scu: fix OF node leak in .probe()
Date: Tue, 25 Mar 2025 08:21:00 -0400
Message-ID: <20250325122149.124285706@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



