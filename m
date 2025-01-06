Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508B3224CC;
	Mon,  6 Jan 2025 15:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176988; cv=none; b=qcberj0hlx/LN8IZl/ANBuo5nnKvuQkHlpSRkQ5A4bgd8z2uM6+HivoI9fDoURvEO5+JCBm3iVQp0lqnC0Z4K4Wk637cgw1QOSt4F4AsbZAJIyVdNW2mx9Rp+Jd8Qk6cz4fMVNZdcbjNR9j5xr2+S4OZd1MiaACfZ3OhzhOn2/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176988; c=relaxed/simple;
	bh=kqPoSK5t+KZ5FQCz9isXKZxyJq3dwc/34L9XS5e+eJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rurIHcd1GSbcPzCgLJCUbvOqYANrrkkLV9TjAxde8Hep8enxsHLb6gQ/K7t5Pe1gMarN2ETnxGIbphzM2yaodk1XvsZVd2gpyTsl4CfiZ8JqqIotvJ2zDvfGeWpenZ0LkodSQAk4VYMfyV3Oz7doMtijw8ym1tuMHsIVWsDxd+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tApjOyLi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tApjOyLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62EE5C4CED2;
	Mon,  6 Jan 2025 15:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176987;
	bh=kqPoSK5t+KZ5FQCz9isXKZxyJq3dwc/34L9XS5e+eJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tApjOyLiUqJzm9hIXWmtCUxsn83H+g+1T4ulWnO5fPylXiepbYraThM2XM8uH9QMa
	 YNuh9YdY3zVv9dwTpUeb6KfIoDunZUzRWVfW7pF9ZHSsbwivsMpn8aDcDDVd01hMoO
	 RJIeJ/2LZF9XI8ZTYTDo9wgWS/pNIbRPTFVl5Cc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/222] drm/radeon: Delay Connector detecting when HPD singals is unstable
Date: Mon,  6 Jan 2025 16:13:38 +0100
Message-ID: <20250106151151.141567133@linuxfoundation.org>
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

From: Shixiong Ou <oushixiong@kylinos.cn>

[ Upstream commit 949658cb9b69ab9d22a42a662b2fdc7085689ed8 ]

In some causes, HPD signals will jitter when plugging in
or unplugging HDMI.

Rescheduling the hotplug work for a second when EDID may still be
readable but HDP is disconnected, and fixes this issue.

Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 979bfe291b5b ("Revert "drm/radeon: Delay Connector detecting when HPD singals is unstable"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_connectors.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index b84b58926106..cf0114ca59a4 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -1267,6 +1267,16 @@ radeon_dvi_detect(struct drm_connector *connector, bool force)
 			goto exit;
 		}
 	}
+
+	if (dret && radeon_connector->hpd.hpd != RADEON_HPD_NONE &&
+	    !radeon_hpd_sense(rdev, radeon_connector->hpd.hpd) &&
+	    connector->connector_type == DRM_MODE_CONNECTOR_HDMIA) {
+		DRM_DEBUG_KMS("EDID is readable when HPD disconnected\n");
+		schedule_delayed_work(&rdev->hotplug_work, msecs_to_jiffies(1000));
+		ret = connector_status_disconnected;
+		goto exit;
+	}
+
 	if (dret) {
 		radeon_connector->detected_by_load = false;
 		radeon_connector_free_edid(connector);
-- 
2.39.5



