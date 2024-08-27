Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B992244C8C;
	Tue, 27 Aug 2024 14:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770046; cv=none; b=u5ly4W05lVZZ9dWpkTmRcy4PWcTG17bEHhi2EcEX2jMN62zNNjCwaSucZ1PEECwOx9d1nlhrVBKEMlM5O80dUg+ZTQPobhzEnJq+mGW4/+YAQxuaRRtOuV1+SXKJtbSk2cMq93lYfvq7A2xtfvcnSPu/qtYymh1yh5FdKbSlJDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770046; c=relaxed/simple;
	bh=qPWR7XVsG/jviL4CwtM3adXQm2Qj+V1UMjIa7ntY740=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4+8Kpa5Y19EKTuS53IeqI/MwIo/P9LKgkkmD94SnX+qyrT57BDq5/sa7NO+3Yb2pwyaWqPoVetEzWvHwIOwFmuLOevB4rGgqsJO6sdeMgb62puMHb5i8Uc9tOXlqU8RsV/bBjqb9jBwBQE8wbniZeP9NhKDGQcwnTb6B6pGLY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kcHhccCJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kcHhccCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA22C61040;
	Tue, 27 Aug 2024 14:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770046;
	bh=qPWR7XVsG/jviL4CwtM3adXQm2Qj+V1UMjIa7ntY740=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kcHhccCJno6wYTjfj3qsKx0fP3dlWYx45kjlSvk2AacIbl5sI6HjMyEDvUoVGpjH+
	 HQRJSwuNNvvkBpZxciN+lte4tNuD1vZ2GRqSKl1J8CmBbavCx2MiUVjrj0BAuABxyX
	 qjTnh+SEaN+8OduLAsCjGKZFN3XwW4Bi7na8yM4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 111/341] drm/amd/display: Validate hw_points_num before using it
Date: Tue, 27 Aug 2024 16:35:42 +0200
Message-ID: <20240827143847.635844276@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 58c3b3341cea4f75dc8c003b89f8a6dd8ec55e50 ]

[WHAT]
hw_points_num is 0 before ogam LUT is programmed; however, function
"dwb3_program_ogam_pwl" assumes hw_points_num is always greater than 0,
i.e. substracting it by 1 as an array index.

[HOW]
Check hw_points_num is not equal to 0 before using it.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dwb_cm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dwb_cm.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dwb_cm.c
index 701c7d8bc038a..03a50c32fcfe1 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dwb_cm.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dwb_cm.c
@@ -243,6 +243,9 @@ static bool dwb3_program_ogam_lut(
 		return false;
 	}
 
+	if (params->hw_points_num == 0)
+		return false;
+
 	REG_SET(DWB_OGAM_CONTROL, 0, DWB_OGAM_MODE, 2);
 
 	current_mode = dwb3_get_ogam_current(dwbc30);
-- 
2.43.0



