Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEE06AC2;
	Tue,  5 Dec 2023 03:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B1i73OmV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC84C433C8;
	Tue,  5 Dec 2023 03:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747811;
	bh=k0ixwN+1mCeSbVL74Em1ZHXXVsA4CwWHwirVy0Jjbgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B1i73OmVyBcikSOyzadpdaeEQieUN4HVpN7nBwStdVKxcG8e1PujyVA2eHvTW8KWG
	 ojVNJpkUqDuo7qgr0Mrt5sDo/HPDtZAVYpJCPWtg/dEy6JOvp0m0OyfivddrQ6jCOD
	 nNjHUO9jiY+y+3D2AjH1k8WkMkmK7uRTk+nP4/Ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Niedermaier <cniedermaier@dh-electronics.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 60/67] cpufreq: imx6q: dont warn for disabling a non-existing frequency
Date: Tue,  5 Dec 2023 12:17:45 +0900
Message-ID: <20231205031523.340768521@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031519.853779502@linuxfoundation.org>
References: <20231205031519.853779502@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Niedermaier <cniedermaier@dh-electronics.com>

[ Upstream commit 11a3b0ac33d95aa84be426e801f800997262a225 ]

It is confusing if a warning is given for disabling a non-existent
frequency of the operating performance points (OPP). In this case
the function dev_pm_opp_disable() returns -ENODEV. Check the return
value and avoid the output of a warning in this case. Avoid code
duplication by using a separate function.

Signed-off-by: Christoph Niedermaier <cniedermaier@dh-electronics.com>
[ Viresh : Updated commit subject ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Stable-dep-of: 2e4e0984c7d6 ("cpufreq: imx6q: Don't disable 792 Mhz OPP unnecessarily")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/imx6q-cpufreq.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
index 90beb26ed34e9..37d30fa2df5fa 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -209,6 +209,14 @@ static struct cpufreq_driver imx6q_cpufreq_driver = {
 	.suspend = cpufreq_generic_suspend,
 };
 
+static void imx6x_disable_freq_in_opp(struct device *dev, unsigned long freq)
+{
+	int ret = dev_pm_opp_disable(dev, freq);
+
+	if (ret < 0 && ret != -ENODEV)
+		dev_warn(dev, "failed to disable %ldMHz OPP\n", freq / 1000000);
+}
+
 #define OCOTP_CFG3			0x440
 #define OCOTP_CFG3_SPEED_SHIFT		16
 #define OCOTP_CFG3_SPEED_1P2GHZ		0x3
@@ -254,17 +262,15 @@ static int imx6q_opp_check_speed_grading(struct device *dev)
 	val &= 0x3;
 
 	if (val < OCOTP_CFG3_SPEED_996MHZ)
-		if (dev_pm_opp_disable(dev, 996000000))
-			dev_warn(dev, "failed to disable 996MHz OPP\n");
+		imx6x_disable_freq_in_opp(dev, 996000000);
 
 	if (of_machine_is_compatible("fsl,imx6q") ||
 	    of_machine_is_compatible("fsl,imx6qp")) {
 		if (val != OCOTP_CFG3_SPEED_852MHZ)
-			if (dev_pm_opp_disable(dev, 852000000))
-				dev_warn(dev, "failed to disable 852MHz OPP\n");
+			imx6x_disable_freq_in_opp(dev, 852000000);
+
 		if (val != OCOTP_CFG3_SPEED_1P2GHZ)
-			if (dev_pm_opp_disable(dev, 1200000000))
-				dev_warn(dev, "failed to disable 1.2GHz OPP\n");
+			imx6x_disable_freq_in_opp(dev, 1200000000);
 	}
 
 	return 0;
@@ -316,20 +322,16 @@ static int imx6ul_opp_check_speed_grading(struct device *dev)
 	val >>= OCOTP_CFG3_SPEED_SHIFT;
 	val &= 0x3;
 
-	if (of_machine_is_compatible("fsl,imx6ul")) {
+	if (of_machine_is_compatible("fsl,imx6ul"))
 		if (val != OCOTP_CFG3_6UL_SPEED_696MHZ)
-			if (dev_pm_opp_disable(dev, 696000000))
-				dev_warn(dev, "failed to disable 696MHz OPP\n");
-	}
+			imx6x_disable_freq_in_opp(dev, 696000000);
 
 	if (of_machine_is_compatible("fsl,imx6ull")) {
 		if (val != OCOTP_CFG3_6ULL_SPEED_792MHZ)
-			if (dev_pm_opp_disable(dev, 792000000))
-				dev_warn(dev, "failed to disable 792MHz OPP\n");
+			imx6x_disable_freq_in_opp(dev, 792000000);
 
 		if (val != OCOTP_CFG3_6ULL_SPEED_900MHZ)
-			if (dev_pm_opp_disable(dev, 900000000))
-				dev_warn(dev, "failed to disable 900MHz OPP\n");
+			imx6x_disable_freq_in_opp(dev, 900000000);
 	}
 
 	return ret;
-- 
2.42.0



