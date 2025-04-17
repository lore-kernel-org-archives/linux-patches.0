Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B8D2638AF;
	Thu, 17 Apr 2025 18:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915761; cv=none; b=BVUBbFIkyew1t2LFAPUsjE2epK+Cxgfj3JK3114UrEIDlb4XajPQjOtEqufxnbP1a/dLhkeq3XBSGIsz4Jy9oPB1jaXalrtjN/u3vXcgFfB9j2E28RnR5QD6J6wK02It4hwVfXMWsYvh6ianE24SIdG0Rh7z0wcs/MbZf0GkOQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915761; c=relaxed/simple;
	bh=gP2kbhyeT4Q0qJPI4/4aHSjZ6WIaoF/KRkYKFvnRtEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mkE1cxL4afCNJGVoE5cDhst3/CDY7fo1T8rmwyDjt6za/P4yF/nnadXBpgUTTjjBSmYNt3HLIgtgRiV1yr+FEwH4JQClVE91dAxy1vS1EJn+dSGan3HH1qeF1r84zBybmf/6HwsjaCW4AsrGXI7ohA9opVlKJ/x7e5Z9cmgau74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ns/1P3e+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ns/1P3e+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BBFC4CEEC;
	Thu, 17 Apr 2025 18:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915761;
	bh=gP2kbhyeT4Q0qJPI4/4aHSjZ6WIaoF/KRkYKFvnRtEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ns/1P3e+K3LDncyNKodJxzuO1XXay7WPhB9dwmCEBnmueTVXvAnQZ1cs8PbdAJZ4Q
	 hrlwz6kI2qTrI8XJaLpBIs9s8vDeZwWPAgKCvaAh1+oeQawtM4Fkfa+Yu6Wb/ZXTmv
	 QxPL7kK7zD4jIQJNHx/uwWLFBLEBBajmKOeWolYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jackson.lee" <jackson.lee@chipsnmedia.com>,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 232/393] media: chips-media: wave5: Fix timeout while testing 10bit hevc fluster
Date: Thu, 17 Apr 2025 19:50:41 +0200
Message-ID: <20250417175116.920686601@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

From: Jackson.lee <jackson.lee@chipsnmedia.com>

commit 035371c9e5098018b8512efc6a8812912469480c upstream.

The Wave5 521C variant does not support 10 bit decoding. When 10 bit
decoding support was added for the 515 variant, a section of the code
was removed which returned an error. This removal causes a timeout for
the 521 variant, which was discovered during HEVC 10-bit decoding tests.

Fixes: 143e7ab4d9a0 ("media: chips-media: wave5: support decoding HEVC Main10 profile")
Cc: stable@vger.kernel.org
Signed-off-by: Jackson.lee <jackson.lee@chipsnmedia.com>
Signed-off-by: Nas Chung <nas.chung@chipsnmedia.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
@@ -1424,10 +1424,24 @@ static int wave5_vpu_dec_start_streaming
 		if (ret)
 			goto free_bitstream_vbuf;
 	} else if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		struct dec_initial_info *initial_info =
+			&inst->codec_info->dec_info.initial_info;
+
 		if (inst->state == VPU_INST_STATE_STOP)
 			ret = switch_state(inst, VPU_INST_STATE_INIT_SEQ);
 		if (ret)
 			goto return_buffers;
+
+		if (inst->state == VPU_INST_STATE_INIT_SEQ &&
+		    inst->dev->product_code == WAVE521C_CODE) {
+			if (initial_info->luma_bitdepth != 8) {
+				dev_info(inst->dev->dev, "%s: no support for %d bit depth",
+					 __func__, initial_info->luma_bitdepth);
+				ret = -EINVAL;
+				goto return_buffers;
+			}
+		}
+
 	}
 
 	return ret;


