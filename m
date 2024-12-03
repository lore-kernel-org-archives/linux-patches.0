Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861E081ADA;
	Tue,  3 Dec 2024 16:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242417; cv=none; b=mdoGrv/cqhmw7nJq4JQcvM+jLI7rgOp9e7ZFC5Z1gTeAA1roraAPzYj6y7kuWVgfOtxxzfCgXdzuNPnlO1vkfBiLRyIvY/XoAMA3IZoedtwhLtvHPshNYHTkp1VkkGB9MQo4UyUiuag+4f4AfVt291IzbtmyYEmuamFR2riGfw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242417; c=relaxed/simple;
	bh=tkinyAk0lvCEkzyt7sAhjSRmTuYZMPEOqHdsXqhB8Oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hLAGeLM9C1Nl60jstxQAlMnP2WtNFS31A7lb8ic+WPLoCjsUfwM6kW98yvn3sT7m6C/9+omDTZI+K1bvPc87omoLJ+Ek2yyAc9MHZaKW5Hw9VUJ/EAI0oy/8V+EWjHqR6VNafKg2XdLbR2ysB/MPBQMgO2w2eOFyUk6/j3yc13c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Afz40fg+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Afz40fg+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08CF0C4CED6;
	Tue,  3 Dec 2024 16:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242417;
	bh=tkinyAk0lvCEkzyt7sAhjSRmTuYZMPEOqHdsXqhB8Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Afz40fg+kGZSTAnvBb6ble7efekvqrHtQOoKiwR24Wk3tasS4S0enbu34TLeBSLvJ
	 AE5oOpetXSZDidqkwqg44Hiwd0EvxW4ng4zXP1phGXXvqidqJhoQkKePNXkjuv+skF
	 LL1E6ymjof0XxHe7BRU4NQ80Ft4cnm8NPKJMDTY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Luba <lukasz.luba@arm.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 6.12 698/826] cpufreq: mediatek-hw: Fix wrong return value in mtk_cpufreq_get_cpu_power()
Date: Tue,  3 Dec 2024 15:47:05 +0100
Message-ID: <20241203144810.985721031@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit 172bf5ed04cb6c9e66d58de003938ed5c8756570 upstream.

mtk_cpufreq_get_cpu_power() return 0 if the policy is NULL. Then in
em_create_perf_table(), the later zero check for power is not invalid
as power is uninitialized. As Lukasz suggested, it must return -EINVAL when
the 'policy' is not found. So return -EINVAL to fix it.

Cc: stable@vger.kernel.org
Fixes: 4855e26bcf4d ("cpufreq: mediatek-hw: Add support for CPUFREQ HW")
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Suggested-by: Lukasz Luba <lukasz.luba@arm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/mediatek-cpufreq-hw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cpufreq/mediatek-cpufreq-hw.c
+++ b/drivers/cpufreq/mediatek-cpufreq-hw.c
@@ -62,7 +62,7 @@ mtk_cpufreq_get_cpu_power(struct device
 
 	policy = cpufreq_cpu_get_raw(cpu_dev->id);
 	if (!policy)
-		return 0;
+		return -EINVAL;
 
 	data = policy->driver_data;
 


