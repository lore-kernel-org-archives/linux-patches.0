Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26AC33A9DA;
	Sat, 30 May 2026 16:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159874; cv=none; b=OlgCtj0PLTNbS68o9TUWPitgUERNPKL46hQihMGZPlb5fOPIQVRYZx6ObvnwoCLlXKECHv08lyRQc10dZs1L1ri2wNFBytloDIYNXJWNuUNXuNvrQFgTNgBYyoVkjknRmtE0mXr1pQYYLYWc7I6TMjniKR1qvBYVoVFm1cyGhfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159874; c=relaxed/simple;
	bh=ecmysMnh2FD2sOzk9b8O1U2NSuxYnVDFJNkMOxwKaNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjgJ0HDeFhiF5eMszZz0h0F1iGFEs2/mDxBttwFo1RZC/bbQvGURXLeeGXsE7uxN/rtKlpl3xWslFhxKoZ0nFnbraAl6UUn0lciBOTwky7UQq5lUkZz+fM0xFXfplrjL+YBQpX4Gj4RztKVOU7HqaKX62suTCxTCy7sS7zyRYWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sPjV7uxM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sPjV7uxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225711F00898;
	Sat, 30 May 2026 16:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159873;
	bh=C5kprFLeZ1Dbpe7MJHsqlj/A3tpHkpmWNr2YQDfMNww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sPjV7uxMrJyUg/DOPoyQWs0eaVDdG12AsGUYRC4607yahdMdeznW9wPRAyJB2lQbe
	 RJ2fOIh5/RGTIq/aacg2kXsUDHqIopb0o6Xhcj8fbcY/ha9NSUbFVwCmMXvWHNdCUh
	 jY66Q9OrG5YH+WMg2hXIA9i7IQGK6iXafWALosK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 184/969] media: amphion: Fix race between m2m job_abort and device_run
Date: Sat, 30 May 2026 17:55:08 +0200
Message-ID: <20260530160305.569928500@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -356,17 +356,14 @@ static void vpu_m2m_device_run(void *pri
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


