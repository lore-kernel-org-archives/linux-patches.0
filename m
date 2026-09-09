Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC882568FBC;
	Wed,  9 Sep 2026 14:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962747; cv=none; b=YGRxFc1WrhUodvfrpeMvVtuXHwigXAIQII8Es1KTwjETFEgdj6QyLA2N5U74cdxQ5KvRm7NozLN7U/TO6+w+GI1SmR1n/1pk3c2+NFOIxIahfMSjJnN/gSWQjw6GARghDNvg3AAnj0PQ6z4bvwywQH70h4zmhdDrPZANlB5Weig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962747; c=relaxed/simple;
	bh=pMMg+jtQt5z0yXnCq6SUjkTYMTRKfWtKoWGMXAddr3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yw1QQtR7TR6TyjMZ11HXu5a5yU8EMP0iG0xLyB3Am/OncZLxvbs0qlQg6LPS0LaChxMXKzwmrcYPVpcIMNq+iwtcVoP5hlYsn0bEZnMm7Eq2O9YzympYEWlD3RNMsHdPMaMPYKTu46yGcKUI4P8FrPzz1x6C83UmHbc2/bA8ye8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSoGjpGK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSoGjpGK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5139F1F00A3A;
	Wed,  9 Sep 2026 14:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962745;
	bh=8Syj5E7atdb22QYC9bFqXukShijcg86DaO52813YgmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MSoGjpGKb/3aZqLW71grCmMnniGmT8KkWIANpF0RC101mump+OFtYVGetYOV29tWr
	 a42XidxSYf3pOpbV+xNcH2amYGXEUCGGwHnrjrtywnOhhe6yNke1M4zBQYVlroxYky
	 rM9ofkqDP8f2PhNUdM8k6F7fafuj0AkFV47ED/oI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 398/556] media: v4l2-ctrls: validate HEVC EXT SPS RPS counts
Date: Wed,  9 Sep 2026 15:41:18 +0200
Message-ID: <20260909134244.644306393@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 796b5c6d4f1615d59d5d8fe5a38fae6bfdfe878e upstream.

The HEVC SPS control carries the short-term and long-term RPS counts
that decoder drivers use to walk the matching EXT SPS dynamic arrays.
Reject SPS values that exceed the HEVC limits of 64 short-term sets and
32 long-term references so drivers cannot later index beyond those
controls.

Also reject EXT SPS ST RPS entries whose negative or positive picture
counts exceed the 16-entry arrays, or whose combined delta-POC count
exceeds the HEVC DPB maximum.

Fixes: c9a59dc2acc7 ("media: rkvdec: Add HEVC support for the VDPU381 variant")
Cc: stable@vger.kernel.org
Suggested-by: Detlev Casanova <detlev.casanova@collabora.com>
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-ctrls-core.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/media/v4l2-core/v4l2-ctrls-core.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls-core.c
@@ -16,6 +16,9 @@
 
 static const union v4l2_ctrl_ptr ptr_null;
 
+#define V4L2_HEVC_MAX_SHORT_TERM_REF_PIC_SETS	64
+#define V4L2_HEVC_MAX_LONG_TERM_REF_PICS_SPS	32
+
 static void fill_event(struct v4l2_event *ev, struct v4l2_ctrl *ctrl,
 		       u32 changes)
 {
@@ -1214,6 +1217,10 @@ static int std_validate_compound(const s
 	case V4L2_CTRL_TYPE_HEVC_SPS:
 		p_hevc_sps = p;
 
+		if (p_hevc_sps->num_short_term_ref_pic_sets >
+		    V4L2_HEVC_MAX_SHORT_TERM_REF_PIC_SETS)
+			return -EINVAL;
+
 		if (!(p_hevc_sps->flags & V4L2_HEVC_SPS_FLAG_PCM_ENABLED)) {
 			p_hevc_sps->pcm_sample_bit_depth_luma_minus1 = 0;
 			p_hevc_sps->pcm_sample_bit_depth_chroma_minus1 = 0;
@@ -1224,6 +1231,9 @@ static int std_validate_compound(const s
 		if (!(p_hevc_sps->flags &
 		      V4L2_HEVC_SPS_FLAG_LONG_TERM_REF_PICS_PRESENT))
 			p_hevc_sps->num_long_term_ref_pics_sps = 0;
+		else if (p_hevc_sps->num_long_term_ref_pics_sps >
+			 V4L2_HEVC_MAX_LONG_TERM_REF_PICS_SPS)
+			return -EINVAL;
 		break;
 
 	case V4L2_CTRL_TYPE_HEVC_PPS:
@@ -1280,6 +1290,11 @@ static int std_validate_compound(const s
 
 		if (p_hevc_st_rps->flags & ~V4L2_HEVC_EXT_SPS_ST_RPS_FLAG_INTER_REF_PIC_SET_PRED)
 			return -EINVAL;
+		if (p_hevc_st_rps->num_negative_pics > 16 ||
+		    p_hevc_st_rps->num_positive_pics > 16 ||
+		    p_hevc_st_rps->num_negative_pics +
+		    p_hevc_st_rps->num_positive_pics > 16)
+			return -EINVAL;
 		break;
 
 	case V4L2_CTRL_TYPE_HEVC_EXT_SPS_LT_RPS:


