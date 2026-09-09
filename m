Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8E8576EB1;
	Wed,  9 Sep 2026 14:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962827; cv=none; b=bwdDW+u2r9CMuRWrkTIDdgHmWsSrnt/vtZx7uZAwuAoxbITfJ/FD0tW1Fna2P9mgHTrW3wdiflTDIE4+XEUsGyjFRWp/NgHpJfRRtT9rV5Z6jYBlQX+uQiFmZKQfLHC8LoffvgI5DmOH00bRo7pWu6p+5hNrAnSVYqF753cjQfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962827; c=relaxed/simple;
	bh=FsvwhzDJ62VF/Bt8a0zPSWAplaozkU1TT4nF9X14Hoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=riuLmNPAdrw2Sla0cz0g2xRZXW56KIGYaH9TwBbnXLwvQkiigBZXsKkc/91Jc9bYuyYa8O6KeuehxQeUxuXq96h1ncrrilsZnGSPdSK426rxLz8fFTRBLLZGQVVCnz7Hd0IHq5hV4192lZdjAl9FM/d8GvQtKwIZOemT4eukvXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vEAGhN5c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vEAGhN5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52651F00A3A;
	Wed,  9 Sep 2026 14:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962826;
	bh=PArhfnCnGw7CyaWFQB7N0rK311X2WniHsCvvAtPEBN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vEAGhN5crfRKsOo5vQifOJxk/j/gP9anDYlbadZRU3GO+YgzAEmN0z3bfyrmYmMYp
	 5OvH1CfEUmIOb2VNW88nhfQsMAmDtiRCC/AgVBgBF2mhjU+QqV10DRyleCTphcwzAa
	 F9aHZ1VBWQCYObYHyi2ScDH/YNrU1Kb6XV4/XD2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 388/556] media: rkvdec: hevc: guard INTER_REF_PIC_SET_PRED index underflow
Date: Wed,  9 Sep 2026 15:41:08 +0200
Message-ID: <20260909134244.315576941@linuxfoundation.org>
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

commit 052c5ed5a1d96a6b24fd50ccda16fc6841ee7ca3 upstream.

st_ref_pic_set_prediction() computes the reference RPS index as
st_rps_idx - (delta_idx_minus1 + 1) per HEVC spec equation 7-59.
Both operands are u8, so when delta_idx_minus1 + 1 exceeds the
current index the subtraction wraps and the subsequent array access
at calculated_rps_st_sets[ref_rps_idx] reads far out of bounds.

A userspace V4L2 client that can open the RKVDEC m2m decoder can
submit an EXT_SPS_ST_RPS control with INTER_REF_PIC_SET_PRED set
and delta_idx_minus1 crafted to trigger the underflow.

Reject the entry early when the reference index would underflow.

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
 drivers/media/platform/rockchip/rkvdec/rkvdec-hevc-common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/rockchip/rkvdec/rkvdec-hevc-common.c b/drivers/media/platform/rockchip/rkvdec/rkvdec-hevc-common.c
index f89602075121..9c4a6093af32 100644
--- a/drivers/media/platform/rockchip/rkvdec/rkvdec-hevc-common.c
+++ b/drivers/media/platform/rockchip/rkvdec/rkvdec-hevc-common.c
@@ -209,6 +209,9 @@ static void st_ref_pic_set_prediction(struct rkvdec_hevc_run *run, int idx,
 	int i, j;
 	int dPoc;
 
+	if ((unsigned int)rps_data->delta_idx_minus1 + 1 > idx)
+		return;
+
 	ref_rps_idx = st_rps_idx - (rps_data->delta_idx_minus1 + 1); /* 7-59 */
 	delta_rps = (1 - 2 * rps_data->delta_rps_sign) *
 		   (rps_data->abs_delta_rps_minus1 + 1); /* 7-60 */
-- 
2.55.0



