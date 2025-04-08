Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBEA1AAA0F;
	Tue,  8 Apr 2025 12:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113871; cv=none; b=pZwz9S5Ihb3ldn8i8WbyfmzWkwqq6546Ynyst6GMD3rV1gcdtoS4eGNwTEhULQb+axP0ZIj45GVE6ZzEehlDsXpyLNp12KXn5IE0KouSiK0wuzznUhZCSOKaNBgs7XdN5WoHNOD2PpTm5uvml7HeQViBZXLI9PZw7bDuaeNvVCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113871; c=relaxed/simple;
	bh=4T6PUlig/y7iM47vYShwGjWWK+Mc7wzjj4XSD7sGUbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4GJ7yQ1JRQfejCrVsr1K19B8HB+bcNDzwceG3vwcUfNkuyRvii9ZMlWowm8FCLMPY3Q4Vo1mM8Hao/Q1uwHIQ2/dAQc2eSFfl7+PxVj3kN0cbgTIQRbTZp654bRy6EkVOGD8TEX9lJbWB3bzR6yom9WY5TDCgNCfFpTlumQvy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gZtpYffv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gZtpYffv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F89DC4CEE5;
	Tue,  8 Apr 2025 12:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113871;
	bh=4T6PUlig/y7iM47vYShwGjWWK+Mc7wzjj4XSD7sGUbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gZtpYffv3MbaPt/C1lOVLfCFjcH0DDD+4DbTq70ObrJjyVCdHLvEV5RzBaQcZYbpX
	 ByVTQ0oiB4B1BFznGQs7/iQFtr6w4C/KOQW44rc2T4xcz5cc1KOa4QGmDqiHMLHdy1
	 vttCrXKldVlcfaTiINUclqbfnL6uOBdnuYmTPsSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 051/154] firmware: imx-scu: fix OF node leak in .probe()
Date: Tue,  8 Apr 2025 12:49:52 +0200
Message-ID: <20250408104816.914111811@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index a3b11bc71dcb8..c973760ed9490 100644
--- a/drivers/firmware/imx/imx-scu.c
+++ b/drivers/firmware/imx/imx-scu.c
@@ -266,6 +266,7 @@ static int imx_scu_probe(struct platform_device *pdev)
 		return ret;
 
 	sc_ipc->fast_ipc = of_device_is_compatible(args.np, "fsl,imx8-mu-scu");
+	of_node_put(args.np);
 
 	num_channel = sc_ipc->fast_ipc ? 2 : SCU_MU_CHAN_NUM;
 	for (i = 0; i < num_channel; i++) {
-- 
2.39.5



