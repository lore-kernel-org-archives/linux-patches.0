Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1C372610;
	Thu,  3 Jul 2025 14:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554065; cv=none; b=POiUBhlFYhgvec80Jo9IBr5tbGsvHWsdhm+mqpSt+0u3qukAKXxKKS4Vv5kl3+X/f9vfMIgkGq2BiZH34R7a27uRy6jCbplB0psEphgxJh/EXfkbQZdirLUuYTprDB3I9pVsQSs43q74nT62m912p9tpuhOxzs/0V1GVr59pTlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554065; c=relaxed/simple;
	bh=f+OFfIoGsT+w/f00PK8+ob83ofaIkA5KfX7aB+0ZDwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ryRCkZbseRWOU1rSCWFHeNmvLwk3oE9GgRYYZpvUUwn6uj0X9iSWhGtEj2Fw3PC3wsIr+/Mf9MH2RijGBIEL/VFUXz6IANbhRJBwrWyTQZY6ppy9Nu0uT3rEId6tP95DnVgA5zqjmZ28AuwtXQc/3iWmfcxn20T5mXN74PGcbP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DhXHsP9c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DhXHsP9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A57C4CEED;
	Thu,  3 Jul 2025 14:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554064;
	bh=f+OFfIoGsT+w/f00PK8+ob83ofaIkA5KfX7aB+0ZDwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DhXHsP9cWxAcq5JtIF9z8agp7Jy759a276l+qWxDT5esStqsckper3+UTRHC0Y9hd
	 Ck481UcFYkmIfXl4/ePaPHnGvDh3P7r6qmuKGk1oUny+SgEkMhqghMSBQevcz7S7Iv
	 hJHA7MtTd726gRDaYjJfpl2sRTVInmjRuy4CdNXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Wachowski <karol.wachowski@intel.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/218] accel/ivpu: Do not fail on cmdq if failed to allocate preemption buffers
Date: Thu,  3 Jul 2025 16:40:18 +0200
Message-ID: <20250703143958.737856815@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karol Wachowski <karol.wachowski@intel.com>

[ Upstream commit 08eb99ce911d3ea202f79b42b96cd6e8498f7f69 ]

Allow to proceed with job command queue creation even if preemption
buffers failed to be allocated, print warning that preemption on such
command queue will be disabled.

Signed-off-by: Karol Wachowski <karol.wachowski@intel.com>
Reviewed-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240930195322.461209-26-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Stable-dep-of: a47e36dc5d90 ("accel/ivpu: Trigger device recovery on engine reset/resume failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_job.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/accel/ivpu/ivpu_job.c b/drivers/accel/ivpu/ivpu_job.c
index 27121c66e48f8..58d64a221a1e0 100644
--- a/drivers/accel/ivpu/ivpu_job.c
+++ b/drivers/accel/ivpu/ivpu_job.c
@@ -60,6 +60,7 @@ static int ivpu_preemption_buffers_create(struct ivpu_device *vdev,
 
 err_free_primary:
 	ivpu_bo_free(cmdq->primary_preempt_buf);
+	cmdq->primary_preempt_buf = NULL;
 	return -ENOMEM;
 }
 
@@ -69,10 +70,10 @@ static void ivpu_preemption_buffers_free(struct ivpu_device *vdev,
 	if (vdev->fw->sched_mode != VPU_SCHEDULING_MODE_HW)
 		return;
 
-	drm_WARN_ON(&vdev->drm, !cmdq->primary_preempt_buf);
-	drm_WARN_ON(&vdev->drm, !cmdq->secondary_preempt_buf);
-	ivpu_bo_free(cmdq->primary_preempt_buf);
-	ivpu_bo_free(cmdq->secondary_preempt_buf);
+	if (cmdq->primary_preempt_buf)
+		ivpu_bo_free(cmdq->primary_preempt_buf);
+	if (cmdq->secondary_preempt_buf)
+		ivpu_bo_free(cmdq->secondary_preempt_buf);
 }
 
 static struct ivpu_cmdq *ivpu_cmdq_alloc(struct ivpu_file_priv *file_priv)
@@ -98,12 +99,10 @@ static struct ivpu_cmdq *ivpu_cmdq_alloc(struct ivpu_file_priv *file_priv)
 
 	ret = ivpu_preemption_buffers_create(vdev, file_priv, cmdq);
 	if (ret)
-		goto err_free_cmdq_mem;
+		ivpu_warn(vdev, "Failed to allocate preemption buffers, preemption limited\n");
 
 	return cmdq;
 
-err_free_cmdq_mem:
-	ivpu_bo_free(cmdq->mem);
 err_erase_xa:
 	xa_erase(&vdev->db_xa, cmdq->db_id);
 err_free_cmdq:
@@ -363,10 +362,16 @@ static int ivpu_cmdq_push_job(struct ivpu_cmdq *cmdq, struct ivpu_job *job)
 
 	if (vdev->fw->sched_mode == VPU_SCHEDULING_MODE_HW &&
 	    (unlikely(!(ivpu_test_mode & IVPU_TEST_MODE_PREEMPTION_DISABLE)))) {
-		entry->primary_preempt_buf_addr = cmdq->primary_preempt_buf->vpu_addr;
-		entry->primary_preempt_buf_size = ivpu_bo_size(cmdq->primary_preempt_buf);
-		entry->secondary_preempt_buf_addr = cmdq->secondary_preempt_buf->vpu_addr;
-		entry->secondary_preempt_buf_size = ivpu_bo_size(cmdq->secondary_preempt_buf);
+		if (cmdq->primary_preempt_buf) {
+			entry->primary_preempt_buf_addr = cmdq->primary_preempt_buf->vpu_addr;
+			entry->primary_preempt_buf_size = ivpu_bo_size(cmdq->primary_preempt_buf);
+		}
+
+		if (cmdq->secondary_preempt_buf) {
+			entry->secondary_preempt_buf_addr = cmdq->secondary_preempt_buf->vpu_addr;
+			entry->secondary_preempt_buf_size =
+				ivpu_bo_size(cmdq->secondary_preempt_buf);
+		}
 	}
 
 	wmb(); /* Ensure that tail is updated after filling entry */
-- 
2.39.5



