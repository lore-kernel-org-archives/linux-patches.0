Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C5F34886B;
	Fri, 21 Nov 2025 13:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733129; cv=none; b=QooqsKb/CbDcRUhmfFTni1P22ewHzkXqYu5d6wvndECi5+AYtuM5HfQLUhkAUHfX5VyoO+ZvrYFGiHq7WQIToEZKIA3AV36Um0GYSD4m96E/CyBekKvQeeQ2an8Ni2rLj2Hts1/oYS2AF30NCejKBdKkZYEMe+FgorTAP0Mhk8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733129; c=relaxed/simple;
	bh=evbpnrkTsHCb5olAesq2YNU79eGT036owWQscp3pZiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NuTWKQx78EzJXJb5yuL5MvxhQog8xbK28tgqKgOBKgag2kKnnWMQprld7jHBVrdN33wwlINGu1lPby3B7mVLnQfYo96mMQcMfyldBqGGSjpyDKT5WeWAkLwHU9Z82MLpZv3/6aIlqPRE48oqoXjD+rvG664yK96e+BLDhBNNz9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tfr2DkbC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tfr2DkbC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8788C4CEF1;
	Fri, 21 Nov 2025 13:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733129;
	bh=evbpnrkTsHCb5olAesq2YNU79eGT036owWQscp3pZiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tfr2DkbCsdiq8NQbusOrxI4mDieRXyefdvsLsMjLY9DcaVQz4S8YdyiQVlZkle6KH
	 LWcE23Q50jZBiN7Z0YkTQ93EURlwm0f80pxg6UoYuHwI0TPAUCclqGIk64gbsMKprO
	 DNz2KuFxPilqzs4NHx/oJXF0p/x4LgQH/OjFlG3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>
Subject: [PATCH 6.6 362/529] drm/amd/display: Enable mst when its detected but yet to be initialized
Date: Fri, 21 Nov 2025 14:11:01 +0100
Message-ID: <20251121130243.908160263@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2993,6 +2993,7 @@ static int dm_resume(void *handle)
 	/* Do mst topology probing after resuming cached state*/
 	drm_connector_list_iter_begin(ddev, &iter);
 	drm_for_each_connector_iter(connector, &iter) {
+		bool init = false;
 
 		if (connector->connector_type == DRM_MODE_CONNECTOR_WRITEBACK)
 			continue;
@@ -3002,7 +3003,14 @@ static int dm_resume(void *handle)
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
 


