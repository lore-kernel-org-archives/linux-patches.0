Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1EF1DE8A5;
	Tue,  3 Dec 2024 15:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241489; cv=none; b=hBViT6T86rQigv9O28lIsjHvHW+L5vuMmYAKQb6CQuXsRzi4oMAarVVPJQTMtGEVbCDqYDkaw2wm7cHjQg6j8Ep42si0wrvZz1ZKM6IXUEohkbY6Ui/ePOvW2MzexiPgQRmDLtr9oiILXxyn5dmzzLRYCX58ALFccRD4hHeqp1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241489; c=relaxed/simple;
	bh=pQmVORMzhDVN2G6Sa5oySk6rMjAEPh9aBwEMF8CbDkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVn0EH9G9ooTtonwBwLOTKuXQDGaoH/sIPDyxwS6RoKLNvWSY7OENjI8GOEPo3hWS4Dz7ghnMNBzCpTlMELfgBiqi2Cwba6JP5yz43KcGiHXav4LFUMpNNKNtgkVwr/F+7tnZSjUg29rQcP5uwJYT9lkz8W7E/NSfPMxchF0Ric=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Za2YelwT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Za2YelwT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B016C4CECF;
	Tue,  3 Dec 2024 15:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241489;
	bh=pQmVORMzhDVN2G6Sa5oySk6rMjAEPh9aBwEMF8CbDkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Za2YelwTN2x829iPDGyEE0YkzmC7Yp+hVLTbDkfbCxkFe3odSkIc5hquZSlk+Nd4Z
	 vBDM4lOSNsKerb7yL/4aHqiUVjsZ8T5FhbQIpg7OYbZcAVL+JFh/80BcajgkYqK0nm
	 gBgzZPfCgPJCvE7JlAg6kHs7uzqLnEdJZq/Rj88s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Quentin Perret <qperret@google.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 432/826] cpufreq: CPPC: Fix wrong return value in cppc_get_cpu_power()
Date: Tue,  3 Dec 2024 15:42:39 +0100
Message-ID: <20241203144800.614517943@linuxfoundation.org>
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

[ Upstream commit b51eb0874d8170028434fbd259e80b78ed9b8eca ]

cppc_get_cpu_power() return 0 if the policy is NULL. Then in
em_create_perf_table(), the later zero check for power is not valid
as power is uninitialized. As Quentin pointed out, kernel energy model
core check the return value of active_power() first, so if the callback
failed it should tell the core. So return -EINVAL to fix it.

Fixes: a78e72075642 ("cpufreq: CPPC: Fix possible null-ptr-deref for cpufreq_cpu_get_raw()")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Suggested-by: Quentin Perret <qperret@google.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cppc_cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cppc_cpufreq.c b/drivers/cpufreq/cppc_cpufreq.c
index 2993b8a4c7f17..c1cdf0f4d0ddd 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -424,7 +424,7 @@ static int cppc_get_cpu_power(struct device *cpu_dev,
 
 	policy = cpufreq_cpu_get_raw(cpu_dev->id);
 	if (!policy)
-		return 0;
+		return -EINVAL;
 
 	cpu_data = policy->driver_data;
 	perf_caps = &cpu_data->perf_caps;
-- 
2.43.0



