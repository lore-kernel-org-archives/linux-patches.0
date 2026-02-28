Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7772E175A60;
	Sat, 28 Feb 2026 17:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301378; cv=none; b=X5+a2tOBI4T+e5TSQUT/SLMe9m7yqHdRXL0m+msG+IyNS0tf2nA6bZpZ6s2BWvw/tJgsOw7dRnVQmPdNLS7kOzN5nu8N+4kEttqpJuIUPeIMlhjCJXTu9qPwBAKaqFwu8mTVq/cYx/PTh1qc74Ffp1Kk9Ob35hpwE7Gqo2HwK5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301378; c=relaxed/simple;
	bh=8Jxu8nMz1pxJCiY21kKu5MFc/CGSD0cfXJcbLf+beSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYWySgKBuLqbK4ddVdPax3j3AEU/8nRlJdWQB3m0bpRtjZrrTLBbAfD4D6KdCwGZyVTdWXB8V+HlZLVYW10fK0yFHBV9bPGPc/jr/yEmt1woQON54OBPYO8ADjqKLfBbXJtUtDCTmqjjbaG3ExrUwIq5Z4RtK0ecwJ25JKW9/QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pn2bmqIq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pn2bmqIq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD28C116D0;
	Sat, 28 Feb 2026 17:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301378;
	bh=8Jxu8nMz1pxJCiY21kKu5MFc/CGSD0cfXJcbLf+beSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pn2bmqIqKbohv1D+4ee5qxX9TTZ2NXeIw6K3DYimqGfpDqK4VnSKBQSY2o/ZQsnQe
	 MInrEujX8N2u2ohrGKCNssJ1rpXAq+Dkq8zNb+Oc/wFtA0hUk+fjt0h9SK4b+i9F+l
	 IFT0lAIWQTkm+SW7lrNBImtEP3Ql9OcQKntEUiHElwJrphp0ZGedziikSva7nbMsSW
	 Y+XRGWZCB3zU2YSEg+YFKHaV4HHSOD+ee2SspXBw7plSbycqNSmHp5UqYcvJM7wjHD
	 O+YhSaaRVwT8Oc5OABLL12ioYyLN8YvVLv2PDvYembDxKoHYLzrF805GLIYlk/YKx5
	 5jwPr05Vs4PTA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Vishnu Reddy <quic_bvisredd@quicinc.com>,
	stable@vger.kernel.org,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
	Vikash Garodia <vikash.garodia@oss.qualcomm.com>,
	Bryan O'Donoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 567/752] media: iris: Fix ffmpeg corrupted frame error
Date: Sat, 28 Feb 2026 12:44:38 -0500
Message-ID: <20260228174750.1542406-567-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Vishnu Reddy <quic_bvisredd@quicinc.com>

[ Upstream commit 89f7cf35901138d9828d981ce64c131a3da6e867 ]

When the ffmpeg decoder is running, the driver receives the
V4L2_BUF_FLAG_KEYFRAME flag in the input buffer. The driver then forwards
this flag information to the firmware. The firmware, in turn, copies the
input buffer flags directly into the output buffer flags. Upon receiving
the output buffer from the firmware, the driver observes that the buffer
contains the HFI_BUFFERFLAG_DATACORRUPT flag. The root cause is that both
V4L2_BUF_FLAG_KEYFRAME and HFI_BUFFERFLAG_DATACORRUPT are the same value.
As a result, the driver incorrectly interprets the output frame as
corrupted, even though the frame is actually valid. This misinterpretation
causes the driver to report an error and skip good frames, leading to
missing frames in the final video output and triggering ffmpeg's "corrupt
decoded frame" error.

To resolve this issue, the input buffer flags should not be sent to the
firmware during decoding, since the firmware does not require this
information.

Fixes: 17f2a485ca67 ("media: iris: implement vb2 ops for buf_queue and firmware response")
Cc: stable@vger.kernel.org
Signed-off-by: Vishnu Reddy <quic_bvisredd@quicinc.com>
Reviewed-by: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Vikash Garodia <vikash.garodia@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/iris/iris_hfi_gen1_command.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/iris/iris_hfi_gen1_command.c b/drivers/media/platform/qcom/iris/iris_hfi_gen1_command.c
index e1788c266bb10..4de03f31eaf38 100644
--- a/drivers/media/platform/qcom/iris/iris_hfi_gen1_command.c
+++ b/drivers/media/platform/qcom/iris/iris_hfi_gen1_command.c
@@ -282,7 +282,7 @@ static int iris_hfi_gen1_queue_input_buffer(struct iris_inst *inst, struct iris_
 		com_ip_pkt.shdr.session_id = inst->session_id;
 		com_ip_pkt.time_stamp_hi = upper_32_bits(buf->timestamp);
 		com_ip_pkt.time_stamp_lo = lower_32_bits(buf->timestamp);
-		com_ip_pkt.flags = buf->flags;
+		com_ip_pkt.flags = 0;
 		com_ip_pkt.mark_target = 0;
 		com_ip_pkt.mark_data = 0;
 		com_ip_pkt.offset = buf->data_offset;
-- 
2.51.0

