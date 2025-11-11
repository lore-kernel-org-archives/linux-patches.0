Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EFC1D6DB5;
	Tue, 11 Nov 2025 00:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822447; cv=none; b=FCnYtLFQAwrtprd0TsBwG5VWJa5RWmXqxPkej2JND+Lfjb77yQv6zHTjkFDFMr1KtAktOXXWUG4h/FV26pGiVRvZf84MpPxno90jM5y0B7aSkG+u6phggPSUiwRAoBa5QXz33wZ73wCsxnaXmLj+Ohi8Z4bkU54/M7NV3gvy1YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822447; c=relaxed/simple;
	bh=R1HZLa7ECdZav7R4Q6yIXuTsey886sRppXunLrrxJ/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mW1Bjf/qCHRGB+G2pcNGGfih7wVcF/VtsvuB8yGXmUdnJHkN6kzskItt5o8cUeBkifJ5Uz8VE5Qi5XI2TsndhoDeZCT1MqRMVD61EpAUPWFwsVrIMkCTUBkE5didZeErwp1rOq7DP6y0AsLAFmX5saRSopFh9+1kmI7PTFHUQ80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qXG2Oqsn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qXG2Oqsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805F3C16AAE;
	Tue, 11 Nov 2025 00:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822446;
	bh=R1HZLa7ECdZav7R4Q6yIXuTsey886sRppXunLrrxJ/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qXG2OqsnCFrOrZPEL2xcbAGbbyprsU2AeeKtGQMdbWaDBz7t0TyS7PK4HUFaNPQ7z
	 gElTKxjEacS8305/2HmvXPzu5+QdQqASCOXwQd8YX2LCsG2iKv6rra6y+9kSniljgZ
	 jI8NHmvOacaOD8OR5YRXAq5JTT+jkg+dBhTrsln4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.17 109/849] drm/amd/display: Add HDR workaround for a specific eDP
Date: Tue, 11 Nov 2025 09:34:39 +0900
Message-ID: <20251111004539.030889026@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

commit 7d08c3b1731014dd1cfd0bf8b0cb1cef9dfd191e upstream.

[WHY & HOW]
Some eDP panels suffer from flicking when HDR is enabled in KDE or
Gnome.

This add another quirk to worksaround to skip VSC that is incompatible
with an eDP panel.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/4452
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 99441824bec63549a076cd86631d138ec9a0c71c)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -82,6 +82,7 @@ static void apply_edid_quirks(struct drm
 		edid_caps->panel_patch.remove_sink_ext_caps = true;
 		break;
 	case drm_edid_encode_panel_id('S', 'D', 'C', 0x4154):
+	case drm_edid_encode_panel_id('S', 'D', 'C', 0x4171):
 		drm_dbg_driver(dev, "Disabling VSC on monitor with panel id %X\n", panel_id);
 		edid_caps->panel_patch.disable_colorimetry = true;
 		break;


