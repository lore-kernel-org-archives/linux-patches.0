Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC5215575F;
	Fri,  6 Dec 2024 14:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496364; cv=none; b=rOW4a/f+8U/b0c22jslruvr51piL5IGXAaKtOH8+zWiwAOA5Dsq6Fa5bbvLfs5Is8Byb+7gOA9CPNHaTdNEpipI5nakoalAFKrqO93Wed1AouLaNINyzysOxHhIlsDxBenYa5uAXp2fSznoXUWamEx1TjGe8bYNf3q2XH52EY6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496364; c=relaxed/simple;
	bh=CnhlHMp1Jbzhjp7HtAyyh27IGo+rAdajbse2MY/oKKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZLU2QFyCecQfzMd7zCINV6LT/9TkH2YIOdOMLkdqK/md7eWiswMbqow7EJ2tJcWCUrqZnVdWy5KPlh9Wb1mMiRJBgQlXmQ6rYbWdMVs4eTfUH1enjrQo6epNG7jKwDc3y77FdYPr2YhoAJEBpc6LwpW69SP2e/c93+tDXfTiLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SGURY7MO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SGURY7MO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B095C4CEDF;
	Fri,  6 Dec 2024 14:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496363;
	bh=CnhlHMp1Jbzhjp7HtAyyh27IGo+rAdajbse2MY/oKKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SGURY7MOE9T7MfR5ORHwpOdgXIDVNclV6FOQe7XQwJjKUb5M0Pi3NhTlIpxGgtg6m
	 TIylRGcVCSXRIDPi+CohUYOyUZBkpldpsmuZ/OWEY1fD+Hpc4Jg+DX1G/P9O9va+H6
	 iGdT/xCSlSqqTISUIW5WqJ1MfJMwPmG5PwFkD6L0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Shixiong Ou <oushixiong@kylinos.cn>
Subject: [PATCH 6.12 131/146] Revert "drm/radeon: Delay Connector detecting when HPD singals is unstable"
Date: Fri,  6 Dec 2024 15:37:42 +0100
Message-ID: <20241206143532.696569877@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 979bfe291b5b30a9132c2fd433247e677b24c6aa upstream.

This reverts commit 949658cb9b69ab9d22a42a662b2fdc7085689ed8.

This causes a blank screen on boot.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3696
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Shixiong Ou <oushixiong@kylinos.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/radeon_connectors.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index f9c73c55f04f..f9996304d943 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -1255,16 +1255,6 @@ radeon_dvi_detect(struct drm_connector *connector, bool force)
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
2.47.1



