Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80959195FDF;
	Thu,  6 Jun 2024 14:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683070; cv=none; b=UYrg58DpBk92YRzc2CgQxnPH7Ur+GeQ83kC4+GiXLFlzO5dPJcdKxrHjtCySWLiyT8gzXnu78u7SCuUHwuYw1doj8rFXwxoH3wXLs1P2CEK6gHYAsd0sf1iVCtma8c3v4U+dcMkojgXr+mD4f6Z+AScaKaN4ZdlWfSo/m0YIowc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683070; c=relaxed/simple;
	bh=pOCwHl2jSmTW160loekKTXYQLnQH+lA8b6phRRT7QV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SP8pYG3Oz8qdhi8HeQY8n6WZJqha+9/HOpMUa2UR5Kn7ZNau8FR9dbDdufss960WGmao2AjtaS8iQNYtUFmOQmAIWxIWb3GFq6j5aYHiQIdyexu+JCnedOefKLKZDvo+6he5x9tVG58s8XILNMRL6tkyA0Axgkkicnm/W7ZjkYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6e6YCVo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6e6YCVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32252C4AF11;
	Thu,  6 Jun 2024 14:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683069;
	bh=pOCwHl2jSmTW160loekKTXYQLnQH+lA8b6phRRT7QV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g6e6YCVo9kuMM6EHUEnJO2SgpgZGPKfveu8dTSwiK9U6gSrS+CDZvURR/Q7S18S93
	 Xf2UdmZweyrnd2luweR7EyS0Ulre6Lja+7HhEW5XupiwzZB5CzxQ6oksrk2YNxyJev
	 Q50bPnJ8RQ7isWmMGJ0EmW2Gq7mihEgkUmiQFVAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Brian Welty <brian.welty@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 329/374] drm/xe: Only use reserved BCS instances for usm migrate exec queue
Date: Thu,  6 Jun 2024 16:05:08 +0200
Message-ID: <20240606131702.881023303@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit c8ea2c31f5ea437199b239d76ad5db27343edb0c ]

The GuC context scheduling queue is 2 entires deep, thus it is possible
for a migration job to be stuck behind a fault if migration exec queue
shares engines with user jobs. This can deadlock as the migrate exec
queue is required to service page faults. Avoid deadlock by only using
reserved BCS instances for usm migrate exec queue.

Fixes: a043fbab7af5 ("drm/xe/pvc: Use fast copy engines as migrate engine on PVC")
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240415190453.696553-2-matthew.brost@intel.com
Reviewed-by: Brian Welty <brian.welty@intel.com>
(cherry picked from commit 04f4a70a183a688a60fe3882d6e4236ea02cfc67)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_migrate.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_migrate.c b/drivers/gpu/drm/xe/xe_migrate.c
index 2ba4fb9511f63..aca519f5b85d9 100644
--- a/drivers/gpu/drm/xe/xe_migrate.c
+++ b/drivers/gpu/drm/xe/xe_migrate.c
@@ -33,7 +33,6 @@
 #include "xe_sync.h"
 #include "xe_trace.h"
 #include "xe_vm.h"
-#include "xe_wa.h"
 
 /**
  * struct xe_migrate - migrate context.
@@ -299,10 +298,6 @@ static int xe_migrate_prepare_vm(struct xe_tile *tile, struct xe_migrate *m,
 }
 
 /*
- * Due to workaround 16017236439, odd instance hardware copy engines are
- * faster than even instance ones.
- * This function returns the mask involving all fast copy engines and the
- * reserved copy engine to be used as logical mask for migrate engine.
  * Including the reserved copy engine is required to avoid deadlocks due to
  * migrate jobs servicing the faults gets stuck behind the job that faulted.
  */
@@ -316,8 +311,7 @@ static u32 xe_migrate_usm_logical_mask(struct xe_gt *gt)
 		if (hwe->class != XE_ENGINE_CLASS_COPY)
 			continue;
 
-		if (!XE_WA(gt, 16017236439) ||
-		    xe_gt_is_usm_hwe(gt, hwe) || hwe->instance & 1)
+		if (xe_gt_is_usm_hwe(gt, hwe))
 			logical_mask |= BIT(hwe->logical_instance);
 	}
 
@@ -368,6 +362,10 @@ struct xe_migrate *xe_migrate_init(struct xe_tile *tile)
 		if (!hwe || !logical_mask)
 			return ERR_PTR(-EINVAL);
 
+		/*
+		 * XXX: Currently only reserving 1 (likely slow) BCS instance on
+		 * PVC, may want to revisit if performance is needed.
+		 */
 		m->q = xe_exec_queue_create(xe, vm, logical_mask, 1, hwe,
 					    EXEC_QUEUE_FLAG_KERNEL |
 					    EXEC_QUEUE_FLAG_PERMANENT |
-- 
2.43.0



