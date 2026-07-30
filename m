Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097A132B116;
	Thu, 30 Jul 2026 15:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423690; cv=none; b=WCEY4q6kucz2LbdsUWC+bTkcySPMoXtcQ1778QtXi5QHezFp2OzFGtZkoFV4dgWEnGIJr8mV7ubWTbe00DO1jsCItsOCMgAvPJewgC7Z8UP8cAmVXc+cpHqALvhBxCDXoilbX7ww/BA/HIVknZkEcCM8bz04GRzGTwh1J83pOZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423690; c=relaxed/simple;
	bh=a/XR/seov+aTLCDBqkGAIGrsbM8wyZ6G1B4E39bRzR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DrZaqosJV5ELAn4bTh+m+Y9HBE18t04hQGprikI50aQPcCE1CqSxcb9+ScUTp0BnOIzrSJRz+kXca3v8LFB9gLXhYW6xoons5ew4e6P7PaxcBMj1NOYl5n4F9lPFkYs9Rw/kF1dsi98wVS7URbsWQPAwMZjz9DGomqsDPvPPLYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jRuc4G4f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jRuc4G4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638911F000E9;
	Thu, 30 Jul 2026 15:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423688;
	bh=GHX/j9QTZJmuWNGleP2tJ9z2s4Rp2zt0gLjS5B2qSmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jRuc4G4fiN5fuYZbz3PKFdHHlhQL2RchG9fa0u/Q/8f03vkaOb+9SrUlwFqQvyL9e
	 9swfNwSwHN6Jtydo6dzJHhcrGaYXdhUcj83FExufz3SUEF1eDq+HeCzlzvNf200cT8
	 f8nirpTEDk+g9LZ0cZ45U2caGEfKBHS+spYMmvbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 133/675] accel/amdxdna: Fix use-after-free of mm_struct in job scheduler
Date: Thu, 30 Jul 2026 16:07:43 +0200
Message-ID: <20260730141447.969028808@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit faebb7ba1ac65fa5810b640df02ce04e509fdc11 ]

amdxdna_cmd_submit() stores current->mm in job->mm without holding any
reference. aie2_sched_job_run() later access job->mm from the DRM
scheduler worker thread. With only a raw pointer and no structural
reference, the mm_struct can be freed before the scheduler runs the job.

Fix this by calling mmgrab() to hold a structural mm_count reference for
the lifetime of the job, paired with mmdrop() in every cleanup path.

Fixes: aac243092b70 ("accel/amdxdna: Add command execution")
Reviewed-by: Max Zhen <max.zhen@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260716151305.1595780-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_ctx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/accel/amdxdna/amdxdna_ctx.c b/drivers/accel/amdxdna/amdxdna_ctx.c
index cfee89681ff3cf..347e046d2a0fba 100644
--- a/drivers/accel/amdxdna/amdxdna_ctx.c
+++ b/drivers/accel/amdxdna/amdxdna_ctx.c
@@ -393,6 +393,7 @@ void amdxdna_sched_job_cleanup(struct amdxdna_sched_job *job)
 	amdxdna_arg_bos_put(job);
 	amdxdna_gem_put_obj(job->cmd_bo);
 	dma_fence_put(job->fence);
+	mmdrop(job->mm);
 }
 
 int amdxdna_cmd_submit(struct amdxdna_client *client,
@@ -443,6 +444,7 @@ int amdxdna_cmd_submit(struct amdxdna_client *client,
 
 	job->hwctx = hwctx;
 	job->mm = current->mm;
+	mmgrab(job->mm);
 
 	job->fence = amdxdna_fence_create(hwctx);
 	if (!job->fence) {
@@ -475,6 +477,8 @@ int amdxdna_cmd_submit(struct amdxdna_client *client,
 cmd_put:
 	amdxdna_gem_put_obj(job->cmd_bo);
 free_job:
+	if (job->mm)
+		mmdrop(job->mm);
 	kfree(job);
 	return ret;
 }
-- 
2.53.0



