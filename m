Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41C71CDFAC;
	Sun,  7 Sep 2025 20:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275677; cv=none; b=CZMv9Zd597RnUtRGYRI5/jdXYCog3IM5zIdo5M9U9IKUB1mwZBKjgBXLPAp4A3ohN61/DLT37tQGRDWMHLe6S0YIYNu0alQFLhE8kuFONT6KbPp2Vl3efqirzWAkSaZlzjZ0wLWby/XOYAnMWRZI6xvwQeqO5Aw7MK1S6/MtQ6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275677; c=relaxed/simple;
	bh=yoaJy85C2tH+Nw7KofVuQTcF0Ebgw0u5zeqrUSlYPrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utTc9NU3TX649aEsRov2eFDOmX77aAB4bZoFy3UTNtyzH+lbbJ4YVt3DTyRPWKbvmPDsU+TkyxIKlKMnRq+5WD7LUncLGi9tOnx2h5wfdhr+kv26X2o4aznym/aup4gttuQ5HOxfjTxGbHpcn16MlF/BOOxYnXPpvK04kvGdVZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cnbv/bA0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cnbv/bA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54684C4CEF0;
	Sun,  7 Sep 2025 20:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275677;
	bh=yoaJy85C2tH+Nw7KofVuQTcF0Ebgw0u5zeqrUSlYPrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cnbv/bA0Lhlodx7ZLrLWrnZCd6lOkEZNdcvXoNQzODrHGZL7z1asrFXnVeidIbW/3
	 zjKEVQPAgd/dL9nDOLAq7b9Er2w7lzZV80OaS7J2HebFVtEiOI+8Ln7jnkKtijZOzB
	 bPe2hI449JTbKC514UTlHPm6qyj1hwyzvTmRxLzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 29/52] cpufreq/sched: Explicitly synchronize limits_changed flag handling
Date: Sun,  7 Sep 2025 21:57:49 +0200
Message-ID: <20250907195602.833628920@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195601.957051083@linuxfoundation.org>
References: <20250907195601.957051083@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

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
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/cpufreq_schedutil.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -88,9 +88,20 @@ static bool sugov_should_update_freq(str
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
 
@@ -443,7 +454,7 @@ static inline bool sugov_cpu_is_busy(str
 static inline void ignore_dl_rate_limit(struct sugov_cpu *sg_cpu, struct sugov_policy *sg_policy)
 {
 	if (cpu_bw_dl(cpu_rq(sg_cpu->cpu)) > sg_cpu->bw_dl)
-		sg_policy->limits_changed = true;
+		WRITE_ONCE(sg_policy->limits_changed, true);
 }
 
 static void sugov_update_single(struct update_util_data *hook, u64 time,
@@ -891,7 +902,16 @@ static void sugov_limits(struct cpufreq_
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


