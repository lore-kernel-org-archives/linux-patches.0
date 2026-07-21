Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E0B1F3D56;
	Tue, 21 Jul 2026 17:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654255; cv=none; b=VI1Lb3XFiPFKCmePPTfqN/psUlW4cXMqQXGMd1/OnM0/yTulzXr3Mtt/6W7FKaf0IvZSeBmeBceMDdYBwoFwvpfbJLTIT1Fw9m2sGhmPs+QsX41C7NOqEcuKO5g/7rlNovNzRxOVN+ykGAeIKUfS+ytRb9Cv2cGuV8UWV/p9BtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654255; c=relaxed/simple;
	bh=FMuq0i6hHCgZO4A6Z7n4o4JSRQOKyOcQbY+KqlyLH4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=px2lBOsnP3JGzTHrXZ/SAKQUcS1hpK+t3B8+9mW8ZbPrVxG52qoe76BQEXMSdYTE1GLR7/aoQW0FJ4a7AMwQzNxunJurAQHsh6DJt21Wm/0+EnJzPvfkXjQ8dYrHvRlEXNqMBdPQbpg+tw5gw3cn+/5zr+u38FEsBX2Q74oaByI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wtYm7Iq1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtYm7Iq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459411F000E9;
	Tue, 21 Jul 2026 17:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654253;
	bh=pom3uN+40dOOlvqooZ6NBZlsdyRU2sy/uzUismrRarY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wtYm7Iq1o03pyzejYCj4RGVkMrOGYhoUVB7Mhzj8GpncRKOORSuRG7skJLcm5aOkM
	 EQHP2uf0nfsBGCqvLStgSKH/hUu+pItmdy/BiZL9PZHCbtYbWBdCrgpUjZebmOV7aX
	 ZZlpuISBe6QNj+9I9tv4WMCSwagOiUf0eUASZo5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Hongyan Xia <hongyan.xia@transsion.com>,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 7.1 1635/2077] cpufreq: schedutil: Fix uncleared need_freq_update on the .adjust_perf() path
Date: Tue, 21 Jul 2026 17:21:48 +0200
Message-ID: <20260721152631.315963354@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>

commit 9ef450ca74e43dacf9a2a15db7a851052c78dcf0 upstream.

The need_freq_update flag makes sugov_should_update_freq() return true
regardless of the rate_limit_us throttling, and is cleared in
sugov_update_next_freq(). sugov_update_single_freq() and
sugov_update_shared() go through that helper, so the flag does not
persist there.

However, sugov_update_single_perf(), used by drivers implementing the
.adjust_perf() callback (e.g. intel_pstate or amd-pstate in passive
mode) calls cpufreq_driver_adjust_perf() directly and never goes through
sugov_update_next_freq(), so the need_freq_update flag is not cleared in
that path.

Before commit 75da043d8f88 ("cpufreq/sched: Set need_freq_update in
ignore_dl_rate_limit()"), this was effectively harmless because
sugov_should_update_freq() still honored the rate limit even when
need_freq_update was set. After that change, the flag forces
sugov_should_update_freq() to always return true, so once set, it
stays effective indefinitely on the .adjust_perf() path.

As a result, cpufreq_driver_adjust_perf() gets called on every scheduler
utilization update (with the runqueue lock held) rather than being
throttled by rate_limit_us, even if the driver itself may skip redundant
hardware updates.

Clear need_freq_update at the end of the adjust_perf path as well.

Fixes: 75da043d8f88 ("cpufreq/sched: Set need_freq_update in ignore_dl_rate_limit()")
Signed-off-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Reviewed-by: Hongyan Xia <hongyan.xia@transsion.com>
Reviewed-by: Christian Loehle <christian.loehle@arm.com>
Cc: All applicable <stable@vger.kernel.org>
[ rjw: Subject and changelog edits ]
Link: https://patch.msgid.link/20260616154733.2405236-1-zhongqiu.han@oss.qualcomm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/cpufreq_schedutil.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -486,6 +486,7 @@ static void sugov_update_single_perf(str
 	cpufreq_driver_adjust_perf(sg_policy->policy, sg_cpu->bw_min,
 				   sg_cpu->util, max_cap);
 
+	sg_policy->need_freq_update = false;
 	sg_policy->last_freq_update_time = time;
 }
 


