Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F73620969B;
	Thu, 12 Dec 2024 15:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017328; cv=none; b=pw5OvD4hT4k/A1hGFFAcPnVMuqBnceUN0Su3P76eA6XxDVZBXJ7CXeXwZOk8pc5rW1N6vYPHrnYj4rjBliqseZF7pxntf630bjacnkodeSpeg4skjFYqiXjePgZlKXmcQAwe2LE+ojEyfYS+N2sDVKD81thJdrl4qj/V7swkdtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017328; c=relaxed/simple;
	bh=L5a08zkpsaY5jyQNzoDL/1bNNQRQzL0hSut9eD64YUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vB6O+r++UjYkPMNx+orNhmWNGeSaRlYtwxcycL+ePtLpQGfaRRzwVbNasH0O0JuQ9utJCZy2rZXo0qvFUydNR58Be8qAdYhR33XqNkbA3YOoqddf6wYOzGJfY4EiZBkXOS0eQMVPQY1vOzvz2D5AfBGvUlafGVtX8XncMOcJJjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1VMJShUd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1VMJShUd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D40C4CECE;
	Thu, 12 Dec 2024 15:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017328;
	bh=L5a08zkpsaY5jyQNzoDL/1bNNQRQzL0hSut9eD64YUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1VMJShUd/GskLtuL0rgvNMMM5FNIQv8IsNP7IrG2lEO1/9pI/0/MkxU9cALVGPPwg
	 JNndRs9Wvp3YED+ufN5Di48qVJSNmkwpjWc0oYnVMKzIOcoYSnXcdBbQ6AgFPrZztX
	 hOUrLVrFR0Bx/ZWI75+MgQTEnoKXuTrlYY/t9LGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoyu Li <lihaoyu499@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 448/466] clk: en7523: Initialize num before accessing hws in en7523_register_clocks()
Date: Thu, 12 Dec 2024 16:00:17 +0100
Message-ID: <20241212144324.557011480@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoyu Li <lihaoyu499@gmail.com>

[ Upstream commit 52fd1709e41d3a85b48bcfe2404a024ebaf30c3b ]

With the new __counted_by annotation in clk_hw_onecell_data, the "num"
struct member must be set before accessing the "hws" array. Failing to
do so will trigger a runtime warning when enabling CONFIG_UBSAN_BOUNDS
and CONFIG_FORTIFY_SOURCE.

Fixes: f316cdff8d67 ("clk: Annotate struct clk_hw_onecell_data with __counted_by")
Signed-off-by: Haoyu Li <lihaoyu499@gmail.com>
Link: https://lore.kernel.org/r/20241203142915.345523-1-lihaoyu499@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-en7523.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk-en7523.c b/drivers/clk/clk-en7523.c
index fdd8ea989ed24..bc21b29214492 100644
--- a/drivers/clk/clk-en7523.c
+++ b/drivers/clk/clk-en7523.c
@@ -508,6 +508,8 @@ static void en7523_register_clocks(struct device *dev, struct clk_hw_onecell_dat
 	u32 rate;
 	int i;
 
+	clk_data->num = EN7523_NUM_CLOCKS;
+
 	for (i = 0; i < ARRAY_SIZE(en7523_base_clks); i++) {
 		const struct en_clk_desc *desc = &en7523_base_clks[i];
 		u32 reg = desc->div_reg ? desc->div_reg : desc->base_reg;
@@ -529,8 +531,6 @@ static void en7523_register_clocks(struct device *dev, struct clk_hw_onecell_dat
 
 	hw = en7523_register_pcie_clk(dev, np_base);
 	clk_data->hws[EN7523_CLK_PCIE] = hw;
-
-	clk_data->num = EN7523_NUM_CLOCKS;
 }
 
 static int en7523_clk_hw_init(struct platform_device *pdev,
-- 
2.43.0



