Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B0E3B52EE;
	Thu, 30 Jul 2026 14:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422700; cv=none; b=FCW0T3c911X22kbnZmgMudcDAL68E7njmkaHnFPDdapwNYrhvMaMl5DSxyx3el/EcaIJV5+tvJNj850w9tdoiYqep9U8fJkrH5y32h5fFsp/trlXPE7VKgjgWW6I12OYr7Jqp0hPLnlaa3dRdRTBhMWZWfXbD1HG2Ij0nXrRVu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422700; c=relaxed/simple;
	bh=BZEINygPJ7cou+xpDrVMtD5Z1OMZVXiYnWUmEOZwfLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jW+fsjQGEXePMR+CKZKL0H1+nH0Zh4i/Q8/PBX7hjLOx70FP+l/YmzkSkAGsDFOM9m3Vidvu21Y3B68uKjwlzivbZP0Z+NuJPZWiyYPaLkByefqwj9RcIYw06Ki4UhMqp3/mD2yGR37DkY6OIIpJCJKf0wQsX8V7Ot+VVFqEPXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DmPEKsyV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DmPEKsyV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB3F1F000E9;
	Thu, 30 Jul 2026 14:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422698;
	bh=x+2Qf/Z5srkmyVUtGYAq5NmWuBJ3L8e+5uaBwcR7Vxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DmPEKsyVjCzjYx09b7jfnozaan9VvMJeqYgoUuBYjls828NWCcM6XFIQjdYEQMvFJ
	 fQn5eTU4dFeG8alnZ4dc1juYu6XPLowQHRdy8GRTKoy6j5dT9GiLI9XGe0CoR6L9zR
	 AGlGB0ECYcEjDOfWFQE7eM9QXwhOneucZUCfYZ04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 527/744] media: v4l2-ctrls: validate HEVC active reference counts
Date: Thu, 30 Jul 2026 16:13:20 +0200
Message-ID: <20260730141455.475289567@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -971,6 +971,7 @@ static int std_validate_compound(const s
 	struct v4l2_ctrl_hevc_ext_sps_st_rps *p_hevc_st_rps;
 	struct v4l2_ctrl_hevc_sps *p_hevc_sps;
 	struct v4l2_ctrl_hevc_pps *p_hevc_pps;
+	struct v4l2_ctrl_hevc_slice_params *p_hevc_slice_params;
 	struct v4l2_ctrl_hdr10_mastering_display *p_hdr10_mastering;
 	struct v4l2_ctrl_hevc_decode_params *p_hevc_decode_params;
 	struct v4l2_area *area;
@@ -1260,6 +1261,18 @@ static int std_validate_compound(const s
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
 
 	case V4L2_CTRL_TYPE_HEVC_EXT_SPS_ST_RPS:


