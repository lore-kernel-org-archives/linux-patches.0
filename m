Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47701260583;
	Tue, 12 Aug 2025 19:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026097; cv=none; b=TCqS0ihDpxWYeOazroOLdwYOjZ3Q5N4ZJtJ7uZ8YLWaCTaRxqvlz7l6NzmXsAfsoBgWZav4k+QHYc2XGdYLvaTpEzgZdFbJbAX4uYVLjM3mLqTEEl35JGIz444Z6mpPVVrTufG9f5p9c8nl7DGlS8XhAb5wcAF/2NMLYFcF4ORA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026097; c=relaxed/simple;
	bh=P8Fsu9weMBPjU8Xw/0wJd/Rlu0qBE+lNbXw/0emnhD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMqyT3DjQMVYTZGSFf5ScdFkC8rJI+06OpOa5z1CBa1kQUd1d4JMNaDmiKbsMezucEgngmfNNXpUYVD315GhzecmJKaeHUR8xuGF58ZEjGTZXV/Bhx7/YPG6W5zoxwvHPbS6p4HddGjBVg6nx0d60YJKsyREGjp1kK0XnEH3SFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H5k5WW7W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H5k5WW7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10A0C4CEF0;
	Tue, 12 Aug 2025 19:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026097;
	bh=P8Fsu9weMBPjU8Xw/0wJd/Rlu0qBE+lNbXw/0emnhD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H5k5WW7WE57q5kVayVC8GslsBFaEdNLbe03mFpKNgCFPnx2DhIg4CzWiDv2qEi4fA
	 HxB3RD+7xQrwy9Y5MNxEUp8MZLx3FTQFhqaGspJPh4apM6TqyySE3i0G8I9l9bCaJb
	 BXZkuBA7eR32zeLZZze5ji/jkhZWzs+4RdJ01lZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohit Visavalia <rohit.visavalia@amd.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 236/480] clk: xilinx: vcu: unregister pll_post only if registered correctly
Date: Tue, 12 Aug 2025 19:47:24 +0200
Message-ID: <20250812174407.182103186@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



