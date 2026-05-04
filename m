Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1962315785;
	Mon,  4 May 2026 14:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904440; cv=none; b=mw8fMaMiCwDyy8dB5Kq7C/RNCb4C3L1hbLHyexgB/I68VnwPw0JEhCJK98rRTOMQXT8EZXnTwdZ558q6npIezTh3VQfJg6pWPIdvBEZJn2i+FsDiEZ9x/qTN+fQfCaWOUWH8ayKVGfNz4sayp8YDwrV5Q6T4Ak0RR/5FSnNdTm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904440; c=relaxed/simple;
	bh=jk2kKMc0GpZJpdQejgURcxm5PWTCQp7z4wUBDz+NxJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7A/viqdPLPVvzn+ZGiWAU9stbqZKo95Wopy9pagKTO+McpVN77/RnWcY6aS53YgdGT8dqL7ktZbIH77/KofzD0hhD7pqoaVV2o3pBB/dh08KWKwuLrzx0PuOkUl32u2eApc7lC2rOOc6Vv1Fw8/Mj1/ZI+0UYK7JYvkODCCCmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WFTwDrdW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WFTwDrdW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8788FC2BCC4;
	Mon,  4 May 2026 14:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904439;
	bh=jk2kKMc0GpZJpdQejgURcxm5PWTCQp7z4wUBDz+NxJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WFTwDrdWZ6Tn7FnEuz4cSnD5KuaYVI1LksS0b5gjdFfbeMtSDwD52qvgXWoHE36GJ
	 6ad49nPSCwCKvxYISs0LZ7ICEKbWRnrWui80/c+Kuve/unN+9dN6Xz05CtoHkE6K9B
	 a9aR33XVBlmeyvyXENYlmmMIlq6V3kAR34EgP4Nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 040/215] media: amphion: Fix race between m2m job_abort and device_run
Date: Mon,  4 May 2026 15:50:59 +0200
Message-ID: <20260504135131.646946433@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Qian <ming.qian@oss.nxp.com>

commit 8cd35ceadcfc8c5da2eb7f7ce24525ce9d4ee62e upstream.

Fix kernel panic caused by race condition where v4l2_m2m_ctx_release()
frees m2m_ctx while v4l2_m2m_try_run() is about to call device_run
with the same context.

Race sequence:
  v4l2_m2m_try_run():           v4l2_m2m_ctx_release():
    lock/unlock                   v4l2_m2m_cancel_job()
                                    job_abort()
                                      v4l2_m2m_job_finish()
                                  kfree(m2m_ctx)  <- frees ctx
    device_run()  <- use-after-free crash at 0x538

Crash trace:
  Unable to handle kernel read from unreadable memory at virtual address
  0000000000000538
  v4l2_m2m_try_run+0x78/0x138
  v4l2_m2m_device_run_work+0x14/0x20

The amphion vpu driver does not rely on the m2m framework's device_run
callback to perform encode/decode operations.

Fix the race by preventing m2m framework job scheduling entirely:
- Add job_ready callback returning 0 (no jobs ready for m2m framework)
- Remove job_abort callback to avoid the race condition

Fixes: 3cd084519c6f ("media: amphion: add vpu v4l2 m2m support")
Cc: stable@vger.kernel.org
Signed-off-by: Ming Qian <ming.qian@oss.nxp.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/amphion/vpu_v4l2.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/media/platform/amphion/vpu_v4l2.c
+++ b/drivers/media/platform/amphion/vpu_v4l2.c
@@ -448,17 +448,14 @@ static void vpu_m2m_device_run(void *pri
 {
 }
 
-static void vpu_m2m_job_abort(void *priv)
+static int vpu_m2m_job_ready(void *priv)
 {
-	struct vpu_inst *inst = priv;
-	struct v4l2_m2m_ctx *m2m_ctx = inst->fh.m2m_ctx;
-
-	v4l2_m2m_job_finish(m2m_ctx->m2m_dev, m2m_ctx);
+	return 0;
 }
 
 static const struct v4l2_m2m_ops vpu_m2m_ops = {
 	.device_run = vpu_m2m_device_run,
-	.job_abort = vpu_m2m_job_abort
+	.job_ready = vpu_m2m_job_ready,
 };
 
 static int vpu_vb2_queue_setup(struct vb2_queue *vq,


