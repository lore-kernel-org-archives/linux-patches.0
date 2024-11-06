Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A88A1DFE38;
	Wed,  6 Nov 2024 12:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897265; cv=none; b=HPMQWf6zYfMOh6sFzpJQKaAuMSzMU2mnuMi6sAJH1CzniebJbpcNgqAt9zeQ/aN50r8pUmoh+4DhAVtT8cV4gzCyAkPjYdeRg+yGmP99Yqxke91TusCu2X+ZAM8lhtKOZ7k7ODYZkiWcBhfkNBDLxglUM7nq8U6s/SK1U/yE37s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897265; c=relaxed/simple;
	bh=kNsFbjvm/pOIOeCtdQEavRI0qEQSwkpsH20uK7RXBlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DOt2/56iW+wwpjA88FisefbWgyHDNeqF5TWezoALIWiNS87EUBiEMCDjH5G3tKJRo4r7nj8PyeEOgnWLw+UzVdKmlSf+HcxeuSDGfel1Ouypm7G+KMsgsCJOA6U0/lXsVWAhjF8gBlz9dzc2ULtQrsRC9GxDA1ctGl+ZjT4Wjxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cbBYDLpw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cbBYDLpw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5BD8C4CECD;
	Wed,  6 Nov 2024 12:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897265;
	bh=kNsFbjvm/pOIOeCtdQEavRI0qEQSwkpsH20uK7RXBlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cbBYDLpw7OOCJ7SegO2Hl5SE73cMt5jl55+HBXedTdXlErBTTze2eJsljSAc2tpag
	 E1AIQ7GHFq3UiWA9vR4B0WBea0Oy1M6DRVl8InAOjRVNVx/MM2Gjr40MarwExPTnDD
	 0y+mmVHd5tQX7HLTbPAug2/l4rfQlWPJJJF1YgJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Xiangyu Chen <xiangyu.chen@windriver.com>
Subject: [PATCH 6.1 123/126] drm/amd/display: Skip on writeback when its not applicable
Date: Wed,  6 Nov 2024 13:05:24 +0100
Message-ID: <20241106120309.381491216@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

commit ecedd99a9369fb5cde601ae9abd58bca2739f1ae upstream.

[WHY]
dynamic memory safety error detector (KASAN) catches and generates error
messages "BUG: KASAN: slab-out-of-bounds" as writeback connector does not
support certain features which are not initialized.

[HOW]
Skip them when connector type is DRM_MODE_CONNECTOR_WRITEBACK.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/3199
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Acked-by: Roman Li <roman.li@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2990,6 +2990,10 @@ static int dm_resume(void *handle)
 	/* Do mst topology probing after resuming cached state*/
 	drm_connector_list_iter_begin(ddev, &iter);
 	drm_for_each_connector_iter(connector, &iter) {
+
+		if (connector->connector_type == DRM_MODE_CONNECTOR_WRITEBACK)
+			continue;
+
 		aconnector = to_amdgpu_dm_connector(connector);
 		if (aconnector->dc_link->type != dc_connection_mst_branch ||
 		    aconnector->mst_port)
@@ -5722,6 +5726,9 @@ get_highest_refresh_rate_mode(struct amd
 		&aconnector->base.probed_modes :
 		&aconnector->base.modes;
 
+	if (aconnector->base.connector_type == DRM_MODE_CONNECTOR_WRITEBACK)
+		return NULL;
+
 	if (aconnector->freesync_vid_base.clock != 0)
 		return &aconnector->freesync_vid_base;
 
@@ -8242,6 +8249,9 @@ static void amdgpu_dm_commit_audio(struc
 			continue;
 
 	notify:
+		if (connector->connector_type == DRM_MODE_CONNECTOR_WRITEBACK)
+			continue;
+
 		aconnector = to_amdgpu_dm_connector(connector);
 
 		mutex_lock(&adev->dm.audio_lock);


