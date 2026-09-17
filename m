Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6021B51C075;
	Thu, 17 Sep 2026 17:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665061; cv=none; b=NYDHO/GtXRkuqiXzi5XdKSmP3rsL4FIEVRmhRF6jRXtgBdankpZ4w8SjWmqp+CEfEz35TkLBMClW94lq7dOoprFZQh9RPlICdvjQOe3Nd8HvoWS0C6VsI9fqyCDzW0TZ+oe1h5nHabjBdxJz7h7eKCH/EMghe/q8CepVuemHdYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665061; c=relaxed/simple;
	bh=7nziwpi1kYvqYMwBoDspXpTWNFgZt1NMTKblM7SPJGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r2pUdWFfRhfCPJcih6mk8mbf1fJStpOINAjwEwKbz9wZaJ8YhB8ZHpmyl+CMqeD3RCWANcK1FyzexxhjpiH6YtMZC3a4R2dCwjK1YnVNgfg/LK6be8ysGfqKt1Q99gYaZ0h2MUmQjJGOYMVk35L/dWaGug5RUNNJtJ6+Xrwy9PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YqdPBzQm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YqdPBzQm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A861F1F00893;
	Thu, 17 Sep 2026 17:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665059;
	bh=iF0L+yDokrbrYQ8R+yuYMpQ1KZo70Gs2aS6m2vsUVzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YqdPBzQmdVobmweOl8uZ3q2tT0s/qNZyISPPrnv8qLnAxasswrUKpduOZPaDKuo1M
	 wylD8amynEbnala0M3J1QxNbz+2y0Kgm4MZUkX4HlOZNuCwh7eSie/kueqvM+BB0CN
	 /cEzHB43TIv0a6DzZE/d4tIZFxdxE7aPi+XDo7Ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregor Herburger <gregor.herburger@linutronix.de>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0579/1250] drm/vc4: hvs/v3d: Fix null dereference in unbind
Date: Thu, 17 Sep 2026 16:06:14 +0100
Message-ID: <20260917151607.586881832@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4811d794001fa..1a76f85d0fad5 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -1751,7 +1751,7 @@ static int vc4_hvs_bind(struct device *dev, struct device *master, void *data)
 static void vc4_hvs_unbind(struct device *dev, struct device *master,
 			   void *data)
 {
-	struct drm_device *drm = dev_get_drvdata(master);
+	struct drm_device *drm = data;
 	struct vc4_dev *vc4 = to_vc4_dev(drm);
 	struct vc4_hvs *hvs = vc4->hvs;
 	struct drm_mm_node *node, *next;
diff --git a/drivers/gpu/drm/vc4/vc4_v3d.c b/drivers/gpu/drm/vc4/vc4_v3d.c
index e470412851cc8..68f098e45944c 100644
--- a/drivers/gpu/drm/vc4/vc4_v3d.c
+++ b/drivers/gpu/drm/vc4/vc4_v3d.c
@@ -492,7 +492,7 @@ static int vc4_v3d_bind(struct device *dev, struct device *master, void *data)
 static void vc4_v3d_unbind(struct device *dev, struct device *master,
 			   void *data)
 {
-	struct drm_device *drm = dev_get_drvdata(master);
+	struct drm_device *drm = data;
 	struct vc4_dev *vc4 = to_vc4_dev(drm);
 
 	vc4_irq_uninstall(drm);
-- 
2.53.0



