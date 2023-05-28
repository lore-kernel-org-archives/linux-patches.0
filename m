Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C244D569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE13C4339B;
	Sun, 28 May 2023 19:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302210;
	bh=Wy7AdRO/K+eBMjRjTP5BswEMqA2Y1niHhYlQEsoiFaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iAFYe1P/kyaKJbzeE4Bz4PMXudFyOqudEDGJUicW6Mrxt1kOZJPUWLsS2zAdh9AnZ
	 FJOWylqjAWxFm9O6geNY5afchscYrptXuPsSDHqcGKXcOJtGSp5kquMzmyTvJb6e4Y
	 RiHUkIv8Zdqa1l0NZUoRFHpA9+ilS1xoJ1CjCRcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <wayne.lin@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.3 044/127] drm/amd/display: Have Payload Properly Created After Resume
Date: Sun, 28 May 2023 20:10:20 +0100
Message-Id: <20230528190837.789297819@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190836.161231414@linuxfoundation.org>
References: <20230528190836.161231414@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2813,7 +2813,7 @@ static int dm_resume(void *handle)
 		 * this is the case when traversing through already created
 		 * MST connectors, should be skipped
 		 */
-		if (aconnector->dc_link->type == dc_connection_mst_branch)
+		if (aconnector && aconnector->mst_root)
 			continue;
 
 		mutex_lock(&aconnector->hpd_lock);
@@ -6717,7 +6717,7 @@ static int dm_encoder_helper_atomic_chec
 	int clock, bpp = 0;
 	bool is_y420 = false;
 
-	if (!aconnector->mst_output_port || !aconnector->dc_sink)
+	if (!aconnector->mst_output_port)
 		return 0;
 
 	mst_port = aconnector->mst_output_port;


