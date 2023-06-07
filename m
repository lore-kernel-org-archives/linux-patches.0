Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D1E37349
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F80C433D2;
	Wed,  7 Jun 2023 20:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170816;
	bh=PgA9svzD/UrG4idImGi3Os7gx2AieyhyjEqIVRnU4P4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yth1T82XguNG39tSJSNBF6w4xwBAQ/6SFklcWWFsEKy9LdNJGNu5/eHlkPNPyuXcp
	 rlSfMPRsFwxBnv+NmCjRcuqGBmDMmw+SYxFR3JJKxTw8Fs5sqPFUr4w2pDhtT+2MIv
	 B9kyH0xrs8e7DdJMMpcydMHeoUmi9r6kdxxnO3FA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <wayne.lin@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.1 218/225] drm/amd/display: Have Payload Properly Created After Resume
Date: Wed,  7 Jun 2023 22:16:51 +0200
Message-ID: <20230607200921.499556831@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fangzhi Zuo <jerry.zuo@amd.com>

commit 482e6ad9adde69d9da08864b4ccf4dfd53edb2f0 upstream.

At drm suspend sequence, MST dc_sink is removed. When commit cached
MST stream back in drm resume sequence, the MST stream payload is not
properly created and added into the payload table. After resume, topology
change is reprobed by removing existing streams first. That leads to
no payload is found in the existing payload table as below error
"[drm] ERROR No payload for [MST PORT:] found in mst state"

1. In encoder .atomic_check routine, remove check existance of dc_sink
2. Bypass MST by checking existence of MST root port. dc_link_type cannot
differentiate MST port before topology is rediscovered.

Reviewed-by: Wayne Lin <wayne.lin@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Fangzhi Zuo <jerry.zuo@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
[Adjusted for variables that were renamed between 6.1 and 6.3.]
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2763,7 +2763,7 @@ static int dm_resume(void *handle)
 		 * this is the case when traversing through already created
 		 * MST connectors, should be skipped
 		 */
-		if (aconnector->dc_link->type == dc_connection_mst_branch)
+		if (aconnector && aconnector->mst_port)
 			continue;
 
 		mutex_lock(&aconnector->hpd_lock);
@@ -6492,7 +6492,7 @@ static int dm_encoder_helper_atomic_chec
 	int clock, bpp = 0;
 	bool is_y420 = false;
 
-	if (!aconnector->port || !aconnector->dc_sink)
+	if (!aconnector->port)
 		return 0;
 
 	mst_port = aconnector->port;


