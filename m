Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E1B32A3C3;
	Mon, 27 Oct 2025 18:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591335; cv=none; b=Y8stDLut+5vrpr82u1DNW0QZad+PfcYEmas71Wj2R+y5vOjYnaJYiXl1vxHINHR7PcFrOCSFwUdGxfqymPZxtSXUptZOqnKk+cuEKWrze/s3HKjYDZq9EMA0vz99TcZ0rANeCEka6rM2OplsnaQ+TH2Y8rYVup/TslZ8eHPVIas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591335; c=relaxed/simple;
	bh=1tp5DctZ7bfspg3chQkuclzYsrReI2bWHcLAjDVQ/Tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QXjsSLCOqMyuk64sPPoiCEt4tvVYh81ikfJjMhKnSoXUapsgj8QdTd9UDHNGFnhrWLdnyUMIKvqW1CMRySScRw27WUKywgGZ1y328q6ptA//vKDDw4Ked0Y5Qxer6Hj43wd6j8DJ7maZpfYr4kSLfHxTDTOGxS8iY7UDuw4dOQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y0qHZiYl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y0qHZiYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B253C4CEF1;
	Mon, 27 Oct 2025 18:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591335;
	bh=1tp5DctZ7bfspg3chQkuclzYsrReI2bWHcLAjDVQ/Tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y0qHZiYl8SyabLYrdNkTcnnmLBn8RWV3Z/2ggqZxMBk45E4VdMvZ1cVw2TE6CCM14
	 DGrFHtqqexWwoBLbVj3HqUgUbyevRRpk2MvgW8+EGkiwmwpq/WwwrvPlubDCWCCb5y
	 JDDT2cvodwLxUBArEysd6l5ckOIbpOiWWdlbJYSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/332] drm/amd/display: Properly clear SCL_*_FILTER_CONTROL on DCE6
Date: Mon, 27 Oct 2025 19:32:54 +0100
Message-ID: <20251027183527.807427599@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a54a309879246..a3f4fa346b77e 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_transform.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_transform.c
@@ -528,8 +528,7 @@ static void dce60_transform_set_scaler(
 		if (coeffs_v != xfm_dce->filter_v || coeffs_h != xfm_dce->filter_h) {
 			/* 4. Program vertical filters */
 			if (xfm_dce->filter_v == NULL)
-				REG_SET(SCL_VERT_FILTER_CONTROL, 0,
-						SCL_V_2TAP_HARDCODE_COEF_EN, 0);
+				REG_WRITE(SCL_VERT_FILTER_CONTROL, 0);
 			program_multi_taps_filter(
 					xfm_dce,
 					data->taps.v_taps,
@@ -543,8 +542,7 @@ static void dce60_transform_set_scaler(
 
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



