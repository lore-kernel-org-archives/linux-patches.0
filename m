Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E622FF672;
	Tue, 11 Nov 2025 01:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825440; cv=none; b=KEFf/xhvHr0I7r9mrJIRifl7bkb8pWLHHdvtst5WmKulB0FrzVSi/K/W5btgtkl78GkoNDE+IVxxVIbHTazwz2ZIxIX1DEsAwhLI3JPd79CgtZfw/W/Ow40zito2zLIN2NE5sXoooEoE9j2bIqTQD63awYG5b721Au2o4WiM+Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825440; c=relaxed/simple;
	bh=g4AhtdM1CryErsE127K7tZS9nWwKlxWxSBAPN4JcKdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=czpml9L7nr58NHKnMMt/zr5qDf2dcZsGhGqazrOMwtt1zLGxprZ+cH408oBhyZo3m/b7YC/4QIUtm6fiO1nMaUofBj2F/Uefcv8hcbSfUom11mFYJzG2g19u0RHEQP69q5pvuXsvdL48yKhpjCLyKZ8tPgLA7q32NqG39DsL3Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ey91ppTM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ey91ppTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45BC2C19422;
	Tue, 11 Nov 2025 01:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825440;
	bh=g4AhtdM1CryErsE127K7tZS9nWwKlxWxSBAPN4JcKdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ey91ppTMZGrtzu6HO1Z/wE7HeMGQhcdX39veFqs404nNlguC2rHZUm6sIUb80RPDr
	 xIOxh+2JRwWU5PvNVDL8WbnFuJWhj93zrnvJqJJXHk5AZyKEjAH6TfwRglahkLDdM1
	 A+5aTBlRDweFVwlh4ny117EtQ8GPO6fKOsbjj85Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>
Subject: [PATCH 6.17 801/849] drm/amd/display: Enable mst when its detected but yet to be initialized
Date: Tue, 11 Nov 2025 09:46:11 +0900
Message-ID: <20251111004555.796937869@linuxfoundation.org>
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
@@ -3574,6 +3574,7 @@ static int dm_resume(struct amdgpu_ip_bl
 	/* Do mst topology probing after resuming cached state*/
 	drm_connector_list_iter_begin(ddev, &iter);
 	drm_for_each_connector_iter(connector, &iter) {
+		bool init = false;
 
 		if (connector->connector_type == DRM_MODE_CONNECTOR_WRITEBACK)
 			continue;
@@ -3583,7 +3584,14 @@ static int dm_resume(struct amdgpu_ip_bl
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
 


