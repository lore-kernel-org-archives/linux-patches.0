Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E07D26E6F4;
	Fri, 21 Nov 2025 13:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731477; cv=none; b=YNVRmGhjPIXlw1RVe2prgkCHxSgCnbPSdVAXL7bU96XJTP9JgFoSwezq1NYZR4AhMXS++rIoy/xyr4HNctHv4cwyxy/lrxrYLIexUzAjRu7JjPW5+hxMG0LEvzVyrPQRu5qGYSu6cGCrpWhzRNEiJI8VHIm1/xom3yxeA1X/7Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731477; c=relaxed/simple;
	bh=Twf+PbOdsLOFjnnQLSixDS9YLmRNrSNp4AYeKbB4r/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hK6AAvdg924Jl+phoj0FD4aq5k2PaRc5h7Qsu13nea9wyIxC1P8vkqBDE0/1SVFuiXyyfwRMrDeDBLE6EhnZekHgQmeLiCOXwfetQR5sR/AIDCW/Vl0rrfcwzDpT8JST9G8sdnsTyrJ2TMVVMQvBwUGUoylxg2sKUDxyAMlEpL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F3ioiTaN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F3ioiTaN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B22C4CEF1;
	Fri, 21 Nov 2025 13:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731477;
	bh=Twf+PbOdsLOFjnnQLSixDS9YLmRNrSNp4AYeKbB4r/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F3ioiTaNo4Ys+0nh1uKTyqu+LCvFtWjwe5tbfMURvF9nWb+KQNXvbxCsnL3W0xbkN
	 O0CXsS1dzmNyu4chuRmq/a06i8E/dDAFpQihzJB7AjXL07fezZ/pzbvcpwcO+uwdhi
	 IyDbiFQGSrYHzYIQGE38Ab/QuCZ4DSVswf51FsJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.17 220/247] drm/amdgpu: fix lock warning in amdgpu_userq_fence_driver_process
Date: Fri, 21 Nov 2025 14:12:47 +0100
Message-ID: <20251121130202.630077958@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse.Zhang <Jesse.Zhang@amd.com>

commit 6623c5f9fd877868fba133b4ae4dab0052e82dad upstream.

Fix a potential deadlock caused by inconsistent spinlock usage
between interrupt and process contexts in the userq fence driver.

The issue occurs when amdgpu_userq_fence_driver_process() is called
from both:
- Interrupt context: gfx_v11_0_eop_irq() -> amdgpu_userq_fence_driver_process()
- Process context: amdgpu_eviction_fence_suspend_worker() ->
  amdgpu_userq_fence_driver_force_completion() -> amdgpu_userq_fence_driver_process()

In interrupt context, the spinlock was acquired without disabling
interrupts, leaving it in {IN-HARDIRQ-W} state. When the same lock
is acquired in process context, the kernel detects inconsistent
locking since the process context acquisition would enable interrupts
while holding a lock previously acquired in interrupt context.

Kernel log shows:
[ 4039.310790] inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
[ 4039.310804] kworker/7:2/409 [HC0[0]:SC0[0]:HE1:SE1] takes:
[ 4039.310818] ffff9284e1bed000 (&fence_drv->fence_list_lock){?...}-{3:3},
[ 4039.310993] {IN-HARDIRQ-W} state was registered at:
[ 4039.311004]   lock_acquire+0xc6/0x300
[ 4039.311018]   _raw_spin_lock+0x39/0x80
[ 4039.311031]   amdgpu_userq_fence_driver_process.part.0+0x30/0x180 [amdgpu]
[ 4039.311146]   amdgpu_userq_fence_driver_process+0x17/0x30 [amdgpu]
[ 4039.311257]   gfx_v11_0_eop_irq+0x132/0x170 [amdgpu]

Fix by using spin_lock_irqsave()/spin_unlock_irqrestore() to properly
manage interrupt state regardless of calling context.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ded3ad780cf97a04927773c4600823b84f7f3cc2)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
@@ -143,15 +143,16 @@ void amdgpu_userq_fence_driver_process(s
 {
 	struct amdgpu_userq_fence *userq_fence, *tmp;
 	struct dma_fence *fence;
+	unsigned long flags;
 	u64 rptr;
 	int i;
 
 	if (!fence_drv)
 		return;
 
+	spin_lock_irqsave(&fence_drv->fence_list_lock, flags);
 	rptr = amdgpu_userq_fence_read(fence_drv);
 
-	spin_lock(&fence_drv->fence_list_lock);
 	list_for_each_entry_safe(userq_fence, tmp, &fence_drv->fences, link) {
 		fence = &userq_fence->base;
 
@@ -166,7 +167,7 @@ void amdgpu_userq_fence_driver_process(s
 		list_del(&userq_fence->link);
 		dma_fence_put(fence);
 	}
-	spin_unlock(&fence_drv->fence_list_lock);
+	spin_unlock_irqrestore(&fence_drv->fence_list_lock, flags);
 }
 
 void amdgpu_userq_fence_driver_destroy(struct kref *ref)


