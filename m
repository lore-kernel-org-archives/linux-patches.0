Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAD563B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2097C433D2;
	Mon, 20 Feb 2023 13:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901069;
	bh=DKpBkqc//T4XWv4uVVRlyIOwxgWQf2JMLxMRR2dnKCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mZQcCxvam0fK98mRoWDfxuxRh3HE5sXnMZECcFQNHbHP/ohCjWuvlsKm5xjnS4FAo
	 2p4Rqiyw4iJX8VwOE3O98dGludDQjYyYJa3YaJnxF2140PQLgZysLpcCWx9pRuF1J2
	 eyBXdfWNqMokb7OGT2MLdNBApoYg4saP+wmNQOEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 18/83] drm/amd/display: Properly handle additional cases where DCN is not supported
Date: Mon, 20 Feb 2023 14:35:51 +0100
Message-Id: <20230220133554.338372931@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 6fc547a5a2ef5ce05b16924106663ab92f8f87a7 ]

There could be boards with DCN listed in IP discovery, but no
display hardware actually wired up.  In this case the vbios
display table will not be populated.  Detect this case and
skip loading DM when we detect it.

v2: Mark DCN as harvested as well so other display checks
elsewhere in the driver are handled properly.

Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index e9797439bb0eb..3f325e1e440c9 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4428,6 +4428,17 @@ DEVICE_ATTR_WO(s3_debug);
 static int dm_early_init(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
+	struct amdgpu_mode_info *mode_info = &adev->mode_info;
+	struct atom_context *ctx = mode_info->atom_context;
+	int index = GetIndexIntoMasterTable(DATA, Object_Header);
+	u16 data_offset;
+
+	/* if there is no object header, skip DM */
+	if (!amdgpu_atom_parse_data_header(ctx, index, NULL, NULL, NULL, &data_offset)) {
+		adev->harvest_ip_mask |= AMD_HARVEST_IP_DMU_MASK;
+		dev_info(adev->dev, "No object header, skipping DM\n");
+		return -ENOENT;
+	}
 
 	switch (adev->asic_type) {
 #if defined(CONFIG_DRM_AMD_DC_SI)
-- 
2.39.0



