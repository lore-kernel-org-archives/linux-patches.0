Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB3B8494
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 070F1C4339B;
	Fri, 10 Mar 2023 14:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458942;
	bh=febVS2vAUITUBmnAC5YZXJQkasw+eqr17zEL2NtJFoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bCieWoVTqirVmOaZhWmgoUUCWRBlJz9vQYUQdONSpS9n/2ZmLANNvy6qeg0s/Aid6
	 SAWw9SVZZieHJGshN0EmFI3tIeBztfguwl6YqFM0yKr0Rf3Ce1n4P2rXFNPbodi4rf
	 Ejs2WaW0/kof6htCV9x8g8Cv5D2Zku+foAujy48w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Wayne Lin <Wayne.Lin@amd.com>,
	Jasdeep Dhillon <jdhillon@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 196/357] drm/amd/display: Fix potential null-deref in dm_resume
Date: Fri, 10 Mar 2023 14:38:05 +0100
Message-Id: <20230310133743.374386754@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Roman Li <roman.li@amd.com>

[ Upstream commit 7a7175a2cd84b7874bebbf8e59f134557a34161b ]

[Why]
Fixing smatch error:
dm_resume() error: we previously assumed 'aconnector->dc_link' could be null

[How]
Check if dc_link null at the beginning of the loop,
so further checks can be dropped.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Wayne Lin <Wayne.Lin@amd.com>
Acked-by: Jasdeep Dhillon <jdhillon@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 9fd711005c1f5..1e7083bc8a527 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1206,12 +1206,14 @@ static int dm_resume(void *handle)
 	list_for_each_entry(connector, &ddev->mode_config.connector_list, head) {
 		aconnector = to_amdgpu_dm_connector(connector);
 
+		if (!aconnector->dc_link)
+			continue;
+
 		/*
 		 * this is the case when traversing through already created
 		 * MST connectors, should be skipped
 		 */
-		if (aconnector->dc_link &&
-		    aconnector->dc_link->type == dc_connection_mst_branch)
+		if (aconnector->dc_link->type == dc_connection_mst_branch)
 			continue;
 
 		mutex_lock(&aconnector->hpd_lock);
-- 
2.39.2



