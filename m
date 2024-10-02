Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812081D0DE8;
	Wed,  2 Oct 2024 14:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878276; cv=none; b=bJ9X39m+1bdxWDubfKoAX3fLAiU+NcvvgjA5r6tSZps6UFzYySLMBviESJ8QybFLYlGWD1zROKunX3U/GxULKFKs6bJVoNmvNlfieJ5JUkJmnP3FIoqRevQWKIl6CYFOtRap0V5c+1g/uH1sFMqpsHHnYpkdlRF+ccVshYYQ9kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878276; c=relaxed/simple;
	bh=CLFv/uOE/Z6RMkYLDvjV5YbyxD92FwKTW7xB/QI+o5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ov5Sz35qLMRo36lpbZygVYUaZQaJGUjkTuyXX+Tzy4n7ZVBS2AZGHCnu0TpAwTfyx0LoKFO8gHWf4OkBMJlv8rthJA8ltapQQyKyfbH6oYrSpI3VOnKkXP/juv9aJ9LgYF6ept3DOmCynn3w2C80zsDq4P320JRr5YIo2Mi0jJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wFvJog6b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wFvJog6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0929BC4CEC2;
	Wed,  2 Oct 2024 14:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878276;
	bh=CLFv/uOE/Z6RMkYLDvjV5YbyxD92FwKTW7xB/QI+o5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wFvJog6bQzyLdETqyZSKm+toXPZPR8j8Wmd+iWZdlHWFrBP0rs3zOWi6tOn1PdbsB
	 0QIQEARFClquGju+BEQREdN5kJfM63SPEdBQnEtrU2DvhMbt0RFQS2+v3JQOOb8Lx2
	 FyiHaiD8RFXTrivgSYCIoQVUmGOtUxTVEivh1dkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Liu <liuyuntao12@huawei.com>,
	Xingyu Wu <xingyu.wu@starfivetech.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 358/634] clk: starfive: Use pm_runtime_resume_and_get to fix pm_runtime_get_sync() usage
Date: Wed,  2 Oct 2024 14:57:38 +0200
Message-ID: <20241002125825.226270887@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuntao Liu <liuyuntao12@huawei.com>

[ Upstream commit 55c312c1b2be6d43e39c280ad6ab4b711e545b89 ]

We need to call pm_runtime_put_noidle() when pm_runtime_get_sync()
fails, so use pm_runtime_resume_and_get() instead. this function
will handle this.

Fixes: dae5448a327ed ("clk: starfive: Add StarFive JH7110 Video-Output clock driver")
Signed-off-by: Yuntao Liu <liuyuntao12@huawei.com>
Link: https://lore.kernel.org/r/20240815093853.757487-1-liuyuntao12@huawei.com
Reviewed-by: Xingyu Wu <xingyu.wu@starfivetech.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/starfive/clk-starfive-jh7110-vout.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/starfive/clk-starfive-jh7110-vout.c b/drivers/clk/starfive/clk-starfive-jh7110-vout.c
index 53f7af234cc23..aabd0484ac23f 100644
--- a/drivers/clk/starfive/clk-starfive-jh7110-vout.c
+++ b/drivers/clk/starfive/clk-starfive-jh7110-vout.c
@@ -145,7 +145,7 @@ static int jh7110_voutcrg_probe(struct platform_device *pdev)
 
 	/* enable power domain and clocks */
 	pm_runtime_enable(priv->dev);
-	ret = pm_runtime_get_sync(priv->dev);
+	ret = pm_runtime_resume_and_get(priv->dev);
 	if (ret < 0)
 		return dev_err_probe(priv->dev, ret, "failed to turn on power\n");
 
-- 
2.43.0



