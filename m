Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88337306B39;
	Tue, 11 Nov 2025 01:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824881; cv=none; b=hdXaMAqfLgf5UjdbBhIyIyD2UezV7oBe10VHRIrXfpFC7maPScBmrodiidHrEaspfbD6QcmnegbdrBIjY6F9CxZdnBXq8TZmHGUpgQHym4OO771gcX1fFcb3Ru7Bci6drLEJDZfeSM0nv+gPQKZb6dSwgtvtxxo/N0oxbmISGFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824881; c=relaxed/simple;
	bh=WTIBi5wHNJs8AxMSur0hmlnYpcJdJDU3Gaw4WwfTsq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+OoYDln+9x5qLbR+tdF2iv782imLhS4KTyXI5H9kxWu0TICwfpSs+nMgiJ+M4bQUllPEi6+Ttn6b1mIwm887fNJ9cDMzU/qejlwSrgMsyzi4rSq1Ppe8AYvcOv9+qYBue1szlburh706Tz4IRxHve89y3oxy2NAH3BkOvzXSf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sHXk6kC+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sHXk6kC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3A2C2BC87;
	Tue, 11 Nov 2025 01:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824881;
	bh=WTIBi5wHNJs8AxMSur0hmlnYpcJdJDU3Gaw4WwfTsq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sHXk6kC+aYq+opdbSdT7kAXr33NhuB+Z2epFokZeD95+4C8rjkVBdxsbpX+dlolHe
	 +No2ZQpM+KdSDMf9UJ1hGPnieZYJW3Ri99CSZPOf9zWPUo3FDXdpC1/Snof0jp7Uat
	 33rfT6E6UW/VnROXrroiYG4j5Ef0+PZ8s2ih5eyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>
Subject: [PATCH 6.12 543/565] drm/amd/display: Enable mst when its detected but yet to be initialized
Date: Tue, 11 Nov 2025 09:46:39 +0900
Message-ID: <20251111004539.203270951@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayne Lin <Wayne.Lin@amd.com>

commit 3c6a743c6961cc2cab453b343bb157d6bbbf8120 upstream.

[Why]
drm_dp_mst_topology_queue_probe() is used under the assumption that
mst is already initialized. If we connect system with SST first
then switch to the mst branch during suspend, we will fail probing
topology by calling the wrong API since the mst manager is yet to
be initialized.

[How]
At dm_resume(), once it's detected as mst branc connected, check if
the mst is initialized already. If not, call
dm_helpers_dp_mst_start_top_mgr() instead to initialize mst

V2: Adjust the commit msg a bit

Fixes: bc068194f548 ("drm/amd/display: Don't write DP_MSTM_CTRL after LT")
Cc: Fangzhi Zuo <jerry.zuo@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 62320fb8d91a0bddc44a228203cfa9bfbb5395bd)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3424,6 +3424,7 @@ static int dm_resume(void *handle)
 	/* Do mst topology probing after resuming cached state*/
 	drm_connector_list_iter_begin(ddev, &iter);
 	drm_for_each_connector_iter(connector, &iter) {
+		bool init = false;
 
 		if (connector->connector_type == DRM_MODE_CONNECTOR_WRITEBACK)
 			continue;
@@ -3433,7 +3434,14 @@ static int dm_resume(void *handle)
 		    aconnector->mst_root)
 			continue;
 
-		drm_dp_mst_topology_queue_probe(&aconnector->mst_mgr);
+		scoped_guard(mutex, &aconnector->mst_mgr.lock) {
+			init = !aconnector->mst_mgr.mst_primary;
+		}
+		if (init)
+			dm_helpers_dp_mst_start_top_mgr(aconnector->dc_link->ctx,
+				aconnector->dc_link, false);
+		else
+			drm_dp_mst_topology_queue_probe(&aconnector->mst_mgr);
 	}
 	drm_connector_list_iter_end(&iter);
 


