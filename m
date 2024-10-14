Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512F6481B7;
	Mon, 14 Oct 2024 14:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917620; cv=none; b=fl8dFNj7J5RWS1uNqLvf4LvYJz9l1p94JOMydr/8h2A9AAZfNwforjPeeOxNzoJ82msiAgii/PR+9ZHjjRgN3xnR9Xjvi3wh1VdHLXNPcUQQpgEwK0Ha8HxoScIjc7eI0HPJT97RlOpKjLZu+Mj3i3oQtUs4eE/b9m1xxk4iXt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917620; c=relaxed/simple;
	bh=p27O/UmQorFC6lpt44+tiMOj+N6qKFv4/fINFQ6422w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MRH1mFLOt0iQclOZi1w56WKjynm4BiowxmbMOJ2o8MB0mPJYjf6Lw4qfBh5NH0/rtv13T2d2xvunzVRimzjJxSFlxa0kMVRwPWO17eNulH6JvwaJwXaSGmwQoQBtiwsYjjF4BvQMjQgkGGNHSTwSRK6eb5O+aWWf9cVb1Yrb9aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g4FwfaP/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g4FwfaP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B017FC4CEC3;
	Mon, 14 Oct 2024 14:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917620;
	bh=p27O/UmQorFC6lpt44+tiMOj+N6qKFv4/fINFQ6422w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g4FwfaP/XfNVsQayZ+kKXpkpbC5hO7ocG3/hoeXpcom6XsoSwMuR/ooK4fG7rers+
	 i2VD27EY9Tw70/1YzH+NZyCLUmxPUujTnk42K4ga9BtG4FXPY0fGKpgnw/roFpUpXI
	 iUU6mvDtzsSymKRa5kZQiCE/pZwZCQ7MP5SlWWUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Agrawal <agrawal.ag.ankit@gmail.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 083/798] clocksource/drivers/qcom: Add missing iounmap() on errors in msm_dt_timer_init()
Date: Mon, 14 Oct 2024 16:10:37 +0200
Message-ID: <20241014141221.196121676@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b4afe3a675835..eac4c95c6127f 100644
--- a/drivers/clocksource/timer-qcom.c
+++ b/drivers/clocksource/timer-qcom.c
@@ -233,6 +233,7 @@ static int __init msm_dt_timer_init(struct device_node *np)
 	}
 
 	if (of_property_read_u32(np, "clock-frequency", &freq)) {
+		iounmap(cpu0_base);
 		pr_err("Unknown frequency\n");
 		return -EINVAL;
 	}
@@ -243,7 +244,11 @@ static int __init msm_dt_timer_init(struct device_node *np)
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



