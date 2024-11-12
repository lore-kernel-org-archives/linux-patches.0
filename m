Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A048E212D16;
	Tue, 12 Nov 2024 10:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408493; cv=none; b=dOeYcp+QxnhKeTTwNX96PEeo9NJFrw8mg3jHT8TXclxP77PHL2MynWof2Tt+gl1yi+mDMur9p3pk8Cv4yUC4vwq9bS1dS6qEY9IW1g1pvfi6YMrLVIUxpX6CZUDzbMqBnVXmK7Mf2L2ltX5+8J9yITJam8BKSa+Yj7zfhK68xss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408493; c=relaxed/simple;
	bh=jRvF0/7/98EmAAwQ7N/T/9YOuPCAPcc7SWmonDWjXc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q2KUBIDWRoiMpTamWb+1txdXOpI1A11sd3CXv4oy+xOHaS2Igmd7GFmp4Q5ml/KkBnHiFRDXhuBkF/Wi1ZYhxYjmSCqhVv22p5TB+ETE40oyiGf/HwTYH8zEt7C7t9e/QIEZwLTBpipV9+tC4QM1EIvvy0YYYmxG3Uk4JBor9Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8qG0rfD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8qG0rfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2583DC4CECD;
	Tue, 12 Nov 2024 10:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408493;
	bh=jRvF0/7/98EmAAwQ7N/T/9YOuPCAPcc7SWmonDWjXc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H8qG0rfDGEwEqifSlkuAQ0ixBgSe7uyQSj2o8FwVcaYNJmsEWujVUiZOrDeJ1+l35
	 bqedlrlroMIElh9Ejm/D0jCWxSeVKLfLKBfQZdwAhunaauT9JoJqGouOLvJR5hBpj4
	 gBN5wUhRs6njLaX4t7iXOF2uV8WtbYoahuIHfVxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Badal Nilawar <badal.nilawar@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 180/184] drm/xe/guc/tlb: Flush g2h worker in case of tlb timeout
Date: Tue, 12 Nov 2024 11:22:18 +0100
Message-ID: <20241112101907.771106636@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

From: Nirmoy Das <nirmoy.das@intel.com>

[ Upstream commit 1491efb39acee3848b61fcb3e5cc4be8de304352 ]

Flush the g2h worker explicitly if TLB timeout happens which is
observed on LNL and that points to the recent scheduling issue with
E-cores on LNL.

This is similar to the recent fix:
commit e51527233804 ("drm/xe/guc/ct: Flush g2h worker in case of g2h
response timeout") and should be removed once there is E core
scheduling fix.

v2: Add platform check(Himal)
v3: Remove gfx platform check as the issue related to cpu
    platform(John)
    Use the common WA macro(John) and print when the flush
    resolves timeout(Matt B)
v4: Remove the resolves log and do the flush before taking
    pending_lock(Matt A)

Cc: Badal Nilawar <badal.nilawar@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: John Harrison <John.C.Harrison@Intel.com>
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: stable@vger.kernel.org # v6.11+
Link: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/2687
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241029120117.449694-3-nirmoy.das@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit e1f6fa55664a0eeb0a641f497e1adfcf6672e995)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c b/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c
index 82795133e129e..836c15253ce7e 100644
--- a/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c
+++ b/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c
@@ -71,6 +71,8 @@ static void xe_gt_tlb_fence_timeout(struct work_struct *work)
 	struct xe_device *xe = gt_to_xe(gt);
 	struct xe_gt_tlb_invalidation_fence *fence, *next;
 
+	LNL_FLUSH_WORK(&gt->uc.guc.ct.g2h_worker);
+
 	spin_lock_irq(&gt->tlb_invalidation.pending_lock);
 	list_for_each_entry_safe(fence, next,
 				 &gt->tlb_invalidation.pending_fences, link) {
-- 
2.43.0



