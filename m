Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BC84F4D0B;
	Thu, 17 Sep 2026 16:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661280; cv=none; b=WjZoruYbFjydaQ2EZuczMbNabJ5N2rrZ1UNthW+Hdwz7i/0c/IdeG2yMznlJAsKATliYq8eW2Ta9scCBEuvU1+FhjsvduxYfZfnG0sVcpFfoSouDjK1CokMcN7k1yokJj2rVvR0cBATHc7wlfUMmwd+RqxcdXowwNmr8FYBT/WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661280; c=relaxed/simple;
	bh=Ndc7ZhFDTgTAj+1ukUlI/GR6Fm0W4q02eDSq5oEEWt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZK1x3NT6o4/IlVg5N661VzJ84mN//+CMQ88wCGBPY393iZ/xKRrNgWjb1Az4bHrkC4CrVKfUXdcKlUSELdL2s5pc1C4tuocEqXV7uzf++5IKE5FSkOaNgvl5iAkyCdooJv20kVxFS0uJZ7k6fuQArj57DXbdra0+hXU41zfQQFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KfjEtNzW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KfjEtNzW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDBC1F00898;
	Thu, 17 Sep 2026 16:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661279;
	bh=xDq/TpG/D7Dq9LxQusQ+mueedo8m+XB6xgN8R/aZXKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KfjEtNzWixxIBzKFYD9mye79hSrWNe0ZviSmUKDlR3Z0HwQShJGYHfrh8yI2Wp36j
	 NwqwyKNx/fM6fcOZ9zU70xLcwk9SVy+Ax4I07j0T7XbpXX4b92YgtmpvxmrIex33bP
	 WDS7V0Qi6CL1galJ1+SdcRRGJ6po3+9IbKzauutg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brajesh Gupta <brajesh.gupta@imgtec.com>,
	Matt Coster <matt.coster@imgtec.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0143/1250] drm/imagination: Dont timeout job if its fence has been signaled
Date: Thu, 17 Sep 2026 15:58:58 +0100
Message-ID: <20260917151555.931813893@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brajesh Gupta <brajesh.gupta@imgtec.com>

[ Upstream commit ee7cb742531432ec1bb29b996e3363aacd860054 ]

Verify the job’s fence in the timeout handler; if the firmware has since
signaled completion, then report NO HANG.

Signed-off-by: Brajesh Gupta <brajesh.gupta@imgtec.com>
Reviewed-by: Matt Coster <matt.coster@imgtec.com>
Link: https://patch.msgid.link/20260519-b4-context_reset-v2-2-931018a7131d@imgtec.com
Signed-off-by: Matt Coster <matt.coster@imgtec.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imagination/pvr_queue.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/imagination/pvr_queue.c b/drivers/gpu/drm/imagination/pvr_queue.c
index bb5835ede6660..7497bca2e7e83 100644
--- a/drivers/gpu/drm/imagination/pvr_queue.c
+++ b/drivers/gpu/drm/imagination/pvr_queue.c
@@ -818,7 +818,9 @@ static void pvr_queue_start(struct pvr_queue *queue)
  * the scheduler, and re-assign parent fences in the middle.
  *
  * Return:
- *  * DRM_GPU_SCHED_STAT_RESET.
+ *  *%DRM_GPU_SCHED_STAT_NO_HANG if the job fence has already been
+ *   signaled, or
+ *  *%DRM_GPU_SCHED_STAT_RESET otherwise.
  */
 static enum drm_gpu_sched_stat
 pvr_queue_timedout_job(struct drm_sched_job *s_job)
@@ -829,6 +831,9 @@ pvr_queue_timedout_job(struct drm_sched_job *s_job)
 	struct pvr_job *job;
 	u32 job_count = 0;
 
+	if (dma_fence_is_signaled(s_job->s_fence->parent))
+		return DRM_GPU_SCHED_STAT_NO_HANG;
+
 	dev_err(sched->dev, "Job timeout\n");
 
 	/* Before we stop the scheduler, make sure the queue is out of any list, so
-- 
2.53.0



