Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B929D28B516;
	Wed, 23 Apr 2025 15:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420690; cv=none; b=COpt98uOh5le7qkl2CIld6RPW9obr79kkua4neQBpC6mMv2sZGgzAwsn2cO9FpYM93DgJwyaLT66ckPkLTaaPfcmOluRIDnPWym9ItzD6ssKfHJ+fGmKLfjUR7AeeX7iThKjEkBmZKsEPNguAWw+wmrM5hVn2SpvFPyBY9fuXYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420690; c=relaxed/simple;
	bh=KW4J5p7Mff6r63sUniqCa6t0JWupE4+0Qb+8x2iaDyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CPN5DrWd+/4YsdD7p58d1x5Kdp1H3sfU6Fio3tQVXNFwqlrA+jUTdzyN9t9HuVHi3C/lAcZDx3lMUQgRjnddKmY3Zgh0DlkaqD7yBSEpVdAnJd8dVeNThOByDdt/7Ddi1xvXURR3dfJ9zXUyRJQFyIAbpNO5MRb3Xb5Sdpwzwxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrG/WAm9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrG/WAm9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E314DC4CEE2;
	Wed, 23 Apr 2025 15:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420690;
	bh=KW4J5p7Mff6r63sUniqCa6t0JWupE4+0Qb+8x2iaDyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CrG/WAm9PqgvH37Pxx4zDxSyHvDbA2g7QhfUFTXkkokl4U1otn48dsfNxfPlAQMMY
	 4/ECdhwteoXnQa9mQmA3+2bTigCSR2kc+kPJtR8rx0ZQB64Zrvn7Y+WkVdpDlWAei5
	 ECSd5GMYdTSrS0TNFl6s/bd656kb8Q0EId1vQn5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 114/241] drm/msm/dpu: Fix error pointers in dpu_plane_virtual_atomic_check
Date: Wed, 23 Apr 2025 16:42:58 +0200
Message-ID: <20250423142625.234654781@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit 5cb1b130e1cd04239cc9c26a98279f4660dce583 ]

The function dpu_plane_virtual_atomic_check was dereferencing pointers
returned by drm_atomic_get_plane_state without checking for errors. This
could lead to undefined behavior if the function returns an error pointer.

This commit adds checks using IS_ERR to ensure that plane_state is
valid before dereferencing them.

Similar to commit da29abe71e16
("drm/amd/display: Fix error pointers in amdgpu_dm_crtc_mem_type_changed").

Fixes: 774bcfb73176 ("drm/msm/dpu: add support for virtual planes")
Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/643132/
Link: https://lore.kernel.org/r/20250314011004.663804-1-chenyuan0y@gmail.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
index af3e541f60c30..b19193b02ab32 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
@@ -1059,6 +1059,9 @@ static int dpu_plane_virtual_atomic_check(struct drm_plane *plane,
 	struct drm_crtc_state *crtc_state;
 	int ret;
 
+	if (IS_ERR(plane_state))
+		return PTR_ERR(plane_state);
+
 	if (plane_state->crtc)
 		crtc_state = drm_atomic_get_new_crtc_state(state,
 							   plane_state->crtc);
-- 
2.39.5



