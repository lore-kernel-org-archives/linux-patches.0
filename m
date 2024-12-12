Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F66211A34;
	Thu, 12 Dec 2024 16:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020162; cv=none; b=Q1iHdeYEjkEI7QId2NioaE7PSF2TcZUQgWN2mv2hCHwp9MgLmREaYSDpF76kgX7q3/FjGT4EcLEw4nZS8DxLgjlzXkvaPwHg1RTakMfKx7i9Mpm3xnPLWE/OYTjDWhM/ajwxPE4ZvBD3sRxNt3FgQveszcRtyFRBmslyEfjL60Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020162; c=relaxed/simple;
	bh=xg2/+CcoMLDbBr0KR6F3LQBJXJDw6+HaES1XuYEG4c8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xk54NhfrmR8w05HeQfqnXeG64HV+dpLkUolPeA7+kePokRuc5BrQvjpGiTx+H64oLimWmSMobuIr8NtzoW1bIBihnA1yuOBZJVoFG1pgaQZuAhfcccp8neNLnrqlu92IzHbLIwhUoU9c554e1RX9lvWIiwABuQPwI0+monw9aNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HamBqsrT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HamBqsrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3F3C4CECE;
	Thu, 12 Dec 2024 16:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020162;
	bh=xg2/+CcoMLDbBr0KR6F3LQBJXJDw6+HaES1XuYEG4c8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HamBqsrTsYqouFRRW2TmAvcIruseNrZP1hAt+1XhM6akkibFf1+Agz+rhbwvYZ5ah
	 xYG7lkZt8O3yJLp/8y8vompUtLttPqec3//vKZZrM6wr/kN4AO7LL38E20H1oR88cd
	 DV6wMK191ndxtZJfA9WVJNqZd2ovE+BfJy2Pytxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Hagar Hemdan <hagarhem@amazon.com>
Subject: [PATCH 6.1 353/772] perf/x86/intel: Hide Topdown metrics events if the feature is not enumerated
Date: Thu, 12 Dec 2024 15:54:58 +0100
Message-ID: <20241212144404.500059207@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kan Liang <kan.liang@linux.intel.com>

commit 556a7c039a52c21da33eaae9269984a1ef59189b upstream.

The below error is observed on Ice Lake VM.

$ perf stat
Error:
The sys_perf_event_open() syscall returned with 22 (Invalid argument)
for event (slots).
/bin/dmesg | grep -i perf may provide additional information.

In a virtualization env, the Topdown metrics and the slots event haven't
been supported yet. The guest CPUID doesn't enumerate them. However, the
current kernel unconditionally exposes the slots event and the Topdown
metrics events to sysfs, which misleads the perf tool and triggers the
error.

Hide the perf-metrics topdown events and the slots event if the
perf-metrics feature is not enumerated.

The big core of a hybrid platform can also supports the perf-metrics
feature. Fix the hybrid platform as well.

Closes: https://lore.kernel.org/lkml/CAM9d7cj8z+ryyzUHR+P1Dcpot2jjW+Qcc4CPQpfafTXN=LEU0Q@mail.gmail.com/
Reported-by: Dongli Zhang <dongli.zhang@oracle.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Dongli Zhang <dongli.zhang@oracle.com>
Link: https://lkml.kernel.org/r/20240708193336.1192217-2-kan.liang@linux.intel.com
Signed-off-by: Hagar Hemdan <hagarhem@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/core.c |   34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -5409,8 +5409,22 @@ default_is_visible(struct kobject *kobj,
 	return attr->mode;
 }
 
+static umode_t
+td_is_visible(struct kobject *kobj, struct attribute *attr, int i)
+{
+	/*
+	 * Hide the perf metrics topdown events
+	 * if the feature is not enumerated.
+	 */
+	if (x86_pmu.num_topdown_events)
+		return x86_pmu.intel_cap.perf_metrics ? attr->mode : 0;
+
+	return attr->mode;
+}
+
 static struct attribute_group group_events_td  = {
 	.name = "events",
+	.is_visible = td_is_visible,
 };
 
 static struct attribute_group group_events_mem = {
@@ -5587,9 +5601,27 @@ static umode_t hybrid_format_is_visible(
 	return (cpu >= 0) && (pmu->cpu_type & pmu_attr->pmu_type) ? attr->mode : 0;
 }
 
+static umode_t hybrid_td_is_visible(struct kobject *kobj,
+				    struct attribute *attr, int i)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct x86_hybrid_pmu *pmu =
+		 container_of(dev_get_drvdata(dev), struct x86_hybrid_pmu, pmu);
+
+	if (!is_attr_for_this_pmu(kobj, attr))
+		return 0;
+
+
+	/* Only the big core supports perf metrics */
+	if (pmu->cpu_type == hybrid_big)
+		return pmu->intel_cap.perf_metrics ? attr->mode : 0;
+
+	return attr->mode;
+}
+
 static struct attribute_group hybrid_group_events_td  = {
 	.name		= "events",
-	.is_visible	= hybrid_events_is_visible,
+	.is_visible	= hybrid_td_is_visible,
 };
 
 static struct attribute_group hybrid_group_events_mem = {


