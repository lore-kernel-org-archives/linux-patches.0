Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4606FAF;
	Tue,  5 Dec 2023 03:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S3kqMEFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F8CC433C7;
	Tue,  5 Dec 2023 03:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747008;
	bh=TBm6jM/SnR2/yduG+DY6qNiVSj1N0TPyjj/Eu3t8LjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S3kqMEFImGBWG0STVyFQo9K1CQhd5Pq28Knuc3239fluAfTLRpwcY97oYl0jZD0GO
	 vylDl+1oyOoKCKu27+CEzOL+neVWrGas429sk0CbCbnX2NrpThFgOsrDHYFqiLfxy8
	 lY31Gxh/Gs3U4gTCMfJRpKl9fHQL4rzZW4sstzIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 025/107] drm/amd/display: fix ABM disablement
Date: Tue,  5 Dec 2023 12:16:00 +0900
Message-ID: <20231205031533.173128121@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

From: Hamza Mahfooz <hamza.mahfooz@amd.com>

commit b9f46f0b98784e40288ee393f863f553fde062fa upstream.

On recent versions of DMUB firmware, if we want to completely disable
ABM we have to pass ABM_LEVEL_IMMEDIATE_DISABLE as the requested ABM
level to DMUB. Otherwise, LCD eDP displays are unable to reach their
maximum brightness levels. So, to fix this whenever the user requests an
ABM level of 0 pass ABM_LEVEL_IMMEDIATE_DISABLE to DMUB instead. Also,
to keep the user's experience consistent map ABM_LEVEL_IMMEDIATE_DISABLE
to 0 when a user tries to read the requested ABM level.

Cc: stable@vger.kernel.org # 6.1+
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6149,7 +6149,7 @@ int amdgpu_dm_connector_atomic_set_prope
 		dm_new_state->underscan_enable = val;
 		ret = 0;
 	} else if (property == adev->mode_info.abm_level_property) {
-		dm_new_state->abm_level = val;
+		dm_new_state->abm_level = val ?: ABM_LEVEL_IMMEDIATE_DISABLE;
 		ret = 0;
 	}
 
@@ -6194,7 +6194,8 @@ int amdgpu_dm_connector_atomic_get_prope
 		*val = dm_state->underscan_enable;
 		ret = 0;
 	} else if (property == adev->mode_info.abm_level_property) {
-		*val = dm_state->abm_level;
+		*val = (dm_state->abm_level != ABM_LEVEL_IMMEDIATE_DISABLE) ?
+			dm_state->abm_level : 0;
 		ret = 0;
 	}
 
@@ -6274,7 +6275,8 @@ void amdgpu_dm_connector_funcs_reset(str
 		state->pbn = 0;
 
 		if (connector->connector_type == DRM_MODE_CONNECTOR_eDP)
-			state->abm_level = amdgpu_dm_abm_level;
+			state->abm_level = amdgpu_dm_abm_level ?:
+				ABM_LEVEL_IMMEDIATE_DISABLE;
 
 		__drm_atomic_helper_connector_reset(connector, &state->base);
 	}


