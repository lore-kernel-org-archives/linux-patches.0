Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574012236EB;
	Thu, 12 Dec 2024 16:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019539; cv=none; b=fCxIRRj0V57jJBE5TdGi/QxORcHar1Mclsuff+3vJuYppTo4/e3lt5bCcUvIwZ8BKsXhq0ekSTw9jVE7uoHbqgrD0+KCm80QgVqhi9k0VTylaAf/FY3fsTr+C5SxOs+ifZM7iW9fKI8Rs3vymEQMekLdDfQaKo89ryN1+VioHV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019539; c=relaxed/simple;
	bh=Z2QtZlmhNVa7beZvB07pjt52Xi6JMzvoj9nItFAN7Dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4xlA5stHDtTNPjD+gwe4vcWrQ6TzBSUh3CnwKp/pQ1Oq0xBPXz7fCYeZfX+ySSkz9Fk3s4jQR4KpejmW7gFNqJNS4YVHPGRQnWEV2jdRlYLFeBWEpn4P/2i5awIT23vz/XUjTLH2oyDLekAQdVq1b/wWPa1zWxbtrLKMjlNvEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gEa5qznu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gEa5qznu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04FEC4CED3;
	Thu, 12 Dec 2024 16:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019539;
	bh=Z2QtZlmhNVa7beZvB07pjt52Xi6JMzvoj9nItFAN7Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gEa5qznuQ4b1SDYSe5n6xrX/klH3eSPMlB8IMiDAuMbNaPlkewLLZsKEE5550LVG5
	 ZMEu1ig5IsriF8sYT9RBVcNw/yHNz0dOLC1QRQCzYg1ww13VDf6x4N8ZdPucwoflql
	 E703L+9nrqQWdKFV9p7+PxXTPl9nIWKQxmB5r2m8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Carlos Song <carlos.song@nxp.com>,
	Dong Aisheng <aisheng.dong@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 234/772] clk: imx: clk-scu: fix clk enable state save and restore
Date: Thu, 12 Dec 2024 15:52:59 +0100
Message-ID: <20241212144359.582775573@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index db307890e4c16..ec5afc7f2690b 100644
--- a/drivers/clk/imx/clk-scu.c
+++ b/drivers/clk/imx/clk-scu.c
@@ -577,7 +577,7 @@ static int __maybe_unused imx_clk_scu_suspend(struct device *dev)
 		clk->rate = clk_scu_recalc_rate(&clk->hw, 0);
 	else
 		clk->rate = clk_hw_get_rate(&clk->hw);
-	clk->is_enabled = clk_hw_is_enabled(&clk->hw);
+	clk->is_enabled = clk_hw_is_prepared(&clk->hw);
 
 	if (clk->parent)
 		dev_dbg(dev, "save parent %s idx %u\n", clk_hw_get_name(clk->parent),
-- 
2.43.0



