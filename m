Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC03B8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28026C433C8;
	Sun, 16 Jul 2023 20:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538276;
	bh=QmyoPhc8oqcfrdYx4GG1NRP9m93AUCsoQj7HpxhFJF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PSnnSA/IQWRAAzgNwfAHzGO1zPLT4UyRCt281RbJENW1eXScm4iwklaDmWRnPSfcR
	 1wrcxydrKzN8jnR2kHmdFtGCuhBigXO/c+KN6sU8FbfXo5oQF6tP2tTUhNfFnh/ezA
	 VxLugsJOlJ84nAHPM42BDDxtydQwjAlUf+e85hoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Michal Simek <michal.simek@amd.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 391/800] clk: clocking-wizard: Fix Oops in clk_wzrd_register_divider()
Date: Sun, 16 Jul 2023 21:44:04 +0200
Message-ID: <20230716194958.154651562@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 9c632a6396505a019ea6d12b5ab45e659a542a93 ]

Smatch detected this potential error pointer dereference
clk_wzrd_register_divider().  If devm_clk_hw_register() fails then
it sets "hw" to an error pointer and then dereferences it on the
next line.  Return the error directly instead.

Fixes: 5a853722eb32 ("staging: clocking-wizard: Add support for dynamic reconfiguration")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/f0e39b5c-4554-41e0-80d9-54ca3fabd060@kili.mountain
Reviewed-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/xilinx/clk-xlnx-clock-wizard.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/xilinx/clk-xlnx-clock-wizard.c b/drivers/clk/xilinx/clk-xlnx-clock-wizard.c
index e83f104fad029..16df34f46280f 100644
--- a/drivers/clk/xilinx/clk-xlnx-clock-wizard.c
+++ b/drivers/clk/xilinx/clk-xlnx-clock-wizard.c
@@ -525,7 +525,7 @@ static struct clk *clk_wzrd_register_divider(struct device *dev,
 	hw = &div->hw;
 	ret = devm_clk_hw_register(dev, hw);
 	if (ret)
-		hw = ERR_PTR(ret);
+		return ERR_PTR(ret);
 
 	return hw->clk;
 }
-- 
2.39.2



