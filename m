Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFA21A840E;
	Wed,  5 Mar 2025 18:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198080; cv=none; b=pJVE8JTVW4qSroPMKsyVZb9ME7YECN+Il8ciZk21CS7faT6RhMRtbLiwXAX1igXDz3cdoa1AMbP4HJKAJSo2i5IuqHKEmobBzvs1j9kzle31x/FU2SuOIP31g5rRrRwVEDMyMHyOKwNOadtyVZ6HseSL4+WbDQ3I8W6OYo4N/ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198080; c=relaxed/simple;
	bh=w67TLsNIhvYRQl+eku/O1OAvWEAUH8TT1xVRTrUJqbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AcYUe8tuA3nZcxC38PGY8Pa1AbWFZ28nYICS8L8hbRCmRIcIkDmytujP8MlJK7ZbPIo9/ddpEfGlXvI5I5HqTMMTHYcDBVOSH85ez6GpVa9DHPbTB77e1aSWpVwD1SGZeizfUnlZn8etblAgnTQOUdIkeRjpUx8V3OS3KjTtQI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+2+Hy0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+2+Hy0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83418C4CEE2;
	Wed,  5 Mar 2025 18:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198079;
	bh=w67TLsNIhvYRQl+eku/O1OAvWEAUH8TT1xVRTrUJqbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+2+Hy0UNVJqZLzcEIu0xoPJzyay30jwmgCeFJ+HLWdRRqN8J0mO5rR/vSIgjcKEz
	 ma2kAhftk7VmZabwDOhVHs/0fVYDQUZnATWKzD1jCIihnMniX0BSU6HzgnLULRQUQk
	 lbBXGhm1tBQCkf/VO+RiHge6W/GxtiQ1+AWXjgv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 058/150] drm/xe: cancel pending job timer before freeing scheduler
Date: Wed,  5 Mar 2025 18:48:07 +0100
Message-ID: <20250305174506.154179603@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejas Upadhyay <tejas.upadhyay@intel.com>

[ Upstream commit 12c2f962fe71f390951d9242725bc7e608f55927 ]

The async call to __guc_exec_queue_fini_async frees the scheduler
while a submission may time out and restart. To prevent this race
condition, the pending job timer should be canceled before freeing
the scheduler.

V3(MattB):
 - Adjust position of cancel pending job
 - Remove gitlab issue# from commit message
V2(MattB):
 - Cancel pending jobs before scheduler finish

Fixes: a20c75dba192 ("drm/xe: Call __guc_exec_queue_fini_async direct for KERNEL exec_queues")
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250225045754.600905-1-tejas.upadhyay@intel.com
Signed-off-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
(cherry picked from commit 18fbd567e75f9b97b699b2ab4f1fa76b7cf268f6)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_submit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index fed23304e4da5..3fd2b28b91ab9 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -1215,6 +1215,8 @@ static void __guc_exec_queue_fini_async(struct work_struct *w)
 
 	if (xe_exec_queue_is_lr(q))
 		cancel_work_sync(&ge->lr_tdr);
+	/* Confirm no work left behind accessing device structures */
+	cancel_delayed_work_sync(&ge->sched.base.work_tdr);
 	release_guc_id(guc, q);
 	xe_sched_entity_fini(&ge->entity);
 	xe_sched_fini(&ge->sched);
-- 
2.39.5



