Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971B8566C42;
	Wed,  9 Sep 2026 14:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962798; cv=none; b=RgYbr58ZzSdODARwDuaSOUhH6val/TSFddS0L5svXtRpy+VCL/5Feft6EaNP8s0PG5hMURlmQ6yp5chvXSG6F7l90qB4OigOwYgX7rgTOKoWf9fkAiDh4/yNEFut5+70foSKAfQVAWQtBI7naBIUvsQIv0RW0gFOeggIdQ4Hhxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962798; c=relaxed/simple;
	bh=Bm0zTjgnweJ4YF8OnlAgGUay2nKdORKf1d3LN3UTRzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHOPO92Dd8GTOcjoLjugctVruMh+XdhSkRlkNcQcGFXeU40nmK5AWSzwIkqyNdBYfpbNbbm/wsaMKCAEHUiNU4WGzAsXjIMDdVDPYVe/pYdxMUYQkBnpSbe+SsrCg/Fwa4DPD8sVLTtH9XdOvizm/S0htxqmgox6I+f1qD032Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9iGyZyx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9iGyZyx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E96871F00A3A;
	Wed,  9 Sep 2026 14:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962797;
	bh=/D05fIujAXxgLysipxCq3u8GBfm7fP7qj0ZfQeJU1jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X9iGyZyxCqGuN6ZKkzO0mUxm2t5StAXS9Gjew0IqdzbJ8P+DHyuTRcQaEV0fIvzEj
	 iT0RV6PAKCTK8c8sSQxBqmSMJV6/W2qTSc/ANKTPzpmWc7ECjBEq92s8tWCHdRLpvw
	 MMz0fxFW95/QlDJJUzWeopGpA03qtiTWYTp9Yi/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackson Lee <jackson.lee@chipsnmedia.com>,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 414/556] media: chips-media: wave5: Fix pipeline stall when queuing fails
Date: Wed,  9 Sep 2026 15:41:34 +0200
Message-ID: <20260909134245.171518284@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jackson Lee <jackson.lee@chipsnmedia.com>

commit e3a80073d99c376176d81013335cd355af576be2 upstream.

The Wave5 decoder calls v4l2_m2m_job_finish() immediately in device_run()
after submitting frames to firmware. When the firmware completes those
frames and the queue drains to zero, finish_decode() has no active M2M
job to finish, so v4l2_m2m_schedule_next_job() is never called and the
decoder stalls.

Call v4l2_m2m_try_schedule() in finish_decode() when the firmware queue
empties to ensure the framework always schedules the next device_run().

Fixes: a176ac5e701f ("media: chips-media: wave5: Improve performance of decoder")
Cc: stable@vger.kernel.org
Signed-off-by: Jackson Lee <jackson.lee@chipsnmedia.com>
Signed-off-by: Nas Chung <nas.chung@chipsnmedia.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c b/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
index f33c00cb801b..1817b83c5884 100644
--- a/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
@@ -475,7 +475,10 @@ static void wave5_vpu_dec_finish_decode(struct vpu_instance *inst)
 			v4l2_m2m_job_finish(inst->v4l2_m2m_dev, m2m_ctx);
 	}
 
-	inst->queuing_fail = false;
+	if (inst->queuing_fail) {
+		inst->queuing_fail = false;
+		v4l2_m2m_try_schedule(m2m_ctx);
+	}
 }
 
 static int wave5_vpu_dec_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
-- 
2.55.0



