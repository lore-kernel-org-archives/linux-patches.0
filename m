Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2667A230BDF;
	Tue, 26 Aug 2025 13:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215048; cv=none; b=NE2Hjin1RLdRxlUhRRwSwFQ2CwK7vqIEWwjvAbknfQfgbFhlqwpcauh4MlHMS3+YKa14wnpZAKxP3iEW6k0at8T6qv1IFTeTZM0xFo0yToL1r6045m+hBDENYaEXw77h/u9Mxvg5u8lVqLZW3/0jMNq0aqyH4bYQen1aqF2aY5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215048; c=relaxed/simple;
	bh=9mg6LpofAR1I6tr6Xi4V7CFfmDrwuS+OqUYIMEQ4JXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZMEO6k6AWbgZgtamCQQHeBzqC3kUxPWYwOYFqcu8Dai7b3W+gRweKRhfzDHzzcg8PkspsuSYuYtzGp/bne5trqdxPn6exSjtNwrwt1RUGHWLXBUl0IImWFb4rKPuCydsjScWQgcR8K4L2fEAsyCO4KRP9Y020juNZA+LT/Dnv1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PnNUeBBV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnNUeBBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D08C4CEF1;
	Tue, 26 Aug 2025 13:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215048;
	bh=9mg6LpofAR1I6tr6Xi4V7CFfmDrwuS+OqUYIMEQ4JXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PnNUeBBVfQaJb0VbRNEkbiIz5/g6ZgF4gVq66rBttY1XDB1JkrAVmFA9BM3YXdjuk
	 HgQxWGJRSgVH2OrYDDU58ryKEpzOqOqi9EsN2g/bvnbfKJPdQ/8+y0kB1Wdzhwb+9P
	 rJ0ktHxYkU241ZacD8NvAYomXun+RICL6RAafll8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vedang Nagar <quic_vnagar@quicinc.com>,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 368/482] media: venus: Fix OOB read due to missing payload bound check
Date: Tue, 26 Aug 2025 13:10:21 +0200
Message-ID: <20250826110939.925986866@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vedang Nagar <quic_vnagar@quicinc.com>

[ Upstream commit 06d6770ff0d8cc8dfd392329a8cc03e2a83e7289 ]

Currently, The event_seq_changed() handler processes a variable number
of properties sent by the firmware. The number of properties is indicated
by the firmware and used to iterate over the payload. However, the
payload size is not being validated against the actual message length.

This can lead to out-of-bounds memory access if the firmware provides a
property count that exceeds the data available in the payload. Such a
condition can result in kernel crashes or potential information leaks if
memory beyond the buffer is accessed.

Fix this by properly validating the remaining size of the payload before
each property access and updating bounds accordingly as properties are
parsed.

This ensures that property parsing is safely bounded within the received
message buffer and protects against malformed or malicious firmware
behavior.

Fixes: 09c2845e8fe4 ("[media] media: venus: hfi: add Host Firmware Interface (HFI)")
Cc: stable@vger.kernel.org
Signed-off-by: Vedang Nagar <quic_vnagar@quicinc.com>
Reviewed-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Co-developed-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Signed-off-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/hfi_msgs.c |   83 ++++++++++++++++++---------
 1 file changed, 58 insertions(+), 25 deletions(-)

--- a/drivers/media/platform/qcom/venus/hfi_msgs.c
+++ b/drivers/media/platform/qcom/venus/hfi_msgs.c
@@ -33,8 +33,9 @@ static void event_seq_changed(struct ven
 	struct hfi_buffer_requirements *bufreq;
 	struct hfi_extradata_input_crop *crop;
 	struct hfi_dpb_counts *dpb_count;
+	u32 ptype, rem_bytes;
+	u32 size_read = 0;
 	u8 *data_ptr;
-	u32 ptype;
 
 	inst->error = HFI_ERR_NONE;
 
@@ -44,86 +45,118 @@ static void event_seq_changed(struct ven
 		break;
 	default:
 		inst->error = HFI_ERR_SESSION_INVALID_PARAMETER;
-		goto done;
+		inst->ops->event_notify(inst, EVT_SYS_EVENT_CHANGE, &event);
+		return;
 	}
 
 	event.event_type = pkt->event_data1;
 
 	num_properties_changed = pkt->event_data2;
-	if (!num_properties_changed) {
-		inst->error = HFI_ERR_SESSION_INSUFFICIENT_RESOURCES;
-		goto done;
-	}
+	if (!num_properties_changed)
+		goto error;
 
 	data_ptr = (u8 *)&pkt->ext_event_data[0];
+	rem_bytes = pkt->shdr.hdr.size - sizeof(*pkt);
+
 	do {
+		if (rem_bytes < sizeof(u32))
+			goto error;
 		ptype = *((u32 *)data_ptr);
+
+		data_ptr += sizeof(u32);
+		rem_bytes -= sizeof(u32);
+
 		switch (ptype) {
 		case HFI_PROPERTY_PARAM_FRAME_SIZE:
-			data_ptr += sizeof(u32);
+			if (rem_bytes < sizeof(struct hfi_framesize))
+				goto error;
+
 			frame_sz = (struct hfi_framesize *)data_ptr;
 			event.width = frame_sz->width;
 			event.height = frame_sz->height;
-			data_ptr += sizeof(*frame_sz);
+			size_read = sizeof(struct hfi_framesize);
 			break;
 		case HFI_PROPERTY_PARAM_PROFILE_LEVEL_CURRENT:
-			data_ptr += sizeof(u32);
+			if (rem_bytes < sizeof(struct hfi_profile_level))
+				goto error;
+
 			profile_level = (struct hfi_profile_level *)data_ptr;
 			event.profile = profile_level->profile;
 			event.level = profile_level->level;
-			data_ptr += sizeof(*profile_level);
+			size_read = sizeof(struct hfi_profile_level);
 			break;
 		case HFI_PROPERTY_PARAM_VDEC_PIXEL_BITDEPTH:
-			data_ptr += sizeof(u32);
+			if (rem_bytes < sizeof(struct hfi_bit_depth))
+				goto error;
+
 			pixel_depth = (struct hfi_bit_depth *)data_ptr;
 			event.bit_depth = pixel_depth->bit_depth;
-			data_ptr += sizeof(*pixel_depth);
+			size_read = sizeof(struct hfi_bit_depth);
 			break;
 		case HFI_PROPERTY_PARAM_VDEC_PIC_STRUCT:
-			data_ptr += sizeof(u32);
+			if (rem_bytes < sizeof(struct hfi_pic_struct))
+				goto error;
+
 			pic_struct = (struct hfi_pic_struct *)data_ptr;
 			event.pic_struct = pic_struct->progressive_only;
-			data_ptr += sizeof(*pic_struct);
+			size_read = sizeof(struct hfi_pic_struct);
 			break;
 		case HFI_PROPERTY_PARAM_VDEC_COLOUR_SPACE:
-			data_ptr += sizeof(u32);
+			if (rem_bytes < sizeof(struct hfi_colour_space))
+				goto error;
+
 			colour_info = (struct hfi_colour_space *)data_ptr;
 			event.colour_space = colour_info->colour_space;
-			data_ptr += sizeof(*colour_info);
+			size_read = sizeof(struct hfi_colour_space);
 			break;
 		case HFI_PROPERTY_CONFIG_VDEC_ENTROPY:
-			data_ptr += sizeof(u32);
+			if (rem_bytes < sizeof(u32))
+				goto error;
+
 			event.entropy_mode = *(u32 *)data_ptr;
-			data_ptr += sizeof(u32);
+			size_read = sizeof(u32);
 			break;
 		case HFI_PROPERTY_CONFIG_BUFFER_REQUIREMENTS:
-			data_ptr += sizeof(u32);
+			if (rem_bytes < sizeof(struct hfi_buffer_requirements))
+				goto error;
+
 			bufreq = (struct hfi_buffer_requirements *)data_ptr;
 			event.buf_count = hfi_bufreq_get_count_min(bufreq, ver);
-			data_ptr += sizeof(*bufreq);
+			size_read = sizeof(struct hfi_buffer_requirements);
 			break;
 		case HFI_INDEX_EXTRADATA_INPUT_CROP:
-			data_ptr += sizeof(u32);
+			if (rem_bytes < sizeof(struct hfi_extradata_input_crop))
+				goto error;
+
 			crop = (struct hfi_extradata_input_crop *)data_ptr;
 			event.input_crop.left = crop->left;
 			event.input_crop.top = crop->top;
 			event.input_crop.width = crop->width;
 			event.input_crop.height = crop->height;
-			data_ptr += sizeof(*crop);
+			size_read = sizeof(struct hfi_extradata_input_crop);
 			break;
 		case HFI_PROPERTY_PARAM_VDEC_DPB_COUNTS:
-			data_ptr += sizeof(u32);
+			if (rem_bytes < sizeof(struct hfi_dpb_counts))
+				goto error;
+
 			dpb_count = (struct hfi_dpb_counts *)data_ptr;
 			event.buf_count = dpb_count->fw_min_cnt;
-			data_ptr += sizeof(*dpb_count);
+			size_read = sizeof(struct hfi_dpb_counts);
 			break;
 		default:
+			size_read = 0;
 			break;
 		}
+		data_ptr += size_read;
+		rem_bytes -= size_read;
 		num_properties_changed--;
 	} while (num_properties_changed > 0);
 
-done:
+	inst->ops->event_notify(inst, EVT_SYS_EVENT_CHANGE, &event);
+	return;
+
+error:
+	inst->error = HFI_ERR_SESSION_INSUFFICIENT_RESOURCES;
 	inst->ops->event_notify(inst, EVT_SYS_EVENT_CHANGE, &event);
 }
 


