Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6A038E121;
	Fri,  7 Aug 2026 14:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114280; cv=none; b=f0Yea4eeo0fv6/jT+PTVKsmUaYmZYVk3yfl4qqiECKnYE2OuaZhrlOJ6NYK6/cWv/K1Cdu4+MyA8InRkzGYzJ2+5tdbu6w9dDjjcQWmEe304/gPYPyPn7qTdItUx3NMdsV6pOtJ91+2viYX2GNA5QyULeSS3ghK81VFBnYkN7kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114280; c=relaxed/simple;
	bh=/um3vBSG/TPRQelgCEhO3g8FxeIpi5/8j61txiv3AiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=flVn0m+yvm1/4aDtHbOVuWJioAO5Im/BqqbyKggMBgXUHT9NBCM5vaoZJ2iOkrzeDmEt6tNYCJZdryN0q3vgfIpp6DUQdEDs1O1Zo/YRT8bkkKbNMcVAwuUFw7jhRCAM1qHSEYkq/arYrIDnlI+GoS4hNuN00fwAmjKuPjZBsVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iDYj+Ipz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iDYj+Ipz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3DF1F00A3A;
	Fri,  7 Aug 2026 14:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114274;
	bh=x0UZ9IsAAjnGQSvUaGP0z9qIZbpWOxGzP73wbRUG84E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iDYj+Ipz+TPB6KZ6Bg2Bl/udM4lwT4lA/KUujHZJskh7LMRtPdi4bSdgm7tpiJC+H
	 hIfTqzzwBvOCdgmT6HQwXCAG4h8xVclUIp5pe5vkHSAMZEuHHazPicy31jViNsZodA
	 pG+Id0bq8zIFuoOSfU8jK8heXivyGmW+6LpIlUvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.12 205/337] cpufreq: schedutil: Publish util hooks only after all sg_cpu are initialized
Date: Fri,  7 Aug 2026 16:36:48 +0200
Message-ID: <20260807143422.999907121@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>

commit f0a3f042293a8c5a2152346b3637ea60866c503a upstream.

Commit 16a03c71bba0 ("cpufreq: schedutil: Merge initialization code of
sg_cpu in single loop") merged the per-CPU initialization and the
utilization-hook registration into a single loop in sugov_start().

For a shared cpufreq policy this re-introduces the race originally fixed
by commit ab2f7cf141aa ("cpufreq: schedutil: Fix sugov_start() versus
sugov_update_shared() race").

The scheduler's util path reaches the hook under RCU-sched and never takes
policy->rwsem, so the rwsem held across sugov_start() cannot serialize the
two. Once the first CPU's hook is published, sugov_update_shared() may run
and, via sugov_next_freq_shared(), read/write each sibling sugov_cpu
(iowait_boost, util, bw_min, ...) concurrently with the memset() still
initializing them, with no lock common to both sides: the update side holds
sg_policy->update_lock while the init side holds only policy->rwsem, which
the scheduler's util path never takes.

The walk only accesses scalar members, never a pointer like ->sg_policy,
so it does not crash today; it merely uses stale (or zero on first start)
values that skew the frequency selection and tracepoints. It is still a
genuine data race, and a latent crash once any pointer member is
dereferenced there.

Restore the two-phase approach: initialize all per-CPU structures first,
and only then publish the per-CPU utilization update hooks.

Fixes: 16a03c71bba0 ("cpufreq: schedutil: Merge initialization code of sg_cpu in single loop")
Cc: stable@vger.kernel.org
Signed-off-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Reviewed-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/20260716115159.848403-1-zhongqiu.han@oss.qualcomm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/cpufreq_schedutil.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -880,8 +880,19 @@ static int sugov_start(struct cpufreq_po
 		memset(sg_cpu, 0, sizeof(*sg_cpu));
 		sg_cpu->cpu = cpu;
 		sg_cpu->sg_policy = sg_policy;
+	}
+
+	/*
+	 * Publish the hooks only after all per-CPU data is initialized, so a
+	 * shared policy's sugov_update_shared() never reads an uninitialized
+	 * sibling sugov_cpu.
+	 */
+	for_each_cpu(cpu, policy->cpus) {
+		struct sugov_cpu *sg_cpu = &per_cpu(sugov_cpu, cpu);
+
 		cpufreq_add_update_util_hook(cpu, &sg_cpu->update_util, uu);
 	}
+
 	return 0;
 }
 


