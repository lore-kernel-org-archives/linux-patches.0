Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717BD335084;
	Fri, 17 Oct 2025 15:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715136; cv=none; b=gc/x9bIclHZDaRj4j0c5M2AbCO1vcLBuf0DbCMj2Y8JnNtI66F0HfO4WhZRypZKbmF1MINhAYuACP0h8zo2gkB9P1PR9UV/6NKL/bGNrLQ9lfzIu2u3OjzB0ONiKfeF6CHheS76yRerqHHFhim/fQh46zwmneJQt8EPljsVaAYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715136; c=relaxed/simple;
	bh=VENoWrzgPuAvb9JZhYay/gMVSZUWcWPZAgSh5VQGzds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WB/eQAl+/jyn9cuYsRdmQqjl8V43v0ZatsH141spegkm6En09UFkKA+RF5H3LlVA5fu3IrJYFQkD9fIkTFYFGVoRTPNcUtHL2gU58tUVTYmxoz0aahbhgZGGf8njJJLP50Pxtv5+oI9rMqFFcbIPpLHCI21eXeA22xa04XN6XRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L48YbKVl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L48YbKVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AACDDC113D0;
	Fri, 17 Oct 2025 15:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715136;
	bh=VENoWrzgPuAvb9JZhYay/gMVSZUWcWPZAgSh5VQGzds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L48YbKVlUPYgUhR8PoJ8MhlJ++r8xQPGs+lOT6JA9pMX9yyNKDSf6euiY6nSwuYN+
	 l025GexIgzK547a/Tveuj36GM2c57WQqXQFyiDV/lCBOJemuZFlL7GlmzVGpTjJeso
	 vDmLTgHG2gGYaNENUx3OYFadbty/L4/bTqO73LMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 110/371] drm/amd/display: Properly clear SCL_*_FILTER_CONTROL on DCE6
Date: Fri, 17 Oct 2025 16:51:25 +0200
Message-ID: <20251017145205.916472587@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 2b1673d69ea83..e5c2fb134d14d 100644
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



