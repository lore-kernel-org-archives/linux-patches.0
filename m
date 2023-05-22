Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A736A171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:37:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26BEDC433D2;
	Mon, 22 May 2023 19:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784273;
	bh=FCJMa3AMPs6r+xc67aJ5KFsUBal607gCT9m48m08n9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vi0wad3G4h3azWy95N/2fCxs5+K6mMjNHJQEMZa+EdFqzYylqWdN8fUFHe8LgIBqG
	 uV/NSBYPIkdIeFTGVNBsxcH8XuVhRAuN0N4tJpCcTQ+ikqPabbOdSgJqh6kq/Xw4I0
	 +tmACovbPGq+P5RldlxPtnU1uT7fhrf29Ga4CE0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Luben Tuikov <luben.tuikov@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 027/364] drm/sched: Check scheduler work queue before calling timeout handling
Date: Mon, 22 May 2023 20:05:32 +0100
Message-Id: <20230522190413.508388237@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vitaly Prosyak <vitaly.prosyak@amd.com>

[ Upstream commit 2da5bffe9eaa5819a868e8eaaa11b3fd0f16a691 ]

During an IGT GPU reset test we see again oops despite of
commit 0c8c901aaaebc9 (drm/sched: Check scheduler ready before calling
timeout handling).

It uses ready condition whether to call drm_sched_fault which unwind
the TDR leads to GPU reset.
However it looks the ready condition is overloaded with other meanings,
for example, for the following stack is related GPU reset :

0  gfx_v9_0_cp_gfx_start
1  gfx_v9_0_cp_gfx_resume
2  gfx_v9_0_cp_resume
3  gfx_v9_0_hw_init
4  gfx_v9_0_resume
5  amdgpu_device_ip_resume_phase2

does the following:
	/* start the ring */
	gfx_v9_0_cp_gfx_start(adev);
	ring->sched.ready = true;

The same approach is for other ASICs as well :
gfx_v8_0_cp_gfx_resume
gfx_v10_0_kiq_resume, etc...

As a result, our GPU reset test causes GPU fault which calls unconditionally gfx_v9_0_fault
and then drm_sched_fault. However now it depends on whether the interrupt service routine
drm_sched_fault is executed after gfx_v9_0_cp_gfx_start is completed which sets the ready
field of the scheduler to true even  for uninitialized schedulers and causes oops vs
no fault or when ISR  drm_sched_fault is completed prior  gfx_v9_0_cp_gfx_start and
NULL pointer dereference does not occur.

Use the field timeout_wq  to prevent oops for uninitialized schedulers.
The field could be initialized by the work queue of resetting the domain.

v1: Corrections to commit message (Luben)

Fixes: 11b3b9f461c5c4 ("drm/sched: Check scheduler ready before calling timeout handling")
Signed-off-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Link: https://lore.kernel.org/r/20230510135111.58631-1-vitaly.prosyak@amd.com
Reviewed-by: Luben Tuikov <luben.tuikov@amd.com>
Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/scheduler/sched_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/scheduler/sched_main.c b/drivers/gpu/drm/scheduler/sched_main.c
index 1e08cc5a17029..78c959eaef0c5 100644
--- a/drivers/gpu/drm/scheduler/sched_main.c
+++ b/drivers/gpu/drm/scheduler/sched_main.c
@@ -308,7 +308,7 @@ static void drm_sched_start_timeout(struct drm_gpu_scheduler *sched)
  */
 void drm_sched_fault(struct drm_gpu_scheduler *sched)
 {
-	if (sched->ready)
+	if (sched->timeout_wq)
 		mod_delayed_work(sched->timeout_wq, &sched->work_tdr, 0);
 }
 EXPORT_SYMBOL(drm_sched_fault);
-- 
2.39.2



