Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A4279C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:38:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACCCEC433D2;
	Thu, 12 Jan 2023 14:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673534280;
	bh=ZAt0PT/vHpElhmbM9Ty7asNuRfZj9JzDj75zuFDpWXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/orWDc01lhxdH6mNlL/aynJb2yJaSNs5QYPGbMERuTAraWdR/JThVFgLV+3CuVHn
	 ynk7AOAB/gslDaXG5h4GTbbid4zX27xDXx0PZaFpwMECkVp+ZAq598UzZfroJwJ9f/
	 iCamugFLtPiyGijjZhCpKwUjBrZU/8u0l8XYluKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 755/783] drm/i915: unpin on error in intel_vgpu_shadow_mm_pin()
Date: Thu, 12 Jan 2023 14:57:51 +0100
Message-Id: <20230112135559.351411298@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 3792fc508c095abd84b10ceae12bd773e61fdc36 ]

Call intel_vgpu_unpin_mm() on this error path.

Fixes: 418741480809 ("drm/i915/gvt: Adding ppgtt to GVT GEM context after shadow pdps settled.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/Y3OQ5tgZIVxyQ/WV@kili
Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gvt/scheduler.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/i915/gvt/scheduler.c b/drivers/gpu/drm/i915/gvt/scheduler.c
index aed2ef6466a2..2bb6203298bc 100644
--- a/drivers/gpu/drm/i915/gvt/scheduler.c
+++ b/drivers/gpu/drm/i915/gvt/scheduler.c
@@ -647,6 +647,7 @@ intel_vgpu_shadow_mm_pin(struct intel_vgpu_workload *workload)
 
 	if (workload->shadow_mm->type != INTEL_GVT_MM_PPGTT ||
 	    !workload->shadow_mm->ppgtt_mm.shadowed) {
+		intel_vgpu_unpin_mm(workload->shadow_mm);
 		gvt_vgpu_err("workload shadow ppgtt isn't ready\n");
 		return -EINVAL;
 	}
-- 
2.35.1



