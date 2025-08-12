Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2802F83CB;
	Tue, 12 Aug 2025 17:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020654; cv=none; b=Abi1p7zy1FzrlMX0GrY3PU45fXnSwIfKrbAsDvVT74CV1TcDy6Mn6ov7oSKtGuiFaOQyaNvyuH33dT6efkyHF6zL0aXuJU1PiZ630jE0Nk2Dea3szC+LKfjR/UF/tjmlP9J4tlP4VyvAZawEm9feZHQ3N69CoR+qTXWGkB+CAz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020654; c=relaxed/simple;
	bh=Mg2N8r43yHVsmkeS1ljI1+BQ1L0Fn37zCXLHwRa7UUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eq9CJ+xlG5csGLUW3P8oSb6WLSa4fArDyr3stgJAylEF/wv2h6QwhZuz+F5TWpeJkEEKSE/IcBgfYr1BvGTPpZ1o3uQoX/4QZboK7d4hlNxs67RqtwW5SBbBLpRek05W/78594aDEmpPQVj6f2+Ii9u8ng8Zg3dGBMGhUY89MNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2tSgNfwb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2tSgNfwb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD61C4CEF0;
	Tue, 12 Aug 2025 17:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020654;
	bh=Mg2N8r43yHVsmkeS1ljI1+BQ1L0Fn37zCXLHwRa7UUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2tSgNfwbYHky2dywXR5kAsgv6GRHn3eAuSIIPEQDk+UlyeydlB3O/Ruy+Z0TeXEEL
	 WPfgtTM3nAncymHlGS4LasIzNGYWUngUMNWe7wtt7xXjm0Lt78ReNSfR1lDuR2l1Nc
	 06RlJpPqrbyyCqjhov4T4FMUKBrYZNChgjJKzTcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Cowgill <james.cowgill@blaize.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 144/253] media: v4l2-ctrls: Fix H264 SEPARATE_COLOUR_PLANE check
Date: Tue, 12 Aug 2025 19:28:52 +0200
Message-ID: <20250812172954.827093811@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 29169170880a..ad5a40e4c2d5 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls-core.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls-core.c
@@ -651,12 +651,12 @@ static int std_validate_compound(const struct v4l2_ctrl *ctrl, u32 idx,
 
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



