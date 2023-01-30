Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7284E28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:16:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB2CC433EF;
	Mon, 30 Jan 2023 14:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088184;
	bh=ZTc8zAISu67psEDf2o3YagVkbSwdIQwgQvZz0Vdjl3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gSbzbyNzVRcLfgdEjP9OBq7V1wL8XmHHXhjZ/pvWM+ShYt/ZbyTQLIY7rcSPF4D7h
	 rBvy7SwgSqhRjBoATt8+rL0cqpGrtfXWrp7Rpg/QLuabgX/tmTflF/21bsFH3Vn5B2
	 GUGQc9bbou9aHu9/9eQlPlp4hai0+MzzN9ua8KuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harsh Jain <harsh.jain@amd.com>,
	Evan Quan <evan.quan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 5.15 144/204] drm/amdgpu: complete gfxoff allow signal during suspend without delay
Date: Mon, 30 Jan 2023 14:51:49 +0100
Message-Id: <20230130134322.876362858@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Harsh Jain <harsh.jain@amd.com>

commit 4b31b92b143f7d209f3d494c56d4c4673e9fc53d upstream.

change guarantees that gfxoff is allowed before moving further in
s2idle sequence to add more reliablity about gfxoff in amdgpu IP's
suspend flow

Signed-off-by: Harsh Jain <harsh.jain@amd.com>
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -580,10 +580,14 @@ void amdgpu_gfx_off_ctrl(struct amdgpu_d
 		if (adev->gfx.gfx_off_req_count == 0 &&
 		    !adev->gfx.gfx_off_state) {
 			/* If going to s2idle, no need to wait */
-			if (adev->in_s0ix)
-				delay = GFX_OFF_NO_DELAY;
-			schedule_delayed_work(&adev->gfx.gfx_off_delay_work,
+			if (adev->in_s0ix) {
+				if (!amdgpu_dpm_set_powergating_by_smu(adev,
+						AMD_IP_BLOCK_TYPE_GFX, true))
+					adev->gfx.gfx_off_state = true;
+			} else {
+				schedule_delayed_work(&adev->gfx.gfx_off_delay_work,
 					      delay);
+			}
 		}
 	} else {
 		if (adev->gfx.gfx_off_req_count == 0) {


