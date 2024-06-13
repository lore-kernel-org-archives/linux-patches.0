Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD9B1448FA;
	Thu, 13 Jun 2024 11:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279880; cv=none; b=UoRUCj1ZV0ZNRdXSXDbf0GSoEkYb8vLiWb1gDI29xDV/qSgEVBxD5RUYBQ/7pgX4n9DD2wg6I9RGeMfgIaep5kc56yZZ7JVb/vw+AXsOQST+Uo1mEaYGSPlqz5mGoECw5O+gMAyCdYEKJn0qG46R06xZO16tGBBEfj9glZVdW7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279880; c=relaxed/simple;
	bh=a3bbkyBVVuO1CMvQD+dk/rKM5ZuoeiM7NEvE1ZC8WOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqxdDZ7baqWHzg5Y7Li49QSIMaBR5nxDc7rq/DU7ZZj+4qzjkJxv5EGWkRrJbAnRHpgMmPN5rwe35JIzC3SMEsWcEmUxDf0/j31TG6HVtJUXTlR9AZ6j0OEUGrCNwljN2uwCAbqGRr/NBhHGTGgLF6rd5KDX723R2HcjQq5qNFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lYmIkF9D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lYmIkF9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2611CC2BBFC;
	Thu, 13 Jun 2024 11:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279879;
	bh=a3bbkyBVVuO1CMvQD+dk/rKM5ZuoeiM7NEvE1ZC8WOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lYmIkF9DeQ7hzihLt/6yGf9vFAyDDgqy3G9sYZi+bZEqSODjMMkurt6iqw3Qd2xcO
	 w6Bjz3AaU/9xy/Z3e5T7VlajuOLW1oQ/xWxAHQSVgHnNL4KmnOYKF5JVfSGHox7Eq5
	 38My1WvNWGyL3UVoo8Ht6n10BkGM8TLv+nAGWFjc=
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
Subject: [PATCH 5.4 068/202] drm/amd/display: Fix potential index out of bounds in color transformation function
Date: Thu, 13 Jun 2024 13:32:46 +0200
Message-ID: <20240613113230.402643516@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index bbd6e01b3eca4..f1b1bc8da175b 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c
@@ -380,6 +380,11 @@ bool cm_helper_translate_curve_to_hw_format(
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



