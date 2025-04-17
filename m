Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A28918C034;
	Thu, 17 Apr 2025 18:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913310; cv=none; b=NCHGHmmw78/l/d9fsRA5XmlVQI1KQHxHFs0bm3BZffwovNAdDs3BgboWJaxMFqrfNkIhzqcU4UvhDUC2Q9ZvjNTCsQ6p0UE4v+i3Iw66EzqHSSFLvxZvulOIQoyWQjUTmAdN0Yl46npkJhZB5vj0VDGVd1S57q8NsttRl1OT38Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913310; c=relaxed/simple;
	bh=BxyCtRKanjlTFRukLnfko1YJNJV3mOQyCMe/Vrc/i1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C1+AG5XoMza5qYduL7eT2mfv8599jLduCr7FR/cQB4tlV0tHb2+sxEx03iGOHo3h59bOB4/UtEL+qi6Edjwi/jqXzkgsG9vP+2k+k0Kcj27U+WZOeTMuHvVQFq7rJBBu1upVmwyAvahHO/HAbgRjNhRLJGZrfN32IvR7VQlTUtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n/zbLkOE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n/zbLkOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF4EC4CEE4;
	Thu, 17 Apr 2025 18:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913310;
	bh=BxyCtRKanjlTFRukLnfko1YJNJV3mOQyCMe/Vrc/i1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n/zbLkOEVb5m5za5JR7NpqwVRBmf9quA8lFV0QDwnxIE1E8c06xHzzza5gOqPuVFN
	 asvf2GKO68Ppjb+oymMLvYDZgFXzpF0GXKB4zqYqqbSGQKN6Mfjg2OwJpvNKipLPRZ
	 L+0xPHKoZTWXBUY9gWM49kfHJzYhqQurxzxKQLx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jackson.lee" <jackson.lee@chipsnmedia.com>,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.14 266/449] media: chips-media: wave5: Fix timeout while testing 10bit hevc fluster
Date: Thu, 17 Apr 2025 19:49:14 +0200
Message-ID: <20250417175128.731380081@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1345,10 +1345,24 @@ static int wave5_vpu_dec_start_streaming
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
 	pm_runtime_mark_last_busy(inst->dev->dev);
 	pm_runtime_put_autosuspend(inst->dev->dev);


