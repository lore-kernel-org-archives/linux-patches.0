Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B815BE4B
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60EFC433C0;
	Mon, 19 Jun 2023 10:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171820;
	bh=61QMRtyLWMns25YZqvhLBcbJq5vqjmtP/73R2kA9qw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m0PU9ZJXlWX74Wf3hS4X7Tm4EAgxQ1/Az0Dq60Q80pPEQKY8U3R6wDcpUynKF5fDL
	 taNbrfKnpU4TUMsJ+FBMEofoi71IKslILPLnPq0Cpyd9AShRzE/Cn3cKHpt42WTwsq
	 ZqfEayAyYP/K6pjOl2GQk+CNOWJdHq/vkQtH154g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Natalia Petrova <n.petrova@fintech.ru>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 134/166] drm/nouveau/dp: check for NULL nv_connector->native_mode
Date: Mon, 19 Jun 2023 12:30:11 +0200
Message-ID: <20230619102201.272091203@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
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
index 1991bbb1d05c3..fd984733b8e6f 100644
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



