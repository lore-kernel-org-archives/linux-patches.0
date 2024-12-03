Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECA11F76AD;
	Tue,  3 Dec 2024 15:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241551; cv=none; b=s4p0rSkvRHwqRJYAym1Qy0LIjym+XD3nhLPC6DdLUIPSKUqvT9SDrXBm8nIoq4xg5pvXZ65wYBmTpBCo7ZGQC+veIDKXZ/1IOTLA8K9jJSjTCWjKHJLmOzWslWhKMkcb5yxg0jataHkbx8qGRpSrxilRhY6iHzuHe64Y33y8qBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241551; c=relaxed/simple;
	bh=2pcbLMwS/ywUH6BG88CNXMOpnr1V3FhQ07B3Cz5QXH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fR+euMeU8XrW859SEoEczaMMkSpsZ4Q/68j4QyhpKYFHkU/7jdqDYQmXUxcX7Ok2SF+pr/TRYvPArAnUwT5iMudXZaRu3J7oAjXuj4EOlxPRUez8XIOssvgqtcBDeCclyf8l1juMPgtD47II4c/sr+jL5Rlm8kCnH6MvfC2/iy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yVVkbpT/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVVkbpT/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1059C4CECF;
	Tue,  3 Dec 2024 15:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241551;
	bh=2pcbLMwS/ywUH6BG88CNXMOpnr1V3FhQ07B3Cz5QXH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yVVkbpT/h+tKuRoAtDz95pZ6ftnFci5X0Ix+Zwo50wSbZdRrwxmzHNtjkTCJe630/
	 ZDpROLheTxtoVzhCk+1HikkaFYDVeL1Ro9x3JdBpVPNMq2dtWJQeDdF+rnq41rya6w
	 kFk+MI0P0j2gFPgkvpM3lDKGjtNdpXsqSZa+zopE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Carlos Song <carlos.song@nxp.com>,
	Dong Aisheng <aisheng.dong@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 408/826] clk: imx: clk-scu: fix clk enable state save and restore
Date: Tue,  3 Dec 2024 15:42:15 +0100
Message-ID: <20241203144759.677598733@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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
index b1dd0c08e091b..b27186aaf2a15 100644
--- a/drivers/clk/imx/clk-scu.c
+++ b/drivers/clk/imx/clk-scu.c
@@ -596,7 +596,7 @@ static int __maybe_unused imx_clk_scu_suspend(struct device *dev)
 		clk->rate = clk_scu_recalc_rate(&clk->hw, 0);
 	else
 		clk->rate = clk_hw_get_rate(&clk->hw);
-	clk->is_enabled = clk_hw_is_enabled(&clk->hw);
+	clk->is_enabled = clk_hw_is_prepared(&clk->hw);
 
 	if (clk->parent)
 		dev_dbg(dev, "save parent %s idx %u\n", clk_hw_get_name(clk->parent),
-- 
2.43.0



