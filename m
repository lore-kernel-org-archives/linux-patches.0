Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DCE21CC55;
	Wed, 19 Mar 2025 14:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395137; cv=none; b=OyFcOrl7qfNBhpiX1Mz3ziruqBSCFRWyuSDeLbaeS953i/oBGzFezx/E8syatEmNI2tYd/szCn6Hvq1hl/qPbfhLMND7q5w3KN2MX2JcHnxNgByM7d6KLK1gKuOMHDRcuBHTFooIev5gF8t4/vaVS2sNynGxcgkozSUFHxdMEYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395137; c=relaxed/simple;
	bh=w67TLsNIhvYRQl+eku/O1OAvWEAUH8TT1xVRTrUJqbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvPpfP0+GMevm4MlX3BhroQHaWGFy3N+RBDXBVhW5w0sOUN9MwPOEI+5ArwgAEZK0a+lWU8f2AWn02MaohF1CaXr5SFHioZv02JZrLRuJYCqSHJYpBc1+YqJcVCLf/dgzcrYANByRJ1VTWSwuQMC96P+wG7KnfghYWS8Bfnyp74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ocQX1i34; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ocQX1i34"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD32C4CEE4;
	Wed, 19 Mar 2025 14:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395137;
	bh=w67TLsNIhvYRQl+eku/O1OAvWEAUH8TT1xVRTrUJqbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ocQX1i34pWZJT0h4jMjg9n+zWZO61WZlFEJFSZTV44y5Pk5nx6BCRQRFaxE+FZSy7
	 7Ssceivwc4yLnDMpKOWFWcc2rdPnOkmTiyEoNY2M0OVzWdl50TShPmzFpP1r0hdp2P
	 3VzT7EO2giL8ZpZ/3PsvyQbrMCGM7QdZWAOEl3m8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 204/231] drm/xe: cancel pending job timer before freeing scheduler
Date: Wed, 19 Mar 2025 07:31:37 -0700
Message-ID: <20250319143031.880769977@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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



