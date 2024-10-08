Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064F41779B1;
	Tue,  8 Oct 2024 12:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390953; cv=none; b=Wxq/vVGwkT4R9lR+bhGq20ROSaDjCb4wMssFn1+tu32pxxdJiWyVhjqg7StusMcS7vkumm1zFbiX+CPFAv2nO2mBQNmTzIFg7yPKu5t8FJ3S2mRQsi3DQEpicbqmg0+vkDtDYZi/vgAHruUMjnA01FxkQqPNpr61HQTmB6zRJYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390953; c=relaxed/simple;
	bh=kmnFd4lbodnVAvuKKV+LmzI+Exi83aFuq7yscDDDOtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2AwrMT/PJbil+yuuEFL/MDgi+cWKoYKPI2S1QyItPJ21XMdXSHxlWojJ/FxvpI03L5/tTOXHAMxl/WyitG2VgaYmoH1wSgdH1d1MIKDM6xR2y/y9m3HGJd7ijQxzq47jzi0DAvPxhwgY2UvMyZ0/Mruga8sXWHsMLi4J6tZBWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MWQZCLlX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWQZCLlX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72ACAC4CEC7;
	Tue,  8 Oct 2024 12:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390952;
	bh=kmnFd4lbodnVAvuKKV+LmzI+Exi83aFuq7yscDDDOtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWQZCLlX253liaa02NLU6We0VCR/wPy8w6vEDd2UinWhlSFVufreAqa5eBXkoRySv
	 ziAV5Qf5Hg2Cf4lopd14QLFiwNP8LtIdzjGu1t7rriH//iMOHopNIDjQqX+yGxIDXm
	 NLfFXEMekPtMzeJyqjwiWABWbI+xHkf32xEdNIec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <wayne.lin@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.10 445/482] drm/amd/display: Fix system hang while resume with TBT monitor
Date: Tue,  8 Oct 2024 14:08:28 +0200
Message-ID: <20241008115706.035376366@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -758,6 +758,12 @@ static void dmub_hpd_callback(struct amd
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


