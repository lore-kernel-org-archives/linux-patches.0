Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A294E1DDA36;
	Wed, 19 Mar 2025 14:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394976; cv=none; b=haC7y/jI8b46LS3UKI+Uw+2yLEO8h7EW2fCHW88BlPAJpSncGRLLiBfsoYWVKkHgUmNNYPTEJ5I2GrLmQsX69Lds/2lxdweWsV0DBB5SCBtlPIDzhfXt0smkbqYdCctb58XWNI9bAhUv/B+U8oUYAGypsnqwmtsau9lzejpWd64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394976; c=relaxed/simple;
	bh=+viPMLfmhEmeMX/lId7o9qdBiRC+jlAjaIuqIhrHErQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HyUrRgiak9XqMdDZdFVkK8IZv3DvbR6By2sKTMXeVG/XEV+9B6GFEvBSYG94+m+Zs+2gwu6cqANKG5MJUEMiCTiAXRUnVffOWVBeTzkUwEF67jhDQB84TabiD1kVx6Cyi0y+TJ2lJkLUbo0tmxV+QwYOOWWPxumhBBYIDP6aMX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uGY+mcGe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uGY+mcGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79808C4CEE4;
	Wed, 19 Mar 2025 14:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394976;
	bh=+viPMLfmhEmeMX/lId7o9qdBiRC+jlAjaIuqIhrHErQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uGY+mcGeDRZYLZGMUFDiqkVRmcQnOOF3Dw7QQj8XK24kPOUPKa43hmeXkF/ZNEaGK
	 38CclV47gDjZ2dnVYS+WcUKtsnS27f0AKudXNFj7iu3NlKGSpEkUvIRF03l4PeNqRm
	 JzU4wP+F6cSubpJp6Sda1pa0Dro7Tm3+oEOjFLJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 213/241] drm/xe: Release guc ids before cancelling work
Date: Wed, 19 Mar 2025 07:31:23 -0700
Message-ID: <20250319143033.020281607@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

[ Upstream commit 10c7988418d8f759ba70c4a558961e0bfa74647f ]

A GT resets can be occurring in parallel while cancelling
work in async call  which can requeue these workers.
to avoid that, lets first release guc ids and then cancel
work so they don't requeued.

Fixes: 8ae8a2e8dd21 ("drm/xe: Long running job update")
Fixes: 12c2f962fe71 ("drm/xe: cancel pending job timer before freeing scheduler")
Signed-off-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Suggested-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250306131211.975503-1-tejas.upadhyay@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 8e8d76f62329127b31c64a034b052fb9e30e92af)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_submit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index fe17e9ba86725..d2b1fce121a84 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -1236,11 +1236,11 @@ static void __guc_exec_queue_fini_async(struct work_struct *w)
 	xe_pm_runtime_get(guc_to_xe(guc));
 	trace_xe_exec_queue_destroy(q);
 
+	release_guc_id(guc, q);
 	if (xe_exec_queue_is_lr(q))
 		cancel_work_sync(&ge->lr_tdr);
 	/* Confirm no work left behind accessing device structures */
 	cancel_delayed_work_sync(&ge->sched.base.work_tdr);
-	release_guc_id(guc, q);
 	xe_sched_entity_fini(&ge->entity);
 	xe_sched_fini(&ge->sched);
 
-- 
2.39.5



