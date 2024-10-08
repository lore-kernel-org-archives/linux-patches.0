Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8D01DF99C;
	Tue,  8 Oct 2024 13:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394087; cv=none; b=bi9xFkceng4Ph567Cc5+J5a4SiCVT3CoGmNL2xtjTDbQH9zUobYQKv5Wmg6o1GP1Agnsy7Ntz0xlxu627shGrdfhu0ce9bbpUub4o/NdBk7h7kEA88AXATNlxdsg8HzP8WttnnK2b2qBGRdrgW0H1Uxut2yZ00C+KM1PzK1LKSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394087; c=relaxed/simple;
	bh=sbABcmMt+xQME9JjLX4qooqMzd0Vi5VYFSHsb9SIo9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMAHAo0Lfy5Da4ALMYNstqH+7SIMrt+bEyGW1u4UWJzebLNGUjeb5ZDpuLhxAl4FQggTKjl+XIQ2S2krQvCLpVJIHAbwkpYRIPRNbAvYcT/z+r321Xrp5W8Vo2Q+2Yf3Vxk1IQ082+OyKSM3NiYCLl5SR2iujrjbaaqc54Hvz9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=njNVh/q9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="njNVh/q9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F94C4CEC7;
	Tue,  8 Oct 2024 13:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394087;
	bh=sbABcmMt+xQME9JjLX4qooqMzd0Vi5VYFSHsb9SIo9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=njNVh/q9Xinvrb0gGm+2fBk9twj6IPeb3b5VPcQBvQzEBTmDcvwGzW8y+2E0bEV9F
	 o57nfk4NXE5UPJJMjwasnQMEPsfDu6y4yn9vCFvXxGfs/Sove8sZ6ch9LjdVANwHuY
	 8aS+tOrJwYRsXs/75M2yLv+phYSxY/JRvyMiwMoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <wayne.lin@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 326/386] drm/amd/display: Fix system hang while resume with TBT monitor
Date: Tue,  8 Oct 2024 14:09:31 +0200
Message-ID: <20241008115642.214608619@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -714,6 +714,12 @@ static void dmub_hpd_callback(struct amd
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


