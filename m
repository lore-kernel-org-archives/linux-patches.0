Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E0253A7;
	Fri,  6 Dec 2024 15:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497456; cv=none; b=BGL7vXy4WbZ/IciD890f7RGRkizlFLSd4gHiydjm/0Gb1IES6Wg/okBQ3X1qoarKW1oFBPGsd74aQ+PUbq6mBIN785VWhWuJITALM4MfoxSd6Pk7cfUhx1nHI3B3WUJGWLowkvTondLZvEmG/mhLHVFFrxsPncDNuWqBb5uDuYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497456; c=relaxed/simple;
	bh=O+OmR7pue1mOBDNq9xpOM2f9VzlocpVCmQWoiYQjQMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uR2WjxoECZGxGrR2uc37GdBACrFxAkRo6cmpZgctnn0C9gysH0Lhrru9oP4joT3aivbcyhW0XSqTC2rJqIofcg93LwezCfrqM+NvQMI9ETAjxZPkbMh3jx6RlmI1X37Rkw/mJwOKYDj+5iwkmvjXuvCCJ/XCA3Qs7fN2kp2JYJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TFPwkffm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TFPwkffm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40AFC4CED1;
	Fri,  6 Dec 2024 15:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497456;
	bh=O+OmR7pue1mOBDNq9xpOM2f9VzlocpVCmQWoiYQjQMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TFPwkffm5p+lyOvPHczjZFodXSbhXOrJXv4ucVzvWVN6askGGWCVerlkJACelC+Qx
	 O9fW8aN/ufJzo8hdIdkk/Z1z63m0ovmIhKoe8rZ/Myefgqnanup0MiRBSXRgD2A7aC
	 TUBTj0vwgvRRqZWpSj1UUaezNTDra2W+Ir8E3/wA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 280/676] cpufreq: CPPC: Fix possible null-ptr-deref for cppc_get_cpu_cost()
Date: Fri,  6 Dec 2024 15:31:39 +0100
Message-ID: <20241206143704.279475171@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 1a1374bb8c5926674973d849feed500bc61ad535 ]

cpufreq_cpu_get_raw() may return NULL if the cpu is not in
policy->cpus cpu mask and it will cause null pointer dereference,
so check NULL for cppc_get_cpu_cost().

Fixes: 740fcdc2c20e ("cpufreq: CPPC: Register EM based on efficiency class information")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cppc_cpufreq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/cppc_cpufreq.c b/drivers/cpufreq/cppc_cpufreq.c
index 284c328a1d3d1..866a0538ca896 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -498,6 +498,9 @@ static int cppc_get_cpu_cost(struct device *cpu_dev, unsigned long KHz,
 	int step;
 
 	policy = cpufreq_cpu_get_raw(cpu_dev->id);
+	if (!policy)
+		return 0;
+
 	cpu_data = policy->driver_data;
 	perf_caps = &cpu_data->perf_caps;
 	max_cap = arch_scale_cpu_capacity(cpu_dev->id);
-- 
2.43.0



