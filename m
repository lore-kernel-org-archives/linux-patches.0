Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905C517E90E;
	Mon, 27 May 2024 19:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837134; cv=none; b=mG/NIdqCqaDsoUWoDW66Plwkak95eEJ+1LrzoXdMPV33H6vwuwflWY3husq3RVS7CKngCCXp5A8OwSrxTHU+m5PqmdxzbfoI7S1zFWJ4fyYN0LppKxjBZYicp29pqQ7tNZEARFY5HXQwwCzAnj1y+RvqXggLFOaHLaKgwZEv4sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837134; c=relaxed/simple;
	bh=toZnJGdjfZWtalC0DAmUwtOLdc0rNqI0dP0VZLIXNb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iji0Lexgk+Vu+qIhKQ7XFSL1UNkwRgTL6uQqO38KGtsDwuKMSCV93+ocoz5wYGSutn7uxokbiKOQi/YvRS7ferUxOnysziiuQy/XdISr4dxoLGCHTdct8cn4W75q6ut52qOIltiMtdWD2lPYmFdLTc1MrcYunZ+YBkKwZ7ZEnVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=icuoAROI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="icuoAROI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27FB9C2BBFC;
	Mon, 27 May 2024 19:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837134;
	bh=toZnJGdjfZWtalC0DAmUwtOLdc0rNqI0dP0VZLIXNb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=icuoAROIjas2SVZNHzpfJF5JvqYpwNfNK4mn0nMJdL7d9uu9Xrq2cvypNxilayxjp
	 TX7O+CdfuuP7feAWTi+JoxqoHRQEa0+3Wxug3NN9F/I4RI7rLAIq0xnGgmVr6RT3qx
	 gCjTNuv/ADovVhOexdnK5FVjTJDKm9B3i5zye+TM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 316/427] drm: bridge: cdns-mhdp8546: Fix possible null pointer dereference
Date: Mon, 27 May 2024 20:56:03 +0200
Message-ID: <20240527185631.283064794@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index e226acc5c15e1..8a91ef0ae0651 100644
--- a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
+++ b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
@@ -2059,6 +2059,9 @@ static void cdns_mhdp_atomic_enable(struct drm_bridge *bridge,
 	mhdp_state = to_cdns_mhdp_bridge_state(new_state);
 
 	mhdp_state->current_mode = drm_mode_duplicate(bridge->dev, mode);
+	if (!mhdp_state->current_mode)
+		return;
+
 	drm_mode_set_name(mhdp_state->current_mode);
 
 	dev_dbg(mhdp->dev, "%s: Enabling mode %s\n", __func__, mode->name);
-- 
2.43.0



