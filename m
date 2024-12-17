Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01161F75BE;
	Tue, 17 Dec 2024 17:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456425; cv=none; b=elH8liOnkQcmaCRn4F9yX0ZtA/BCo5Kgek3bqL6gZf/mqqP95S715N+NWPXko1m/ZNNL8g1s8oQu2JrAsFc3UZkrYT0KjxHKvePB3ZqrO4h1vdnHe/3Suc2IgSsBTHBY8LD7rDkBIDx64rrjR5CPcCXoZbK/iBOCBWiX2x3DkbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456425; c=relaxed/simple;
	bh=2bLrqFuNh5pDdoJux/BmQv7dxxrqN0A1elkAFlIhRD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N2f/jOTckO4VNopkZLKVAmWCxtm1e64DG3hkL5G9H2utn5VAYpIpLTLEvMchWogLbikEym+r3gs95LtwJ1TJIHAoL3Un59XYzwRt+UsD0R8Hi/A9SAQM7XdG+LO7Q1PMTRMmie95yf8DPVX5+2g1oLGmS0mR/T1QLQTVM3+0S/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kQEDNzwg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kQEDNzwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DA2C4CED3;
	Tue, 17 Dec 2024 17:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456424;
	bh=2bLrqFuNh5pDdoJux/BmQv7dxxrqN0A1elkAFlIhRD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kQEDNzwgBnPZIXsg4P8wgzneYx64uk7LrH9tkSXf6lphiAzusc19SyxqwKwxluekj
	 diM2BrhPL85ec4kzMfdUkoJVbt3g7rajAON0FFKvgxta0qC705DXH2vA1VxCDsEScF
	 ZUXFiCmUZiajqN60KRzPHEf+eum5wVpWiihPauic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.12 056/172] drm/xe: Call invalidation_fence_fini for PT inval fences in error state
Date: Tue, 17 Dec 2024 18:06:52 +0100
Message-ID: <20241217170548.592954561@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

commit cefade70f346160f47cc24776160329e2ee63653 upstream.

Invalidation_fence_init takes a PM reference, which is released in its
_fini counterpart, so we need to make sure that the latter is called,
even if the fence is in an error state.

Since we already have a function that calls _fini() and signals the
fence in the tlb inval code, we can expose that and call it from the PT
code.

Fixes: f002702290fc ("drm/xe: Hold a PM ref when GT TLB invalidations are inflight")
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: <stable@vger.kernel.org> # v6.11+
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Nirmoy Das <nirmoy.das@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241206015022.1567113-1-daniele.ceraolospurio@intel.com
(cherry picked from commit 65338639b79ce88aef5263cd518cde570a3c7c8e)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c | 8 ++++++++
 drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h | 1 +
 drivers/gpu/drm/xe/xe_pt.c                  | 3 +--
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c b/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c
index 3cb228c773cd..6146d1776bda 100644
--- a/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c
+++ b/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c
@@ -65,6 +65,14 @@ invalidation_fence_signal(struct xe_device *xe, struct xe_gt_tlb_invalidation_fe
 	__invalidation_fence_signal(xe, fence);
 }
 
+void xe_gt_tlb_invalidation_fence_signal(struct xe_gt_tlb_invalidation_fence *fence)
+{
+	if (WARN_ON_ONCE(!fence->gt))
+		return;
+
+	__invalidation_fence_signal(gt_to_xe(fence->gt), fence);
+}
+
 static void xe_gt_tlb_fence_timeout(struct work_struct *work)
 {
 	struct xe_gt *gt = container_of(work, struct xe_gt,
diff --git a/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h b/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h
index f430d5797af7..00b1c6c01e8d 100644
--- a/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h
+++ b/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h
@@ -28,6 +28,7 @@ int xe_guc_tlb_invalidation_done_handler(struct xe_guc *guc, u32 *msg, u32 len);
 void xe_gt_tlb_invalidation_fence_init(struct xe_gt *gt,
 				       struct xe_gt_tlb_invalidation_fence *fence,
 				       bool stack);
+void xe_gt_tlb_invalidation_fence_signal(struct xe_gt_tlb_invalidation_fence *fence);
 
 static inline void
 xe_gt_tlb_invalidation_fence_wait(struct xe_gt_tlb_invalidation_fence *fence)
diff --git a/drivers/gpu/drm/xe/xe_pt.c b/drivers/gpu/drm/xe/xe_pt.c
index f27f579f4d85..797576690356 100644
--- a/drivers/gpu/drm/xe/xe_pt.c
+++ b/drivers/gpu/drm/xe/xe_pt.c
@@ -1333,8 +1333,7 @@ static void invalidation_fence_cb(struct dma_fence *fence,
 		queue_work(system_wq, &ifence->work);
 	} else {
 		ifence->base.base.error = ifence->fence->error;
-		dma_fence_signal(&ifence->base.base);
-		dma_fence_put(&ifence->base.base);
+		xe_gt_tlb_invalidation_fence_signal(&ifence->base);
 	}
 	dma_fence_put(ifence->fence);
 }
-- 
2.47.1



