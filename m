Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4259D522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8369C433C8;
	Sun,  9 Jul 2023 11:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902314;
	bh=ue9EbbSodOQGvyTQlJM772APoYnHF0BOM8sb+4iO1ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pDyatUgI9hyTAvCoQ6glSATTX499W1S5VMP3Achc1DtZ1TByV2h7R42Cv4Vuf8wB6
	 22OWaaJiG8M8dy9HiItGWN0GI7ecbsDC3avt91Yuye0GeQl4o3WHWBqd78fd5HQLql
	 bQZunqUMC1U66qzCiESopjg3yWoUVxKs6VcQuMhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fei Shao <fshao@chromium.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 331/431] clk: Fix memory leak in devm_clk_notifier_register()
Date: Sun,  9 Jul 2023 13:14:39 +0200
Message-ID: <20230709111458.935270244@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
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
index 657b27743c4dd..15a405a5582bb 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -4694,6 +4694,7 @@ int devm_clk_notifier_register(struct device *dev, struct clk *clk,
 	if (!ret) {
 		devres->clk = clk;
 		devres->nb = nb;
+		devres_add(dev, devres);
 	} else {
 		devres_free(devres);
 	}
-- 
2.39.2



