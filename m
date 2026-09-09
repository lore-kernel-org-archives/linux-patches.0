Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1664256E040;
	Wed,  9 Sep 2026 14:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962787; cv=none; b=j4wACLQzX0f7J5+A75xGr/DAYQzW6biuPEcaxjaoGjmvKZp7vJdiItILBhYXz4NlebwZGiDfYStfGbK50IbUaM5H3U2Fqi5jt1q9OV9H5JNEv5GMluhHuO0aW8VjTv4MGDap0SZ5sUheW+Y7+R0pxC3TnaLDLlOdFJWkOWuI6q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962787; c=relaxed/simple;
	bh=KuneFSCrhjXm2QLpXeI60MNo5+mUxYL9m6UgM22f0ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LbBaGRQfYTKPabCc3AEACVrRDa4o20eFV8R4ANoKV/4TqN01v7tODzEoAF6Taxc4x/1Q1gHYUGSrNJR7LaJXUivivutmgJllGbciQX85nbIgkzhpUVSpWHvthNzfjlChnO9AZ71YLG92TgNIs7Ro0lKNHX5SQF3VzRlOu1gGDzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D52LrR42; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D52LrR42"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB681F00A3A;
	Wed,  9 Sep 2026 14:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962785;
	bh=YBr0H+9J76cvxKL3FQuHPVD4YSddL0jdhgQdFuEKtDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D52LrR42Vdfpc4eipiY5ARWZAve9eBITe8m5ODSN2asW2zvENtHRH0qaQ80jAqV2f
	 awGRHQgZf6CUM4SoSC54EoRwbsO9zH/+sO/xcFNzmCZM6k9COHCAE+T+cyUNJA2r5K
	 zmypcGylTbvPQ3rRB8/dF5hXLkitNwy12IvygXgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackson Lee <jackson.lee@chipsnmedia.com>,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 411/556] media: chips-media: wave5: avoid skipping device_run while VPU has work
Date: Wed,  9 Sep 2026 15:41:31 +0200
Message-ID: <20260909134245.074027741@linuxfoundation.org>
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

commit 8c5a74a24cbbba9142e38c463c96435d316149ce upstream.

The decoder stalls because empty_queue is set to true even when the
m2m context still has pending commands. As a result, device_run is
never invoked, the m2m source queue fills up, and userspace (e.g.
Chromium) can no longer queue new bitstream buffers to the V4L2
driver.

Fix this by querying the VPU queue status via DEC_GET_QUEUE_STATUS
before deciding whether to skip device_run. Only skip when the
VPU's instance_queue_count equals the number of ready source
buffers in the v4l2-m2m context, which indicates that there is
genuinely no new work to perform. Otherwise, proceed with issuing
a decode command so that the VPU can continue draining its internal
queue.

Fixes: a176ac5e701f ("media: chips-media: wave5: Improve performance of decoder")
Cc: stable@vger.kernel.org
Signed-off-by: Jackson Lee <jackson.lee@chipsnmedia.com>
Signed-off-by: Nas Chung <nas.chung@chipsnmedia.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../media/platform/chips-media/wave5/wave5-vpu-dec.c   | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c b/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
index 01d1368b2965..6c6e86b09b40 100644
--- a/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
@@ -1663,9 +1663,13 @@ static void wave5_vpu_dec_device_run(void *priv)
 		} else if (!inst->eos &&
 				inst->queuing_num == 0 &&
 				inst->state == VPU_INST_STATE_PIC_RUN) {
-			dev_dbg(inst->dev->dev, "%s: no bitstream for feeding, so skip ", __func__);
-			inst->empty_queue = true;
-			goto finish_job_and_return;
+			wave5_vpu_dec_give_command(inst, DEC_GET_QUEUE_STATUS, &q_status);
+			if (q_status.instance_queue_count == v4l2_m2m_num_src_bufs_ready(m2m_ctx)) {
+				dev_dbg(inst->dev->dev, "%s: no bitstream, skip\n",
+					__func__);
+				inst->empty_queue = true;
+				goto finish_job_and_return;
+			}
 		}
 	}
 
-- 
2.55.0



