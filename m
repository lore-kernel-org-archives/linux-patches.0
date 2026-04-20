Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42FE47CC74;
	Mon, 20 Apr 2026 13:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691859; cv=none; b=udcO/IwSr5Ut83NFkbMGGD+P/1GYa9C984C3nAiLvDliH9b102Aw/a6RKxzsad/sWOO7M087V7NSugwaFjIn6l8MZAo0ZNVZH8R7bJ712cHZy+89J5HEuC+S7x19AenxvrtD81aqE1S/h6rviG+/ny3iGMkO6ndcsJR5sNX8qrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691859; c=relaxed/simple;
	bh=LRAJ8qX2H67FTCG3PvDi1IWN3WZKR60808VjHLCxRB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NLaKLt4hVyd27DfeCcGQ/DChZMPgXzIzoELgas84VeC3e7N8MbFzEQwW+78/AFyBv2n8IVFPFzTPijmoS4PIq0oLY0jgZ2W5z9jqDggNJe5STP5KNT96hGupbgVFHPGmbOVwB4RGj4OM5lBjQ0GfRY3ToTAMxlU1IvDvmzGmEy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L8FFzFXl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L8FFzFXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6CF3C2BCB6;
	Mon, 20 Apr 2026 13:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691859;
	bh=LRAJ8qX2H67FTCG3PvDi1IWN3WZKR60808VjHLCxRB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L8FFzFXlZOi1NL2VUUHlrvw9BW7lAGKnUo3wG2YKyHhL4yrp+uy6uS78kSXluhaQj
	 m0hvjpEYunRmH73txQH/8+qyHtmkMh2xffhwodbBu2WEBQcG2eFOEl3SfClD5fMMBf
	 kxQZUhd3Yyr5yVhNfEV/RfVhr5UEjhx14ACP4JByvBEZkXMvN0TnODLforpX8mfRA6
	 BQKEL3Q3CdJVYsOIsMnRpASBzXai7Luafp3qcLUOl6Oktl1J7gdeTm/Gg6IoHXnJHn
	 LWLh8NIU99bXeGR4i9jGHsaK2U0Z3J9OQYS0JBOOlXvSzeKye3AWV2zrL4FxDXSjoL
	 2J6DM/CpciRnQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	lenb@kernel.org,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] tools/power turbostat: Fix --show/--hide for individual cpuidle counters
Date: Mon, 20 Apr 2026 09:20:30 -0400
Message-ID: <20260420132314.1023554-236-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 tools/power/x86/turbostat/turbostat.c | 35 ++++++++++++++++-----------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 67dfd3eaad014..48677f1846347 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -10890,6 +10890,14 @@ void probe_cpuidle_residency(void)
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
@@ -10899,7 +10907,7 @@ void probe_cpuidle_counts(void)
 	int min_state = 1024, max_state = 0;
 	char *sp;
 
-	if (!DO_BIC(BIC_cpuidle))
+	if (!DO_BIC(BIC_cpuidle) && !deferred_add_index)
 		return;
 
 	for (state = 10; state >= 0; --state) {
@@ -10914,12 +10922,6 @@ void probe_cpuidle_counts(void)
 
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
@@ -10934,16 +10936,19 @@ void probe_cpuidle_counts(void)
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
@@ -10952,8 +10957,10 @@ void probe_cpuidle_counts(void)
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

