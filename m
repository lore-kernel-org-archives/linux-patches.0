Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBD51292EC;
	Tue, 23 Jan 2024 00:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971003; cv=none; b=ibvq4IULo37dnZGwedS4+uwoniMOeSOwOgliYTymDh84CtcHN3VhQIHN5dJ2Hx7EeNJWJ8EH25RKt0ORNJFCg3A+6GEAICsL/9dJ1iIdYwcf4w6b+E9bg3HBdyQ6U46Vi0ymjr0VF9B1Y6W1xO6anlw0verkeAkAxwcCvEn6xB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971003; c=relaxed/simple;
	bh=ubUFFKf4x680k7HOn3qGMivDVS/q1wGBj/VjGMPf06k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WAUX/O09HJVQedw9bnSXZE9lpXTxqxWHyJXcU94nb1DRI0DR3G4PUELiDUS5tZGBwZwdWPPvx7hT+ddcnNClr3QzmaSK7KVP2fSNMN8AM2Srm6glsaJrMMShaK3Py4S7dzcrgWq3TzKSkEPYOeAd/t0eTU0f1Rzp+QSTCA9WK0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EdKBM2Mm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EdKBM2Mm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F117AC43390;
	Tue, 23 Jan 2024 00:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971003;
	bh=ubUFFKf4x680k7HOn3qGMivDVS/q1wGBj/VjGMPf06k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EdKBM2Mmsv+Q87zC80ho7oBBPTM0tPWTDlrdEDizqUpmgBgasYIKGvNfJLyWLybNF
	 H13aFIBiWHYC2LHVt12XGw9nj+/0DLLO9P/Z8nGb361wtXv2My2Y0vESPRM0PJN1Sg
	 y0lVXH68uVJrLyKVJdo/J5RJ+PevIAH2WlpYHTeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Diupina <adiupina@astralinux.ru>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/286] cpufreq: scmi: process the result of devm_of_clk_add_hw_provider()
Date: Mon, 22 Jan 2024 15:56:14 -0800
Message-ID: <20240122235734.640691337@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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
index ca95b538c48a..bb1389f276d7 100644
--- a/drivers/cpufreq/scmi-cpufreq.c
+++ b/drivers/cpufreq/scmi-cpufreq.c
@@ -238,8 +238,11 @@ static int scmi_cpufreq_probe(struct scmi_device *sdev)
 
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



