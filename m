Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BA519884D;
	Thu,  6 Jun 2024 14:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683364; cv=none; b=WL2fOtpckhgTB0l/NH8kDTbhZtun0zzUIBQ4YAP6mF4vnwdcveYa2lrW44XkD9jlb7Lkb/HpKsX1YlamVK6mquuBn+8lT+MBlMUp/8ib9sXMvx7WIw4UwAVjtfIIEkjiJljFWwXtEbbRss+eivfkVWsAS9kGu2BPz/81yzp7lqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683364; c=relaxed/simple;
	bh=hXvUTBEBUSCV86+MWcIijESYZ4zs6wiMX02ddJkk6q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFemkrWFt/U9qtGeut6YncQ35LOovp5UPFk4Ei+G4yRNJQyS/RQljY7ZEwCqy/qnznZjjFqwYn8HfpBXlbcE0q2x9hGLl6UtAeQsL+AMWYWrct/paoLPAjz/YFtPkNtU/x93VjNuZRfy6qu/+cyNog3pEdki/k+9A2Xdo8Nrtiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXT0NB6b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXT0NB6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6EAC32782;
	Thu,  6 Jun 2024 14:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683364;
	bh=hXvUTBEBUSCV86+MWcIijESYZ4zs6wiMX02ddJkk6q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UXT0NB6bElujYiOs4cJ7vU0tjUDZR3m64halxJR+PJQfnXcUMOyTOZ7FEqj8iDMcn
	 xs1IaJXmk4rD9xWYC/B13OwI3/HGsyvrqP2bkzSSIWwv9pglQNUVhdlmv+kXhryO+f
	 K3RZT+xHkw8GEksc6Bq5xR43ZC9wxcEs4ww5LUqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 306/744] drm: bridge: cdns-mhdp8546: Fix possible null pointer dereference
Date: Thu,  6 Jun 2024 15:59:38 +0200
Message-ID: <20240606131742.199403315@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index 6af565ac307ae..858f5b6508491 100644
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



