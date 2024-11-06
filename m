Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7251DF260;
	Wed,  6 Nov 2024 12:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894924; cv=none; b=sKS3RkNykKcTfNlrmaz5KyuwcMouGnoJ/xS7PkIC9l4vyXXaKOZGJ4K06zRWaKG8Im1h4iqdaFpcom6CFql2dfBCtK/7S/Y9u/tOqZ3OolXNOKUtIBo07847llcLILNQcNPVPkleOD/uP3GXc51S09rySf2na8/8pFSlKWoKZqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894924; c=relaxed/simple;
	bh=sXXwR8fDB9zQ0CPyKZWjLhm7DavEIxmGxf66gD36jdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTxfTswmieGst8bT2h5gBG5vYA4LhO5X1Q5aDrpAB5sdrwRvqxExABdSTOoJKPUSUEEr8lQRnHRew6WJWvvhU6h0xmlH6fsA5ba34qcmzOLUz14KTLy8SAotuZVtyln21mg37DPTs2eixd7jnsVVVnE6tXmPzAs2Fa5GwDXJ5ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=umziaj4b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="umziaj4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4945C4CECD;
	Wed,  6 Nov 2024 12:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894924;
	bh=sXXwR8fDB9zQ0CPyKZWjLhm7DavEIxmGxf66gD36jdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=umziaj4bkScJzyUmxFmmD56dq0k3Zgio/3YNYjK59CUSyRjhx5NjozXFaeDK1dZho
	 VtydIZnIil3JPhJmo/K4RyJKUZB+GnrcLmnfJuaYBPSt2g+QEdIaGvgxjJb/O3ffeE
	 M4tE1EdkwB+2EvjOp61dT7IvzsG2ijvD/c2nzyB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Agrawal <agrawal.ag.ankit@gmail.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 044/350] clocksource/drivers/qcom: Add missing iounmap() on errors in msm_dt_timer_init()
Date: Wed,  6 Nov 2024 12:59:32 +0100
Message-ID: <20241106120321.976023622@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

From: Ankit Agrawal <agrawal.ag.ankit@gmail.com>

[ Upstream commit ca140a0dc0a18acd4653b56db211fec9b2339986 ]

Add the missing iounmap() when clock frequency fails to get read by the
of_property_read_u32() call, or if the call to msm_timer_init() fails.

Fixes: 6e3321631ac2 ("ARM: msm: Add DT support to msm_timer")
Signed-off-by: Ankit Agrawal <agrawal.ag.ankit@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240713095713.GA430091@bnew-VirtualBox
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-qcom.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/timer-qcom.c b/drivers/clocksource/timer-qcom.c
index 89816f89ff3f4..83385bc431acc 100644
--- a/drivers/clocksource/timer-qcom.c
+++ b/drivers/clocksource/timer-qcom.c
@@ -242,6 +242,7 @@ static int __init msm_dt_timer_init(struct device_node *np)
 	}
 
 	if (of_property_read_u32(np, "clock-frequency", &freq)) {
+		iounmap(cpu0_base);
 		pr_err("Unknown frequency\n");
 		return -EINVAL;
 	}
@@ -252,7 +253,11 @@ static int __init msm_dt_timer_init(struct device_node *np)
 	freq /= 4;
 	writel_relaxed(DGT_CLK_CTL_DIV_4, source_base + DGT_CLK_CTL);
 
-	return msm_timer_init(freq, 32, irq, !!percpu_offset);
+	ret = msm_timer_init(freq, 32, irq, !!percpu_offset);
+	if (ret)
+		iounmap(cpu0_base);
+
+	return ret;
 }
 TIMER_OF_DECLARE(kpss_timer, "qcom,kpss-timer", msm_dt_timer_init);
 TIMER_OF_DECLARE(scss_timer, "qcom,scss-timer", msm_dt_timer_init);
-- 
2.43.0



