Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9C01DEFC7;
	Tue,  8 Oct 2024 12:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391557; cv=none; b=Ojd9PXM1/W2huLq60J0F6V6SP7npqirI+LG1QyTyCeJbcA5M8VBOIcGNptfJfehQ8m/EaMN8Fqy1ixvw/SpxLSPAdbKXxb3+Ca0LLs7SN63bv9mDykzztz4gW6xFd7fnu8pTMijBIWI0FUfWc1GBVnX0Wx8nQXhjlvSOPbzudOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391557; c=relaxed/simple;
	bh=kAvyEQczXtFcCqFzmE9LnNMf+/lasG7aDU/dJTc4bE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YSA+jpjWMdCQp/AnVGlTkYR+7KkJXPxu+Gta+b/X6+GKilvBad501rDqfRlprMLxQrDn3+lW+PLfqb03olaaLTUmGXanoG2rO+hzaoWFW3+gU4YAZ/typsLIG7LNyqEk3m+4H1UX7o3qaz05klfch2aMKx7CcG0Nk19F4jRB3tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3eohDWy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3eohDWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E8DC4CEC7;
	Tue,  8 Oct 2024 12:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391557;
	bh=kAvyEQczXtFcCqFzmE9LnNMf+/lasG7aDU/dJTc4bE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w3eohDWynUVOHl1MRMoRucXZZF4qMdtOoyvZy7MGM6xgMfNJqfbl09v4aVqSfFw4R
	 6Yg5lS9Glm2pxNMIsX7kRHcz/pG3C8jzON0tHBg/hrkPbjghmNVrcxXXzCE2rBp8vD
	 Iw4cMETkWmdHTFOjC9QhDUouLL4bmVGAXT9TNmdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Ruoyao <xry111@xry111.site>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 152/558] cpufreq: loongson3: Use raw_smp_processor_id() in do_service_request()
Date: Tue,  8 Oct 2024 14:03:02 +0200
Message-ID: <20241008115708.343772613@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 2b7ec33e534f7a10033a5cf07794acf48b182bbe ]

Use raw_smp_processor_id() instead of plain smp_processor_id() in
do_service_request(), otherwise we may get some errors with the driver
enabled:

 BUG: using smp_processor_id() in preemptible [00000000] code: (udev-worker)/208
 caller is loongson3_cpufreq_probe+0x5c/0x250 [loongson3_cpufreq]

Reported-by: Xi Ruoyao <xry111@xry111.site>
Tested-by: Binbin Zhou <zhoubinbin@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/loongson3_cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/loongson3_cpufreq.c b/drivers/cpufreq/loongson3_cpufreq.c
index 5f79b6de127c9..6b5e6798d9a28 100644
--- a/drivers/cpufreq/loongson3_cpufreq.c
+++ b/drivers/cpufreq/loongson3_cpufreq.c
@@ -176,7 +176,7 @@ static DEFINE_PER_CPU(struct loongson3_freq_data *, freq_data);
 static inline int do_service_request(u32 id, u32 info, u32 cmd, u32 val, u32 extra)
 {
 	int retries;
-	unsigned int cpu = smp_processor_id();
+	unsigned int cpu = raw_smp_processor_id();
 	unsigned int package = cpu_data[cpu].package;
 	union smc_message msg, last;
 
-- 
2.43.0



