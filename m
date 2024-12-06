Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8AF1494D9;
	Fri,  6 Dec 2024 14:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496214; cv=none; b=BCzb3HYRMsFv/LbVQMc/XTj8vvGzY9OFPgeBBA0TAioy4q7Ku4Q2wPoUhDDMGXNYB9iHvwDjisnPT5RmqPf5Xx4bfSxdD/wk0/i19Pnl4iVoGKQRwMg4M+Fp2vD80zXsPaTFoMhiJakvYRGFfC/V/sI8UKJEndGuGSJGtC1uYYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496214; c=relaxed/simple;
	bh=k/DF4UjmyZbCkwCKn5W5a2tH1Z96639RpLHool5Qe2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIg5v3+bENo8VRhWeVC47PkPsf+jhbVcJshPd0nIxlpagbNBUHr2/Tc82Mt8Obj+sGlPJNOR2qRXFT9riZ6xd/zMEwTaVAd8LIczPi07mzPf4kbdK7ZiDIrLs6v9FhkqigFHp6EpZvkpl+lB5wgMwvYG7CUInBs/MgcwMQLDIJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q39FGKJf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q39FGKJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B42FC4CED1;
	Fri,  6 Dec 2024 14:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496214;
	bh=k/DF4UjmyZbCkwCKn5W5a2tH1Z96639RpLHool5Qe2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q39FGKJfk9CezEDJAOSK33MIIS9t3LFytB7FhqMy4NT6pw1/AsOdjIRSyDleEPSwg
	 Ulgj6QNHP3qveCxPXnazjgntbyNbp9xseBwRNdwMtB86KGO4Qi3Y0jFVT4FhtJuBhO
	 m+q+d3yqGFpGBBf9sgtP2lk/hqeax/Y46p4Ji8Ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sibi Sankar <quic_sibis@quicinc.com>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 6.12 053/146] cpufreq: scmi: Fix cleanup path when boost enablement fails
Date: Fri,  6 Dec 2024 15:36:24 +0100
Message-ID: <20241206143529.705397434@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sibi Sankar <quic_sibis@quicinc.com>

commit 8c776a54d9ef3e945db2fe407ad6ad4525422943 upstream.

Include free_cpufreq_table in the cleanup path when boost enablement fails.

cc: stable@vger.kernel.org
Fixes: a8e949d41c72 ("cpufreq: scmi: Enable boost support")
Signed-off-by: Sibi Sankar <quic_sibis@quicinc.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/scmi-cpufreq.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/cpufreq/scmi-cpufreq.c
+++ b/drivers/cpufreq/scmi-cpufreq.c
@@ -287,7 +287,7 @@ static int scmi_cpufreq_init(struct cpuf
 		ret = cpufreq_enable_boost_support();
 		if (ret) {
 			dev_warn(cpu_dev, "failed to enable boost: %d\n", ret);
-			goto out_free_opp;
+			goto out_free_table;
 		} else {
 			scmi_cpufreq_hw_attr[1] = &cpufreq_freq_attr_scaling_boost_freqs;
 			scmi_cpufreq_driver.boost_enabled = true;
@@ -296,6 +296,8 @@ static int scmi_cpufreq_init(struct cpuf
 
 	return 0;
 
+out_free_table:
+	dev_pm_opp_free_cpufreq_table(cpu_dev, &freq_table);
 out_free_opp:
 	dev_pm_opp_remove_all_dynamic(cpu_dev);
 


