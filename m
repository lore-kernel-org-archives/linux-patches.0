Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827219;
	b=BckXyxiFdOKZ0/h0jbBtkVfQ3jobQvWognZdYhzoyXD+hvxUHgJebAYfxtRJ7RFLLAAa
	 Ip2YHO7Dc09sgg013KMdSZ+GtWSnfuJXXHt949ghgSpRLyEV0A2SxfBQ0iynXPHV+JbQ2
	 WQpmrX/qiiLyN2PJSqN4R1+BN2Eh4+rGKElqILcWER6SWSBKEkmKS+ur2ulpl6+NtlYUN
	 oprb6N8SCjdkOimqGh9ODevWI/RVAd9sXXhWpNdAiXqR8c1ovAJKX34EtDyNVqto/etKL
	 gj52N/XQYSXr+QxgNO0GINsI9HMMUn3IZEs8VyxWSVbaFV6qF4r4JEXSrgdbzp8MOUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827219;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+ZpOXSh1yJN3rCYqTwD4ku7+X2/vPAH348X3wqjzbFY=;
	b=YVDuLrDKzvYsnKWeIAE9Cr9zw89ad7zJ2ZAjRrdEuHe76BWXG5JwN1sA+DpoP7cz0coy
	 R7CjngjshKEWlIm/duIgPIle9aua6MgHhFndfPZxr7IjPOesdFQ8RilkqNLK5slSrDv+/
	 NLkzi7V6G4+3lwHFtVzx6jmB9D1BFnZUMGu1Zx8YivEhIHo3E7JTVkiNJVls/zFWJporI
	 AY7Z5cFAKNc1mWOkcBi+jcoEG2Vw9jlXKoCRZSZiwrqU5D2bn8gu4vyS8NZX3LORdpOCs
	 SDBUhhbStZuAsqjid/YXKBynG8K5puDwV7YphM2WXXp7Ce09trLzbIyHiSsN1pESyHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=smnprCfg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564DA608C9B7;
	Wed,  4 Nov 2026 21:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=smnprCfg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67041F000C1;
	Wed,  4 Nov 2026 21:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827219;
	bh=+ZpOXSh1yJN3rCYqTwD4ku7+X2/vPAH348X3wqjzbFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=smnprCfgC7v8OJO3AisGnHBmMReL0GRLQEvZvQePXjzYI5Eu/HS+2GJIXDIAq4Sqj
	 f60+vtCuET5prkLkrFtvqJ3XSnvu9B/2BLAUuhpXswvKl0ljrdr9YBOjZ+TPXUvz2O
	 0eHm3eHyTVMdLJ9b29NUll2vKeQDSdllJMLHc6Nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Ming Qian <ming.qian@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.3 227/547] media: imx-jpeg: cancel timeout worker when streaming stops
Date: Wed,  4 Nov 2026 16:06:51 -0500
Message-ID: <20261104211044.605617646@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 78fdfbf117c409273eecbfa7a528ef42358a0e38 upstream.

Each per-fd context ctx owns a delayed_work (ctx->task_timer, callback
mxc_jpeg_device_run_timeout) armed via schedule_delayed_work() at the end
of mxc_jpeg_device_run() to recover a stalled encode/decode job. The only
existing cancellation is cancel_delayed_work() in the frame-done IRQ
handler, which de-queues a pending work item but does not wait for a
callback that has already started, and it only runs when a frame completes.

When the fd is closed while a job is in flight (the frame-done IRQ has not
fired yet), nothing syncs the worker before mxc_jpeg_release() frees ctx
with kfree() after v4l2_m2m_ctx_release(). A queued or executing
mxc_jpeg_device_run_timeout() can then recover ctx through
container_of(&ctx->task_timer) and dereference it (ctx->mxc_jpeg,
slot_data, dev_warn) after ctx has been freed.

Cancel the worker from mxc_jpeg_stop_streaming(). The cancel cannot live
in mxc_jpeg_release(): mxc_jpeg_device_run() arms the timer while holding
only hw_lock, not the mxc_jpeg->lock mutex that release holds, so a cancel
in release could still race a concurrent mxc_jpeg_device_run() that
re-arms the timer afterwards. mxc_jpeg_stop_streaming() instead runs inside
v4l2_m2m_ctx_release() -> vb2_queue_release(), i.e. after
v4l2_m2m_cancel_job() has set TRANS_ABORT and waited for any in-flight job
to finish (so __v4l2_m2m_try_queue() will not queue and v4l2_m2m_try_run()
will not run any further job for this context, which prevents
mxc_jpeg_device_run() from re-arming the timer) and before the m2m context
is freed. cancel_delayed_work_sync() removes a pending work item and waits
for a running callback, so the worker can no longer race with the
subsequent kfree(). The cancel is placed before the buffer-release loop so
a concurrently running timeout callback cannot race with it over the same
buffers. If the frame-done IRQ canceled a still-pending timer, this cancel
is a no-op; if the timeout callback has already started, it waits for the
callback to finish. The same mxc_jpeg_stop_streaming() call is also
reached from VIDIOC_STREAMOFF, which drains the worker early, although
STREAMOFF itself does not free ctx -- the use-after-free arises only
when the fd is later closed.

This bug was found by static analysis.

Fixes: cfed9632ca8e ("media: imx-jpeg: Add a timeout mechanism for each frame")
Cc: stable@vger.kernel.org
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Reviewed-by: Ming Qian <ming.qian@oss.nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -1798,6 +1798,8 @@ static void mxc_jpeg_stop_streaming(stru
 
 	dev_dbg(ctx->mxc_jpeg->dev, "Stop streaming ctx=%p", ctx);
 
+	cancel_delayed_work_sync(&ctx->task_timer);
+
 	/* Release all active buffers */
 	for (;;) {
 		if (V4L2_TYPE_IS_OUTPUT(q->type))


