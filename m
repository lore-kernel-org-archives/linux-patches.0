Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C60A17727;
	Mon, 27 May 2024 19:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838440; cv=none; b=HDu5KGlh+XRoKNOnyZT3OqdEK7DK+MKnwNM/n0RtFRALtbssCQHNdrEzG8Y4yLzYt+xOY2onURXFd7uCVsHGd/9eC81D9kbwkNxDRYLq1Ipnq9K6kAZrZPpFv2HEwHBXs5KB19pxOM9s41CCkpU9oe1gSUFhiY6X6OGUh7t1l1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838440; c=relaxed/simple;
	bh=UjrnKtilEVeqM2C5D9JkzzLGu3Jp0F0lHVTisP4XjYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6q51BVX9NxDRHfxb8GAr1FM8KzD4s+YRfB96kB3Clq38+n0wUkJxT7k4ge/3elhUu7sKJB60Jq840JQwE1xK/QSDyZlXzlEOFBEE9GnTgLF8pbvfvgCZMbuNVhv6uC8WSmjum+M94EO4MWR/6iqI73QfT+d4F1vx3HkMD8KBRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bMJsR00w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bMJsR00w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946A5C2BBFC;
	Mon, 27 May 2024 19:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838439;
	bh=UjrnKtilEVeqM2C5D9JkzzLGu3Jp0F0lHVTisP4XjYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bMJsR00wIz+GNn2Z4B0fOwVy2My8slF/6OJXCfycZqMlO69+uKL0gk8J1G4sJXrp6
	 Ah6MeD12dxne1/VvExYgN8KbCtX/7dDh2g8lj04SqYcdf6LCcYINSVSdPBJy3jQu6q
	 XipftKMN9GzGUVFc94FhNY7GKzGRjNEdEwnhDxRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 391/493] drm: bridge: cdns-mhdp8546: Fix possible null pointer dereference
Date: Mon, 27 May 2024 20:56:33 +0200
Message-ID: <20240527185643.060759445@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit 935a92a1c400285545198ca2800a4c6c519c650a ]

In cdns_mhdp_atomic_enable(), the return value of drm_mode_duplicate() is
assigned to mhdp_state->current_mode, and there is a dereference of it in
drm_mode_set_name(), which will lead to a NULL pointer dereference on
failure of drm_mode_duplicate().

Fix this bug add a check of mhdp_state->current_mode.

Fixes: fb43aa0acdfd ("drm: bridge: Add support for Cadence MHDP8546 DPI/DP bridge")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240408125810.21899-1-amishin@t-argos.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
index 7d470527455b1..bab8844c6fefb 100644
--- a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
+++ b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
@@ -2057,6 +2057,9 @@ static void cdns_mhdp_atomic_enable(struct drm_bridge *bridge,
 	mhdp_state = to_cdns_mhdp_bridge_state(new_state);
 
 	mhdp_state->current_mode = drm_mode_duplicate(bridge->dev, mode);
+	if (!mhdp_state->current_mode)
+		return;
+
 	drm_mode_set_name(mhdp_state->current_mode);
 
 	dev_dbg(mhdp->dev, "%s: Enabling mode %s\n", __func__, mode->name);
-- 
2.43.0



