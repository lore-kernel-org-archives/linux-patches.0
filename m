Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8856F2FD1B2;
	Tue, 12 Aug 2025 17:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020657; cv=none; b=DbfbPIpytGEaLuYVyncW3lBcSi7vUKsyznwTb4gyWXqUI3fcnnjjsZT4eR6SfVROJITE+3drJO3tgxJmVAjcgs6ULSWtDB778XHX818UKMwU3hhFXyIp04wqQcHPHOG9qkJ3zyvf9FE89Y6Gm91SjmUxnpwzQPgbE1M3WbHSER4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020657; c=relaxed/simple;
	bh=NVpmMzjgOGk8KEmsDm08bNqzFrjjHRF3ELCQAsmaOtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XOw73ouQ22q2WgxEsdcQGMpzdXwFjJju/Pw4GT+TIXaUntaFZxuE5Em5tjwn13YLMm1jMOsLqJkQjlviT/wXsksz9Dv0vLdGnLy5jm1imNAHKhqsPgYsICUfICRG1uS2V1h+UORskPx7uti+e7yKHl0go85Eg3kG67UOYVjk6/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ghPsL3RD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ghPsL3RD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EEDC4CEF0;
	Tue, 12 Aug 2025 17:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020657;
	bh=NVpmMzjgOGk8KEmsDm08bNqzFrjjHRF3ELCQAsmaOtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ghPsL3RDQ93EkNgxiauOf8UYW0tbSxhyvu3ldt0Ge7aFn0reHDE+vHhJdMazSJBTF
	 Z3zXu/BPYMrCtb7SzjQVozPUb/HLzgQ9As/LI9PuWRKf0P4xT8siQc8VQeUsaaf00z
	 EJIy9y5VYlA4c075EbaLuxwTcbwesV0XY/clMzH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohit Visavalia <rohit.visavalia@amd.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 145/253] clk: xilinx: vcu: unregister pll_post only if registered correctly
Date: Tue, 12 Aug 2025 19:28:53 +0200
Message-ID: <20250812172954.873456067@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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



