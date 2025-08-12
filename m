Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0202FDC35;
	Tue, 12 Aug 2025 18:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022463; cv=none; b=cwrvplSkkvPgEF07AnI490zVqA5yWtbZPbibVfEWqHFOjeDE/jxSUFDf92ijWm3SVbmgWBj3FP+1ZjqhQ+xneLP7J6zYwXo9HHZN4PBcTGD6fU45SpO2oqZgKRNYBuc7fdhrOTE0q5sOQhdl2ccaJhHEgQqLupf0d3/4m3gVHY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022463; c=relaxed/simple;
	bh=hu86ZwqOG2IwpXOo8j3pIkXFZC2Z6HpDh6CrF1ccMG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hglFhCeKnNoM9dCRsTH+Y+NfN0JzmRh5v+M2v01dFFxFeTlGTIpSbYJTdFXaQk8dLF5d8pAY8u0BJ/ZkZs5J3ec7bDYNeQuItwdnqBz6Xm21JffUfzvUl2R0uVE39QSXQ2HBEI/lVLFPojDjLH60m3mGvvCQ6WwboUp30n8GtEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SLVQpXhq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SLVQpXhq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F2A1C4CEF0;
	Tue, 12 Aug 2025 18:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022463;
	bh=hu86ZwqOG2IwpXOo8j3pIkXFZC2Z6HpDh6CrF1ccMG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SLVQpXhqd0w2HHcGU9SVXmS0CL8A7oQFOveo119KM/D1oOeHAsh16VWY8kiSWfAmB
	 0Iz2p30d+N5gFZpf7Ak2jmhjY4UkYanmh7ew6pgnCL80OXLPBeBHnCAfe0Z8tgW/kA
	 5m5R5r8d69zMxNwSpwdake6nqANYYm/lpShNP6C0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Cowgill <james.cowgill@blaize.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 162/369] media: v4l2-ctrls: Fix H264 SEPARATE_COLOUR_PLANE check
Date: Tue, 12 Aug 2025 19:27:39 +0200
Message-ID: <20250812173020.862098680@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Cowgill <james.cowgill@blaize.com>

[ Upstream commit 803b9eabc649c778986449eb0596e5ffeb7a8aed ]

The `separate_colour_plane_flag` element is only present in the SPS if
`chroma_format_idc == 3`, so the corresponding flag should be disabled
whenever that is not the case and not just on profiles where
`chroma_format_idc` is not present.

Fixes: b32e48503df0 ("media: controls: Validate H264 stateless controls")
Signed-off-by: James Cowgill <james.cowgill@blaize.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-ctrls-core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls-core.c b/drivers/media/v4l2-core/v4l2-ctrls-core.c
index eeab6a5eb7ba..675642af8601 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls-core.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls-core.c
@@ -897,12 +897,12 @@ static int std_validate_compound(const struct v4l2_ctrl *ctrl, u32 idx,
 
 			p_h264_sps->flags &=
 				~V4L2_H264_SPS_FLAG_QPPRIME_Y_ZERO_TRANSFORM_BYPASS;
-
-			if (p_h264_sps->chroma_format_idc < 3)
-				p_h264_sps->flags &=
-					~V4L2_H264_SPS_FLAG_SEPARATE_COLOUR_PLANE;
 		}
 
+		if (p_h264_sps->chroma_format_idc < 3)
+			p_h264_sps->flags &=
+				~V4L2_H264_SPS_FLAG_SEPARATE_COLOUR_PLANE;
+
 		if (p_h264_sps->flags & V4L2_H264_SPS_FLAG_FRAME_MBS_ONLY)
 			p_h264_sps->flags &=
 				~V4L2_H264_SPS_FLAG_MB_ADAPTIVE_FRAME_FIELD;
-- 
2.39.5



