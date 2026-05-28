Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1DC25F7B9;
	Thu, 28 May 2026 20:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000241; cv=none; b=qcJYHpGcN9gvvopUN67H4pADkfNCXbmfwsLNk2IW39xwKl24XLloCyb1QSyW9gF58G/LD5qxfi9BlnI76MrhoPu7OmPhG9ZdqUoYuSWR/GRT/Xc6nY8JpMogeqw4rL5r0MxZWmEl9jfDFEjX5Qa7QLIfDWyp8VHd1qHowRwwSFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000241; c=relaxed/simple;
	bh=73fVXsSmgsMM9Ix/N2CCVmeV75Bq/VBdSS+BwimzGbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXtc531zG995iHvSMF8Gaqe29metdT0j0mdHMcjJ8yspxIi7yCSfu3v03VQ9kvBN2E9cXmpkySdqniZyXfQFAeCidZGow7cAUglgxhvXH8fLGJimmPBcupAFd8WMP1E6ZdM/FclZEllaNWxOSDKyE7k2J/EWal7J00ALEqeAWSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MqnA0uOt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MqnA0uOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02EF11F00A3A;
	Thu, 28 May 2026 20:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000240;
	bh=fFb1FMQUaMz1ht+pAUNGqeaqcwBDoFtYaYclsKvwlQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MqnA0uOtIUaA6Et4XAORhaRlLlm9vzWuPjSA2evRDcTeBilqt6C9sOhVjyaLEpHdd
	 YT5p026k86NPEusDgyFYPTWEJzBUN9gJk7OkMa3YPb9li1sFsySMtDR3MqJnEgfdw1
	 7EgL/6dID3F373fEuhETGdURlR9sBVs3FmRkccEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 315/377] drm/xe/gsc: Fix double-free of managed BO in error path
Date: Thu, 28 May 2026 21:49:13 +0200
Message-ID: <20260528194647.513566915@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit d3ded53fab90996e7d94a39049e11962dd066725 ]

The error path in xe_gsc_init_post_hwconfig() explicitly frees a BO
allocated with xe_managed_bo_create_pin_map() via
xe_bo_unpin_map_no_vm(). Since the managed BO already has a devm
cleanup action registered, this causes a double-free when devm
unwinds during probe failure.

Remove the explicit free and let devm handle it, consistent with
all other xe_managed_bo_create_pin_map() callers.

Fixes: 2e5d47fe7839 ("drm/xe/uc: Use managed bo for HuC and GSC objects")
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Assisted-by: Claude:claude-opus-4.6
Link: https://patch.msgid.link/20260511154134.223696-1-shuicheng.lin@intel.com
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
(cherry picked from commit 71d61e3e299a17139e47f980a4d6f425b2c59bf7)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gsc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gsc.c b/drivers/gpu/drm/xe/xe_gsc.c
index 8371ec002e4ed..2a496987b8299 100644
--- a/drivers/gpu/drm/xe/xe_gsc.c
+++ b/drivers/gpu/drm/xe/xe_gsc.c
@@ -487,8 +487,7 @@ int xe_gsc_init_post_hwconfig(struct xe_gsc *gsc)
 				 EXEC_QUEUE_FLAG_PERMANENT, 0);
 	if (IS_ERR(q)) {
 		xe_gt_err(gt, "Failed to create queue for GSC submission\n");
-		err = PTR_ERR(q);
-		goto out_bo;
+		return PTR_ERR(q);
 	}
 
 	wq = alloc_ordered_workqueue("gsc-ordered-wq", 0);
@@ -511,8 +510,6 @@ int xe_gsc_init_post_hwconfig(struct xe_gsc *gsc)
 
 out_q:
 	xe_exec_queue_put(q);
-out_bo:
-	xe_bo_unpin_map_no_vm(bo);
 	return err;
 }
 
-- 
2.53.0



