Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5E62F12D2;
	Fri, 17 Oct 2025 15:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715055; cv=none; b=O5J5w6guqrAHTgCQD6TcOP0y92AYcPLNP7Aci2oitdST/jlh/ceKKiA5OMQ1qM90Ggn2MIUWPYyns+8vPOYou6ayLTEVtwT9+6LG9FKPD/wVNHcLIbrYr+URIF6i/u38UsJjVtxHejtDZTJWGZJowDm2n5xOxM574jdsKfX4VCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715055; c=relaxed/simple;
	bh=eHUsPuyZmir5MY4+b2+32Afamx5Aajo8cZxxHzkxil0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APCNJpTSJ4x5TJgi7AIlqzpa8szhuXR1qr28G90SwlD/HS8cEXHFGKCXqYC2iZJW0hVadOVBDTwodaCxKT1qjne5BPWnd+MaERTxR694tmj18Bv65O/9GGOoUWaYH6CGKB4Y2ZjNq57RyziA1Z8OwNAAKOMwHtb/+w/gQkT23QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q1lrIOB2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q1lrIOB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B941C4CEE7;
	Fri, 17 Oct 2025 15:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715055;
	bh=eHUsPuyZmir5MY4+b2+32Afamx5Aajo8cZxxHzkxil0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q1lrIOB2dwHHfeV3f+N1JMUjD/OF4WqMji6sAprSdFonEfN78J1UnnvpPmhyzCzlH
	 0UHpprvHxbi25wMl6Hv9H0KNqmW8PKn9Mad8yvjOG7P+60FxIw0PfygUjnbA6XO3m5
	 JY2idVHjyhgT1Y6Yw8vR4Wb8//z0lwCFR56ilbjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francois Dugast <francois.dugast@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 082/371] drm/xe/hw_engine_group: Fix double write lock release in error path
Date: Fri, 17 Oct 2025 16:50:57 +0200
Message-ID: <20251017145204.905611538@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit 08fdfd260e641da203f80aff8d3ed19c5ecceb7d ]

In xe_hw_engine_group_get_mode(), a write lock is acquired before
calling switch_mode(), which in turn invokes
xe_hw_engine_group_suspend_faulting_lr_jobs().

On failure inside xe_hw_engine_group_suspend_faulting_lr_jobs(),
the write lock is released there, and then again in
xe_hw_engine_group_get_mode(), leading to a double release.

Fix this by keeping both acquire and release operation in
xe_hw_engine_group_get_mode().

Fixes: 770bd1d34113 ("drm/xe/hw_engine_group: Ensure safe transition between execution modes")
Cc: Francois Dugast <francois.dugast@intel.com>
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
Reviewed-by: Francois Dugast <francois.dugast@intel.com>
Link: https://lore.kernel.org/r/20250925023145.1203004-2-shuicheng.lin@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 662d98b8b373007fa1b08ba93fee11f6fd3e387c)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_hw_engine_group.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_hw_engine_group.c b/drivers/gpu/drm/xe/xe_hw_engine_group.c
index c926f840c87b0..cb1d7ed54f429 100644
--- a/drivers/gpu/drm/xe/xe_hw_engine_group.c
+++ b/drivers/gpu/drm/xe/xe_hw_engine_group.c
@@ -213,17 +213,13 @@ static int xe_hw_engine_group_suspend_faulting_lr_jobs(struct xe_hw_engine_group
 
 		err = q->ops->suspend_wait(q);
 		if (err)
-			goto err_suspend;
+			return err;
 	}
 
 	if (need_resume)
 		xe_hw_engine_group_resume_faulting_lr_jobs(group);
 
 	return 0;
-
-err_suspend:
-	up_write(&group->mode_sem);
-	return err;
 }
 
 /**
-- 
2.51.0



