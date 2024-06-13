Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05124A07;
	Thu, 13 Jun 2024 12:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282077; cv=none; b=SlLG20eQBtvh9rESfqjq/Btia9BPjdkpU+0nHySCdqh/Di7pD+/zEpb6tOJ7ifp9UcKNYIoTg6Uf69Zd3vPCJqrwdVpYC27svgngJr9Fkfrf5JIzFa5YRRgDC+HL3nWeCl7ny9cvyyvCgRFb0REbIgUCZYHebvXRVBZiA9rrTjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282077; c=relaxed/simple;
	bh=82aztCju/V0q34RtN8rt4GVGsFnOpMnmxRZlAdr4Lfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVNZd0xkAnd81yGF4VwIbemrdHz4kHdft0TEG5X+MvcT+Z9DV8XOeIl1cYDGFJptvt9bB4b0OfHrUjGtLBbaBCdldctmWPZbFlzF/2MdEDE8NTI8r+U94a/GNhJetfK95rL9V8ReLHOF0PiAABP+7yVMVMfqEEJ0HO6rf5dhBA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tL/Krl7W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tL/Krl7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39DF7C2BBFC;
	Thu, 13 Jun 2024 12:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282076;
	bh=82aztCju/V0q34RtN8rt4GVGsFnOpMnmxRZlAdr4Lfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tL/Krl7WmL9La1we1ZdcOmZElITkEvfyB60L3/4tVXWdeUniXz69YRsUV6U+e3Tm8
	 a6ktTfdVlNWDMQ1VsCoyw9f8WOuFQzR77S9MrG9Ev5evz547FRm2tKtQ7Cl5RTmUQF
	 pfiuIAYhPDbW69OMVZjYi6MiB4ua+4PsKqeHDBUE=
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
Subject: [PATCH 5.15 123/402] drm/amd/display: Fix potential index out of bounds in color transformation function
Date: Thu, 13 Jun 2024 13:31:20 +0200
Message-ID: <20240613113306.938531756@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7a00fe525dfba..bd9bc51983fec 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c
@@ -379,6 +379,11 @@ bool cm_helper_translate_curve_to_hw_format(
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



