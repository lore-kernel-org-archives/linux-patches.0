Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793111DE4CC;
	Tue,  8 Oct 2024 13:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392890; cv=none; b=HLXlOQqEnFaGJN0DOD/bseOlm7h5SBE7LP3j7OXgj18JcH3lWAagZkPpqP3IGFJwJIW/d26YxHYzWiF3exQ3ou4xQRE6Mfj+FYL+9yzfjsxIqjNdXVELg4u2qd74f+bLztn7WVtSw7Sx8uX16YFr7oU66OKeLoNiJfIDnu399SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392890; c=relaxed/simple;
	bh=Ir64wRETTQF9Qmt8IUYh5MBsb7his7HSdtfKaO39Vrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZV2yAGM2sm0yfLRH3g70PRoRfUxnzeYu3SFNHQ034MeKnkIYJjAkCUmCuiI2vquaj+c15KalHjVIodpqMBPwSgpm3eSXmtH7Rrone3hnKM3wnRseoMN7OJGroME1AkECUrjRR8eUl6UgRDwuZwNIaIXD4edWERDC+NNphv+w3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KJoMmuKM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KJoMmuKM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3163C4CEC7;
	Tue,  8 Oct 2024 13:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392890;
	bh=Ir64wRETTQF9Qmt8IUYh5MBsb7his7HSdtfKaO39Vrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KJoMmuKMNoEahZTUSCEYyJAZGoSesln3LVujZJEMoodZmCjtDo2SRrvvwOMhDLD8K
	 7EP0Pul7CAufZ0uE2e+GHHQs5+r1xfS0SV84FmD6cS94fuo+nBFQYcqZcGfwZcv3o0
	 UoDFsHfqXyRdDW7oC0ezF01JsspdxYSblunMFQsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Julia Lawall <julia.lawall@inria.fr>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>
Subject: [PATCH 6.11 518/558] drm/panthor: Fix access to uninitialized variable in tick_ctx_cleanup()
Date: Tue,  8 Oct 2024 14:09:08 +0200
Message-ID: <20241008115722.613029539@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Brezillon <boris.brezillon@collabora.com>

commit 282864cc5d3f144af0cdea1868ee2dc2c5110f0d upstream.

The group variable can't be used to retrieve ptdev in our second loop,
because it points to the previously iterated list_head, not a valid
group. Get the ptdev object from the scheduler instead.

Cc: <stable@vger.kernel.org>
Fixes: d72f049087d4 ("drm/panthor: Allow driver compilation")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@inria.fr>
Closes: https://lore.kernel.org/r/202409302306.UDikqa03-lkp@intel.com/
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240930163742.87036-1-boris.brezillon@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -2046,6 +2046,7 @@ static void
 tick_ctx_cleanup(struct panthor_scheduler *sched,
 		 struct panthor_sched_tick_ctx *ctx)
 {
+	struct panthor_device *ptdev = sched->ptdev;
 	struct panthor_group *group, *tmp;
 	u32 i;
 
@@ -2054,7 +2055,7 @@ tick_ctx_cleanup(struct panthor_schedule
 			/* If everything went fine, we should only have groups
 			 * to be terminated in the old_groups lists.
 			 */
-			drm_WARN_ON(&group->ptdev->base, !ctx->csg_upd_failed_mask &&
+			drm_WARN_ON(&ptdev->base, !ctx->csg_upd_failed_mask &&
 				    group_can_run(group));
 
 			if (!group_can_run(group)) {
@@ -2077,7 +2078,7 @@ tick_ctx_cleanup(struct panthor_schedule
 		/* If everything went fine, the groups to schedule lists should
 		 * be empty.
 		 */
-		drm_WARN_ON(&group->ptdev->base,
+		drm_WARN_ON(&ptdev->base,
 			    !ctx->csg_upd_failed_mask && !list_empty(&ctx->groups[i]));
 
 		list_for_each_entry_safe(group, tmp, &ctx->groups[i], run_node) {


