Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F5F250BEC;
	Tue,  6 Jan 2026 17:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721009; cv=none; b=LzQxf9YM9IpqcbFgKTXbci9PIrA/B/7Qf5i3U1nKxNIJCd37Mwp5hfkOO6UZV0Pivsj2A1Nf/a3ANYWbahmSgiVIJvSLoGLyeVpH2h2SV2hPHQyTMGWV9SGYXcT6wSceGTZawu26zqUiKC0fJWn1Agh7QB0Me/dQHpG8o7MmmmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721009; c=relaxed/simple;
	bh=EJ4dAAOCZfQ32WT66H9SVujacPWzx7Pflr82yRvC1Dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UP5Ybs989sO5BpsPqnCp4Ko/g5W+wZIXZwSf1U+h8F285B61E3md/mQZhN1xgy4P/z0HxJLrvuMyIlclfGqQ5VuWOatjtcNzbZDRv6AZ4sG+XNjQxD4HB6JwsipknuRKczh12f5F80rTH0ODJp6ZtS03yHy18WZHLwjlcRdZSRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qPDVrtJh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qPDVrtJh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E199BC116C6;
	Tue,  6 Jan 2026 17:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721009;
	bh=EJ4dAAOCZfQ32WT66H9SVujacPWzx7Pflr82yRvC1Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qPDVrtJhQKAFIQfBznEfitf95gAobkeEKXra/IS12+ubnx8KyPRpPT7YoWQPa8vjh
	 sY4bBR6tGbZBTPMxUG2xuMglfG8MmHe4TEDCrf63QgXsQ28tgSdGjCXjpiY8CkyyqP
	 Yy6JlRxWCb1MVwTB/xEX96z9Sz3hXJEAeHxWvLJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 408/567] media: verisilicon: Protect G2 HEVC decoder against invalid DPB index
Date: Tue,  6 Jan 2026 18:03:10 +0100
Message-ID: <20260106170506.435357019@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Nicolas Dufresne <nicolas.dufresne@collabora.com>

commit 47825b1646a6a9eca0f90baa3d4f98947c2add96 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/verisilicon/hantro_g2_hevc_dec.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/verisilicon/hantro_g2_hevc_dec.c
+++ b/drivers/media/platform/verisilicon/hantro_g2_hevc_dec.c
@@ -283,6 +283,15 @@ static void set_params(struct hantro_ctx
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
@@ -355,8 +364,10 @@ static void set_ref_pic_list(struct hant
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
 


