Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9BD19F485;
	Tue, 27 Aug 2024 15:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772156; cv=none; b=iAP3F02WS/enbjj1EYVkOfCKqvsQvCUMMK0UA0hAnNoDoxLIoLfFHEotZlFSDkrCDqNv8Ux9JngIS6k9o0h4sRazJwrZvvTYhnpUi9v5iRCOPOHtAZ2aMjYvh7KXRoz1QL9PpRjNkdUInzSwukz/TFffh71NTgYVk4BRHo44Hwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772156; c=relaxed/simple;
	bh=gtcLf2Mxo9A5efCxh7UQmbiaYE0qZ7RMUGIaAn/Scg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJGkt68tFFsLLic7UHOsYWUp2kJ3aXEMky1ap5fSnXXzjMHAW8Ur/EC6x0EA6+afZjIvFFK//LtwLAHKDBAAt/kGFzOailErVC3MiJRUDxWy+VHykYgkj55LjezWDqZscpuQXoIograwOWggBlSBg3AqB17KaV5OQaqBqdmdKdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RcKS3Yfk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RcKS3Yfk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42495C61042;
	Tue, 27 Aug 2024 15:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772156;
	bh=gtcLf2Mxo9A5efCxh7UQmbiaYE0qZ7RMUGIaAn/Scg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RcKS3YfkReSL1EElWFA4h4rIEFMYIQvPKcDVwJ6GmO8pFZGwLpHV7H0n3CdGZzwvo
	 IOh4K8xXj7XmKw02Uv8qDoCpY0kNSbzZ6Av3BmBjBRBgTsV33pfPXgX7EmFbBF5WQG
	 UiBe5mUOtj8tgNX5v52//ICtOut+RLQEW7L5QkvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 129/321] drm/amd/display: Validate hw_points_num before using it
Date: Tue, 27 Aug 2024 16:37:17 +0200
Message-ID: <20240827143843.155182398@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



