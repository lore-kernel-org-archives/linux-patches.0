Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19A624E00F;
	Tue, 29 Apr 2025 18:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950275; cv=none; b=IqZxSHmI9fKhs6RxOEv3xYxUPhN5sYGeW93q+btEmNNnIuluZ5nbCns3ag1U+lVtdY3+sbZFllXeqSNwCrP+LRTLH2pq9rDH1eRXXSV/A7nbJ16/ooiHBPzm1CMgFR/EHXNy5628+NbKsNcFdISL6nDbd+jb65skF3nX2UQV7LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950275; c=relaxed/simple;
	bh=hFLmkmR17Z6TrAT6o2KMMD8/IojQ54jh7bzoNAG0hwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DBomoSA6sxN+7xMlHtSZVMHYfFj8+PAh4PIu0mllYdGtZ/M05JaDaRHpt5Y6/3NyUps85NaS7CJ7srJch3EUGhu72g6peQOKSIhln3JjNolUXfT+7U/YXINHkadxVA86Jp0FMFiXlyq69cG9nyN4WXR3z6AUKglU3xN+rwadQGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQyNJJ+G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQyNJJ+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6177DC4CEE3;
	Tue, 29 Apr 2025 18:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950275;
	bh=hFLmkmR17Z6TrAT6o2KMMD8/IojQ54jh7bzoNAG0hwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SQyNJJ+GyxnySWXNCFcz/RLorN7RFCSkLRuq68TSbK8v4rA5UH0+8jq5WvSBwDutX
	 0q482o3Fatgu1IDCxcmL2vItdd61wQ4P/gY6rPbe9lhoOlYO+P/Y5pySY7N1Zuct5l
	 ioXsZ/dxWVesxPwLfbTGtaBdeio9cb/zFysyJf1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/204] cpufreq/sched: Explicitly synchronize limits_changed flag handling
Date: Tue, 29 Apr 2025 18:42:12 +0200
Message-ID: <20250429161101.214034065@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 79443a7e9da3c9f68290a8653837e23aba0fa89f ]

The handling of the limits_changed flag in struct sugov_policy needs to
be explicitly synchronized to ensure that cpufreq policy limits updates
will not be missed in some cases.

Without that synchronization it is theoretically possible that
the limits_changed update in sugov_should_update_freq() will be
reordered with respect to the reads of the policy limits in
cpufreq_driver_resolve_freq() and in that case, if the limits_changed
update in sugov_limits() clobbers the one in sugov_should_update_freq(),
the new policy limits may not take effect for a long time.

Likewise, the limits_changed update in sugov_limits() may theoretically
get reordered with respect to the updates of the policy limits in
cpufreq_set_policy() and if sugov_should_update_freq() runs between
them, the policy limits change may be missed.

To ensure that the above situations will not take place, add memory
barriers preventing the reordering in question from taking place and
add READ_ONCE() and WRITE_ONCE() annotations around all of the
limits_changed flag updates to prevent the compiler from messing up
with that code.

Fixes: 600f5badb78c ("cpufreq: schedutil: Don't skip freq update when limits change")
Cc: 5.3+ <stable@vger.kernel.org> # 5.3+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/3376719.44csPzL39Z@rjwysocki.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/cpufreq_schedutil.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
index f84473f73ed00..776be0549162c 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -81,9 +81,20 @@ static bool sugov_should_update_freq(struct sugov_policy *sg_policy, u64 time)
 	if (!cpufreq_this_cpu_can_update(sg_policy->policy))
 		return false;
 
-	if (unlikely(sg_policy->limits_changed)) {
-		sg_policy->limits_changed = false;
+	if (unlikely(READ_ONCE(sg_policy->limits_changed))) {
+		WRITE_ONCE(sg_policy->limits_changed, false);
 		sg_policy->need_freq_update = true;
+
+		/*
+		 * The above limits_changed update must occur before the reads
+		 * of policy limits in cpufreq_driver_resolve_freq() or a policy
+		 * limits update might be missed, so use a memory barrier to
+		 * ensure it.
+		 *
+		 * This pairs with the write memory barrier in sugov_limits().
+		 */
+		smp_mb();
+
 		return true;
 	}
 
@@ -334,7 +345,7 @@ static inline bool sugov_cpu_is_busy(struct sugov_cpu *sg_cpu) { return false; }
 static inline void ignore_dl_rate_limit(struct sugov_cpu *sg_cpu)
 {
 	if (cpu_bw_dl(cpu_rq(sg_cpu->cpu)) > sg_cpu->bw_min)
-		sg_cpu->sg_policy->limits_changed = true;
+		WRITE_ONCE(sg_cpu->sg_policy->limits_changed, true);
 }
 
 static inline bool sugov_update_single_common(struct sugov_cpu *sg_cpu,
@@ -844,7 +855,16 @@ static void sugov_limits(struct cpufreq_policy *policy)
 		mutex_unlock(&sg_policy->work_lock);
 	}
 
-	sg_policy->limits_changed = true;
+	/*
+	 * The limits_changed update below must take place before the updates
+	 * of policy limits in cpufreq_set_policy() or a policy limits update
+	 * might be missed, so use a memory barrier to ensure it.
+	 *
+	 * This pairs with the memory barrier in sugov_should_update_freq().
+	 */
+	smp_wmb();
+
+	WRITE_ONCE(sg_policy->limits_changed, true);
 }
 
 struct cpufreq_governor schedutil_gov = {
-- 
2.39.5



