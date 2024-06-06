Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB2E1AD9DA;
	Thu,  6 Jun 2024 14:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683338; cv=none; b=iaXHoqLebpjHp97lQJuqZlk1w34AZhrrgOxq0zw5/HSXCJVSD7CzDOnf5QdVgLuRTolEH8pZ3xk5YYyKXj6E4v5RtWFXeIzI1RTg3/99swl7pNFBHSnD0yQ5rcKggbjbu1ofDD4butcVrKTz9cRqD+eMvSIcBfRuRm7lEUTNO0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683338; c=relaxed/simple;
	bh=kkiSvmaM3axtIlh0aK75Zxw+ZrAo2c75SQmoS1NbyYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+DXouVuMxhUttSqgg6BzRj4tHeVR2aZS9Fit240KQ7SqiBcH4cApRvR3cYxxbR9UlrwLQn2stSaejTG3HBSwq2ai3N3bmmgf+seplqSwHYbiWTOD0nkkfKxjZf6jSFKCuBzl1XAEB85f16AU2eIn96WDPIdp2pURRjm+cwxWtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=faJsLjyd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="faJsLjyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6D9C2BD10;
	Thu,  6 Jun 2024 14:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683338;
	bh=kkiSvmaM3axtIlh0aK75Zxw+ZrAo2c75SQmoS1NbyYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=faJsLjydVg29v6BQS4upMHSxw7vdG54X8iVr/ZtOwDl4Wy7qx+Kva4+enIVhuTr96
	 FcKzPM/PKlT2fOKqR6gAejo62KJX8Tp92NpPe0fwSx42SjUwz0Yq/IzjRVj7cAFaWJ
	 JphQ4J4FcTe8qyfIsUqpGk4cy0C8c8V5f0DKaS6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Charlene Liu <Charlene.Liu@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Roman Li <roman.li@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 279/744] drm/amd/display: Fix potential index out of bounds in color transformation function
Date: Thu,  6 Jun 2024 15:59:11 +0200
Message-ID: <20240606131741.351591139@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 63ae548f1054a0b71678d0349c7dc9628ddd42ca ]

Fixes index out of bounds issue in the color transformation function.
The issue could occur when the index 'i' exceeds the number of transfer
function points (TRANSFER_FUNC_POINTS).

The fix adds a check to ensure 'i' is within bounds before accessing the
transfer function points. If 'i' is out of bounds, an error message is
logged and the function returns false to indicate an error.

Reported by smatch:
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn10/dcn10_cm_common.c:405 cm_helper_translate_curve_to_hw_format() error: buffer overflow 'output_tf->tf_pts.red' 1025 <= s32max
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn10/dcn10_cm_common.c:406 cm_helper_translate_curve_to_hw_format() error: buffer overflow 'output_tf->tf_pts.green' 1025 <= s32max
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn10/dcn10_cm_common.c:407 cm_helper_translate_curve_to_hw_format() error: buffer overflow 'output_tf->tf_pts.blue' 1025 <= s32max

Fixes: b629596072e5 ("drm/amd/display: Build unity lut for shaper")
Cc: Vitaly Prosyak <vitaly.prosyak@amd.com>
Cc: Charlene Liu <Charlene.Liu@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Roman Li <roman.li@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c
index 3538973bd0c6c..c0372aa4ec838 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c
@@ -382,6 +382,11 @@ bool cm_helper_translate_curve_to_hw_format(struct dc_context *ctx,
 				i += increment) {
 			if (j == hw_points - 1)
 				break;
+			if (i >= TRANSFER_FUNC_POINTS) {
+				DC_LOG_ERROR("Index out of bounds: i=%d, TRANSFER_FUNC_POINTS=%d\n",
+					     i, TRANSFER_FUNC_POINTS);
+				return false;
+			}
 			rgb_resulted[j].red = output_tf->tf_pts.red[i];
 			rgb_resulted[j].green = output_tf->tf_pts.green[i];
 			rgb_resulted[j].blue = output_tf->tf_pts.blue[i];
-- 
2.43.0



