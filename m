Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7089A1DE886;
	Tue,  8 Oct 2024 12:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390181; cv=none; b=pFJxLFO98Iu9HDZIF2z8y/DBhYsRSdd47FD5YbLxIjGCXP053S2hEmaLAjErwwvBuL622ptJSphNphZtfTDF0aHbR8i01Rv3sGUm59opMMXeHbVtuQE9yVD7M8cm9XOXnFl0ByPmZZc2XevX3f8IkMa4hbunWCX5pbDUl0TdKdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390181; c=relaxed/simple;
	bh=GN3aHf1CyWm0x1f6Xn281KuzwWql582bWHHZ4OcPWDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ryYHDgdYEfaFs46O29HRn18CdvuH7/eoKe/FGsL+4uQ8kfxSj/jxALUh12XojcpAB4yXPa/0HRgZz3CM7VCTxgVM+7E3sE92bPuTUCEAdaUv/N0xvxy+nybjuo58K8PMVxGAeCGZLmkQg4+eTgt5YpLmWbVJEhOXNGGK3isIuJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d3sp40QR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d3sp40QR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415FBC4CEC7;
	Tue,  8 Oct 2024 12:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390180;
	bh=GN3aHf1CyWm0x1f6Xn281KuzwWql582bWHHZ4OcPWDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d3sp40QRchQE+WOne58ZYw2HQFTdfkE9AvqZ1y/oGLo/Cx4YyJ0pd3nFFZGrcDzXe
	 haA7q2Gfnbx7pDoDu5KbMzgRQb/YeOohpusB2Hl9jjT37+hmoz2Zrg264Km1iSlFvy
	 s1FJThnWO1wKQFCg72oWeaixkOaTkZ07H6XzoGZA=
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
Subject: [PATCH 6.10 214/482] drm/amd/display: Fix index out of bounds in DCN30 degamma hardware format translation
Date: Tue,  8 Oct 2024 14:04:37 +0200
Message-ID: <20241008115656.733415424@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit bc50b614d59990747dd5aeced9ec22f9258991ff ]

This commit addresses a potential index out of bounds issue in the
`cm3_helper_translate_curve_to_degamma_hw_format` function in the DCN30
color  management module. The issue could occur when the index 'i'
exceeds the  number of transfer function points (TRANSFER_FUNC_POINTS).

The fix adds a check to ensure 'i' is within bounds before accessing the
transfer function points. If 'i' is out of bounds, the function returns
false to indicate an error.

Reported by smatch:
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn30/dcn30_cm_common.c:338 cm3_helper_translate_curve_to_degamma_hw_format() error: buffer overflow 'output_tf->tf_pts.red' 1025 <= s32max
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn30/dcn30_cm_common.c:339 cm3_helper_translate_curve_to_degamma_hw_format() error: buffer overflow 'output_tf->tf_pts.green' 1025 <= s32max
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn30/dcn30_cm_common.c:340 cm3_helper_translate_curve_to_degamma_hw_format() error: buffer overflow 'output_tf->tf_pts.blue' 1025 <= s32max

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
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c
index b8327237ed441..edc77615d0973 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c
@@ -335,6 +335,8 @@ bool cm3_helper_translate_curve_to_degamma_hw_format(
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



