Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E81E2D060B;
	Tue, 26 Aug 2025 13:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215797; cv=none; b=cE6bMHe8OvZqOcML2Q+sO0nL1zrZgWaCbYbYS7Ubl1yucE+8EjmY1GV9TJcESEUV4GqZUfWPpYGquZe+scOanfF6ZOUoR+bJZ6Bcr6PQEwnGbuKtFM+ymxjKLHCwjXjl/ymaCpAoPR1gbr77kyB9HPd/ZuWn65HpjWU26dC6Zik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215797; c=relaxed/simple;
	bh=ZUUsUk3gCWv+otGHx0gjq+jzDBf9zdZCJwb5cRz4EGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GAQhh+XhzFhAPP/n4WE/7u/Un+5o5Z+IXq5Ylp7psobFyoUAzYvA6WNGgyffN+CGuGNa7uK75sCr9wxTTdjTD5PNrz4Hz3IvPFfmSuZR6UfKLhW8t3XhNa5vuvbJZ+Y7nQ5j9fxvgiMP8lyXF+ucruOnKxaez7Sn1Lqoc/JZqLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=05t6tgqw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="05t6tgqw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0B6C4CEF1;
	Tue, 26 Aug 2025 13:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215797;
	bh=ZUUsUk3gCWv+otGHx0gjq+jzDBf9zdZCJwb5cRz4EGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=05t6tgqwmVhHNh8DZDMpnqZvjU2nVO9RyDbHM3h9X2at1RG3ZyWQ56qVz4PkZjcyc
	 KRqFStWoIiKlgfHTNveQv48/yJIAhXX+CFlBQNU0Gl1SxU5rYRWYVV3Qiv4B4BRbq+
	 98ChAQAfKotApeZArgJAVYcu/Rg5ckFuIntt8McQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohit Visavalia <rohit.visavalia@amd.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 170/644] clk: xilinx: vcu: unregister pll_post only if registered correctly
Date: Tue, 26 Aug 2025 13:04:21 +0200
Message-ID: <20250826110950.689255815@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rohit Visavalia <rohit.visavalia@amd.com>

[ Upstream commit 3b0abc443ac22f7d4f61ddbbbbc5dbb06c87139d ]

If registration of pll_post is failed, it will be set to NULL or ERR,
unregistering same will fail with following call trace:

Unable to handle kernel NULL pointer dereference at virtual address 008
pc : clk_hw_unregister+0xc/0x20
lr : clk_hw_unregister_fixed_factor+0x18/0x30
sp : ffff800011923850
...
Call trace:
 clk_hw_unregister+0xc/0x20
 clk_hw_unregister_fixed_factor+0x18/0x30
 xvcu_unregister_clock_provider+0xcc/0xf4 [xlnx_vcu]
 xvcu_probe+0x2bc/0x53c [xlnx_vcu]

Fixes: 4472e1849db7 ("soc: xilinx: vcu: make pll post divider explicit")
Signed-off-by: Rohit Visavalia <rohit.visavalia@amd.com>
Link: https://lore.kernel.org/r/20250210113614.4149050-2-rohit.visavalia@amd.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/xilinx/xlnx_vcu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/xilinx/xlnx_vcu.c b/drivers/clk/xilinx/xlnx_vcu.c
index d66b1315114e..292d50ba0112 100644
--- a/drivers/clk/xilinx/xlnx_vcu.c
+++ b/drivers/clk/xilinx/xlnx_vcu.c
@@ -587,8 +587,8 @@ static void xvcu_unregister_clock_provider(struct xvcu_device *xvcu)
 		xvcu_clk_hw_unregister_leaf(hws[CLK_XVCU_ENC_MCU]);
 	if (!IS_ERR_OR_NULL(hws[CLK_XVCU_ENC_CORE]))
 		xvcu_clk_hw_unregister_leaf(hws[CLK_XVCU_ENC_CORE]);
-
-	clk_hw_unregister_fixed_factor(xvcu->pll_post);
+	if (!IS_ERR_OR_NULL(xvcu->pll_post))
+		clk_hw_unregister_fixed_factor(xvcu->pll_post);
 }
 
 /**
-- 
2.39.5



