Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584B4217F35;
	Tue, 12 Aug 2025 19:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026577; cv=none; b=PtRhx8GDhuoTBnXFz2n6b3hotm5ofQwDqjv8OIClVtqYGRQ4Q5Xm7O4N4UKAWp3JwyyrzlCQ62zWbdZXlfKXa+2CkFqcBl+GcXVTlz3v/5ncv5wF6pTmHnHavONVpFabZVRRKBIJTTiucbRzgH9EceF2IxWRq6qtSMOi5P1Toc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026577; c=relaxed/simple;
	bh=raWm7/VMBHuyRi5jHeEIynCptyR+AXAI2F9GvRcs0EQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wjhw1w3fBrlhqGrshGySt/VKhRdHPWCW9mCDNUbfIs1nHZJBmfbGmHhjsWrlCbLI5a0/zdn0poNc+NOQRy1T88G7KIgTYpsgSbbHzakGmA9iIknkELKhqV6EUSZRJ9wRu4ACExWNulclGdBZUGH9oOIKsE0xIVLaxAowukBR7pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Vg3j7z7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Vg3j7z7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D18C4CEF0;
	Tue, 12 Aug 2025 19:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026576;
	bh=raWm7/VMBHuyRi5jHeEIynCptyR+AXAI2F9GvRcs0EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Vg3j7z7XkTNY91q5jG6WHG5j5Haw09pVXMPV5VHRqYPLrhdieMUHbhyzdtjRklS3
	 J1owIVXpvn5K2+zoukFNM8Fmh577jiAlFqMduaU4+DOb6gwxEVbe3h0kvkxNLxomrr
	 t9hUSoEb93zeLrsQqeG6wMHg0MimCPQWgAyJ6JjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 379/480] tools/power turbostat: regression fix: --show C1E%
Date: Tue, 12 Aug 2025 19:49:47 +0200
Message-ID: <20250812174413.062857241@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index ab79854cb296..7a407694d221 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -2385,7 +2385,6 @@ unsigned long long bic_lookup(char *name_list, enum show_hide_mode mode)
 
 		}
 		if (i == MAX_BIC) {
-			fprintf(stderr, "deferred %s\n", name_list);
 			if (mode == SHOW_LIST) {
 				deferred_add_names[deferred_add_index++] = name_list;
 				if (deferred_add_index >= MAX_DEFERRED) {
@@ -10314,9 +10313,6 @@ void probe_cpuidle_residency(void)
 	int min_state = 1024, max_state = 0;
 	char *sp;
 
-	if (!DO_BIC(BIC_pct_idle))
-		return;
-
 	for (state = 10; state >= 0; --state) {
 
 		sprintf(path, "/sys/devices/system/cpu/cpu%d/cpuidle/state%d/name", base_cpu, state);
-- 
2.39.5



