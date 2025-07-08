Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD412DEA94;
	Tue,  8 Jul 2025 16:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993469; cv=none; b=tE3lOvAOf32sbB6ySacgyw2uE9eop8zRT9tlcJC1VYN848VVqfE4p9uISK+K1hicvl7tULrKPIObNvBt5OFnkNORIA3tp/sFfgVjDDw1ZOcSK3C+0+u/rbi5OrNyxWBFiMBwQNzRatoiaxV4djzk8CriXL/NUVBOyZaLTDxXHBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993469; c=relaxed/simple;
	bh=9qgjqAprIoAfG31AJBjaC6zYuN644aESDmRKidbNsqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mTFxAqet2wOBk3/8lbCgp3lnqqdEHJUnHd5+3ZF/XEze1THs6aFIs7Gz53n4zbzZZBzQhhuIzdnN9zMF+M7s+5CPecVx97qrP7R0q1JIa05tljMW4ipDlmDI0mdyxsZdpoxSd/P+YQ6fG/29idnV1K8l0aZSRqEtMJH4quICCJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nGlu/BQz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nGlu/BQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E758C4CEF0;
	Tue,  8 Jul 2025 16:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993469;
	bh=9qgjqAprIoAfG31AJBjaC6zYuN644aESDmRKidbNsqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nGlu/BQz2xkXlA48tnKrBzpf+oZV0d6VWxoYxmvW4rVSa4zYyIq2ZsYsK25lW8+gy
	 bBo/PWFwtiH71UKc5/xfYx9YEt5UFa0dIKfgwRD+ghITXi0XBYc0U/khIa8lFm9k1H
	 lZ9a1JB2qYFgZV0SMBFAAOfKaGTFuwvFBZrdxQhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 085/178] drm/bridge: panel: move prepare_prev_first handling to drm_panel_bridge_add_typed
Date: Tue,  8 Jul 2025 18:22:02 +0200
Message-ID: <20250708162238.900375736@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit eb028cd884e1b0976ff8c5944ee6650fe3ed0a6c ]

The commit 5ea6b1702781 ("drm/panel: Add prepare_prev_first flag to
drm_panel") and commit 0974687a19c3 ("drm/bridge: panel: Set
pre_enable_prev_first from drmm_panel_bridge_add") added handling of
panel's prepare_prev_first to devm_panel_bridge_add() and
drmm_panel_bridge_add(). However if the driver calls
drm_panel_bridge_add_typed() directly, then the flag won't be handled
and thus the drm_bridge.pre_enable_prev_first will not be set.

Move prepare_prev_first handling to the drm_panel_bridge_add_typed() so
that there is no way to miss the flag.

Fixes: 5ea6b1702781 ("drm/panel: Add prepare_prev_first flag to drm_panel")
Fixes: 0974687a19c3 ("drm/bridge: panel: Set pre_enable_prev_first from drmm_panel_bridge_add")
Reported-by: Svyatoslav Ryhel <clamor95@gmail.com>
Closes: https://lore.kernel.org/dri-devel/CAPVz0n3YZass3Bns1m0XrFxtAC0DKbEPiW6vXimQx97G243sXw@mail.gmail.com/
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250220-panel_prev_first-v1-1-b9e787825a1a@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/panel.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bridge/panel.c b/drivers/gpu/drm/bridge/panel.c
index 258c85c83a283..6c58d0759f227 100644
--- a/drivers/gpu/drm/bridge/panel.c
+++ b/drivers/gpu/drm/bridge/panel.c
@@ -298,6 +298,7 @@ struct drm_bridge *drm_panel_bridge_add_typed(struct drm_panel *panel,
 	panel_bridge->bridge.of_node = panel->dev->of_node;
 	panel_bridge->bridge.ops = DRM_BRIDGE_OP_MODES;
 	panel_bridge->bridge.type = connector_type;
+	panel_bridge->bridge.pre_enable_prev_first = panel->prepare_prev_first;
 
 	drm_bridge_add(&panel_bridge->bridge);
 
@@ -412,8 +413,6 @@ struct drm_bridge *devm_drm_panel_bridge_add_typed(struct device *dev,
 		return bridge;
 	}
 
-	bridge->pre_enable_prev_first = panel->prepare_prev_first;
-
 	*ptr = bridge;
 	devres_add(dev, ptr);
 
@@ -455,8 +454,6 @@ struct drm_bridge *drmm_panel_bridge_add(struct drm_device *drm,
 	if (ret)
 		return ERR_PTR(ret);
 
-	bridge->pre_enable_prev_first = panel->prepare_prev_first;
-
 	return bridge;
 }
 EXPORT_SYMBOL(drmm_panel_bridge_add);
-- 
2.39.5



