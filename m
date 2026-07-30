Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94144432F8;
	Thu, 30 Jul 2026 16:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427702; cv=none; b=rsOWhiW1DSql53qu4u+bxxF8STEofPBk3uGbi8+dq4DuX+3fKKRlu2Zh27s1bEeNRhT0WdjNJXIsgvjTr8WvpupY0leAeR3HDZUXDnR39ZKKPNgzTvZkK0i8WFS4qDWQqC6yepxaqGl+Uhey5wRk/0s+XpQTe++fhBk5r0P23OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427702; c=relaxed/simple;
	bh=TlXiftpG1Ni/Ur79szWaPjz2DMbpbpDapfjKgM7X8F0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXVVjSRkCqE/WY6ghxFBummIKJfif9ByCuTONyPMKh3O9+XiMMwh0MBUmtftccqZTu1qUal7BfmsB9JMdZ3WK5mTgNGXShSnTHXt0R+QTxS454ShFUQ/NQkZ0Hv5pl5toVJ0GYRL9G2KX2ogiLskX0fPYhafwpsIZ2mPZHRGpis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+edmX7U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+edmX7U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE24D1F000E9;
	Thu, 30 Jul 2026 16:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427701;
	bh=M+IzjzBzzijSbeIfqwGa1G6gGJ9unM4Qert1OmF4/ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u+edmX7UcAvtVYbLAxRc6SC8RzAhYgx8fbBlnk1yd1cf5h0upWHMrPDn3/FSiLU/v
	 xb9LWAlMXLx6qzHhntT2Y9FuG3iwc8yNCAuxv8aYCks+BrNPs6qPfhAviG8RuYTz0y
	 1ljOaEbKxdfdKYG3BRmiRjjrF0s0InKr7LEBAt3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 262/484] media: v4l2-ctrls: validate HEVC active reference counts
Date: Thu, 30 Jul 2026 16:12:39 +0200
Message-ID: <20260730141429.182925232@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -809,6 +809,7 @@ static int std_validate_compound(const s
 	struct v4l2_ctrl_h264_decode_params *p_h264_dec_params;
 	struct v4l2_ctrl_hevc_sps *p_hevc_sps;
 	struct v4l2_ctrl_hevc_pps *p_hevc_pps;
+	struct v4l2_ctrl_hevc_slice_params *p_hevc_slice_params;
 	struct v4l2_ctrl_hdr10_mastering_display *p_hdr10_mastering;
 	struct v4l2_ctrl_hevc_decode_params *p_hevc_decode_params;
 	struct v4l2_area *area;
@@ -1097,6 +1098,18 @@ static int std_validate_compound(const s
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


