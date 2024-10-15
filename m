Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67151C57B1;
	Tue, 15 Oct 2024 12:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993615; cv=none; b=R3n/bW+1mWW1/DnBul61iXrgCfqPoqqlh8HPQtcbnUccJngyowS990ietCmREKjos0w44aA/xQBsMItk9EjVSeqmpNpGDpr2wxce6Z8RMZwFiijl95ERWZx5jDnhdX/MUfGtLjVSklJDQJ8eL48bJ6Bk2EDh0ya+v9i2V2zF20Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993615; c=relaxed/simple;
	bh=xq7CCQaVMc7ajJOQdDtbPozq7xqIYJcPTZaGwXElXq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3jQ0cK/S0vDzVVmn8kpB2qkwNfA8iARKk9012RWo8gTIYeolDxWDizn2U6afvV2MAoWaPk+w3Go3/yNg3Tpg9DJ7QEkAkk6wHtQEDDPUQ7+o3PlPK/TJExnAupWu7MEzBmN9rny4qjZty4mveFzERKBxF2oY23legav9ZtyyBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NK2X61GE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NK2X61GE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08710C4CEC6;
	Tue, 15 Oct 2024 12:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993615;
	bh=xq7CCQaVMc7ajJOQdDtbPozq7xqIYJcPTZaGwXElXq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NK2X61GEdb9ll7ZsLmgd+ccJAZhDSobj/6gGYONtlUnWCwvieGl6UDoSyhboaxm2e
	 WFlUP1d+hj3W+CnUOKv2VjVL2dmWREFKPBVbJo76Y+a+iEgG4tsPmQHUxS8e1BxklD
	 sfd0oUv0H7/wohJBHclwxJHWm9Ro7e4aPKUQF3oE=
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
Subject: [PATCH 5.15 465/691] drm/amd/display: Fix index out of bounds in DCN30 color transformation
Date: Tue, 15 Oct 2024 13:26:53 +0200
Message-ID: <20241015112458.800894177@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

[ Upstream commit d81873f9e715b72d4f8d391c8eb243946f784dfc ]

This commit addresses a potential index out of bounds issue in the
`cm3_helper_translate_curve_to_hw_format` function in the DCN30 color
management module. The issue could occur when the index 'i' exceeds the
number of transfer function points (TRANSFER_FUNC_POINTS).

The fix adds a check to ensure 'i' is within bounds before accessing the
transfer function points. If 'i' is out of bounds, the function returns
false to indicate an error.

drivers/gpu/drm/amd/amdgpu/../display/dc/dcn30/dcn30_cm_common.c:180 cm3_helper_translate_curve_to_hw_format() error: buffer overflow 'output_tf->tf_pts.red' 1025 <= s32max
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn30/dcn30_cm_common.c:181 cm3_helper_translate_curve_to_hw_format() error: buffer overflow 'output_tf->tf_pts.green' 1025 <= s32max
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn30/dcn30_cm_common.c:182 cm3_helper_translate_curve_to_hw_format() error: buffer overflow 'output_tf->tf_pts.blue' 1025 <= s32max

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
index e0b1fc92ed186..62c02adae7e76 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c
@@ -178,6 +178,8 @@ bool cm3_helper_translate_curve_to_hw_format(
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



