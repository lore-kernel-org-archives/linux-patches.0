Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75811C4A2E;
	Tue, 15 Oct 2024 13:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998081; cv=none; b=PtNDUy7bPpWUWIGUiUUd0+Tn+N6xizsomwpBUuRPUfuIEdimJBfVQW/6mSPIryMjTuBLwwC3J5i5xqmW39xvSzkAiSaLZpAFw8hIc3cJzag/vQrwlSv7kpK8rPJnaLODKu91lbsnRE1Bzk7e2otXDBQPV6Y2PFeMHKcmiJyMX+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998081; c=relaxed/simple;
	bh=q36eb354hyhs8dcaLnrITiXUyw1Guu3wU276YS34vso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DUkjAmy3QQs4piVn//zwckPAwEtC2JJjBXDXS/v7BNQbwOWQZqXV0rMZO4F/2Z8kmmHpStcR6Pb8kgnEZkHMf70T7I7IyhesYZiO3gMxE8fyWOVAa7FNoWtpz/TvBO7icyYZNcBdBF+rcVG5hchbvlpwKAH2RlvGNa1HptuePfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ojbtf1yo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ojbtf1yo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D438C4CEDC;
	Tue, 15 Oct 2024 13:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998081;
	bh=q36eb354hyhs8dcaLnrITiXUyw1Guu3wU276YS34vso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ojbtf1yomM0VqcOXTFyAjYBhfSCXdtDklYxHygo7tn8QbFw+nZqGCF7WaoUorxK/w
	 U92JxsKb9p9/K64pIIy7N6XNoiY30JbcBhpfjdlIFgRDq59nnjKj+qrWCCmlZ2FRwf
	 xOfe70hkBqT/JMpGd6MOfz9jdXHrLT+BUMr4bnPU=
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
Subject: [PATCH 5.10 342/518] drm/amd/display: Fix index out of bounds in DCN30 degamma hardware format translation
Date: Tue, 15 Oct 2024 14:44:06 +0200
Message-ID: <20241015123930.170413145@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e0df9b0065f9c..e0b1fc92ed186 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c
@@ -355,6 +355,8 @@ bool cm3_helper_translate_curve_to_degamma_hw_format(
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



