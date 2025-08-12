Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9C6291C1F;
	Tue, 12 Aug 2025 18:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024349; cv=none; b=Rx2A5iHvCxYTuzOdXMpsfu6sr8NEwJu+B/NuSrsnSp+9D3K/peo8eBw7INL2pNO8KPAn+/Yfx5xtupaxBOEIm/zRRQc5L8svL/3q9PHKKpb83moTLOIllWAA50ub2w7OfAfh6MK0+TUJ+FkSjsVEoLTWcJ02jiwBJaWaYfBZjoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024349; c=relaxed/simple;
	bh=4O1w3gCJvrTruUtgs28/lD/tRbmrw63TRcw7SiR68Hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ley+tSkclejPoKAub9Uh3E6tw64hGbWvvseAe22vMsolNzat4S0l2fELmX5UKd487JD3n5OjmFaWJT+DeNDyqjVmNUlJB/ufcFHT83/yPAD2Y5cbs1FwR3YPbqRpPKPgq0DwROyj8s61RRAtG1eVd8AZt2Ii0j975ODkWUk1sUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cPvDQ2bk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cPvDQ2bk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F53C4CEF0;
	Tue, 12 Aug 2025 18:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024349;
	bh=4O1w3gCJvrTruUtgs28/lD/tRbmrw63TRcw7SiR68Hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cPvDQ2bkbFQWKgGpMDAoEGAmwq0/1nJ+rVtzeDkB4jpy6W0B8VwFe0j8FlWOuYSeP
	 VdA8F9pmFqXijfl7Agg4EcjrsnKT83ajLiPJY24iw4PXBAf7JEGVVbQhSyRX36MUZO
	 4pFgzoUMR3rtFMLigEjKihoKRlp8lUbLsqJaZU8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Cowgill <james.cowgill@blaize.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 314/627] media: v4l2-ctrls: Fix H264 SEPARATE_COLOUR_PLANE check
Date: Tue, 12 Aug 2025 19:30:09 +0200
Message-ID: <20250812173431.247141637@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 90d25329661e..b45809a82f9a 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls-core.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls-core.c
@@ -968,12 +968,12 @@ static int std_validate_compound(const struct v4l2_ctrl *ctrl, u32 idx,
 
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



