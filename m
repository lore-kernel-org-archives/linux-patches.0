Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678CE1798C;
	Mon, 14 Oct 2024 15:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919467; cv=none; b=eHWHI/o6Y3FkkuKO1/SpeT+bIYkJRNRTt7FLviymhkXD55m5Ak/PhVfXHkO/RAi4e6C+CFyP1xlzdSyMZoaCdRE5/5/605O7nKIofjrzvQ3eYx+3VC7s9H2wjF33GHXdjLAQFJ+KC4kkukkWQKgviFWsuHDHFj/7QT5gq0trzWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919467; c=relaxed/simple;
	bh=SGD93FjHzeZJYc/Jc3XE5tgLvjdiQmtXf/lP4RKnCxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9B9R9BdFJ+f/uY98AUKQStHjH8+FfMaMKiNVa+DmMpkc6mrVsW+2HwsnATt4QUdUBhmjLRKyAbgXJQOpMfpLE6S5o+HIK0QxSFcBZVR+j8MLRWAcYW/xqinpSp+D59yyU5MkKTOO1MdnRc5mhfdG6u+sbK0BYE1XQ6Qw5PtmRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJIbGfaJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJIbGfaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA140C4CEC3;
	Mon, 14 Oct 2024 15:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919467;
	bh=SGD93FjHzeZJYc/Jc3XE5tgLvjdiQmtXf/lP4RKnCxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJIbGfaJKdMnC/nhGIJkSksRc2dpa51tnaiIJykpJ7U5zh4eL5djcTi7859hxStYT
	 m0TgYuDLGpMHIwX/zFJY0688XtTL1mATjvKiNea6uZIOz24UekSZth2cy0wJh9+Mih
	 nxouKtlBwfwwnSWjtjetAKzeRYz9BiKyUwf0vsX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <wayne.lin@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 615/798] drm/amd/display: Fix system hang while resume with TBT monitor
Date: Mon, 14 Oct 2024 16:19:29 +0200
Message-ID: <20241014141242.196308089@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -712,6 +712,12 @@ static void dmub_hpd_callback(struct amd
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


