Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2BF257C
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:07:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FAE7C433D2;
	Thu, 23 Feb 2023 13:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677157654;
	bh=c9jDw8CVB+jrwKJzBQNMG5sLSYowvlAiVEjGt6z+yiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VUtG2TQRlvZfpQlbt/vgKMkxKHHC7S3ANIBD1Aj260ov+kJjEayDOmtc8FiwNel7K
	 eqYXwour6FIAJY7wU54GQ10u5dE1wD3dEGxWwDSjyvt+6ScZFSglBpkiSifYv1XoEf
	 f8zJBnmqWWNKZ8ybNyv3QnCOItsrap70GtB0mxGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi xin Zhu <yzhu@maxlinear.com>,
	Rahul Tanwar <rtanwar@maxlinear.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 06/25] clk: mxl: Fix a clk entry by adding relevant flags
Date: Thu, 23 Feb 2023 14:06:23 +0100
Message-Id: <20230223130427.073204777@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130426.817998725@linuxfoundation.org>
References: <20230223130426.817998725@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rahul Tanwar <rtanwar@maxlinear.com>

[ Upstream commit 106ef3bda21006fe37b62c85931230a6355d78d3 ]

One of the clock entry "dcl" clk has some HW limitations. One is that
its rate can only by changed by changing its parent clk's rate & two is
that HW does not support enable/disable for this clk.

Handle above two limitations by adding relevant flags. Add standard flag
CLK_SET_RATE_PARENT to handle rate change and add driver internal flag
DIV_CLK_NO_MASK to handle enable/disable.

Fixes: d058fd9e8984 ("clk: intel: Add CGU clock driver for a new SoC")
Reviewed-by: Yi xin Zhu <yzhu@maxlinear.com>
Signed-off-by: Rahul Tanwar <rtanwar@maxlinear.com>
Link: https://lore.kernel.org/r/a4770e7225f8a0c03c8ab2ba80434a4e8e9afb17.1665642720.git.rtanwar@maxlinear.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/x86/clk-cgu.c | 5 +++--
 drivers/clk/x86/clk-cgu.h | 1 +
 drivers/clk/x86/clk-lgm.c | 4 ++--
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/x86/clk-cgu.c b/drivers/clk/x86/clk-cgu.c
index 4278a687076c9..89b53f280aee0 100644
--- a/drivers/clk/x86/clk-cgu.c
+++ b/drivers/clk/x86/clk-cgu.c
@@ -164,8 +164,9 @@ static int lgm_clk_divider_enable_disable(struct clk_hw *hw, int enable)
 {
 	struct lgm_clk_divider *div = to_lgm_clk_divider(hw);
 
-	lgm_set_clk_val(div->membase, div->reg, div->shift_gate,
-			div->width_gate, enable);
+	if (div->flags != DIV_CLK_NO_MASK)
+		lgm_set_clk_val(div->membase, div->reg, div->shift_gate,
+				div->width_gate, enable);
 	return 0;
 }
 
diff --git a/drivers/clk/x86/clk-cgu.h b/drivers/clk/x86/clk-cgu.h
index 73ce84345f81e..bcaf8aec94e5d 100644
--- a/drivers/clk/x86/clk-cgu.h
+++ b/drivers/clk/x86/clk-cgu.h
@@ -198,6 +198,7 @@ struct lgm_clk_branch {
 #define CLOCK_FLAG_VAL_INIT	BIT(16)
 #define MUX_CLK_SW		BIT(17)
 #define GATE_CLK_HW		BIT(18)
+#define DIV_CLK_NO_MASK		BIT(19)
 
 #define LGM_MUX(_id, _name, _pdata, _f, _reg,		\
 		_shift, _width, _cf, _v)		\
diff --git a/drivers/clk/x86/clk-lgm.c b/drivers/clk/x86/clk-lgm.c
index e312af42e97ae..4de77b2c750d3 100644
--- a/drivers/clk/x86/clk-lgm.c
+++ b/drivers/clk/x86/clk-lgm.c
@@ -255,8 +255,8 @@ static const struct lgm_clk_branch lgm_branch_clks[] = {
 	LGM_FIXED(LGM_CLK_SLIC, "slic", NULL, 0, CGU_IF_CLK1,
 		  8, 2, CLOCK_FLAG_VAL_INIT, 8192000, 2),
 	LGM_FIXED(LGM_CLK_DOCSIS, "v_docsis", NULL, 0, 0, 0, 0, 0, 16000000, 0),
-	LGM_DIV(LGM_CLK_DCL, "dcl", "v_ifclk", 0, CGU_PCMCR,
-		25, 3, 0, 0, 0, 0, dcl_div),
+	LGM_DIV(LGM_CLK_DCL, "dcl", "v_ifclk", CLK_SET_RATE_PARENT, CGU_PCMCR,
+		25, 3, 0, 0, DIV_CLK_NO_MASK, 0, dcl_div),
 	LGM_MUX(LGM_CLK_PCM, "pcm", pcm_p, 0, CGU_C55_PCMCR,
 		0, 1, CLK_MUX_ROUND_CLOSEST, 0),
 	LGM_FIXED_FACTOR(LGM_CLK_DDR_PHY, "ddr_phy", "ddr",
-- 
2.39.0



