Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4432FD1C2;
	Tue, 12 Aug 2025 18:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024889; cv=none; b=GZBB83K/YgOuR9Ur0HDti/1yneoPQjU3DL+lJARCLe/3TJvyZ29txYibTVBaN2OkyoWatDxctzucOcbWMTUHMuhneTZy0oljrGyZmvYOuHST6hwCemK/Y6pBPHuTYhK9htbdF0a5rh27XZxNs4GxdQMepGzmxilvhFV06CTxZvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024889; c=relaxed/simple;
	bh=IJ2AzBbH9mxs4dhwn0j4zVU//5P6WzhNwRV54OsLoP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uu5rekVtc+2ISiPZSY+LcwwEcR3nUVvg8Tntw+wYYkDyn9Ap8j5X8LL5yGrVl5Fef5qcCaL72K6cNzR1zZr1EVTBSGswdVu6qTOrrY8Bpm0Dl24Wsfu3xTbYnWjIqSf2NPi07dINGMvyIu05g1RkkUk1xHCi38tHHM+XJcrjmtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WKwdU6dm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WKwdU6dm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3667C4CEF0;
	Tue, 12 Aug 2025 18:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024889;
	bh=IJ2AzBbH9mxs4dhwn0j4zVU//5P6WzhNwRV54OsLoP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WKwdU6dmRhGTW69aUYPfedcztOanRVLYKvArScQFg/LLJHyzUexq4wCzE5y9NlCcg
	 Ou/BMSZeNbZbMxSFcFnuzgIQl1d7TDGs3yKkfklvHodaqqAPNaXE4bEdi0SPTsMI6t
	 gHrCqWmCrPlswK/PRV9DW2qwvYgEVBN/fuXIMls8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 507/627] tools/power turbostat: regression fix: --show C1E%
Date: Tue, 12 Aug 2025 19:33:22 +0200
Message-ID: <20250812173448.457609738@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

[ Upstream commit 5d939fbdd480cdf276eccc01eda3ed41e37d3f8a ]

The new default idle counter groupings broke "--show C1E%" (or any other C-state %)

Also delete a stray debug printf from the same offending commit.

Reported-by: Zhang Rui <rui.zhang@intel.com>
Fixes: ec4acd3166d8 ("tools/power turbostat: disable "cpuidle" invocation counters, by default")
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 5230e072e414..33a54a9e0781 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -2429,7 +2429,6 @@ unsigned long long bic_lookup(char *name_list, enum show_hide_mode mode)
 
 		}
 		if (i == MAX_BIC) {
-			fprintf(stderr, "deferred %s\n", name_list);
 			if (mode == SHOW_LIST) {
 				deferred_add_names[deferred_add_index++] = name_list;
 				if (deferred_add_index >= MAX_DEFERRED) {
@@ -10537,9 +10536,6 @@ void probe_cpuidle_residency(void)
 	int min_state = 1024, max_state = 0;
 	char *sp;
 
-	if (!DO_BIC(BIC_pct_idle))
-		return;
-
 	for (state = 10; state >= 0; --state) {
 
 		sprintf(path, "/sys/devices/system/cpu/cpu%d/cpuidle/state%d/name", base_cpu, state);
-- 
2.39.5



