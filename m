Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6662E11C7;
	Mon, 20 Apr 2026 15:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700144; cv=none; b=X+496hqhKyroDQBoyQ05qmJ2aq1UHawnjnQxmDp1fankSuP8Q6OQElErLY6ru/RVm5jG1DGUiwUir8ZS+ecLNkzFt/f7XB/FW30AtIJlzPPnVq1T62eZff+8X+ystPC+jSvArVxaFNjfrrVRhsvw8pvFRqsz741uz6uIY4buxug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700144; c=relaxed/simple;
	bh=AEJgazPvLUyMsw9N+k2HHbEvN72OevGmW4N5JZruWxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CCnCMasbNRlfUIPWO41j+2ZPUOutLa2M4Xe5b8yT7PlPl+h2+wjWCoGkyhMBI9Njfm5X1JARtpntCKWETCwgWS2ZLkz08nDoQtKmZw3lmHFQs4oEQgKzgiHPWJWD9J6sx+AO0l/r9Kzuo0hHbrZdOvMVBRc/DOIDqHn1LDPuMbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AMKgRcNy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AMKgRcNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C44C19425;
	Mon, 20 Apr 2026 15:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700144;
	bh=AEJgazPvLUyMsw9N+k2HHbEvN72OevGmW4N5JZruWxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AMKgRcNyV9KDrEo80+yRdzqQGqnrKQAzUIlqq/rOCAfPVJcPGN9LX5WCLPPsOv5vX
	 G7uSfNtM1yLWgwo/93FSCN2X4gJ1l+pYTDdylG5YuyGjQWRXJl8cOs4l+9FL8nE+Mn
	 2EkpdA4HGuiR25v2hA6NY5poil3l4EQMsQkFiDgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 059/220] tools/power turbostat: Fix --show/--hide for individual cpuidle counters
Date: Mon, 20 Apr 2026 17:40:00 +0200
Message-ID: <20260420153936.167113385@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

[ Upstream commit b6398bc2ef3a78f1be37ba01ae0a5eedaee47803 ]

Problem: individual swidle counter names (C1, C1+, C1-, etc.) cannot be
selected via --show/--hide due to two bugs in probe_cpuidle_counts():
1. The function returns immediately when BIC_cpuidle is not enabled,
   without checking deferred_add_index.
2. The deferred name check runs against name_buf before the trailing
   newline is stripped, so is_deferred_add("C1\n") never matches "C1".

Fix:
1. Relax the early return to pass through when deferred names are
   queued.
2. Strip the trailing newline from name_buf before performing deferred
   name checks.
3. Check each suffixed variant (C1+, C1, C1-) individually so that
   e.g. "--show C1+" enables only the requested metric.

In addition, introduce a helper function to avoid repeating the
condition (readability cleanup).

Fixes: ec4acd3166d8 ("tools/power turbostat: disable "cpuidle" invocation counters, by default")
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 35 ++++++++++++++++-----------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 603651e74dacf..b01a905bd24a7 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -10908,6 +10908,14 @@ void probe_cpuidle_residency(void)
 	}
 }
 
+static bool cpuidle_counter_wanted(char *name)
+{
+	if (is_deferred_skip(name))
+		return false;
+
+	return DO_BIC(BIC_cpuidle) || is_deferred_add(name);
+}
+
 void probe_cpuidle_counts(void)
 {
 	char path[64];
@@ -10917,7 +10925,7 @@ void probe_cpuidle_counts(void)
 	int min_state = 1024, max_state = 0;
 	char *sp;
 
-	if (!DO_BIC(BIC_cpuidle))
+	if (!DO_BIC(BIC_cpuidle) && !deferred_add_index)
 		return;
 
 	for (state = 10; state >= 0; --state) {
@@ -10932,12 +10940,6 @@ void probe_cpuidle_counts(void)
 
 		remove_underbar(name_buf);
 
-		if (!DO_BIC(BIC_cpuidle) && !is_deferred_add(name_buf))
-			continue;
-
-		if (is_deferred_skip(name_buf))
-			continue;
-
 		/* truncate "C1-HSW\n" to "C1", or truncate "C1\n" to "C1" */
 		sp = strchr(name_buf, '-');
 		if (!sp)
@@ -10952,16 +10954,19 @@ void probe_cpuidle_counts(void)
 			 * Add 'C1+' for C1, and so on. The 'below' sysfs file always contains 0 for
 			 * the last state, so do not add it.
 			 */
-
 			*sp = '+';
 			*(sp + 1) = '\0';
-			sprintf(path, "cpuidle/state%d/below", state);
-			add_counter(0, path, name_buf, 64, SCOPE_CPU, COUNTER_ITEMS, FORMAT_DELTA, SYSFS_PERCPU, 0);
+			if (cpuidle_counter_wanted(name_buf)) {
+				sprintf(path, "cpuidle/state%d/below", state);
+				add_counter(0, path, name_buf, 64, SCOPE_CPU, COUNTER_ITEMS, FORMAT_DELTA, SYSFS_PERCPU, 0);
+			}
 		}
 
 		*sp = '\0';
-		sprintf(path, "cpuidle/state%d/usage", state);
-		add_counter(0, path, name_buf, 64, SCOPE_CPU, COUNTER_ITEMS, FORMAT_DELTA, SYSFS_PERCPU, 0);
+		if (cpuidle_counter_wanted(name_buf)) {
+			sprintf(path, "cpuidle/state%d/usage", state);
+			add_counter(0, path, name_buf, 64, SCOPE_CPU, COUNTER_ITEMS, FORMAT_DELTA, SYSFS_PERCPU, 0);
+		}
 
 		/*
 		 * The 'above' sysfs file always contains 0 for the shallowest state (smallest
@@ -10970,8 +10975,10 @@ void probe_cpuidle_counts(void)
 		if (state != min_state) {
 			*sp = '-';
 			*(sp + 1) = '\0';
-			sprintf(path, "cpuidle/state%d/above", state);
-			add_counter(0, path, name_buf, 64, SCOPE_CPU, COUNTER_ITEMS, FORMAT_DELTA, SYSFS_PERCPU, 0);
+			if (cpuidle_counter_wanted(name_buf)) {
+				sprintf(path, "cpuidle/state%d/above", state);
+				add_counter(0, path, name_buf, 64, SCOPE_CPU, COUNTER_ITEMS, FORMAT_DELTA, SYSFS_PERCPU, 0);
+			}
 		}
 	}
 }
-- 
2.53.0



