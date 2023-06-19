Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85248AD26
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037FBC433C8;
	Mon, 19 Jun 2023 10:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172386;
	bh=R2l51hUOLonAFTtsgoSmpw4FrbG+XD9GDpsR+Ib5vi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FXcgqp3NFbLKj87jzKA7ytMG6bC1ZYT5bkCM9srK82RVvPlUg1MHCwCYLAwhkHgvL
	 8gPibrl9Ylhxn9dZTUjGEGxKMoq8POEbEHSaXf7WMVSS0iE3lfitdgZG21Y3rjTR+l
	 hkp7OtV0Zq/wtmUCDok485i5PrixiyMEqNW3Sdps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Stylon Wang <stylon.wang@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Roman Li <roman.li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 5.15 049/107] drm/amd/display: edp do not add non-edid timings
Date: Mon, 19 Jun 2023 12:30:33 +0200
Message-ID: <20230619102143.853202705@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102141.541044823@linuxfoundation.org>
References: <20230619102141.541044823@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hersen Wu <hersenxs.wu@amd.com>

commit e749dd10e5f292061ad63d2b030194bf7d7d452c upstream.

[Why] most edp support only timings from edid. applying
non-edid timings, especially those timings out of edp
bandwidth, may damage edp.

[How] do not add non-edid timings for edp.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Acked-by: Stylon Wang <stylon.wang@amd.com>
Signed-off-by: Hersen Wu <hersenxs.wu@amd.com>
Reviewed-by: Roman Li <roman.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8177,7 +8177,13 @@ static int amdgpu_dm_connector_get_modes
 				drm_add_modes_noedid(connector, 640, 480);
 	} else {
 		amdgpu_dm_connector_ddc_get_modes(connector, edid);
-		amdgpu_dm_connector_add_common_modes(encoder, connector);
+		/* most eDP supports only timings from its edid,
+		 * usually only detailed timings are available
+		 * from eDP edid. timings which are not from edid
+		 * may damage eDP
+		 */
+		if (connector->connector_type != DRM_MODE_CONNECTOR_eDP)
+			amdgpu_dm_connector_add_common_modes(encoder, connector);
 		amdgpu_dm_connector_add_freesync_modes(connector, edid);
 	}
 	amdgpu_dm_fbc_init(connector);


