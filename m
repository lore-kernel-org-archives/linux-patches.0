Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB5A1DE8BE;
	Tue,  8 Oct 2024 13:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393513; cv=none; b=txKlQdcy6nzpbTmI9CbhBhlWqHmiy5fv/FXIJ7M5NjNu9z95pA+Q/5V3MdJkHaev1fA5pYHJQf7hQz/8h5sR1ChicVDaeXhOx9UGXzL+dSLonAprr8Il+d7dbcSfnIgFhfpCqGRcWBuO/ySrBj2ebGi93jEHji9N4xuFbYLQ4es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393513; c=relaxed/simple;
	bh=CY6UiXK5M6WjO+EnDSF6KZ0InQdpydP4x4XDCvIQYn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sa2xh39MU78mHgXhJSqF5LF68+lScEa3E7g6/n5VBVJGiG6RrIDrtGpPKc2HfCjH6IVzETpE56efjdMzP2m3h5yZXKZlTEon2hbqApOIlrgshRugATQ0MJsTz7T9wwPGLgW4ir7qCLP7P+sChKL8fUSlfkgIWqP/kY7B9a2mGkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qQ/ABVwA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qQ/ABVwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E19BC4CEC7;
	Tue,  8 Oct 2024 13:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393513;
	bh=CY6UiXK5M6WjO+EnDSF6KZ0InQdpydP4x4XDCvIQYn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qQ/ABVwANsLKP9CsrbT+Q9wovQLyULq+mONrUHCFvJaX3r938p+ZwU4zx473YsYdo
	 7a4mkNzxq3463E1nA85ajhPcU3YI5OMBNlxJF0h3wpMuXYvol4Wxo5P5fage7Knx44
	 cT8NuZrmp5JhPaNIzmWW5yyYpMhud4qB4UOT/Dic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Chung <chiahsuan.chung@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 157/386] drm/amd/display: Fix index out of bounds in degamma hardware format translation
Date: Tue,  8 Oct 2024 14:06:42 +0200
Message-ID: <20241008115635.603979482@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

[ Upstream commit b7e99058eb2e86aabd7a10761e76cae33d22b49f ]

Fixes index out of bounds issue in
`cm_helper_translate_curve_to_degamma_hw_format` function. The issue
could occur when the index 'i' exceeds the number of transfer function
points (TRANSFER_FUNC_POINTS).

The fix adds a check to ensure 'i' is within bounds before accessing the
transfer function points. If 'i' is out of bounds the function returns
false to indicate an error.

Reported by smatch:
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn10/dcn10_cm_common.c:594 cm_helper_translate_curve_to_degamma_hw_format() error: buffer overflow 'output_tf->tf_pts.red' 1025 <= s32max
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn10/dcn10_cm_common.c:595 cm_helper_translate_curve_to_degamma_hw_format() error: buffer overflow 'output_tf->tf_pts.green' 1025 <= s32max
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn10/dcn10_cm_common.c:596 cm_helper_translate_curve_to_degamma_hw_format() error: buffer overflow 'output_tf->tf_pts.blue' 1025 <= s32max

Cc: Tom Chung <chiahsuan.chung@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Roman Li <roman.li@amd.com>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c
index c0372aa4ec838..684e30f9cf898 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c
@@ -571,6 +571,8 @@ bool cm_helper_translate_curve_to_degamma_hw_format(
 				i += increment) {
 			if (j == hw_points - 1)
 				break;
+			if (i >= TRANSFER_FUNC_POINTS)
+				return false;
 			rgb_resulted[j].red = output_tf->tf_pts.red[i];
 			rgb_resulted[j].green = output_tf->tf_pts.green[i];
 			rgb_resulted[j].blue = output_tf->tf_pts.blue[i];
-- 
2.43.0



