Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190B742E8C4;
	Thu, 16 Jul 2026 14:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212212; cv=none; b=ukweu8O2UIO5nAfmry2YcAol4wwTflOVLewyRNV7fUVi3IRCSXH6eYeAgLQcChbHvYSR2CD3B9EbxnPwYefMM40TKv6nzhXPxQBDtcQzuR3v8tnYJ/qc5BUjWywDghSXOKRATIyhyISFJwcGDiNFl77eoymOMkJPlMJ/Kz8Wdx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212212; c=relaxed/simple;
	bh=TtK4m3GNdv6a/i/MZDQcgb76hIpv7IkVNmy9ZewNIT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VoEOQqNvdZH9cLxp1VheyUFF6aIj6jfVzQfgcm7pVeAv81+pIe/2607V9E+aFi2XARC0ZUdY3xw+XzPfbzpNA6LsqklVzCCRWy19YmHw9RjB9u8z4YOpwDvZdmm4eloYEsfpt1rwB8JmisRxi0UsjWcgomQ7Y2ojUqdJkYa/zPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YDi9fGeL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YDi9fGeL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE8B1F000E9;
	Thu, 16 Jul 2026 14:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212211;
	bh=rtSH4byF2Cl0EB8WzEo76cAPiUP/X8lH1N486aw9p8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YDi9fGeLtTDS/NVWFcqbPnJbXkVLNL1MLXdPuAuwmvb+25cMatx6e1mngUuygkveo
	 YNeAUwvl8fIrgNwpOrVidsfRRwIFGcX0Ick1evB+LF/kfUztOgw7JMzQ+A7LSUV2es
	 3SKV1hYfwjCe24ct1CJbZWB2zpvdH+nfZ/mNWLQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 6.12 188/349] cpufreq: qcom-cpufreq-hw: Fix possible double free
Date: Thu, 16 Jul 2026 15:32:02 +0200
Message-ID: <20260716133037.586466497@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit bcb8889c4981fdde42d4fd2c29a77d510fe21da2 upstream.

qcom_cpufreq.data is allocated with devm_kzalloc() in probe() as an
array of per-domain data. qcom_cpufreq_hw_cpu_init() stores a pointer to
one element of this array in policy->driver_data.

qcom_cpufreq_hw_cpu_exit() currently calls kfree() on policy->driver_data.
This is not valid because the memory is devm-managed. For the first
domain, this can free the devm-managed allocation while the devres entry
is still active, leading to a possible double free when the platform
device is later detached. For other domains, the pointer may refer to an
element inside the array rather than the allocation base.

Remove the kfree(data) call and let devres release qcom_cpufreq.data.

This issue was found by a static analysis tool I am developing.

Fixes: 054a3ef683a1 ("cpufreq: qcom-hw: Allocate qcom_cpufreq_data during probe")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/qcom-cpufreq-hw.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -584,7 +584,6 @@ static void qcom_cpufreq_hw_cpu_exit(str
 	dev_pm_opp_of_cpumask_remove_table(policy->related_cpus);
 	qcom_cpufreq_hw_lmh_exit(data);
 	kfree(policy->freq_table);
-	kfree(data);
 }
 
 static void qcom_cpufreq_ready(struct cpufreq_policy *policy)


