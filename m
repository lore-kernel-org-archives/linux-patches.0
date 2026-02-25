Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947DF332914;
	Wed, 25 Feb 2026 06:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002795; cv=none; b=gAMlQhPaTzSb2PmMD4qJTyTxeWxOOmlmI2tpjC3dSWEPVD5gtDaq2sSTq62RxumqJNV0KkqjrU6ZQCwClnYYwmufHntr1CYHys83O0ZEjLjkgtChzRxn/2t+EDLcMrlGdYD5uxnXmJApO32XoTO2ed9bTexIoQ0+kzng+r+pFjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002795; c=relaxed/simple;
	bh=XoKdUmj9bgMg/eoFkEtGasmnM8YJKOVIfiNOSEXKFUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z99bYziw9wiIhYQ/NEkoQmupe8pXZkRl3ArTx+9l2HIS8ZAdzqpImV3aGaw9PJDY98BabHzflQiy976RF4uj0NkQGUdF2TG04rZQenxqGOTmZANMDV8eu2D04TG9nT6dz15+FVIYoyuXcOx6KBN2ToFwnO0j1eHlSz1TJ+yiVXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aMbcItrr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aMbcItrr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6367FC116D0;
	Wed, 25 Feb 2026 06:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002795;
	bh=XoKdUmj9bgMg/eoFkEtGasmnM8YJKOVIfiNOSEXKFUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aMbcItrrsV3514xiJj5/2OOAqjICgHdlDnsJ+RUgWHRuGv/hqayRGcQ720q3c6NyC
	 WsqC8qSjSginedzjoXHWti2dtH9GwIE1R7lzNLEWG5kG0PpJV1JjXnno5XY2ZyHdHx
	 CipgbwcG/JPRPMvqj+eOYr5drdzSz6NNXgXMcRUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Lipski <ivan.lipski@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 640/641] drm/amd/display: Clear HDMI HPD pending work only if it is enabled
Date: Tue, 24 Feb 2026 17:26:06 -0800
Message-ID: <20260225012404.009827318@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Lipski <ivan.lipski@amd.com>

commit 17b2c526fd8026d8e0f4c0e7f94fc517e3901589 upstream.

[Why&How]
On amdgpu_dm_connector_destroy(), the driver attempts to cancel pending
HDMI HPD work without checking if the HDMI HPD is enabled.

Added a check that it is enabled before clearing it.

Fixes: 6a681cd90345 ("drm/amd/display: Add an hdmi_hpd_debounce_delay_ms module")
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7548,10 +7548,12 @@ static void amdgpu_dm_connector_destroy(
 		drm_dp_mst_topology_mgr_destroy(&aconnector->mst_mgr);
 
 	/* Cancel and flush any pending HDMI HPD debounce work */
-	cancel_delayed_work_sync(&aconnector->hdmi_hpd_debounce_work);
-	if (aconnector->hdmi_prev_sink) {
-		dc_sink_release(aconnector->hdmi_prev_sink);
-		aconnector->hdmi_prev_sink = NULL;
+	if (aconnector->hdmi_hpd_debounce_delay_ms) {
+		cancel_delayed_work_sync(&aconnector->hdmi_hpd_debounce_work);
+		if (aconnector->hdmi_prev_sink) {
+			dc_sink_release(aconnector->hdmi_prev_sink);
+			aconnector->hdmi_prev_sink = NULL;
+		}
 	}
 
 	if (aconnector->bl_idx != -1) {


