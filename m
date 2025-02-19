Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FE51DF974;
	Wed, 19 Feb 2025 09:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955989; cv=none; b=mASnZ5VE1ESNgJT4BmFaHxyhYeVLrihaSwZfgrxgQSRSNfuIR/0Qy6IVI0cqL9AnhZWROCoKKJRI+sSt0NyH0rsBZ3Yg07ITDMbU94wSHONQLOka3TvZ4XqpJymAyfrON+XYlMZwJlKf7zObA4ru9QdvQ2EMsI+TZXgCLzURh9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955989; c=relaxed/simple;
	bh=V9OsOhcSil6AsCUKlvA0ZVojbqT9T4yWEYlVIOGoMvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p2GaskykP+W7xTA3zBu2c7Dr5ezG7Yw2Qn6vbgOT+Z/n9eO8gUCUmduKQjK1MAvAzd3V+EjbZhPiQ/q1tyAXjQcnbLkv7CmmIL40VuMB8dDdFI2iiABPDCYtShRX82XR0yGy5PUNtzKqGS+fovtwjMrpC9Fqs+0e/L8AAl7U0/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BnIpVfTq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BnIpVfTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E9CC4CED1;
	Wed, 19 Feb 2025 09:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955989;
	bh=V9OsOhcSil6AsCUKlvA0ZVojbqT9T4yWEYlVIOGoMvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BnIpVfTqItZmo72rjKicF/ZQCIERSNw8sfb1rDHAFlWJaGy7Lw/cgWlq6i6W2Bj9I
	 q9RWNi0R0/eKzTdXLBR4BrDSxeRn9aJe8p86Z06hfxajkunZVsrZGI/8j4TMqypvQS
	 2vmBfF9qRRXezFbnaBoiH6oF2YhsydP8ZVPMDZp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/578] OPP: Introduce dev_pm_opp_get_freq_indexed() API
Date: Wed, 19 Feb 2025 09:20:31 +0100
Message-ID: <20250219082653.963559714@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 5f756d03e2c7db63c1df7148d7b1739f29ff1532 ]

In the case of devices with multiple clocks, drivers need to specify the
frequency index for the OPP framework to get the specific frequency within
the required OPP. So let's introduce the dev_pm_opp_get_freq_indexed() API
accepting the frequency index as an argument.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
[ Viresh: Fixed potential access to NULL opp pointer ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Stable-dep-of: b44b9bc7cab2 ("OPP: fix dev_pm_opp_find_bw_*() when bandwidth table not initialized")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/core.c     | 20 ++++++++++++++++++++
 include/linux/pm_opp.h |  7 +++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index 8775f9d71f90a..1483d10627fba 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -200,6 +200,26 @@ unsigned long dev_pm_opp_get_freq(struct dev_pm_opp *opp)
 }
 EXPORT_SYMBOL_GPL(dev_pm_opp_get_freq);
 
+/**
+ * dev_pm_opp_get_freq_indexed() - Gets the frequency corresponding to an
+ *				   available opp with specified index
+ * @opp: opp for which frequency has to be returned for
+ * @index: index of the frequency within the required opp
+ *
+ * Return: frequency in hertz corresponding to the opp with specified index,
+ * else return 0
+ */
+unsigned long dev_pm_opp_get_freq_indexed(struct dev_pm_opp *opp, u32 index)
+{
+	if (IS_ERR_OR_NULL(opp) || index >= opp->opp_table->clk_count) {
+		pr_err("%s: Invalid parameters\n", __func__);
+		return 0;
+	}
+
+	return opp->rates[index];
+}
+EXPORT_SYMBOL_GPL(dev_pm_opp_get_freq_indexed);
+
 /**
  * dev_pm_opp_get_level() - Gets the level corresponding to an available opp
  * @opp:	opp for which level value has to be returned for
diff --git a/include/linux/pm_opp.h b/include/linux/pm_opp.h
index 2617f2c51f29d..a13a1705df57b 100644
--- a/include/linux/pm_opp.h
+++ b/include/linux/pm_opp.h
@@ -105,6 +105,8 @@ unsigned long dev_pm_opp_get_power(struct dev_pm_opp *opp);
 
 unsigned long dev_pm_opp_get_freq(struct dev_pm_opp *opp);
 
+unsigned long dev_pm_opp_get_freq_indexed(struct dev_pm_opp *opp, u32 index);
+
 unsigned int dev_pm_opp_get_level(struct dev_pm_opp *opp);
 
 unsigned int dev_pm_opp_get_required_pstate(struct dev_pm_opp *opp,
@@ -213,6 +215,11 @@ static inline unsigned long dev_pm_opp_get_freq(struct dev_pm_opp *opp)
 	return 0;
 }
 
+static inline unsigned long dev_pm_opp_get_freq_indexed(struct dev_pm_opp *opp, u32 index)
+{
+	return 0;
+}
+
 static inline unsigned int dev_pm_opp_get_level(struct dev_pm_opp *opp)
 {
 	return 0;
-- 
2.39.5



