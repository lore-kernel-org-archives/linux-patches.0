Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3831C57B1;
	Tue, 15 Oct 2024 12:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993905; cv=none; b=D3BYuMJ709bGEZ3QQo+6gBKtbQs+HTn/rRw42p14dr/LBfW5eqjPPOji1GJLq6ORH7ae8YH0rVtPiHy/0RN5D9mLmjck2RkauNVHeqYvpKlm2WT9hwfcLQzQYs8U3L36joOn9htnAlq2xmhPmTAZLJVn0S2kje/EbUokDWvwqLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993905; c=relaxed/simple;
	bh=qlRTiOXvBKj9OXKcV5QibSHFzH5FnhBX3GUmtOCJgmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TqCrRsVAVfTJe2NXBlMiJnVs7QTalavt/CT2p1W/xCqtb/GlK5fHdGfZpJdcgp6pMeOPrtO8tY4PWHqMGPbQd1rw0wrZaTGJvUh0lbUltvh/yi4jYBSpVRub+b+7WarBMTpXzBDOVse70/c8cWqKfoyz3e4D+W2r5zzIB+i1gCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HaIcbtvl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HaIcbtvl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11EAC4CEC6;
	Tue, 15 Oct 2024 12:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993905;
	bh=qlRTiOXvBKj9OXKcV5QibSHFzH5FnhBX3GUmtOCJgmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HaIcbtvlhjhNEdfIMFBc0PyKo5X5qC522sU6GYEd9jlUeeGuK6Rx7t4n+NMzSrshL
	 0Vwq762Rpo0oYMKYc/13twdxNUkAjCBewE6T/yJUayYKBwZm5fgEiTa9SY+WjBZFPG
	 RERGj499xSihWZSO9aruYgtndD9O9bN4ABaOvYKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <wayne.lin@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 548/691] drm/amd/display: Fix system hang while resume with TBT monitor
Date: Tue, 15 Oct 2024 13:28:16 +0200
Message-ID: <20241015112502.090812823@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Chung <chiahsuan.chung@amd.com>

commit 52d4e3fb3d340447dcdac0e14ff21a764f326907 upstream.

[Why]
Connected with a Thunderbolt monitor and do the suspend and the system
may hang while resume.

The TBT monitor HPD will be triggered during the resume procedure
and call the drm_client_modeset_probe() while
struct drm_connector connector->dev->master is NULL.

It will mess up the pipe topology after resume.

[How]
Skip the TBT monitor HPD during the resume procedure because we
currently will probe the connectors after resume by default.

Reviewed-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Fangzhi Zuo <jerry.zuo@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 453f86a26945207a16b8f66aaed5962dc2b95b85)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -697,6 +697,12 @@ void dmub_hpd_callback(struct amdgpu_dev
 		return;
 	}
 
+	/* Skip DMUB HPD IRQ in suspend/resume. We will probe them later. */
+	if (notify->type == DMUB_NOTIFICATION_HPD && adev->in_suspend) {
+		DRM_INFO("Skip DMUB HPD IRQ callback in suspend/resume\n");
+		return;
+	}
+
 	link_index = notify->link_index;
 	link = adev->dm.dc->links[link_index];
 	dev = adev->dm.ddev;


