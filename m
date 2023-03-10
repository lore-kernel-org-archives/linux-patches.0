Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214048825
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:55:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB92C433D2;
	Fri, 10 Mar 2023 14:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460157;
	bh=2WQbXXLgLp7LJ5OBhNG908yH9LO8bkkmgZMwQm6kXkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MCKw9mF3qNBH7/hbbt6xWoIAUlgIYHMpITUC9NaA5CLAVJ4gcCXzl9e+ZnGQs2zcJ
	 CqRxPCaSFRHguptlXq45DTL+WgRI6MixN/eu8+JBKneeAglnPRxkiiczHRlGfUSnZL
	 F5t7tYrp66Co6cIp9LgKmxbi8LS21czsn/Jkk5+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 241/529] clk: imx: avoid memory leak
Date: Fri, 10 Mar 2023 14:36:24 +0100
Message-Id: <20230310133816.137169686@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit f4419db4086e8c31821da14140e81498516a3c75 ]

In case imx_register_uart_clocks return early, the imx_uart_clocks
memory will be no freed. So execute kfree always to avoid memory leak.

Fixes: 379c9a24cc23 ("clk: imx: Fix reparenting of UARTs not associated with stdout")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20230104110032.1220721-2-peng.fan@oss.nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk.c b/drivers/clk/imx/clk.c
index 7cc669934253a..d4cf0c7045ab2 100644
--- a/drivers/clk/imx/clk.c
+++ b/drivers/clk/imx/clk.c
@@ -201,9 +201,10 @@ static int __init imx_clk_disable_uart(void)
 			clk_disable_unprepare(imx_uart_clocks[i]);
 			clk_put(imx_uart_clocks[i]);
 		}
-		kfree(imx_uart_clocks);
 	}
 
+	kfree(imx_uart_clocks);
+
 	return 0;
 }
 late_initcall_sync(imx_clk_disable_uart);
-- 
2.39.2



