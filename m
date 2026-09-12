Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0342E47ACD6;
	Sat, 12 Sep 2026 11:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213921; cv=none; b=lNZdIWJZmaxBwQL0gy8+S5yYxWJJe4KPTzd/UA1ZTfvTeipVSxo55koQ/PIdFN0vPInjqyIU3ZOy4XvxsLUr6pLmtRNyyZgDv5iFT7+xRdbZFnQLAiRBvwKV0Ps/LIsvlRXU3KVgHLxShV8eA2bdtAHpGubz6QQ3Ig7mVq2fW2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213921; c=relaxed/simple;
	bh=wJX9jZwqvzEzvdkbW/3teoS+SQ6Tj6GAgV1g7gowlfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdQx0QaHxlEFpgNpN7eF+Ovzfd3w+Rs3qYlmTt1sVhmgRg7Um6kmGCA8POm5tXkWL3MaI46gT2fKj9s+/yCLDUeQ1C0EPCtKuKBY50W/wvRsTZcFhtT/m/GcVXDBcNyvsXGxK/zWUJ9L3OwQ0/8b+e4z/m6Cjs2oeCsR7sMglpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rpbDNyuS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rpbDNyuS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1E31F00898;
	Sat, 12 Sep 2026 11:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213919;
	bh=+bbsrmRU19aL41zHw9YEXY84Nfe8y+z3gYHoMYUvcnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rpbDNyuSMWlftqcwAd7fYblvTgRIiGX4GEV1E9ZTkHg3aZEw6aN8kUJXltF1Ni/pR
	 CxeWSGwFl+AVB1KT8LaZZJFZycrr/fjjn/mjkr4iEiZZzNA5Bq9CYx7vXu9cQDf2Dw
	 m5hRUSlR/hdhh+R36mo7324w2iWczc96eOBqtk+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackson Lee <jackson.lee@chipsnmedia.com>,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0219/1376] media: chips-media: wave5: Guard bit depth check with initial_info_obtained
Date: Sat, 12 Sep 2026 08:44:05 +0200
Message-ID: <20260912065612.428365399@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Jackson Lee <jackson.lee@chipsnmedia.com>

commit 1551386934ad43d934c3bb7317929207e1edcd6a upstream.

When CAPTURE STREAMON is called before the VPU has completed sequence
initialization (initial_info_obtained == false), the initial_info fields
contain uninitialized data. The driver checks
luma_bitdepth and rejects anything other than 8-bit, so garbage values
(e.g. 15) cause STREAMON to fail spuriously.

This is reproducible with the following multi-threaded test scenario:
  1. Allocate 2 CAPTURE buffers.
  2. Call STREAMON on the CAPTURE queue.
  3. Call DQBUF, which blocks waiting for a decoded frame.
  4. A second thread calls STREAMOFF on the CAPTURE queue.
  5. The blocked DQBUF should be released, allowing graceful termination.

At step 2, STREAMON reads uninitialized luma_bitdepth and rejects the
stream, causing the test to fail.

Fix this by checking initial_info_obtained before accessing the bit
depth fields, so the validation is only performed when the sequence
info has actually been parsed by the VPU.

Fixes: 035371c9e509 ("media: chips-media: wave5: Fix timeout while testing 10bit hevc fluster")
Cc: stable@vger.kernel.org
Signed-off-by: Jackson Lee <jackson.lee@chipsnmedia.com>
Signed-off-by: Nas Chung <nas.chung@chipsnmedia.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
@@ -1430,6 +1430,7 @@ static int wave5_vpu_dec_start_streaming
 	} else if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
 		struct dec_initial_info *initial_info =
 			&inst->codec_info->dec_info.initial_info;
+		struct dec_info *p_dec_info = &inst->codec_info->dec_info;
 
 		if (inst->state == VPU_INST_STATE_STOP)
 			ret = switch_state(inst, VPU_INST_STATE_INIT_SEQ);
@@ -1437,6 +1438,7 @@ static int wave5_vpu_dec_start_streaming
 			goto return_buffers;
 
 		if (inst->state == VPU_INST_STATE_INIT_SEQ &&
+		    p_dec_info->initial_info_obtained &&
 		    inst->dev->product_code == WAVE521C_CODE) {
 			if (initial_info->luma_bitdepth != 8) {
 				dev_info(inst->dev->dev, "%s: no support for %d bit depth",
@@ -1445,7 +1447,6 @@ static int wave5_vpu_dec_start_streaming
 				goto return_buffers;
 			}
 		}
-
 	}
 
 	return ret;


