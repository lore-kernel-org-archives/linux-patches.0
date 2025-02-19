Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9981CAA85;
	Wed, 19 Feb 2025 09:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955995; cv=none; b=EuLYDHRuYKrul4AWxB3GYvZbXOV1SpQZ6jPv0aF39G72QDbXnbqieL5tbkDqURSuTU27qMgPWxuv92pbWBJGMfnghouq94yAQpd+Y+tu1/hao/Ai26+Ry+5C3uNbEKKOas8/I/81n+Dd5+HculcJX/c5U71++JDKDUAAyE1fHDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955995; c=relaxed/simple;
	bh=dW2rv3YHECkYdR0zQJeAmLSttpkP1+t/e+3NCWkbBF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avAev9ufslasVoR4HABlQzjXAiMCfBEI8iVxfg6qHd9cAs+XTU9AhEr7jZs3EGmJboIf86/5jxC5UqTpEmvPs6Ge2Y6qFXXf4pCFDQqClVGHObwWQdvpitwpz1NwyKu1MNL57B0eDI5IQyn/XpfSfOdN/qFtT+wW/BqkWR0IzzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NhKiEE+3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NhKiEE+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72EB0C4CED1;
	Wed, 19 Feb 2025 09:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955994;
	bh=dW2rv3YHECkYdR0zQJeAmLSttpkP1+t/e+3NCWkbBF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NhKiEE+3aPa4F3+MmdxxWb1M7c/IyrI/KmCRm9EsYyn7+GT9/plsMHkqNAcYtDMB+
	 vCAlPzVNEor5WFFup9eQ8rQDP6V76CKaayxXxB4VMkG6LVX82pk95hSzeKaV3BQlJP
	 qMqLNe4xIAHF/CeLsTVpl1UXWGO44a8htP8GMVwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/578] OPP: Reuse dev_pm_opp_get_freq_indexed()
Date: Wed, 19 Feb 2025 09:20:33 +0100
Message-ID: <20250219082654.041964063@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 746de8255076c9924ffa51baad9822adddccb94e ]

Reuse dev_pm_opp_get_freq_indexed() from dev_pm_opp_get_freq().

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Stable-dep-of: b44b9bc7cab2 ("OPP: fix dev_pm_opp_find_bw_*() when bandwidth table not initialized")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/core.c     | 21 ---------------------
 include/linux/pm_opp.h | 12 +++++-------
 2 files changed, 5 insertions(+), 28 deletions(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index e1d9eddf26833..83ff32b7f4793 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -179,27 +179,6 @@ unsigned long dev_pm_opp_get_power(struct dev_pm_opp *opp)
 }
 EXPORT_SYMBOL_GPL(dev_pm_opp_get_power);
 
-/**
- * dev_pm_opp_get_freq() - Gets the frequency corresponding to an available opp
- * @opp:	opp for which frequency has to be returned for
- *
- * Return: frequency in hertz corresponding to the opp, else
- * return 0
- */
-unsigned long dev_pm_opp_get_freq(struct dev_pm_opp *opp)
-{
-	if (IS_ERR_OR_NULL(opp)) {
-		pr_err("%s: Invalid parameters\n", __func__);
-		return 0;
-	}
-
-	if (!assert_single_clk(opp->opp_table))
-		return 0;
-
-	return opp->rates[0];
-}
-EXPORT_SYMBOL_GPL(dev_pm_opp_get_freq);
-
 /**
  * dev_pm_opp_get_freq_indexed() - Gets the frequency corresponding to an
  *				   available opp with specified index
diff --git a/include/linux/pm_opp.h b/include/linux/pm_opp.h
index 23e4e4eaaa427..91f87d7e807cb 100644
--- a/include/linux/pm_opp.h
+++ b/include/linux/pm_opp.h
@@ -103,8 +103,6 @@ int dev_pm_opp_get_supplies(struct dev_pm_opp *opp, struct dev_pm_opp_supply *su
 
 unsigned long dev_pm_opp_get_power(struct dev_pm_opp *opp);
 
-unsigned long dev_pm_opp_get_freq(struct dev_pm_opp *opp);
-
 unsigned long dev_pm_opp_get_freq_indexed(struct dev_pm_opp *opp, u32 index);
 
 unsigned int dev_pm_opp_get_level(struct dev_pm_opp *opp);
@@ -214,11 +212,6 @@ static inline unsigned long dev_pm_opp_get_power(struct dev_pm_opp *opp)
 	return 0;
 }
 
-static inline unsigned long dev_pm_opp_get_freq(struct dev_pm_opp *opp)
-{
-	return 0;
-}
-
 static inline unsigned long dev_pm_opp_get_freq_indexed(struct dev_pm_opp *opp, u32 index)
 {
 	return 0;
@@ -669,4 +662,9 @@ static inline void dev_pm_opp_put_prop_name(int token)
 	dev_pm_opp_clear_config(token);
 }
 
+static inline unsigned long dev_pm_opp_get_freq(struct dev_pm_opp *opp)
+{
+	return dev_pm_opp_get_freq_indexed(opp, 0);
+}
+
 #endif		/* __LINUX_OPP_H__ */
-- 
2.39.5



