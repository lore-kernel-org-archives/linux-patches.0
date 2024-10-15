Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FD21E7C14;
	Tue, 15 Oct 2024 11:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992651; cv=none; b=kWOF+XKawRT3JS/YrihMx+LZTzbSboQHcDPYzizuf4HgTEsbl6uqB+Nyfm6RNaZ1OERR5Th1SChd7IOItOarWcoJGy6fewhyykU6htZLBzCK8a8/E4d8bcqq2uBKFaLjsqdVK+dtsy5SqULMPoJj62wV2kx2Qv8p+rleBfdOh7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992651; c=relaxed/simple;
	bh=mYfOPFifAA7yhVkjwdUQD4RWpTQVhxg/QePusYcAF6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQmHpgzV98IVLsHWZzgFkJwrhdZHm187D9vzygM8knoJK3sumeGLl8XMWR4BwJswd9LsBXSzrxoi42VuK8pwyNToqxIRB5UukTLRITCErDNrwx0oh/3K41NyFtvobXIix5XPq7XuoUsUE6BjRWM/9x4iEvK2yGQlLnSPz/thQwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kDb6dxjI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kDb6dxjI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3F6C4CEC6;
	Tue, 15 Oct 2024 11:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992651;
	bh=mYfOPFifAA7yhVkjwdUQD4RWpTQVhxg/QePusYcAF6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kDb6dxjI2QYoNt78VfjUd4olbdNze6EDBRyxhriB4u+SYVe+JQMh2FD7gaQUy61Dh
	 KUuvZwQ2+wAvB4z6Gbl400p7T4Xwql/6Z62jz8cOFevnhG39ZZd7R9z0TCkultokmg
	 Jx+PACkdNRBIJgEzgqwc1PiShN5m1FwtBOazxJUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Agrawal <agrawal.ag.ankit@gmail.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 147/691] clocksource/drivers/qcom: Add missing iounmap() on errors in msm_dt_timer_init()
Date: Tue, 15 Oct 2024 13:21:35 +0200
Message-ID: <20241015112446.188021661@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



