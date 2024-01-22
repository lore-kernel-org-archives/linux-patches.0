Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC1A58AD4;
	Tue, 23 Jan 2024 01:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974078; cv=none; b=rkDn+YvY5ZHaQK4ED6ucI/3olvQiVUEH19mal4gWfl8jcyZRxzSuE8AR+wY9ZVV8fqXuOUFZIzBLy68NxsAWeFmv2vdQ6DU6S1hf717xQpKxnzWdqVi/Jt/+QifwFYb1F61A/7uo2VqcfBN54KPtwssVR8tEsu/16Jx8KVnZLVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974078; c=relaxed/simple;
	bh=B9gn/1ykJaoaAJVolIy8uxMnm/ApfrM6eaIlKWUAryw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQetyodkMT/S6vLIOYgZYpEBfg6hgwLxNe21damNlJvm4tJnuOieb5BotwlU0fHI94hxwIwVU8+5GLINz34hGs9seSLH+bGJSBmh30JHa2HKuwTCIVaV9Cj9GS0hsrAdSj/eb0ufpunRVzrClVdZv2jDDh/7opkQPuzJ/Q3G0y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zPsOdDBj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zPsOdDBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8CDEC433C7;
	Tue, 23 Jan 2024 01:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974077;
	bh=B9gn/1ykJaoaAJVolIy8uxMnm/ApfrM6eaIlKWUAryw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zPsOdDBjSbDoHgJeveS4sbzOKN/pnqX7nMzXPHj7F9Tsb/H1keIV8/ZtoI5TBhEFz
	 PsWf75wqP7vd3HNDEYYK/fzkTFWVyGeY0+63mjqxdmhv61v9SNBaS5oSLkduturxmK
	 bO2f0zSValPSpwcY/qClhJEPdrGyCtCCc5ddPa50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Diupina <adiupina@astralinux.ru>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/583] cpufreq: scmi: process the result of devm_of_clk_add_hw_provider()
Date: Mon, 22 Jan 2024 15:51:20 -0800
Message-ID: <20240122235813.076808977@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f34e6382a4c5..028df8a5f537 100644
--- a/drivers/cpufreq/scmi-cpufreq.c
+++ b/drivers/cpufreq/scmi-cpufreq.c
@@ -310,8 +310,11 @@ static int scmi_cpufreq_probe(struct scmi_device *sdev)
 
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



