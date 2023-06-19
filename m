Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32C83C23
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:40:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A34C433C0;
	Mon, 19 Jun 2023 10:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171202;
	bh=It2DotmhJgF6bEerrBSRXbMcT0xPUBgjMzA77bJYsFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iNTJsXn+A4PR8X97ByOP1jcaca8e2Qlh0Nn9TMjinNTNqHKYooa6wcTlOhb8jyY5f
	 9L1dbun1K1uF3w+4KWhtUJcVPhYXf2fuldAwL0zwJJMks+9NCv5dHtd51K849NEh5C
	 C6BQECPppmsBk74/0rn8qXi8lPK92dkHx2KGpwAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Natalia Petrova <n.petrova@fintech.ru>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 158/187] drm/nouveau/dp: check for NULL nv_connector->native_mode
Date: Mon, 19 Jun 2023 12:29:36 +0200
Message-ID: <20230619102205.223211120@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
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
index 086b66b60d918..5dbf025e68737 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -966,7 +966,7 @@ nouveau_connector_get_modes(struct drm_connector *connector)
 	/* Determine display colour depth for everything except LVDS now,
 	 * DP requires this before mode_valid() is called.
 	 */
-	if (connector->connector_type != DRM_MODE_CONNECTOR_LVDS)
+	if (connector->connector_type != DRM_MODE_CONNECTOR_LVDS && nv_connector->native_mode)
 		nouveau_connector_detect_depth(connector);
 
 	/* Find the native mode if this is a digital panel, if we didn't
@@ -987,7 +987,7 @@ nouveau_connector_get_modes(struct drm_connector *connector)
 	 * "native" mode as some VBIOS tables require us to use the
 	 * pixel clock as part of the lookup...
 	 */
-	if (connector->connector_type == DRM_MODE_CONNECTOR_LVDS)
+	if (connector->connector_type == DRM_MODE_CONNECTOR_LVDS && nv_connector->native_mode)
 		nouveau_connector_detect_depth(connector);
 
 	if (nv_encoder->dcb->type == DCB_OUTPUT_TV)
-- 
2.39.2



