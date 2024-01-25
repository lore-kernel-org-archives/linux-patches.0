Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8086717BA3
	for <patches@lists.linux.dev>; Thu, 25 Jan 2024 08:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706171007; cv=none; b=GRv1oN9nl2cDL+75YrGmxrxauP6fvoMH6CzrKEL92ZsPsuDy2ENHu+yNS310LZ3BKw5YeSB6O/68xJcPv2jNhxrJr/7BH6uBZAZVTZxhkErQNFw59AxR2bigCo8Y8vkNv3h9PKZ7rzI4rAEHyrnXwU86QFyY2AW0eIT0Bt8tE0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706171007; c=relaxed/simple;
	bh=Ym5ZXbQlJdyEqtBYOvsursmkKZcSXkI8IFQ9feaQTG8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VERyBKgwh/2Vr/EO4rZRNhXJEMs/kssnjsYvMD+tgClZZjFQU2GrXF4XOFyk9FG2H7Acqt+85uQXBMmmiiVUnl9x9dXHStxP6Ww2bMabBrgWmLzRs4Bhcn+hgJP0EKjc8V+dCem+Ikoxl6zQiPT1rTEsjLZBi5/YPrIpKtmXHto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MayUiR5X; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MayUiR5X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706171006; x=1737707006;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ym5ZXbQlJdyEqtBYOvsursmkKZcSXkI8IFQ9feaQTG8=;
  b=MayUiR5XeRdDRM5D/QkG9O2hNWtZfjZsyEzvmrbVduH3aGOJsjHlM7SE
   KP+hgOad1putgDXfdQ317jXK1ajQ3o+W0ZdFI4Dp0zE7cmD4M8XjhrSnM
   vxFp9mzgeSRbH7YDujcYPruK87pmA5dBKO3BBoiSDV3a1qly08xN1Yvmq
   Lar+GKTryVvg4RHi+0vNeUJb1jReTGr3iX+CLWpNfKSXB3pZ5U+RNQfyg
   j1aMCwNg1FnVzzLN3jk5CfEy3Q4Gi/6wOPZ3HCYDoUXjRLMJOYXZ7rjnv
   61xJs+jRWJJNi4sAJtyWv4d6yzz707AiViFKLcbcQQT4gpj9ZQOZ2l6i5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="1987183"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="1987183"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 00:23:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="876975932"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="876975932"
Received: from araj-ucode.jf.intel.com ([10.23.0.11])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 00:23:23 -0800
From: Ashok Raj <ashok.raj@intel.com>
To: Hans de Goede <hdegoede@redhat.com>,
	Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>,
	markgross@kernel.org
Cc: Jithu Joseph <jithu.joseph@intel.com>,
	rostedt@goodmis.org,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	LKML <linux-kernel@vger.kernel.org>,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	pengfei.xu@intel.com
Subject: [PATCH 4/5] platform/x86/intel/ifs: Replace the exit rendezvous with an entry rendezvous for ARRAY_BIST
Date: Thu, 25 Jan 2024 00:22:53 -0800
Message-Id: <20240125082254.424859-5-ashok.raj@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240125082254.424859-1-ashok.raj@intel.com>
References: <20240125082254.424859-1-ashok.raj@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ARRAY_BIST requires the test to be invoked only from one of the HT
siblings of a core.  If the other sibling was in mwait(), that didn't permit
the test to complete and resulted in several retries before the test could
finish.

The exit rendezvous was introduced to keep the HT sibling busy until the primary
CPU completed the test to avoid those retries. What is actually needed is
to ensure that both the threads rendezvous *before* the wrmsr to trigger the
test to give good chance to complete the test.

The `stop_machine()` function returns only after all the CPUs complete
running the function, and provides an exit rendezvous implicitly.

In kernel/stop_machine.c::multi_cpu_stop(), every CPU in the mask
needs to complete reaching MULTI_STOP_RUN. When all CPUs complete, the
state machine moves to next state, i.e MULTI_STOP_EXIT. Thus the underlying API
stop_core_cpuslocked() already provides an exit rendezvous.

Add the rendezvous earlier in order to  ensure the wrmsr is triggered after all
CPUs reach the do_array_test(). Remove the exit rendezvous since
stop_core_cpuslocked() already gaurantees that.

Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
 drivers/platform/x86/intel/ifs/runtest.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/intel/ifs/runtest.c b/drivers/platform/x86/intel/ifs/runtest.c
index 21dc0046fd9b..e3307dd8e3c4 100644
--- a/drivers/platform/x86/intel/ifs/runtest.c
+++ b/drivers/platform/x86/intel/ifs/runtest.c
@@ -271,7 +271,7 @@ static void ifs_test_core(int cpu, struct device *dev)
 }
 
 #define SPINUNIT 100 /* 100 nsec */
-static atomic_t array_cpus_out;
+static atomic_t array_cpus_in;
 
 /*
  * Simplified cpu sibling rendezvous loop based on microcode loader __wait_for_cpus()
@@ -298,6 +298,8 @@ static int do_array_test(void *data)
 	int cpu = smp_processor_id();
 	int first;
 
+	wait_for_sibling_cpu(&array_cpus_in, NSEC_PER_SEC);
+
 	/*
 	 * Only one logical CPU on a core needs to trigger the Array test via MSR write.
 	 */
@@ -309,9 +311,6 @@ static int do_array_test(void *data)
 		rdmsrl(MSR_ARRAY_BIST, command->data);
 	}
 
-	/* Tests complete faster if the sibling is spinning here */
-	wait_for_sibling_cpu(&array_cpus_out, NSEC_PER_SEC);
-
 	return 0;
 }
 
@@ -332,7 +331,7 @@ static void ifs_array_test_core(int cpu, struct device *dev)
 			timed_out = true;
 			break;
 		}
-		atomic_set(&array_cpus_out, 0);
+		atomic_set(&array_cpus_in, 0);
 		stop_core_cpuslocked(cpu, do_array_test, &command);
 
 		if (command.ctrl_result)
-- 
2.39.2

