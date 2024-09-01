Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A0744C93;
	Sun,  1 Sep 2024 16:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209990; cv=none; b=qNaGQ4qsm2LT+a7aziFcyFr74vit3ueKqgYVXvfSek6YwfR7F1Ullsfd8RWc+kEaGxJHYaeWZm8QRNZ6MWBFdVFDIzBAHyFU7yxEOQotDL9ktQ2wArXT3clMukYnEivEci6G/YJ+072XFZSJrEdl7IAv1Lk3TszOHhFeX3pwdRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209990; c=relaxed/simple;
	bh=LFh4qChb+A+l0tHWs17OwUxrpYy14vwvTaG8eWDNFQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZmNgA19ukvnuHcxtLPT3j5/qEA9SM/l1hp+3P+dmAhr4BheNhK2Adr/n15xZzXvOq/aAm4f3vDNc87rS++rF/1DHFzjCABqZ35pOc8K1DNKvjQKSGEfUser7z23A/8YXoZBhjw1fwjtgSZt+UXWzvTaObAKWOaycTaONZNmivU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GK8XVS+q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GK8XVS+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A33AC4CEC3;
	Sun,  1 Sep 2024 16:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209990;
	bh=LFh4qChb+A+l0tHWs17OwUxrpYy14vwvTaG8eWDNFQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GK8XVS+q/6RtqujJqRBWfiyK1dAWmS9b4565Zk0wcVkRXFcN9a1XiDTPLgjhQbW2R
	 6wNjRLQhB9d6vBDdckNr1W/acisxDm9X5k48vQCDmIzmwJZR5g7WiMcfkI0D6kP7Zm
	 0YYS/fI8bmA8W9mwOEcihwHKD9F+kGoivWMOcITE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/215] drm/amd/display: Validate hw_points_num before using it
Date: Sun,  1 Sep 2024 18:16:06 +0200
Message-ID: <20240901160825.393543094@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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
index 6a3d3a0ec0a36..0f2e7fba0c938 100644
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



