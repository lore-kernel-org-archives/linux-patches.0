Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD171A2389;
	Thu, 15 Jan 2026 17:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498591; cv=none; b=m9tSZroJDep6HMibIwrmUGqIoepq3n2kBa2l6suvwuZmy4dELoc2CnJZ22kSv9xmBh6EFk1wP0EUWyWUqlqJpuwd1FT3gRLiKNKPrzytb8DvwtlJ7TZfCJSXijDMsXAZQb1iSRSSniIAtQdbk1aZkZ0pt/NcncBXi9JzweM4ywM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498591; c=relaxed/simple;
	bh=qaq3enyYAbCuNJBzVyP/hXb6U0B6MvTPzFSmvkeiUhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3Vkhv93DCZeB9KYBThPDgph+yYqcF8BPt5rMHxX/soI7MMT7/5bHSX3bkaJ9PFur6supBrigYmLlNH6MHxhxvZrPsMPnhMYbKtjJZDSVqBQRnTF+qZZwuWfolZUjuIIKmc00+riWIp31bocwitQZW28OShHhoJHamZ61VR0D1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1QseKIE6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1QseKIE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489FFC116D0;
	Thu, 15 Jan 2026 17:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498591;
	bh=qaq3enyYAbCuNJBzVyP/hXb6U0B6MvTPzFSmvkeiUhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1QseKIE6Rid1egxKfenoNETYrMsxW4KIOMCq1vb8jkJwL/Uam7WKm0zLy+kc7RT/p
	 bIyyYDdqFQ9LK4vVhG/SCD/rkXmFJA61nA9JcfZd+ZYOAmZHZJY1jtaVyJTu9Xzv+q
	 saDbdtvVfrhlIIB2UOvoNMa0HnOdc9B++TRREvBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 458/554] media: verisilicon: Protect G2 HEVC decoder against invalid DPB index
Date: Thu, 15 Jan 2026 17:48:44 +0100
Message-ID: <20260115164302.857771460@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dufresne <nicolas.dufresne@collabora.com>

[ Upstream commit 47825b1646a6a9eca0f90baa3d4f98947c2add96 ]

Fix the Hantro G2 HEVC decoder so that we use DPB index 0 whenever a
ninvalid index is received from user space. This protects the hardware
from doing faulty memory access which then leads to bus errors.

To be noted that when a reference is missing, userspace such as GStreamer
passes an invalid DPB index of 255. This issue was found by seeking to a
CRA picture using GStreamer. The framework is currently missing the code
to skip over RASL pictures placed after the CRA. This situation can also
occur while doing live streaming over lossy transport.

Fixes: cb5dd5a0fa518 ("media: hantro: Introduce G2/HEVC decoder")
Cc: stable@vger.kernel.org
Reviewed-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/hantro/hantro_g2_hevc_dec.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/staging/media/hantro/hantro_g2_hevc_dec.c
+++ b/drivers/staging/media/hantro/hantro_g2_hevc_dec.c
@@ -264,6 +264,15 @@ static void set_params(struct hantro_ctx
 	hantro_reg_write(vpu, &g2_apf_threshold, 8);
 }
 
+static u32 get_dpb_index(const struct v4l2_ctrl_hevc_decode_params *decode_params,
+			 const u32 index)
+{
+	if (index > decode_params->num_active_dpb_entries)
+		return 0;
+
+	return index;
+}
+
 static void set_ref_pic_list(struct hantro_ctx *ctx)
 {
 	const struct hantro_hevc_dec_ctrls *ctrls = &ctx->hevc_dec.ctrls;
@@ -336,8 +345,10 @@ static void set_ref_pic_list(struct hant
 		list1[j++] = list1[i++];
 
 	for (i = 0; i < V4L2_HEVC_DPB_ENTRIES_NUM_MAX; i++) {
-		hantro_reg_write(vpu, &ref_pic_regs0[i], list0[i]);
-		hantro_reg_write(vpu, &ref_pic_regs1[i], list1[i]);
+		hantro_reg_write(vpu, &ref_pic_regs0[i],
+				 get_dpb_index(decode_params, list0[i]));
+		hantro_reg_write(vpu, &ref_pic_regs1[i],
+				 get_dpb_index(decode_params, list1[i]));
 	}
 }
 


