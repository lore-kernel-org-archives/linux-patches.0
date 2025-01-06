Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36F215575F;
	Mon,  6 Jan 2025 15:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176991; cv=none; b=JymC6Lz9BI+q3o0vIbfKo/vglGYvnl2HDXG/tguam116k5/EFknhtAWkIUzib2QYVrdSD1ewaNEpB8C294PNBPYaDHSQr7flbS5/0CoOXW838YpZh0foWvP+WD+sxZG9QxYlpAXNmGHT95d7v2CQcCcWSqfX8fYUsPUDFKpZWMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176991; c=relaxed/simple;
	bh=YVoCIOCrzE8omb+VOgnX94CF/PczzlzxQ4pTOSdpKfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dr/Evh3mXpAuJ4vAWJk6fV5Pp6yYeuJ+wznEnctrRDVIbOcIcyyC/dic8Noa9OyFGBbYoDiuUzj1qoaAOc2OtLf6F5Gvwi2rrIziW5F7b5BCXShn4+zfIYS0MQybdwRTWMuGA5QXCG2N/xJG1tKDXWsIvGtsofUWn4+CPwmj+LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmVP0tad; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmVP0tad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C808C4CED2;
	Mon,  6 Jan 2025 15:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176990;
	bh=YVoCIOCrzE8omb+VOgnX94CF/PczzlzxQ4pTOSdpKfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wmVP0tad/sgfEwGqBozGI3nmtK8uVbyL99Vv5EqFQzTfwQbH5If/V8eybWIbwd4vP
	 JkcGKcoGwR+hx+mCUs/3xPi3gO9lFFL7UgvqzA/VmcU7+M7jbdCM6jnfi1RteZuhNQ
	 JFcZ0kZywV44hsEFe/kZVvOnvJv2VIbk83ORmLrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/222] Revert "drm/radeon: Delay Connector detecting when HPD singals is unstable"
Date: Mon,  6 Jan 2025 16:13:39 +0100
Message-ID: <20250106151151.178279051@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 979bfe291b5b30a9132c2fd433247e677b24c6aa ]

This reverts commit 949658cb9b69ab9d22a42a662b2fdc7085689ed8.

This causes a blank screen on boot.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3696
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Shixiong Ou <oushixiong@kylinos.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_connectors.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index cf0114ca59a4..b84b58926106 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -1267,16 +1267,6 @@ radeon_dvi_detect(struct drm_connector *connector, bool force)
 			goto exit;
 		}
 	}
-
-	if (dret && radeon_connector->hpd.hpd != RADEON_HPD_NONE &&
-	    !radeon_hpd_sense(rdev, radeon_connector->hpd.hpd) &&
-	    connector->connector_type == DRM_MODE_CONNECTOR_HDMIA) {
-		DRM_DEBUG_KMS("EDID is readable when HPD disconnected\n");
-		schedule_delayed_work(&rdev->hotplug_work, msecs_to_jiffies(1000));
-		ret = connector_status_disconnected;
-		goto exit;
-	}
-
 	if (dret) {
 		radeon_connector->detected_by_load = false;
 		radeon_connector_free_edid(connector);
-- 
2.39.5



