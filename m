Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75037BE4B
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:53:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D72C433C0;
	Mon, 19 Jun 2023 10:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171998;
	bh=mA9qCJhH/9wTKiVC8Rvfeu+aOjEz94m39S6f5tf4br4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ak/AmjLYqDVfsgBgEw3kgUvc62CHUuc0fuVuOYbPqoJUxxrsVOSnBOFGUYy4pTMRc
	 SXZ8YEMML4/AWwi8kZkGca8ZhcUQ43Ecr+qAJ+3px+2zNwQzuNSFFFb59/mu+JqpqI
	 Mmkx9DSldcZ//ByxCordyCxd4FHmBO0D6oPe+daU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Natalia Petrova <n.petrova@fintech.ru>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 52/64] drm/nouveau/dp: check for NULL nv_connector->native_mode
Date: Mon, 19 Jun 2023 12:30:48 +0200
Message-ID: <20230619102135.562101607@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102132.808972458@linuxfoundation.org>
References: <20230619102132.808972458@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Natalia Petrova <n.petrova@fintech.ru>

[ Upstream commit 20a2ce87fbaf81e4c3dcb631d738e423959eb320 ]

Add checking for NULL before calling nouveau_connector_detect_depth() in
nouveau_connector_get_modes() function because nv_connector->native_mode
could be dereferenced there since connector pointer passed to
nouveau_connector_detect_depth() and the same value of
nv_connector->native_mode is used there.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: d4c2c99bdc83 ("drm/nouveau/dp: remove broken display depth function, use the improved one")

Signed-off-by: Natalia Petrova <n.petrova@fintech.ru>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230512111526.82408-1-n.petrova@fintech.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_connector.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
index 496e7dcd6b7dc..18c3aae91be26 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -950,7 +950,7 @@ nouveau_connector_get_modes(struct drm_connector *connector)
 	/* Determine display colour depth for everything except LVDS now,
 	 * DP requires this before mode_valid() is called.
 	 */
-	if (connector->connector_type != DRM_MODE_CONNECTOR_LVDS)
+	if (connector->connector_type != DRM_MODE_CONNECTOR_LVDS && nv_connector->native_mode)
 		nouveau_connector_detect_depth(connector);
 
 	/* Find the native mode if this is a digital panel, if we didn't
@@ -971,7 +971,7 @@ nouveau_connector_get_modes(struct drm_connector *connector)
 	 * "native" mode as some VBIOS tables require us to use the
 	 * pixel clock as part of the lookup...
 	 */
-	if (connector->connector_type == DRM_MODE_CONNECTOR_LVDS)
+	if (connector->connector_type == DRM_MODE_CONNECTOR_LVDS && nv_connector->native_mode)
 		nouveau_connector_detect_depth(connector);
 
 	if (nv_encoder->dcb->type == DCB_OUTPUT_TV)
-- 
2.39.2



