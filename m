Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFF5847F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:56:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC18C433EF;
	Fri, 10 Mar 2023 13:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456618;
	bh=CORs0OV9739NaLsoe+hSIXd0tasqwgI24jdoa62SmTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yP/236rXul5fXF3svyx9s4xw0hC5vlvc6IOW7LD1JqtAxzVY/H/Cm9ouOHzmTcv2y
	 ndu9dkxDPL3BqJ2Tto+dRko8sqaWEXRofOm0IThtosqHpM7PFRO0j1IFlbv/mOQNBX
	 U0i5DNBAhssGz9wF06K5x0DSD2p+jJnV8HIgUJLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Cherian <george.cherian@marvell.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 065/211] watchdog: sbsa_wdog: Make sure the timeout programming is within the limits
Date: Fri, 10 Mar 2023 14:37:25 +0100
Message-Id: <20230310133720.712295202@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: George Cherian <george.cherian@marvell.com>

[ Upstream commit 000987a38b53c172f435142a4026dd71378ca464 ]

Make sure to honour the max_hw_heartbeat_ms while programming the timeout
value to WOR. Clamp the timeout passed to sbsa_gwdt_set_timeout() to
make sure the programmed value is within the permissible range.

Fixes: abd3ac7902fb ("watchdog: sbsa: Support architecture version 1")

Signed-off-by: George Cherian <george.cherian@marvell.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20230209021117.1512097-1-george.cherian@marvell.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/sbsa_gwdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/sbsa_gwdt.c b/drivers/watchdog/sbsa_gwdt.c
index 9791c74aebd48..63862803421f1 100644
--- a/drivers/watchdog/sbsa_gwdt.c
+++ b/drivers/watchdog/sbsa_gwdt.c
@@ -150,6 +150,7 @@ static int sbsa_gwdt_set_timeout(struct watchdog_device *wdd,
 	struct sbsa_gwdt *gwdt = watchdog_get_drvdata(wdd);
 
 	wdd->timeout = timeout;
+	timeout = clamp_t(unsigned int, timeout, 1, wdd->max_hw_heartbeat_ms / 1000);
 
 	if (action)
 		sbsa_gwdt_reg_write(gwdt->clk * timeout, gwdt);
-- 
2.39.2



