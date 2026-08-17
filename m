Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F321EFF93;
	Mon, 17 Aug 2026 15:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979397; cv=none; b=NioEdjgMiPtwKBFh31etEB+Gf80SKdUsz31nQ+5ofJaS9SXYv4fOFqC5g8XyIgpG2S9lll4ARVDQIee15T9wcUk0SRdB2OnUj858N0qG7sFzZaWVTcWiDNoaP8FyIRsL1o5yx72BMIZRDz7bc3xbNtPV7jI8MrHul6aZHALFtGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979397; c=relaxed/simple;
	bh=/WEs7oxsRPtEHZ9SwIyH9yb+GeRtyMrXD0l4MH3PLHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EGdMDkDhTkQZNfP0elIj7fsEaVsW3j8zbep0iiWavBAU/FGJiFau1sn8xxvxmetQlR9aCkT1BPwOMMzPXhwtvxguwQ2sj/+XEgq0hEFA2ptw4V/xXF7u+xblC9rV6LylApjJ3WoAg2KmcNDkHjmlSR+dtQzEHxYRWgy7tMeutWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZZh5zpb+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZh5zpb+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43551F000E9;
	Mon, 17 Aug 2026 15:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979395;
	bh=Ao5oLxS8+5UOhwne9G64W0/lzXYzpzIOmA0RJ8v8voQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZZh5zpb+N+mvEJRD0sDKvmEnfNuAuKE9hwd791OHDts/fFqW5cAPWlA8qU/b3zc+K
	 QNYrfRI2vAqgufiCKAc2YkWWoy20B5nNZSXsW3kv3hS4cUc9J8xxkdzS9B55ftRG9X
	 ux1V+vjhjaFhdE3HrfPRvdmtq+XfLLT8vA8V2Jfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 211/609] media: v4l2-ctrls: validate HEVC active reference counts
Date: Mon, 17 Aug 2026 15:28:27 +0200
Message-ID: <20260817132551.148669743@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit afbe4bc252d90a6f8fad869b06d5430f615f22f9 upstream.

HEVC slice parameters are shared stateless V4L2 controls, but the common
validation path does not verify the active L0/L1 reference counts before
driver-specific code consumes them.

The original report came from Cedrus, but the active count bounds are
not Cedrus-specific. Validate them in the common HEVC slice control path
so stateless HEVC drivers get the same basic guarantees as soon as the
control is queued.

Do not reject ref_idx_l0/ref_idx_l1 entries here. Existing userspace may
use out-of-range sentinel values such as 0xff for missing references, and
some hardware can use that information for concealment. Keep this common
check limited to the active reference counts.

Fixes: d395a78db9eab ("media: hevc: Add decode params control")
Cc: stable@vger.kernel.org
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-ctrls-core.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/media/v4l2-core/v4l2-ctrls-core.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls-core.c
@@ -566,6 +566,7 @@ static int std_validate_compound(const s
 	struct v4l2_ctrl_h264_decode_params *p_h264_dec_params;
 	struct v4l2_ctrl_hevc_sps *p_hevc_sps;
 	struct v4l2_ctrl_hevc_pps *p_hevc_pps;
+	struct v4l2_ctrl_hevc_slice_params *p_hevc_slice_params;
 	struct v4l2_ctrl_hdr10_mastering_display *p_hdr10_mastering;
 	struct v4l2_ctrl_hevc_decode_params *p_hevc_decode_params;
 	struct v4l2_area *area;
@@ -854,6 +855,18 @@ static int std_validate_compound(const s
 		break;
 
 	case V4L2_CTRL_TYPE_HEVC_SLICE_PARAMS:
+		p_hevc_slice_params = p;
+
+		if (p_hevc_slice_params->num_ref_idx_l0_active_minus1 >=
+		    V4L2_HEVC_DPB_ENTRIES_NUM_MAX)
+			return -EINVAL;
+
+		if (p_hevc_slice_params->slice_type != V4L2_HEVC_SLICE_TYPE_B)
+			break;
+
+		if (p_hevc_slice_params->num_ref_idx_l1_active_minus1 >=
+		    V4L2_HEVC_DPB_ENTRIES_NUM_MAX)
+			return -EINVAL;
 		break;
 
 	case V4L2_CTRL_TYPE_HDR10_CLL_INFO:


