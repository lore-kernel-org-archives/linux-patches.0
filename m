Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE58291C1F;
	Tue, 12 Aug 2025 18:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024355; cv=none; b=m6kWATuWCT01/Re2lozppSqUHAtcOxLkEP0bI5V7/O+LHypt9soUiT98AHoW1sBo/LUURR0xjPNOqcmpiJBaV5zL9nwFSrbeSq64F9cY3Hf6BIvhUWfHs5wjmOi6xfpVDpeJunxgQq0a0aOCxs8BjPjLU5egnkWhJPQG13QK+kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024355; c=relaxed/simple;
	bh=5KTNYITfp205TyDycm+sr9hxwfRkK+0FMp12dPOfF7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0HJyqa0ASepXCKIzs1/j/aILddztCPMZc5nSY82OCYWivbuxKEt9LCEDhtRBlp5jTkyzaBnkxXqzvwHTOcK5ebVHV/f5+y82M7UFbRcgQnMe2KuAFzhWhp/hB7zRN+1DIG0nC7HSPVb6eJtEvdxm9K8aAmynql5tKUDkArqWHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gBt/VVz9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gBt/VVz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7F1C4CEF0;
	Tue, 12 Aug 2025 18:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024355;
	bh=5KTNYITfp205TyDycm+sr9hxwfRkK+0FMp12dPOfF7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gBt/VVz9dBBVVE6hO0DU1i5ko3aqUwmOoMrLjrsyHWEvmThm59nlTv00NrjP/EePo
	 cUbBLbk4aGRdMsb6qkMpuBaTNTQsdvBCXD0vtrvNIxrIfsv3/5rKjBFYubRCRUC83x
	 rIPM8ppktY2qakLwjHTaI5nV+gDRF9WRVcE6R/Mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohit Visavalia <rohit.visavalia@amd.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 316/627] clk: xilinx: vcu: unregister pll_post only if registered correctly
Date: Tue, 12 Aug 2025 19:30:11 +0200
Message-ID: <20250812173431.327164237@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 81501b48412e..88b3fd8250c2 100644
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



