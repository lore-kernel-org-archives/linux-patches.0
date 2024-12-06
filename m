Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4779453A7;
	Fri,  6 Dec 2024 15:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497439; cv=none; b=b71RfLXYJ3eaEeWOKeZ/Ve0rzQtkaLudXjo0nTjOWOOWOjt7cJPkGYDPtKU6EwaO0xXdtpW/OZTRafxi5e/Zip5H+oEnNR+xBOaOWwAoLuSF9PAr9iYypSF0aAt1Fsn7cFERGs6PpbDhyJ7XGnDazTdObMSVVzaOe4LzWBdZllE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497439; c=relaxed/simple;
	bh=2DP6r0u3wz1ARozSHh4eYsgbdegCeoDr758wlxrspyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXUKJWO61cCBjACJruUjAUPlqCXjL4Z9PPmn1DGpXpL3Ff6h3O1d7nVgpiquYUYfJD8ZY4sP992Cmh9vU+38GyMBxTRK3gmlRFvtxIkc1brZr08zC7sS/0pa6eCdd6A3/qR4sSAO0Uti4fw1tLZD0LmNbow5iSL7L91poz9SNf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVLhamKK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVLhamKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900F9C4CED1;
	Fri,  6 Dec 2024 15:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497439;
	bh=2DP6r0u3wz1ARozSHh4eYsgbdegCeoDr758wlxrspyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vVLhamKKXkG3dzLrRUa17jQy+hA5toF5xPBPPawxRnq9HoCOHZtZGE0OaEeZEzfNF
	 1HgCpq+ATkSz2MhjpslXl4VepMzbUXBkomDbhB7/o2cWnZsHWJ1JccN+3V2ejFfaxm
	 +lDiQiwCzHa0A6B+To9vGsuWa4ilgpf5VQEipj/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Carlos Song <carlos.song@nxp.com>,
	Dong Aisheng <aisheng.dong@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 293/676] clk: imx: clk-scu: fix clk enable state save and restore
Date: Fri,  6 Dec 2024 15:31:52 +0100
Message-ID: <20241206143704.788062336@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dong Aisheng <aisheng.dong@nxp.com>

[ Upstream commit e81361f6cf9bf4a1848b0813bc4becb2250870b8 ]

The scu clk_ops only inplements prepare() and unprepare() callback.
Saving the clock state during suspend by checking clk_hw_is_enabled()
is not safe as it's possible that some device drivers may only
disable the clocks without unprepare. Then the state retention will not
work for such clocks.

Fixing it by checking clk_hw_is_prepared() which is more reasonable
and safe.

Fixes: d0409631f466 ("clk: imx: scu: add suspend/resume support")
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Tested-by: Carlos Song <carlos.song@nxp.com>
Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
Link: https://lore.kernel.org/r/20241027-imx-clk-v1-v3-4-89152574d1d7@nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-scu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-scu.c b/drivers/clk/imx/clk-scu.c
index cd83c52e9952a..564f549ec204f 100644
--- a/drivers/clk/imx/clk-scu.c
+++ b/drivers/clk/imx/clk-scu.c
@@ -594,7 +594,7 @@ static int __maybe_unused imx_clk_scu_suspend(struct device *dev)
 		clk->rate = clk_scu_recalc_rate(&clk->hw, 0);
 	else
 		clk->rate = clk_hw_get_rate(&clk->hw);
-	clk->is_enabled = clk_hw_is_enabled(&clk->hw);
+	clk->is_enabled = clk_hw_is_prepared(&clk->hw);
 
 	if (clk->parent)
 		dev_dbg(dev, "save parent %s idx %u\n", clk_hw_get_name(clk->parent),
-- 
2.43.0



