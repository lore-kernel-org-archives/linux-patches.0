Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BD627781E;
	Tue, 12 Aug 2025 19:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026090; cv=none; b=BmsbC4nzETSj3CPxl7FTgE0mRDBKgCYHXKw+qd96psIs/p2FsI4ZusQTam8FvkWG1J2bIhGb6DVr921QmNNWjphpRjmMX1IiZsXrHeKwaacjpOB1nY6vZNRMqj2sCJilujg8U9J1qqN1OSasTQdqUOQj3K/x2+zkSrRWGG3KI1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026090; c=relaxed/simple;
	bh=5ciDEkzn0n4SPRdX4fUn7iE6NA3wGrPaUlXc7IUdFr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aoAjby396WH5+FuHVl7Ppnfzweq4CzDq9xYz1Vq3+bhoqaOeeHXB3m19kQsRV1wld7U3BE/cUpK2L/suIWKIGGF3sHcFcVE7MSPh6nY47eXl3VbgR64fBxwrSxO03rQ8BgfR3wRxtBNMiFxclbqyeTA1gv/CFnovpZRDTNPK3lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ikr+u/W0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ikr+u/W0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B57C4CEF0;
	Tue, 12 Aug 2025 19:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026090;
	bh=5ciDEkzn0n4SPRdX4fUn7iE6NA3wGrPaUlXc7IUdFr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ikr+u/W0cv5pJcZ4X76hvJ63W0OZvR0kfEPI1h3t8c9D0a6fiqDWKJ8+AnuY7NdHE
	 XK0RAMlo1w9KK43Aw6qhbcH12VpckAc8y9oqcWzTjAs5VoZoDU3WNrRtRNeUTumo9I
	 nWGOe5TioUMzlw3Pf/EI4hn8MQFVI8WSnnVYTew8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Cowgill <james.cowgill@blaize.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 234/480] media: v4l2-ctrls: Fix H264 SEPARATE_COLOUR_PLANE check
Date: Tue, 12 Aug 2025 19:47:22 +0200
Message-ID: <20250812174407.098179149@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



