Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087832F44;
	Thu, 12 Dec 2024 16:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022758; cv=none; b=fwiFkepkdw0PmXpH6d2lzV1lwnxClgaY4RQFG+bsH3spyPMJbb83dHOqF43Nm+Wibbh2h9Aub6uEdaurol7s/RqJmaXN/W1rjz1QLhfje0TmZPMc/RCvlK0CnmLDJF8BX1tLJkguf4DzVMUJ6XEf+Vp8zZJaj5MOE8VxfJy/+mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022758; c=relaxed/simple;
	bh=p6axj+vyLwFDD6P1Ez5QsnIQodqYc+KmLLfGTQ0Cyaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7qZEwDhmKxysdoOk5xCLkJi0AoejGsdT55L1KhY3wFCGVg+g9hjoAxZ/K4l/LwKm+aT28QMNEnArSrxAKYg/5/0X1RaXTIAqvISLWGDamHqUyPC8M4YQA3wyKbFCa0jYeQx6m7SEhyjf/cJvKyDaCHlLFwvBN3ie2vmFbqEE+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VhpO833q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VhpO833q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517C6C4CED0;
	Thu, 12 Dec 2024 16:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022757;
	bh=p6axj+vyLwFDD6P1Ez5QsnIQodqYc+KmLLfGTQ0Cyaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VhpO833qHo7wCC15Vjrthho9sYCuCuDlqmikkaEpCY5qEPj02ZHJQFrH/ljt7M/2F
	 X7iEzQiKRV1V1pstyJyVfMog53EXWhlhnon6QXzs5v9CtcDnqb2ZG7wIF808uwbyo9
	 98YHJaxeY4w/vSXhiLR6RfaqMqHIJvDLUGwNAk1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Luba <lukasz.luba@arm.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5.15 329/565] cpufreq: mediatek-hw: Fix wrong return value in mtk_cpufreq_get_cpu_power()
Date: Thu, 12 Dec 2024 15:58:44 +0100
Message-ID: <20241212144324.603161076@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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
@@ -60,7 +60,7 @@ mtk_cpufreq_get_cpu_power(unsigned long
 
 	policy = cpufreq_cpu_get_raw(cpu_dev->id);
 	if (!policy)
-		return 0;
+		return -EINVAL;
 
 	data = policy->driver_data;
 


