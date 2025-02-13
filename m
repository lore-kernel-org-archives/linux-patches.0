Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58801487FA;
	Thu, 13 Feb 2025 14:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458681; cv=none; b=EleukaJrltY5NERW3DbrikpSGwitg5sNbeGDJQTr2gZPdr+Gy/cZDswVrfESs3/AGl5f0/VjsbuHJuB8Lu2PGh/zGGXCL1NmCN7oEXRMGC70xOqDL2ylFSbmEoSSBx6TKBRzlKn47jawnqVAaHwv+GC4uoxHDR+Ocg6Qhoqt1zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458681; c=relaxed/simple;
	bh=2cMVJz2JrAGEKxtq1jmbq0+Cowkjjn/H+2ieRKDuXB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q03NJsPgyBcME1axsTKcCa+yCeUH8BWEI0micx5z4fZH9zVr6X0gd9zpB1Pp3vDNdpilrRwO1ubS3ZGRCEA/eIzkX5souMOvAE1H2iQg1aj/g5jPnnZkxZlpSEAdWglj2G6RDIgxQy7mOFPmJZFWW+NnCGMmzQIJ3Q4SBTzSeyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7Nwrgso; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7Nwrgso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34D8C4CED1;
	Thu, 13 Feb 2025 14:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458681;
	bh=2cMVJz2JrAGEKxtq1jmbq0+Cowkjjn/H+2ieRKDuXB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7NwrgsoP2frvRX512dh8z+aXhsNlCVCo0+YXDo2bZ2B9I0iuSnZLTJhSs0TrVxRy
	 W4fZBpof3bbLHyCg1CX/L/iCUkB4gMjM2zxL8AWzpQ/i06odoPHgkgIc77ihflhACe
	 1o4wsuDJmTEcaIaLoK29ISMb457jgpdx8p0BVrzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	Xiangxu Yin <quic_xiangxuy@quicinc.com>
Subject: [PATCH 6.13 031/443] drm/msm/dpu: filter out too wide modes if no 3dmux is present
Date: Thu, 13 Feb 2025 15:23:16 +0100
Message-ID: <20250213142441.825944794@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhinav Kumar <quic_abhinavk@quicinc.com>

[ Upstream commit dbc7bb1a93f41c533fe31ddc97bdf777d7a61faa ]

On chipsets such as QCS615, there is no 3dmux present. In such
a case, a layer exceeding the max_mixer_width cannot be split,
hence cannot be supported.

Filter out the modes which exceed the max_mixer_width when there
is no 3dmux present. Also, add a check in the dpu_crtc_atomic_check()
to return failure for such modes.

Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Xiangxu Yin <quic_xiangxuy@quicinc.com> # QCS615
Patchwork: https://patchwork.freedesktop.org/patch/627974/
Link: https://lore.kernel.org/r/20241209-no_3dmux-v3-1-48aaa555b0d3@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
index 9f6ffd344693e..ad3462476a143 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
@@ -732,6 +732,13 @@ static int _dpu_crtc_check_and_setup_lm_bounds(struct drm_crtc *crtc,
 	struct dpu_kms *dpu_kms = _dpu_crtc_get_kms(crtc);
 	int i;
 
+	/* if we cannot merge 2 LMs (no 3d mux) better to fail earlier
+	 * before even checking the width after the split
+	 */
+	if (!dpu_kms->catalog->caps->has_3d_merge &&
+	    adj_mode->hdisplay > dpu_kms->catalog->caps->max_mixer_width)
+		return -E2BIG;
+
 	for (i = 0; i < cstate->num_mixers; i++) {
 		struct drm_rect *r = &cstate->lm_bounds[i];
 		r->x1 = crtc_split_width * i;
@@ -1251,6 +1258,12 @@ static enum drm_mode_status dpu_crtc_mode_valid(struct drm_crtc *crtc,
 {
 	struct dpu_kms *dpu_kms = _dpu_crtc_get_kms(crtc);
 
+	/* if there is no 3d_mux block we cannot merge LMs so we cannot
+	 * split the large layer into 2 LMs, filter out such modes
+	 */
+	if (!dpu_kms->catalog->caps->has_3d_merge &&
+	    mode->hdisplay > dpu_kms->catalog->caps->max_mixer_width)
+		return MODE_BAD_HVALUE;
 	/*
 	 * max crtc width is equal to the max mixer width * 2 and max height is 4K
 	 */
-- 
2.39.5



