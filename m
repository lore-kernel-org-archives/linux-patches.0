Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856F115CAD
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:58:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05766C433C1;
	Tue,  8 Nov 2022 13:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915932;
	bh=WL3xuACdpdD3QmaNX9D3ChNlYQZmexu52My6POZiYMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LwpLrMDuNKurPgoWRCF0h6jLEnbbxP90JpaDeMjbdIr/iEUKpFvA+2ZJ4TS+fQZoc
	 nqSXz2ToeGPJx+ZJtOKh+a8MdFhDjlceBZX91+gBQpYChZHuW2BcgYWmosykVlr+PV
	 oVkFCjg0GGn09ODDFdyi2m6Ic2qeMDFzDBgloWXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shirish S <shirish.s@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 007/144] drm/amd/display: explicitly disable psr_feature_enable appropriately
Date: Tue,  8 Nov 2022 14:38:04 +0100
Message-Id: <20221108133345.638058627@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shirish S <shirish.s@amd.com>

[ Upstream commit 6094b9136ca9038b61e9c4b5d25cd5512ce50b34 ]

[Why]
If psr_feature_enable is set to true by default, it continues to be enabled
for non capable links.

[How]
explicitly disable the feature on links that are not capable of the same.

Fixes: 8c322309e48e9 ("drm/amd/display: Enable PSR")
Signed-off-by: Shirish S <shirish.s@amd.com>
Reviewed-by: Leo Li <sunpeng.li@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.15+
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
index 7072fb2ec07f..278ff281a1bd 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
@@ -36,10 +36,14 @@ void amdgpu_dm_set_psr_caps(struct dc_link *link)
 {
 	uint8_t dpcd_data[EDP_PSR_RECEIVER_CAP_SIZE];
 
-	if (!(link->connector_signal & SIGNAL_TYPE_EDP))
+	if (!(link->connector_signal & SIGNAL_TYPE_EDP)) {
+		link->psr_settings.psr_feature_enabled = false;
 		return;
-	if (link->type == dc_connection_none)
+	}
+	if (link->type == dc_connection_none) {
+		link->psr_settings.psr_feature_enabled = false;
 		return;
+	}
 	if (dm_helpers_dp_read_dpcd(NULL, link, DP_PSR_SUPPORT,
 					dpcd_data, sizeof(dpcd_data))) {
 		link->dpcd_caps.psr_caps.psr_version = dpcd_data[0];
-- 
2.35.1



