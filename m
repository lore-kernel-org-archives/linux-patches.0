Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E9643B6D1;
	Thu, 30 Jul 2026 14:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422040; cv=none; b=RT8IX21SGBzH17OERjgUttbbM/Fhd/XkEwhDEzuNsBcr7UccRDLFsePHfl+hma2maP61QWkYGVChfHFZ/1qXBdZljla6p5vdYRiD9SW5fZYPWDw23pMsRwbs/sSygsMML78Co98s8NQvEOKqk5f/BCBdpcqZrXood7gcyRo06MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422040; c=relaxed/simple;
	bh=ewjWWQx6SBUPVIbP8xS1EG+D3H8j91sJuZ2ePIMCaac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ln027Y/0YOCY7oWBRoT2MmfUrUQUIFJPlWWv6M7dWQLBxNH8qCmaaHuaDyD1pUhbnc5laWd+lWptyLA8vinWe2ePCbu6fEGdL8VkQwh7l0/bCtLzj/l69FOqDqT0Tj6R4uj+WyHTZ/uuV4XYQtxBX3kaxrvHFqNUPYc2FSfJUFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UgfDDmSf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UgfDDmSf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7041F000E9;
	Thu, 30 Jul 2026 14:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422039;
	bh=ArTVukRAoy6SLXmK7UnY8HiWb/SoiSt0fewG+TKDWFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UgfDDmSfb/XKTl+E7RLEIOlU4i7rUbXf6C3nMFoqwtxwtWVswG7IXAmlb0OlLzAIF
	 P8G0sk02ayc6DubZmn7q3xfWBdBmxujsZklbAEtNSrGf4lTBTdIch4j1in9iksjmBF
	 dZTCItLZQpN/+NuE0hiXa4q+wU9w9WsIaWHl1+Eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregor Herburger <gregor.herburger@linutronix.de>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 303/744] drm/vc4: hvs/v3d: Fix null dereference in unbind
Date: Thu, 30 Jul 2026 16:09:36 +0200
Message-ID: <20260730141450.730701406@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregor Herburger <gregor.herburger@linutronix.de>

[ Upstream commit 7dc3680b7ffe01add3e9299fde8471d2dd53a8ae ]

The hvs and v3d drivers use dev_get_drvdata(master) in their unbind
functions. Since the vc4-drm gets removed before its dependent drivers
(vc4_hvs/vc4_v3d) the vc4_hvs_unbind/vc4_v3d_unbind functions try to
get drvdata of its master and fails with a null dereference error.

Use the data pointer passed to the unbind functions directly instead of
dev_get_drvdata(master). This avoids using potentially freed memory.

Fixes: d3f5168a0810 ("drm/vc4: Bind and initialize the V3D engine.")
Fixes: c8b75bca92cb ("drm/vc4: Add KMS support for Raspberry Pi.")
Signed-off-by: Gregor Herburger <gregor.herburger@linutronix.de>
Link: https://patch.msgid.link/20260721-rpi-vc4-fix-v2-1-b813dcd01dc7@linutronix.de
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hvs.c | 2 +-
 drivers/gpu/drm/vc4/vc4_v3d.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hvs.c b/drivers/gpu/drm/vc4/vc4_hvs.c
index ee8d0738501b87..89359d1900087d 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -1752,7 +1752,7 @@ static int vc4_hvs_bind(struct device *dev, struct device *master, void *data)
 static void vc4_hvs_unbind(struct device *dev, struct device *master,
 			   void *data)
 {
-	struct drm_device *drm = dev_get_drvdata(master);
+	struct drm_device *drm = data;
 	struct vc4_dev *vc4 = to_vc4_dev(drm);
 	struct vc4_hvs *hvs = vc4->hvs;
 	struct drm_mm_node *node, *next;
diff --git a/drivers/gpu/drm/vc4/vc4_v3d.c b/drivers/gpu/drm/vc4/vc4_v3d.c
index d31b906cb8e787..f32410420d3e4d 100644
--- a/drivers/gpu/drm/vc4/vc4_v3d.c
+++ b/drivers/gpu/drm/vc4/vc4_v3d.c
@@ -494,7 +494,7 @@ static int vc4_v3d_bind(struct device *dev, struct device *master, void *data)
 static void vc4_v3d_unbind(struct device *dev, struct device *master,
 			   void *data)
 {
-	struct drm_device *drm = dev_get_drvdata(master);
+	struct drm_device *drm = data;
 	struct vc4_dev *vc4 = to_vc4_dev(drm);
 
 	vc4_irq_uninstall(drm);
-- 
2.53.0



