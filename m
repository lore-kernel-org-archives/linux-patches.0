Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2188E1F473A;
	Tue,  3 Dec 2024 15:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239690; cv=none; b=H1qJGviJUumCkjwBjojuPbbz/+ztfJd4t/1RRD5qJ6/q22QtXdyYLziBWSZwkXwr9JmXPuc9uM5rXf6JZL7W59RirHVAviuEak3QfRPoKD4I3GQw89d3vZwwA5SOM045qAPWBCAgHwjPkKm2eivyaBhjV7Ct8QeHd6/upPIZtUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239690; c=relaxed/simple;
	bh=Tk/95r+tOWcB5XeKgwR45WqTlIhRw3i3WabM+2BVkkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLkmfVsAL8nG/TrwTsASoIiykIQGcfFkmQDy/5exFdE9YzWnkw+8yYlpQ68ImcrYIOSU69b69bny++lZqDiXLDd5Qx5HjmTWF1+ncmtqJjkRHJeFUBS2df4x/gwJp6urlYx8wHycYcLwhfLSLJGILiz+yg+KsnQKJjFP+4UfyIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RGwxjxcf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RGwxjxcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50420C4CECF;
	Tue,  3 Dec 2024 15:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239689;
	bh=Tk/95r+tOWcB5XeKgwR45WqTlIhRw3i3WabM+2BVkkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RGwxjxcfu5OlxYLJl2YMTMHefgdGtxsn8BLwTutG5YYkw/WkXufYrAln5um55rrnJ
	 2sDTaUq0lu8dJ+lsRhlDhuGuTZNhU308V+u9BTb6a5K3fqMO2SooC4TFac8mZmRSae
	 exptIZm7FhPdNYuvR8Vp/wg7gFDlxIinTktTYwzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Luba <lukasz.luba@arm.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 6.11 700/817] cpufreq: mediatek-hw: Fix wrong return value in mtk_cpufreq_get_cpu_power()
Date: Tue,  3 Dec 2024 15:44:32 +0100
Message-ID: <20241203144023.303162816@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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
 


