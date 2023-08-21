Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8354A11707
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:53:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A8CC433C8;
	Mon, 21 Aug 2023 19:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647608;
	bh=B77pQH4kCd+5X3F9uUrfzJJLzLSM30YZslTRqE1feFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vt8/Y1uhlDCkysO0TEjhISHnfMOjrc8lsfy68GmdfM76OoEGFCCM2+VuZ1f9GP54C
	 HMKeTucMDjhJi+M19NUgB15bfT/f2/WrTcx7GBHx7t/YVnVwnH6MHMKaEFk1UUsbwE
	 sd1lfBguF3ZpDlO2W7cQPmU1fA0vBNgJQTtBfHV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
	Qingqing Zhuo <qingqing.zhuo@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 075/194] drm/amd/display: fix access hdcp_workqueue assert
Date: Mon, 21 Aug 2023 21:40:54 +0200
Message-ID: <20230821194126.064176183@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
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

[ Upstream commit cdff36a0217aadf5cbc167893ad1c0da869619cb ]

[Why] hdcp are enabled for asics from raven. for old asics
which hdcp are not enabled, hdcp_workqueue are null. some
access to hdcp work queue are not guarded with pointer check.

[How] add hdcp_workqueue pointer check before access workqueue.

Reviewed-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Hersen Wu <hersenxs.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c    |  6 ++++++
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c  | 16 ++++++++++------
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index aa0ea28a86f02..249b269e2cc53 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8372,6 +8372,9 @@ static void amdgpu_dm_atomic_commit_tail(struct drm_atomic_state *state)
 		struct amdgpu_crtc *acrtc = to_amdgpu_crtc(dm_new_con_state->base.crtc);
 		struct amdgpu_dm_connector *aconnector = to_amdgpu_dm_connector(connector);
 
+		if (!adev->dm.hdcp_workqueue)
+			continue;
+
 		pr_debug("[HDCP_DM] -------------- i : %x ----------\n", i);
 
 		if (!connector)
@@ -8420,6 +8423,9 @@ static void amdgpu_dm_atomic_commit_tail(struct drm_atomic_state *state)
 		struct amdgpu_crtc *acrtc = to_amdgpu_crtc(dm_new_con_state->base.crtc);
 		struct amdgpu_dm_connector *aconnector = to_amdgpu_dm_connector(connector);
 
+		if (!adev->dm.hdcp_workqueue)
+			continue;
+
 		new_crtc_state = NULL;
 		old_crtc_state = NULL;
 
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 9884dd78c652c..a9ddff774a978 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -379,13 +379,17 @@ static int dm_dp_mst_get_modes(struct drm_connector *connector)
 		if (aconnector->dc_sink && connector->state) {
 			struct drm_device *dev = connector->dev;
 			struct amdgpu_device *adev = drm_to_adev(dev);
-			struct hdcp_workqueue *hdcp_work = adev->dm.hdcp_workqueue;
-			struct hdcp_workqueue *hdcp_w = &hdcp_work[aconnector->dc_link->link_index];
 
-			connector->state->hdcp_content_type =
-			hdcp_w->hdcp_content_type[connector->index];
-			connector->state->content_protection =
-			hdcp_w->content_protection[connector->index];
+			if (adev->dm.hdcp_workqueue) {
+				struct hdcp_workqueue *hdcp_work = adev->dm.hdcp_workqueue;
+				struct hdcp_workqueue *hdcp_w =
+					&hdcp_work[aconnector->dc_link->link_index];
+
+				connector->state->hdcp_content_type =
+				hdcp_w->hdcp_content_type[connector->index];
+				connector->state->content_protection =
+				hdcp_w->content_protection[connector->index];
+			}
 		}
 #endif
 
-- 
2.40.1



