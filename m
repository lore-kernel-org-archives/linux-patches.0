Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23166FAF;
	Tue,  5 Dec 2023 03:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mSpgCV1Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62152C433C7;
	Tue,  5 Dec 2023 03:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746918;
	bh=QxX+8wnRo0a+iUQXP1PWYn/fT47aweiqt9Yvtz3JHwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mSpgCV1ZDkr7Bu6GJvvyvReFHJwlG22nTB1hxSm1pbAaFaoslH1VwOCEaugGmotka
	 jjTpddYwtSW3J6z5qV5HR8iYcJmXUbALHVzR21lKb0TJEgXBjDI2okzNfCjUHQVdZ8
	 5+aoxyRF1LVbKgOIqXxO8CCGwqilzIRgezhds2lQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Niedermaier <cniedermaier@dh-electronics.com>,
	Marek Vasut <marex@denx.de>,
	Fabio Estevam <festevam@denx.de>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 66/71] cpufreq: imx6q: Dont disable 792 Mhz OPP unnecessarily
Date: Tue,  5 Dec 2023 12:17:04 +0900
Message-ID: <20231205031521.721751210@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031517.859409664@linuxfoundation.org>
References: <20231205031517.859409664@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Niedermaier <cniedermaier@dh-electronics.com>

[ Upstream commit 2e4e0984c7d696cc74cf2fd7e7f62997f0e9ebe6 ]

For a 900MHz i.MX6ULL CPU the 792MHz OPP is disabled. There is no
convincing reason to disable this OPP. If a CPU can run at 900MHz,
it should also be able to cope with 792MHz. Looking at the voltage
level of 792MHz in [1] (page 24, table 10. "Operating Ranges") the
current defined OPP is above the minimum. So the voltage level
shouldn't be a problem. However in [2] (page 24, table 10.
"Operating Ranges"), it is not mentioned that 792MHz OPP isn't
allowed. Change it to only disable 792MHz OPP for i.MX6ULL types
below 792 MHz.

[1] https://www.nxp.com/docs/en/data-sheet/IMX6ULLIEC.pdf
[2] https://www.nxp.com/docs/en/data-sheet/IMX6ULLCEC.pdf

Fixes: 0aa9abd4c212 ("cpufreq: imx6q: check speed grades for i.MX6ULL")
Signed-off-by: Christoph Niedermaier <cniedermaier@dh-electronics.com>
Reviewed-by: Marek Vasut <marex@denx.de>
Reviewed-by: Fabio Estevam <festevam@denx.de>
[ Viresh: Edited subject ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/imx6q-cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
index 1a4ea82e4c172..b3a392b4c9282 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -349,7 +349,7 @@ static int imx6ul_opp_check_speed_grading(struct device *dev)
 			imx6x_disable_freq_in_opp(dev, 696000000);
 
 	if (of_machine_is_compatible("fsl,imx6ull")) {
-		if (val != OCOTP_CFG3_6ULL_SPEED_792MHZ)
+		if (val < OCOTP_CFG3_6ULL_SPEED_792MHZ)
 			imx6x_disable_freq_in_opp(dev, 792000000);
 
 		if (val != OCOTP_CFG3_6ULL_SPEED_900MHZ)
-- 
2.42.0



