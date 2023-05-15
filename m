Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEDBFBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:57:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3420C433EF;
	Mon, 15 May 2023 16:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169856;
	bh=uj+gcVHHknqsuUYqH19xmCR92HGJ0Y0REI1UsmLYbgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OyTVa2ETnu/Ql6S5m4Hx8rLo3x39+RTflx0F9Q3jmKZkGbc/+zbJuvJVtRMs5KJq/
	 kYhqvFYKbZX9p+5l8H3mXunsDP66zrZZYmYy4ww4g8gFK+SeQIX9oDcUoFDWXnQelC
	 B2Y9DwOQu99VwU0fsoA/YY4c/4+svA0xo0r+ExwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nikl=C4=81vs=20Ko=C4=BCes=C5=86ikovs?= <89q1r14hd@relay.firefox.com>,
	Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
	Qingqing Zhuo <qingqing.zhuo@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.3 193/246] drm/amd/display: fix access hdcp_workqueue assert
Date: Mon, 15 May 2023 18:26:45 +0200
Message-Id: <20230515161728.406610761@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
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

commit 3cf7cd3f770a0b89dc5f06e19edb52e65b93b214 upstream.

[Why] hdcp are enabled for asics from raven. for old asics
which hdcp are not enabled, hdcp_workqueue are null. some
access to hdcp work queue are not guarded with pointer check.

[How] add hdcp_workqueue pointer check before access workqueue.

Fixes: 82986fd631fa ("drm/amd/display: save restore hdcp state when display is unplugged from mst hub")
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2444
Reported-by: Niklāvs Koļesņikovs <89q1r14hd@relay.firefox.com>
Reviewed-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Hersen Wu <hersenxs.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c           |    6 ++++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |   16 +++++++-----
 2 files changed, 16 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8533,6 +8533,9 @@ static void amdgpu_dm_atomic_commit_tail
 		struct amdgpu_crtc *acrtc = to_amdgpu_crtc(dm_new_con_state->base.crtc);
 		struct amdgpu_dm_connector *aconnector = to_amdgpu_dm_connector(connector);
 
+		if (!adev->dm.hdcp_workqueue)
+			continue;
+
 		pr_debug("[HDCP_DM] -------------- i : %x ----------\n", i);
 
 		if (!connector)
@@ -8581,6 +8584,9 @@ static void amdgpu_dm_atomic_commit_tail
 		struct amdgpu_crtc *acrtc = to_amdgpu_crtc(dm_new_con_state->base.crtc);
 		struct amdgpu_dm_connector *aconnector = to_amdgpu_dm_connector(connector);
 
+		if (!adev->dm.hdcp_workqueue)
+			continue;
+
 		new_crtc_state = NULL;
 		old_crtc_state = NULL;
 
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -385,13 +385,17 @@ static int dm_dp_mst_get_modes(struct dr
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
 


