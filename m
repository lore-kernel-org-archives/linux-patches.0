Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B22118B482;
	Tue, 30 Jul 2024 16:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355602; cv=none; b=PKhgSsDP4S7DICd4RqlkrhIdt2UgIOpQeG4nwyO59h+R3q23pa37MrV2VG8VzDqctJdlXAF+om+uNBkCgiC65NzdYRJI2X2u6gtBpOQA/zrmxwW+kuJp0/RjmrnIUInqwdhiqid2dAkW8C/yrobL2/EimaVQ6pKiwiu2ENUVNQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355602; c=relaxed/simple;
	bh=SnCCYiLMc7fyZv8bhK3kyVH/Aj9SDdVB5zdcp2wKWZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alPlOloiXcI/iGCHl58/bbWZINV4MKBIc4H2n2KaKLZtJdiVXY+V9zodnvR7dZ1VfTst5yABPxzVp8P2G4k1QUK5A+wJaEV6U3oCfiKpxXIvXOmQLnkeWgigm2EEhRKk8JYb/wv6vsrtFPnm4+27hL+8UcrIu008VEH9R0lVtlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=skP3hWzV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="skP3hWzV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B5A0C32782;
	Tue, 30 Jul 2024 16:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355601;
	bh=SnCCYiLMc7fyZv8bhK3kyVH/Aj9SDdVB5zdcp2wKWZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=skP3hWzVaR4c67gZsSJ6hC1zCEJ23foeWpCLGG6B7a0sK+BM1lHPXjgZ6IVO5ZW+o
	 nqqnFWnPGTuIfIK0eBXQ4MknNzHJXI/nrKwGmeLc8I1Lyxwsq5WGn+Gv2gDdqq3G6Y
	 lmxhl5qKRhHPmD+QU3j7TDNlS+gmamqdf3KL+n6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Primoz Fiser <primoz.fiser@norik.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 070/809] cpufreq: ti-cpufreq: Handle deferred probe with dev_err_probe()
Date: Tue, 30 Jul 2024 17:39:06 +0200
Message-ID: <20240730151727.406604456@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Primoz Fiser <primoz.fiser@norik.com>

[ Upstream commit 101388b8ef1027be72e399beeb97293cce67bb24 ]

Handle deferred probing gracefully by using dev_err_probe() to not
spam console with unnecessary error messages.

Fixes: f88d152dc739 ("cpufreq: ti: Migrate to dev_pm_opp_set_config()")
Signed-off-by: Primoz Fiser <primoz.fiser@norik.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/ti-cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/ti-cpufreq.c b/drivers/cpufreq/ti-cpufreq.c
index 714ed53753fa5..5af85c4cbad0c 100644
--- a/drivers/cpufreq/ti-cpufreq.c
+++ b/drivers/cpufreq/ti-cpufreq.c
@@ -417,7 +417,7 @@ static int ti_cpufreq_probe(struct platform_device *pdev)
 
 	ret = dev_pm_opp_set_config(opp_data->cpu_dev, &config);
 	if (ret < 0) {
-		dev_err(opp_data->cpu_dev, "Failed to set OPP config\n");
+		dev_err_probe(opp_data->cpu_dev, ret, "Failed to set OPP config\n");
 		goto fail_put_node;
 	}
 
-- 
2.43.0



