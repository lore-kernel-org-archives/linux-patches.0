Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F30132F75D;
	Fri, 17 Oct 2025 15:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716342; cv=none; b=O0hg6fRtFO23KdpHllhfJ/0NNNgiMH2yKoplH8YTeq4yhF83XznbM3aJKQVSGXaJb11gG/t0kRjQqzCQkPbSCbQaFfWmdUojfTFdN+jyE2p+MyDaBxH9EndfwhRhgbBUr+5c+kMi1rWE5VnAl1Mi6zyf/sUuf9vb9Ljk8S6QpwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716342; c=relaxed/simple;
	bh=GRdMilTFudBmp96Wo4naiDV1yZbOu8Sk2X71OGFeQV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qPCk1odREt8tQGtjAIhmXdJC4bzKUru+1Jds1Ul52J+rKY8a7eEjIHt0P9JTKAUeMe4Z6BfXS0ubjhZoFmO0EtVswFqb9/S1QfEzUVi3ydskmuM9UpGzdPlaz00dIqhQ0ikLvZW7Db+NrXq2wnVbLV9gdKKQvaSYcHcThWKMixs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OeYtzsl8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OeYtzsl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC95FC4CEFE;
	Fri, 17 Oct 2025 15:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716342;
	bh=GRdMilTFudBmp96Wo4naiDV1yZbOu8Sk2X71OGFeQV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OeYtzsl8tQmydk2mPsAz9ZWRsGS32fVgSCrNikMZYL5eC4mOGRg+SMGhPS6hslzFN
	 gdA1f5kt60lKUklIBSvrRMZI89bA/ptyegdGqYBFS772c/Bwjt9CE10iD0qHSsGTd9
	 1PQxEcFJVFatO4GXNer4qOJHY0d8fGXbb7xaobEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 158/276] drm/amd/display: Properly clear SCL_*_FILTER_CONTROL on DCE6
Date: Fri, 17 Oct 2025 16:54:11 +0200
Message-ID: <20251017145148.244129809@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit c0aa7cf49dd6cb302fe28e7183992b772cb7420c ]

Previously, the code would set a bit field which didn't exist
on DCE6 so it would be effectively a no-op.

Fixes: b70aaf5586f2 ("drm/amd/display: dce_transform: add DCE6 specific macros,functions")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_transform.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_transform.c b/drivers/gpu/drm/amd/display/dc/dce/dce_transform.c
index 670d5ab9d9984..b761dda491d54 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_transform.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_transform.c
@@ -527,8 +527,7 @@ static void dce60_transform_set_scaler(
 		if (coeffs_v != xfm_dce->filter_v || coeffs_h != xfm_dce->filter_h) {
 			/* 4. Program vertical filters */
 			if (xfm_dce->filter_v == NULL)
-				REG_SET(SCL_VERT_FILTER_CONTROL, 0,
-						SCL_V_2TAP_HARDCODE_COEF_EN, 0);
+				REG_WRITE(SCL_VERT_FILTER_CONTROL, 0);
 			program_multi_taps_filter(
 					xfm_dce,
 					data->taps.v_taps,
@@ -542,8 +541,7 @@ static void dce60_transform_set_scaler(
 
 			/* 5. Program horizontal filters */
 			if (xfm_dce->filter_h == NULL)
-				REG_SET(SCL_HORZ_FILTER_CONTROL, 0,
-						SCL_H_2TAP_HARDCODE_COEF_EN, 0);
+				REG_WRITE(SCL_HORZ_FILTER_CONTROL, 0);
 			program_multi_taps_filter(
 					xfm_dce,
 					data->taps.h_taps,
-- 
2.51.0



