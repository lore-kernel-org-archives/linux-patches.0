Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1744443B6D1;
	Thu, 30 Jul 2026 14:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422037; cv=none; b=MegN618aoxTP7lvEjWJdSZVrNggzW84yPmDqnUmNCJZKYRkD/cACT9EYKdx8Y9lGyRsKyVA5IC0FADY/JTGWGppv/Y5V+3hDbk6lEKhkIKpR/KTVqufy2X8lRYIDF9arbGJxpt8SyrUHZlRNJ0ZFyNGKhUJs+LOD+Pb2lY2jMzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422037; c=relaxed/simple;
	bh=kVS2iAaGQEQllcWXuGERmveu+z0ZlYGIquirL6Vq+8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NRjKe4E6Wnw6RhqAhEFMpmsuBMf3eMyyZ/5+RlVF+VSrcpyfKP991m15DVfK1EwqaL7AL2sjVimxVGxO2JpyliaAnZS1Lvjl4pL2UWzha0B6qZzSDVIgg6m849UZcVClGjEm6QHGHv9jhLvWnhWullwYCmMQKjzyz3RuQ8h5YNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g9eChAIM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g9eChAIM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA981F000E9;
	Thu, 30 Jul 2026 14:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422036;
	bh=5tZIsj4EmiUsy4bSrK2VQQVHnUMtbVwd88iJ4BrK9ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g9eChAIMnmP1zkVtRJrulRNS7jt6la8RCGjNjmgrfBsXG+T2kjXQS0+nb8dITd8Vp
	 EgS+exgg6LET5TUFhjnLpekEHvB5pzsgadf/vKPyK+NibBcv9JdELw5em2mJA+xmAV
	 xVcJUJpCmHqkeXQ1zagYY317dGbguqzqzFqLF/ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Braha <julianbraha@gmail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 302/744] drm/panel: fix unmet dependency bug for DRM_PANEL_HIMAX_HX83121A
Date: Thu, 30 Jul 2026 16:09:35 +0200
Message-ID: <20260730141450.710501347@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Braha <julianbraha@gmail.com>

[ Upstream commit aaa5be0258db1709e254b4150af5c2fa5518c548 ]

Currently, DRM_PANEL_HIMAX_HX83121A selects DRM_DISPLAY_DSC_HELPER
without also ensuring DRM_DISPLAY_HELPER is enabled, causing an unmet
dependency:

WARNING: unmet direct dependencies detected for DRM_DISPLAY_DSC_HELPER
  Depends on [n]: HAS_IOMEM [=y] && DRM [=m] && DRM_DISPLAY_HELPER [=n]
  Selected by [m]:
  - DRM_PANEL_HIMAX_HX83121A [=m] && HAS_IOMEM [=y] && DRM [=m] && DRM_PANEL [=y] && OF [=y] && DRM_MIPI_DSI [=y] && BACKLIGHT_CLASS_DEVICE [=m]
  - DRM_PANEL_ILITEK_ILI9882T [=m] && HAS_IOMEM [=y] && DRM [=m] && DRM_PANEL [=y] && OF [=y] && DRM_MIPI_DSI [=y] && BACKLIGHT_CLASS_DEVICE [=m]

Many other DRM_PANEL_* options select DRM_DISPLAY_HELPER when selecting
DRM_DISPLAY_DSC_HELPER, let's do the same here.

This unmet dependency bug was found by kconfirm, a static analysis tool
for Kconfig.

Fixes: defab7b01e08 ("drm/panel: hx83121a: select DRM_DISPLAY_DSC_HELPER")
Signed-off-by: Julian Braha <julianbraha@gmail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260711234230.2236041-1-julianbraha@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/Kconfig b/drivers/gpu/drm/panel/Kconfig
index db2bd4d02377bb..adab94b3ebdfd7 100644
--- a/drivers/gpu/drm/panel/Kconfig
+++ b/drivers/gpu/drm/panel/Kconfig
@@ -208,6 +208,7 @@ config DRM_PANEL_HIMAX_HX83121A
 	depends on OF
 	depends on DRM_MIPI_DSI
 	depends on BACKLIGHT_CLASS_DEVICE
+	select DRM_DISPLAY_HELPER
 	select DRM_DISPLAY_DSC_HELPER
 	select DRM_KMS_HELPER
 	help
-- 
2.53.0



