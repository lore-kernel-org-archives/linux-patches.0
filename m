Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E81178CC8;
	Wed,  5 Mar 2025 18:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198513; cv=none; b=HSAp0OJ/RXktuuYo5hV4xoYxdscBYuYT2fEOVUCMPu8hIn6DTyce24TP+NmhDgGosLnGI5WwQFaufCqJ9sFmMhRyFvzyPc60oeFTO91NWFZtTSYgq8UhU4k0GF2sF4sEHenatMf4nj4m56SYGkCvKChndTpFo6ZkT4UW/EWVlyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198513; c=relaxed/simple;
	bh=ZY2VC4a6ZgKIwu1FpyutaqX/Y29sANgAUw9Gmwp7Lso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZUsUNslTBGPHkZmloI8SNKmVtod424L7uXreq04xUUH+PPL19olVnhKg1YWsX+iInhgyJNr0jujQdFoXXKJsR78fijeGxLXe8/dHXG3u8pH91J5zlVuvPX7ZbsgfPld0LAl2+bJo1XCifY+I1gHRTXq0LT/axBiRIG7l2pAmFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oJBSzWad; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oJBSzWad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5BA7C4CED1;
	Wed,  5 Mar 2025 18:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198513;
	bh=ZY2VC4a6ZgKIwu1FpyutaqX/Y29sANgAUw9Gmwp7Lso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oJBSzWadkp1D3oy6nm5wMy+ou4HnAqiTzGJeeB7ehtFG4sxEHk3xtkgKWgngcGSUE
	 hbGvd/UXZnJT9yT1UPeWrCabQeAwUQUO/ZAt9UiBFSKg+Ki3LrNSxJtJWNelOtIadd
	 a3AY2bg5oWr356aXu69c+bFk5M/Zt8B1LwGUR/fY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 052/157] drm/xe: cancel pending job timer before freeing scheduler
Date: Wed,  5 Mar 2025 18:48:08 +0100
Message-ID: <20250305174507.399643662@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 6f4a9812b4f4a..fe17e9ba86725 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -1238,6 +1238,8 @@ static void __guc_exec_queue_fini_async(struct work_struct *w)
 
 	if (xe_exec_queue_is_lr(q))
 		cancel_work_sync(&ge->lr_tdr);
+	/* Confirm no work left behind accessing device structures */
+	cancel_delayed_work_sync(&ge->sched.base.work_tdr);
 	release_guc_id(guc, q);
 	xe_sched_entity_fini(&ge->entity);
 	xe_sched_fini(&ge->sched);
-- 
2.39.5



