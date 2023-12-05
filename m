Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8826A6FB1;
	Tue,  5 Dec 2023 03:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WqxaZV7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D0DC433C8;
	Tue,  5 Dec 2023 03:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747572;
	bh=jxIekVJqdBf+DfodXQFledhsdAmu+qnk640N4xnk6Zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WqxaZV7aPwTcie+dn1+/g8MZs5exOoxpAsUsvGYp1bgevreXsY1Z6JclTl2LKqTQ+
	 N3wrvitn4rTcMWBVep12FOk78dAr36M4MbYYWlvsQZyKrsy7e9HTz3qeHGH7kVqfpp
	 T3YV3XJbPw9Ag8YbF/F1zSeqg9FVritysI1vsmA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Niedermaier <cniedermaier@dh-electronics.com>,
	Marek Vasut <marex@denx.de>,
	Fabio Estevam <festevam@denx.de>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 125/135] cpufreq: imx6q: Dont disable 792 Mhz OPP unnecessarily
Date: Tue,  5 Dec 2023 12:17:26 +0900
Message-ID: <20231205031538.791131591@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031530.557782248@linuxfoundation.org>
References: <20231205031530.557782248@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index cc874d0c4395a..00f7ad7466680 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -327,7 +327,7 @@ static int imx6ul_opp_check_speed_grading(struct device *dev)
 			imx6x_disable_freq_in_opp(dev, 696000000);
 
 	if (of_machine_is_compatible("fsl,imx6ull")) {
-		if (val != OCOTP_CFG3_6ULL_SPEED_792MHZ)
+		if (val < OCOTP_CFG3_6ULL_SPEED_792MHZ)
 			imx6x_disable_freq_in_opp(dev, 792000000);
 
 		if (val != OCOTP_CFG3_6ULL_SPEED_900MHZ)
-- 
2.42.0



