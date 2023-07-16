Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A9B8F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:45:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3BFC433C7;
	Sun, 16 Jul 2023 20:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540313;
	bh=SS2QPdxXc9dAbaHZnLKHGQRcLOOCO3CBqZ8lgQ6CMxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lGGRBZ09f4Ei8el1wH1DE/05DFQSLPELJ2B8S/0ZfGQNH+/YG6326rL9RY5g8V2RB
	 FBeI3n744A+g/Ge4WLxe4xxntird4Taqp0+hEPnHOu0GL5VgV0zbA45l6EDlRAGF15
	 p1+bPrVIkHe8A8quvbPzs3oweZ6fMt9mIlBco6Yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fei Shao <fshao@chromium.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 281/591] clk: Fix memory leak in devm_clk_notifier_register()
Date: Sun, 16 Jul 2023 21:47:00 +0200
Message-ID: <20230716194931.163777045@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fei Shao <fshao@chromium.org>

[ Upstream commit 7fb933e56f77a57ef7cfc59fc34cbbf1b1fa31ff ]

devm_clk_notifier_register() allocates a devres resource for clk
notifier but didn't register that to the device, so the notifier didn't
get unregistered on device detach and the allocated resource was leaked.

Fix the issue by registering the resource through devres_add().

This issue was found with kmemleak on a Chromebook.

Fixes: 6d30d50d037d ("clk: add devm variant of clk_notifier_register")
Signed-off-by: Fei Shao <fshao@chromium.org>
Link: https://lore.kernel.org/r/20230619112253.v2.1.I13f060c10549ef181603e921291bdea95f83033c@changeid
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index d4a74759fe292..e0de6565800d2 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -4651,6 +4651,7 @@ int devm_clk_notifier_register(struct device *dev, struct clk *clk,
 	if (!ret) {
 		devres->clk = clk;
 		devres->nb = nb;
+		devres_add(dev, devres);
 	} else {
 		devres_free(devres);
 	}
-- 
2.39.2



