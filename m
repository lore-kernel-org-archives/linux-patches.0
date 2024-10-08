Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D960A1DED6F;
	Tue,  8 Oct 2024 13:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392816; cv=none; b=Aad/vG9TVafXV5Tcq8iUiZSfr4KwUj4dnEYyJu2zX/U0LqyAH2/1w7pf8NYSnNMCFEsTzZbEIsq+lD+yUhh4UW1N9IXVclrR0AyGxDHLF+rZ/JYe5J9uibNs5RCfJqYbCQbzFPbeCRSbolpHZUpuK6OiSppo3MXIKrF6ESr4pFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392816; c=relaxed/simple;
	bh=24rToqJnrztsTmKjyaz4XSrdEtn7b/ldojgz4gSSy5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lrXXRuzDYwurAQTofgi2HGehElMPjlX9Hn+sfkZXrNQz5/o1kUF4pgcVozMipPaOQBIsFz0kpqivDns+MawuRbwbA9vZNb7aJSBkSSPuuD8bbxx4DR6fnkBr90FbfMcIgS4ukb2+M+qrPuwMdxcTf0C9daGv27QJUGaMiOn51L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Duuu0Fr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Duuu0Fr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE8AC4CEC7;
	Tue,  8 Oct 2024 13:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392816;
	bh=24rToqJnrztsTmKjyaz4XSrdEtn7b/ldojgz4gSSy5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Duuu0Frcd91sKBasfc18FkxXAk9w5p1Zq3c5EyReyt2AjmoMUEopF4Z/Me7DrrAp
	 wMfo5oBZpSYoS+A3QfrgQhSLZuPGwDejQN3ugL2FaVEe0+S9C6yuN8v7qU6KNoI7fq
	 4nIeXKYSvMFTBMC8RpKLkBqbn+SkRqqxrj+4mtjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <wayne.lin@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 528/558] drm/amd/display: Fix system hang while resume with TBT monitor
Date: Tue,  8 Oct 2024 14:09:18 +0200
Message-ID: <20241008115723.005344309@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -770,6 +770,12 @@ static void dmub_hpd_callback(struct amd
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


