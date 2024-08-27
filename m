Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC6973466;
	Tue, 27 Aug 2024 15:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771535; cv=none; b=GPi6Y4B9Ng4YL4kZm2gl836dXuW/Z+HQCAgaEz+ADrh5jC0OVGMhViRNi0MnlZjC+W4V4GborYRygRKX8RW60cmFWKm7E3l16NUddyNFNb3ntnqE3YSKn4Wfbn1W4uo1Ie+DWpLTlSI3MvSwYix8+C7VvS+Vzu9dQN9kjYRO1Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771535; c=relaxed/simple;
	bh=nhNlCnqGIs9OJbymqV+dC6QMbgbtXH+cfinyMt9imNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWPcThbccdH3CMpSoYy5TiqbT4MfD8eXNDo604Kn4WALC87t/mc/i8WRyuVYtAQarDRUyC7esY6xjR5dRaMy3yEDYPsDqWjJWoM3lIWp9tRLvgz7L+iMcdM+8J04ExWn2yfKzCmrTgmIB/oPwzJ/UntsnG8lSqKLoSoqICZ2H3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c6bFQ6QG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c6bFQ6QG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2C7C4DDFA;
	Tue, 27 Aug 2024 15:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771535;
	bh=nhNlCnqGIs9OJbymqV+dC6QMbgbtXH+cfinyMt9imNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c6bFQ6QGLCiuCKHXaZziWJn4c8aP0OnQ2LqhzqZqTpMjWIT31MXBa74I+Anggf+k1
	 xhLMKaz1JxkCL35LM5U2e5HgbsK3KvAuHs3YAG/rNb8mlKQbuHmOm9ui06ALr3rrBc
	 ciBREMrWygRBC0J1WWUf2kL/u7JC9c/ZkPdGTYQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Jagmeet Randhawa <jagmeet.randhawa@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 217/273] drm/xe: Free job before xe_exec_queue_put
Date: Tue, 27 Aug 2024 16:39:01 +0200
Message-ID: <20240827143841.665948620@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit 9e7f30563677fbeff62d368d5d2a5ac7aaa9746a ]

Free job depends on job->vm being valid, the last xe_exec_queue_put can
destroy the VM. Prevent UAF by freeing job before xe_exec_queue_put.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Jagmeet Randhawa <jagmeet.randhawa@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240820202309.1260755-1-matthew.brost@intel.com
(cherry picked from commit 32a42c93b74c8ca6d0915ea3eba21bceff53042f)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_sched_job.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_sched_job.c b/drivers/gpu/drm/xe/xe_sched_job.c
index 29f3201d7dfac..2b064680abb96 100644
--- a/drivers/gpu/drm/xe/xe_sched_job.c
+++ b/drivers/gpu/drm/xe/xe_sched_job.c
@@ -171,12 +171,13 @@ void xe_sched_job_destroy(struct kref *ref)
 	struct xe_sched_job *job =
 		container_of(ref, struct xe_sched_job, refcount);
 	struct xe_device *xe = job_to_xe(job);
+	struct xe_exec_queue *q = job->q;
 
 	xe_sched_job_free_fences(job);
-	xe_exec_queue_put(job->q);
 	dma_fence_put(job->fence);
 	drm_sched_job_cleanup(&job->drm);
 	job_free(job);
+	xe_exec_queue_put(q);
 	xe_pm_runtime_put(xe);
 }
 
-- 
2.43.0



