Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04B8424651;
	Thu, 16 Jul 2026 13:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209604; cv=none; b=XuiqoygN+AOKb7q4I+JyaAW9uyBhsGF0PE7pVab4CWFXlMIP5XRGxUJV8edCC/okv7aydGOuyhbrif/mP+sbHoSMCC2hfNzsUElfoIf5Meszb06eeEh3nmE+79SOvvoKpFsSDcXWiyTVPEkT8eupjF/nFT5JTkmgxe+WEWyMMj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209604; c=relaxed/simple;
	bh=8NDGrpGiD3Wpqjo+z4ic39O451sDrjPtTzZSgUQFqIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FgKp7+HknqdKpffQsPJ4QTLLEv7OcnAGnYanjfj7vomg51XIRXzqd+8hspb/nimMog70UTXl18Aca+j5nxjA18DZGkr7dE9a83BsbOdTyqyg+hoWFFuMY3LqmJatgoRwmdtj5PH8RPHMAieZkSQIDl1tSXL+erjfNg77/rijHC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=URd3scne; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="URd3scne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5241F00A3A;
	Thu, 16 Jul 2026 13:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209599;
	bh=a1Atr5etb33g5ToQfL7lBB6JHL5cQnOH6MTUIJ1MGfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=URd3scnemi3Rhf2KMQ/f4IT0klQIBKb+jHSukvCt/qk3LyHbvUQTbo+fg9nKrG5yr
	 WrbtlPZuHnmslj0l8nqTqp/ckv+DfjFMtwjLyUICIS2wbeD8FWABfOBvEOmoD1Ht74
	 3VXmhcpyCzsgxxUKRQ7fUPDA6cI+3j/V+8DpKRlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 7.1 246/518] cpufreq: qcom-cpufreq-hw: Fix possible double free
Date: Thu, 16 Jul 2026 15:28:34 +0200
Message-ID: <20260716133053.199349063@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -578,7 +578,6 @@ static void qcom_cpufreq_hw_cpu_exit(str
 	dev_pm_opp_of_cpumask_remove_table(policy->related_cpus);
 	qcom_cpufreq_hw_lmh_exit(data);
 	kfree(policy->freq_table);
-	kfree(data);
 }
 
 static void qcom_cpufreq_ready(struct cpufreq_policy *policy)


