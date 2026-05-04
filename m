Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8573D6489;
	Mon,  4 May 2026 13:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777902969; cv=none; b=L3YGJ8Oq7KXN/B909XElsG70Y2rSvaGlPc9fygDTiYKEVtbb5RceDZvXLg/OZSq6R2oZq+UwXl9Dgqa2B2CjONxEYiFQArjbK+XDxPffm459nDwE8G7626iy76VLDe38LkswexfHu+PTSpYAuZwJx0v5frYonunpl7D3jJ95s3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777902969; c=relaxed/simple;
	bh=WZ36wMgxrPGxDe8PZKxXSEYLDgVbd2d/aejmFlsaEa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s7VLFJN+9PHWsDd8QuPDZrnUVMQ8rc8yEXTAm8uUjolg2Afoh6r6nwWLyzeXeRfAv7ZaiRB+9v76U0MmL5AzGousVd5u2JBCCOToNkkb99NntB1tdQZkCnqCM0VReL4PUbNtvRP0TvUssTRoy4pKwwxOKXTv4RiHcl/m6Ps4xes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cztaaxeJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cztaaxeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D60CC2BCB8;
	Mon,  4 May 2026 13:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777902968;
	bh=WZ36wMgxrPGxDe8PZKxXSEYLDgVbd2d/aejmFlsaEa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cztaaxeJO9QIB79xwfgzWC1Q84yVQ3mRUDwu1VVtW7sEVNk3pIW6wWroFF9VF65Oc
	 DM8Q2KWIQ63Re/oVWPRaV3+2jzCN/1Bdhlv9DX8n+eJw3S1uyIi29YY0LdbtBuKiRC
	 Wx6UArUAZg/ILlX0+ake9Kz3rKPB7dMjjKFPq+lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.0 052/307] media: amphion: Fix race between m2m job_abort and device_run
Date: Mon,  4 May 2026 15:48:57 +0200
Message-ID: <20260504135144.784590798@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -447,17 +447,14 @@ static void vpu_m2m_device_run(void *pri
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


