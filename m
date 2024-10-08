Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D081DED74;
	Tue,  8 Oct 2024 12:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390184; cv=none; b=Zi0mIdw4mBsqKSduFu1HHotAE8wM7GuOggyIbGjvZa95O52MA6Fp/QOu/wJ/m/Da5BUl/Ixmcj3D8QWLNtlNLrAU1yOD00k0NpTMuXDqgloKtMdVJOv7y4EYNAn9rqAZ6P0ZJnym+rMHdPamMqvUJTxkcj2kRuHtOZNYzGpJQYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390184; c=relaxed/simple;
	bh=Hbkrznynf4M1NRChYLXQMsgssEOMedJ0SlTB67/6kQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=advma08Qcc4UpLH/+1cA8qT2UZj002b3974yK/QIWmo7VVwi1wx6bCkx4watlYtV5WlP/mXxBe6Yk3HmtZSMBKp4gki9n0V3lLhIOW03n9QXsA5t+mqVBZ2mbNfvEMcrSseNuvROquJkrII/ZtJLg45U9x9KGPaswrKAua2EBLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hSe1xlo0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hSe1xlo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28AF2C4CEC7;
	Tue,  8 Oct 2024 12:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390184;
	bh=Hbkrznynf4M1NRChYLXQMsgssEOMedJ0SlTB67/6kQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hSe1xlo0Fysefu+qamPBLtCTFeN2cqEYl+Mf4u+Ce/r0eIap7IYEXwO/DAvseQpw/
	 SRzygKSgKKqEeGdFU+IZz/bhw8XahdDGiszlgCmy9bWiW1nauNfApNvB94EZqh/l7z
	 +XDXjQhEPsUmWZZhSDir41YYvaoMDZBINdQx5xa8=
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
Subject: [PATCH 6.10 215/482] drm/amd/display: Fix index out of bounds in degamma hardware format translation
Date: Tue,  8 Oct 2024 14:04:38 +0200
Message-ID: <20241008115656.772757199@linuxfoundation.org>
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
index 0b49362f71b06..eaed5d1c398aa 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c
@@ -591,6 +591,8 @@ bool cm_helper_translate_curve_to_degamma_hw_format(
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



