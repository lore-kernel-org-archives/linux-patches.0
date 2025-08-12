Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F552FA0DB;
	Tue, 12 Aug 2025 17:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021409; cv=none; b=TCDq6r4vOquLZxSFnSowdVQA4fwzoqTR3H2Xxs8+VyV3dZcX2o4aKIFGClSQwk+Y0s1mFmKMpY/oahBYlDFNMs6lweDEy0rzcmbJrNkKonQmJFDq+byhDcA9U3hljj4T+stcTddJo4pmfn99K1D9feCAmLP7PNI9tcyfyG2nCFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021409; c=relaxed/simple;
	bh=B1KOnSsVy812xZ0fGRwbzQ/2Aw4ndAy1RyWUD9zHZyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I8eSwZa6lqC6pCveyqjl97oh6WOksq3uZxNnjmWKooOwM1G8EJJYqJjVFcv29zcw5vFU04lzcR7dKu18LNyve4iW+Fi0gU0ciGocJg6UQFfPsyvvP5L2watoODd5RectfG62j+9Z4kOXlzxazp4apGkdhR8o4NlbnZR2KPIAuPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=diz6uiFV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="diz6uiFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06314C4CEF0;
	Tue, 12 Aug 2025 17:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021409;
	bh=B1KOnSsVy812xZ0fGRwbzQ/2Aw4ndAy1RyWUD9zHZyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=diz6uiFVtrC54dEhfJMgOg/7gJcYeKt3r2qurRjXSVAHpk3geM2L5+N80izlahm5t
	 YveSR4zk7+q1b6XML+xJ/GfoWdoztVjohmpO9+VCgsBZ8G1nCXywAnQLS+pZmLcCPg
	 22fy9vWydy/RK3H5G0lunfH8sVTLz9wEsrVW+zXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Cowgill <james.cowgill@blaize.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 113/262] media: v4l2-ctrls: Fix H264 SEPARATE_COLOUR_PLANE check
Date: Tue, 12 Aug 2025 19:28:21 +0200
Message-ID: <20250812172957.913225013@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a662fb60f73f..84fbf4e06cd3 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls-core.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls-core.c
@@ -894,12 +894,12 @@ static int std_validate_compound(const struct v4l2_ctrl *ctrl, u32 idx,
 
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



