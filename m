Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81541CFEB3;
	Wed,  2 Oct 2024 14:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877631; cv=none; b=abxZCtSPXq1aVhna7jGcaBqfQVFpHBN8dLRKfFrZQv31O2j5m7eygOr+kNfvvXC7uY0BF+ka3piIIoKzjJiRvRPxvBtO63YKgPdAucmZWSyu8ogFkINbC3DlvqDP4m5qCN9Kv0u/cKzW+AuK8MIJRnTVnWOnkQYnYLVWTFVd9ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877631; c=relaxed/simple;
	bh=MncaevKxwDNi0uR8IfcuS4rj1H9wH4BLMEWSC6M5/yA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWEqa6+k403HvJAx4Y79mwRgVAVQWhY2Ueap8M24MjbtfmzTFS2006V+oI2Lzd0zDVCGAOagA2K4Reg6YsHU029Aw5H5BPYBmSexxJQ1akwC3wf/U03cG57DW/NCotMa6uQKlE+yHo1GFhGKkvExb/TI29nu8+uRYrQm3+j3Fzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wHZdG0sG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wHZdG0sG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD01C4CEC2;
	Wed,  2 Oct 2024 14:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877631;
	bh=MncaevKxwDNi0uR8IfcuS4rj1H9wH4BLMEWSC6M5/yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wHZdG0sGeKq8Lgi/xsu/EwuR5yHg7JJ/Ab2ZwWrH5RCBt/eVSRnV7g56Rl5a37ifQ
	 +6/FeVaaSkUvXIrHFbhcVedpcknf650ebOQUkPLJsukHzretWOIUyfZxS6eXOnvZ27
	 yfo55TXvSvRHGoePI1T+gaSKisvjnILpqBIeZHfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Agrawal <agrawal.ag.ankit@gmail.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 141/634] clocksource/drivers/qcom: Add missing iounmap() on errors in msm_dt_timer_init()
Date: Wed,  2 Oct 2024 14:54:01 +0200
Message-ID: <20241002125816.671870072@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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



