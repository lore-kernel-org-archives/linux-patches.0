Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E1F8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E075FC433C8;
	Sun, 16 Jul 2023 20:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538448;
	bh=PnPAnvrqw/dVRWaLGv37cyp+zCHXUr/NVoBySgyapW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KK5BMlVJ8Flgi2JX6+11VpGRrG4hreOvbFXW2O0XeVXrenFerIL090xuohpVPOn5K
	 zXBa0QVRbKDxsN8PPrL6NbVrruZ7orpCmkISZjI2jaKlnBXGnnvzpZOL8ONUJ9yHgz
	 LBANnvsJ2dbk/lTg98goABlvcN8yLm028gyGjuKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fei Shao <fshao@chromium.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 427/800] clk: Fix memory leak in devm_clk_notifier_register()
Date: Sun, 16 Jul 2023 21:44:40 +0200
Message-ID: <20230716194959.005277851@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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
index e495dd7a1eae1..8c13bcf57f1ae 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -4696,6 +4696,7 @@ int devm_clk_notifier_register(struct device *dev, struct clk *clk,
 	if (!ret) {
 		devres->clk = clk;
 		devres->nb = nb;
+		devres_add(dev, devres);
 	} else {
 		devres_free(devres);
 	}
-- 
2.39.2



