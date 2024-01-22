Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67131487C4;
	Tue, 23 Jan 2024 00:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969146; cv=none; b=BOLZnYP/BWyw6iTfQi3Y+6xxD5qhwrt7DiUItUEch1hpoXpEMHENnVaaP9mgakk68JOCDkeVj+13dmOZ7OEX0qbXONNeTQppNStuYGrno9pRuEsv4KhC01vegHJaV+OnCvxl8hgtdo0c0UT2Kc/lCZ8AWMd5ID8ofiuxwwQcbWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969146; c=relaxed/simple;
	bh=3tROXfNka0I+koYB0yUCBXEyCKtXnboUCZlEpqAWKwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nTzj7fdpKZOlTod4fK5eiJp8dO+UQ01Dg9DpFrBRYKAwuCyIAdHkQAmE50We6EYLiHy/b6yWjvwgDOxkPAMAkpEuJIx2Z4aEH02irWBs/tl0ltXiUn5w9Q4u+pn5J9bYnVkQMQ12GC51vlPSIRUpF4YCADjSBaXt7jkt+9o+d2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2o5ha95c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2o5ha95c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBFFC433A6;
	Tue, 23 Jan 2024 00:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969146;
	bh=3tROXfNka0I+koYB0yUCBXEyCKtXnboUCZlEpqAWKwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2o5ha95cHAMaqpC07IMGHRo0UWwSrKwpAiIs2oUhEUFVHoSpBQPzQBB1Z474/+cFm
	 yP2f8U8IQryKUxOrfSHzz1pSun0yP0jP72fXPXZYWfJINv0jI2qDXQfCdE7SvlZi9H
	 7Wd7FQ9T+68806kSAMeWWs+vzA4yzHuwkMqV41F0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Diupina <adiupina@astralinux.ru>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 029/641] cpufreq: scmi: process the result of devm_of_clk_add_hw_provider()
Date: Mon, 22 Jan 2024 15:48:53 -0800
Message-ID: <20240122235819.001067013@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandra Diupina <adiupina@astralinux.ru>

[ Upstream commit c4a5118a3ae1eadc687d84eef9431f9e13eb015c ]

devm_of_clk_add_hw_provider() may return an errno, so
add a return value check

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 8410e7f3b31e ("cpufreq: scmi: Fix OPP addition failure with a dummy clock provider")
Signed-off-by: Alexandra Diupina <adiupina@astralinux.ru>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/scmi-cpufreq.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/scmi-cpufreq.c b/drivers/cpufreq/scmi-cpufreq.c
index c8a7ccc42c16..4ee23f4ebf4a 100644
--- a/drivers/cpufreq/scmi-cpufreq.c
+++ b/drivers/cpufreq/scmi-cpufreq.c
@@ -334,8 +334,11 @@ static int scmi_cpufreq_probe(struct scmi_device *sdev)
 
 #ifdef CONFIG_COMMON_CLK
 	/* dummy clock provider as needed by OPP if clocks property is used */
-	if (of_property_present(dev->of_node, "#clock-cells"))
-		devm_of_clk_add_hw_provider(dev, of_clk_hw_simple_get, NULL);
+	if (of_property_present(dev->of_node, "#clock-cells")) {
+		ret = devm_of_clk_add_hw_provider(dev, of_clk_hw_simple_get, NULL);
+		if (ret)
+			return dev_err_probe(dev, ret, "%s: registering clock provider failed\n", __func__);
+	}
 #endif
 
 	ret = cpufreq_register_driver(&scmi_cpufreq_driver);
-- 
2.43.0



