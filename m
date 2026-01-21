Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3243A89BF;
	Wed, 21 Jan 2026 18:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020401; cv=none; b=AsbrpspGH/5nydr+3nIrQgjdKPGVJtD1oboEopiDU3JGEnEXiQYRNGacqLB2z6Gk9+lstHpf3qQ72Gm7jzVkZjP7g+s0IMa+6hzlijSugoh+OuUQbckHoF2M84pskEYyaG4y1V9xjRMUBt5EXsUvkSE8VEZvY8pzKL7N+cIMYnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020401; c=relaxed/simple;
	bh=2FXAkFcUnVLAev/Qu25iTwQ9G7LPU+RGykjR3pgtwiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZFhPqwGOz8Qy+ffXSyWi3ZM36Q4ZndZkyG4ZMTY2BUV0d2e+iyuQBsZCui194MWR4MlTqbk3iM/QcseyoQNdTFq7Yg0Sv0rwn28e/hk+9hsgBzsTJQ1zZ+b5QLWYn7sgEQU4PDIGTkJOtPNzurhbN1MkXW5mop9teRpf1fmvv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MV6ojxOe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MV6ojxOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7FBC4CEF1;
	Wed, 21 Jan 2026 18:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020400;
	bh=2FXAkFcUnVLAev/Qu25iTwQ9G7LPU+RGykjR3pgtwiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MV6ojxOe5u0OG+5+IPnGuIzQstuwlDhzE+O+SGDc6XjIzgTU/wjoO54clcNpqxt8m
	 0cWjGM3jx7vLCfYWQ3BA7x24IlrvpCrM/yuDGRzIfR5NQ0IC0ZmZ2G57E/u3j4qH+q
	 nCuNxe9J3E36tef2NTqGS8iy/lcSxTP5KOsNT9r8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lisa Robinson <lisa@bytefly.space>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 147/198] LoongArch: Fix PMU counter allocation for mixed-type event groups
Date: Wed, 21 Jan 2026 19:16:15 +0100
Message-ID: <20260121181423.850418600@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lisa Robinson <lisa@bytefly.space>

commit a91f86e27087f250a5d9c89bb4a427b9c30fd815 upstream.

When validating a perf event group, validate_group() unconditionally
attempts to allocate hardware PMU counters for the leader, sibling
events and the new event being added.

This is incorrect for mixed-type groups. If a PERF_TYPE_SOFTWARE event
is part of the group, the current code still tries to allocate a hardware
PMU counter for it, which can wrongly consume hardware PMU resources and
cause spurious allocation failures.

Fix this by only allocating PMU counters for hardware events during group
validation, and skipping software events.

A trimmed down reproducer is as simple as this:

  #include <stdio.h>
  #include <assert.h>
  #include <unistd.h>
  #include <string.h>
  #include <sys/syscall.h>
  #include <linux/perf_event.h>

  int main (int argc, char *argv[])
  {
  	struct perf_event_attr attr = { 0 };
  	int fds[5];

  	attr.disabled = 1;
  	attr.exclude_kernel = 1;
  	attr.exclude_hv = 1;
  	attr.read_format = PERF_FORMAT_TOTAL_TIME_ENABLED |
  		PERF_FORMAT_TOTAL_TIME_RUNNING | PERF_FORMAT_ID | PERF_FORMAT_GROUP;
  	attr.size = sizeof (attr);

  	attr.type = PERF_TYPE_SOFTWARE;
  	attr.config = PERF_COUNT_SW_DUMMY;
  	fds[0] = syscall (SYS_perf_event_open, &attr, 0, -1, -1, 0);
  	assert (fds[0] >= 0);

  	attr.type = PERF_TYPE_HARDWARE;
  	attr.config = PERF_COUNT_HW_CPU_CYCLES;
  	fds[1] = syscall (SYS_perf_event_open, &attr, 0, -1, fds[0], 0);
  	assert (fds[1] >= 0);

  	attr.type = PERF_TYPE_HARDWARE;
  	attr.config = PERF_COUNT_HW_INSTRUCTIONS;
  	fds[2] = syscall (SYS_perf_event_open, &attr, 0, -1, fds[0], 0);
  	assert (fds[2] >= 0);

  	attr.type = PERF_TYPE_HARDWARE;
  	attr.config = PERF_COUNT_HW_BRANCH_MISSES;
  	fds[3] = syscall (SYS_perf_event_open, &attr, 0, -1, fds[0], 0);
  	assert (fds[3] >= 0);

  	attr.type = PERF_TYPE_HARDWARE;
  	attr.config = PERF_COUNT_HW_CACHE_REFERENCES;
  	fds[4] = syscall (SYS_perf_event_open, &attr, 0, -1, fds[0], 0);
  	assert (fds[4] >= 0);

  	printf ("PASSED\n");

  	return 0;
  }

Cc: stable@vger.kernel.org
Fixes: b37042b2bb7c ("LoongArch: Add perf events support")
Signed-off-by: Lisa Robinson <lisa@bytefly.space>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/perf_event.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/arch/loongarch/kernel/perf_event.c
+++ b/arch/loongarch/kernel/perf_event.c
@@ -626,6 +626,18 @@ static const struct loongarch_perf_event
 	return pev;
 }
 
+static inline bool loongarch_pmu_event_requires_counter(const struct perf_event *event)
+{
+	switch (event->attr.type) {
+	case PERF_TYPE_HARDWARE:
+	case PERF_TYPE_HW_CACHE:
+	case PERF_TYPE_RAW:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static int validate_group(struct perf_event *event)
 {
 	struct cpu_hw_events fake_cpuc;
@@ -633,15 +645,18 @@ static int validate_group(struct perf_ev
 
 	memset(&fake_cpuc, 0, sizeof(fake_cpuc));
 
-	if (loongarch_pmu_alloc_counter(&fake_cpuc, &leader->hw) < 0)
+	if (loongarch_pmu_event_requires_counter(leader) &&
+	    loongarch_pmu_alloc_counter(&fake_cpuc, &leader->hw) < 0)
 		return -EINVAL;
 
 	for_each_sibling_event(sibling, leader) {
-		if (loongarch_pmu_alloc_counter(&fake_cpuc, &sibling->hw) < 0)
+		if (loongarch_pmu_event_requires_counter(sibling) &&
+		    loongarch_pmu_alloc_counter(&fake_cpuc, &sibling->hw) < 0)
 			return -EINVAL;
 	}
 
-	if (loongarch_pmu_alloc_counter(&fake_cpuc, &event->hw) < 0)
+	if (loongarch_pmu_event_requires_counter(event) &&
+	    loongarch_pmu_alloc_counter(&fake_cpuc, &event->hw) < 0)
 		return -EINVAL;
 
 	return 0;


