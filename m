Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323EC1EE001;
	Tue,  3 Dec 2024 15:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238874; cv=none; b=fCyVcvDn2VwSYDhVkAOk9eO/uKyOKZT8eHgVFCjcsrN1YPpDOvaKyr3MZ+ifzi8zwJnzX8TkbnIVIgxEkVQKLy7ZxUexidlbvk3O1AVe2JKVvm0S/DtpinQJMiS1vf3LH2OddRxjnFsmwIXTcgh5NKYzoposCynZBONv4ALmC3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238874; c=relaxed/simple;
	bh=21VfLtCI/C+kg2CbmJ0W6EiezDuh59tKoIVTS9yHTXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GxJl7k9K4v9QgLsAKy3QEtyQMLHUlKYaGgT4KdQJqGJxmn00uLYbrmzmJQWntm+uktZ6j0MOntfSD/fIXuSWiCGYas0ThBMjXea4/e8L1PfXYCRn+cM408uA78T8wyz1NtG6RWNM0ZsyfZ5wxx3A3tLpoG7sHsqPFJ9LmoYPwVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBF6w10N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBF6w10N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19BFC4CECF;
	Tue,  3 Dec 2024 15:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238874;
	bh=21VfLtCI/C+kg2CbmJ0W6EiezDuh59tKoIVTS9yHTXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBF6w10N7LTW2SHUxApZZsWzuxGM15yM1Vno0uS4vrEahtaC3WB++Rc/kH4GbI9SZ
	 +leMM2UIipTSwBSzYZGWXSa53h7n5AgGI7K3Z40zLWxl3Wv1RoQKy/s+p2ZxjpJnQd
	 kgDXm57PJE93x9VRUNtXM7e0BcoRYozkPFvmw+pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacky Bai <ping.bai@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 426/817] clk: imx: fracn-gppll: correct PLL initialization flow
Date: Tue,  3 Dec 2024 15:39:58 +0100
Message-ID: <20241203144012.512637330@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 557be501c38e1864b948fc6ccdf4b035d610a2ea ]

Per i.MX93 Reference Mannual 22.4 Initialization information
1. Program appropriate value of DIV[ODIV], DIV[RDIV] and DIV[MFI]
   as per Integer mode.
2. Wait for 5 μs.
3. Program the following field in CTRL register.
   Set CTRL[POWERUP] to 1'b1 to enable PLL block.
4. Poll PLL_STATUS[PLL_LOCK] register, and wait till PLL_STATUS[PLL_LOCK]
   is 1'b1 and pll_lock output signal is 1'b1.
5. Set CTRL[CLKMUX_EN] to 1'b1 to enable PLL output clock.

So move the CLKMUX_EN operation after PLL locked.

Fixes: 1b26cb8a77a4 ("clk: imx: support fracn gppll")
Co-developed-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20241027-imx-clk-v1-v3-2-89152574d1d7@nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-fracn-gppll.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/imx/clk-fracn-gppll.c b/drivers/clk/imx/clk-fracn-gppll.c
index 1becba2b62d0b..f85dd8798f15c 100644
--- a/drivers/clk/imx/clk-fracn-gppll.c
+++ b/drivers/clk/imx/clk-fracn-gppll.c
@@ -301,13 +301,13 @@ static int clk_fracn_gppll_prepare(struct clk_hw *hw)
 	val |= POWERUP_MASK;
 	writel_relaxed(val, pll->base + PLL_CTRL);
 
-	val |= CLKMUX_EN;
-	writel_relaxed(val, pll->base + PLL_CTRL);
-
 	ret = clk_fracn_gppll_wait_lock(pll);
 	if (ret)
 		return ret;
 
+	val |= CLKMUX_EN;
+	writel_relaxed(val, pll->base + PLL_CTRL);
+
 	val &= ~CLKMUX_BYPASS;
 	writel_relaxed(val, pll->base + PLL_CTRL);
 
-- 
2.43.0



