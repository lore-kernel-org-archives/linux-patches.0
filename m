Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BC0238C19;
	Mon, 23 Jun 2025 13:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685721; cv=none; b=HMYE3XpAUyX8BOlHeNiAWNM//E4h4sE+Z25AP3jDWE7DaXJ/PH+ZUtvmPPS5vC6LBoE9pqEQ/zfbcNS+ViFKoVz7R+aDlaubtOTLXLhpbm3QmQ3V6wohM+PE7ON41KDalqvqLUjNu87Hnjds+qS+Lq4c2NFlRVN5fKRGi4+RUpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685721; c=relaxed/simple;
	bh=ivifqEbW56J0I/MatNL9o5LyilIWFudjppYPp8gropY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CObdm/eq+p8IULBDtNV1gvaNbREiMF17S6gE+00FQXSeE1mcqiQdxS7VdiWGJgK2m+qBfYdb3R27jkyFzpz+zXah/dCSehJmCBTxIReHSfa9aipqOfRX1djG4GOf7APg3frPo/8X9deAzSZp0KMCeoNiQmM9H9Fs217KLm9OPQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMp/G9MB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMp/G9MB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17256C4CEEA;
	Mon, 23 Jun 2025 13:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685721;
	bh=ivifqEbW56J0I/MatNL9o5LyilIWFudjppYPp8gropY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yMp/G9MBOHohnoCz2/LiWjthe1A5AU0hqfe1f/Isqr3YLVQTrYfdai9v4ljGddyrz
	 nEH8QhvbwHOOqOZIpJtfcDwXALONxXiGa67X51eRn1Ukz6umEvCG0qhFmqZTjkP0nT
	 aiFWKsAhaBW4MruYHD/xq8R/KrD3Dy1Xulkh/wec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Rudorff <chris@rudorff.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 255/592] drm/nouveau: fix hibernate on disabled GPU
Date: Mon, 23 Jun 2025 15:03:33 +0200
Message-ID: <20250623130706.364331332@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

From: Christoph Rudorff <chris@rudorff.com>

[ Upstream commit 4c4d9b7b6c6e676eca22585139aba5f03de74b90 ]

Hibernate bricks the machine if a discrete GPU was disabled via

echo IGD > /sys/kernel/debug/vgaswitcheroo/switch

The freeze and thaw handler lacks checking the GPU power state,
as suspend and resume do.

This patch add the checks and fix this issue.

Signed-off-by: Christoph Rudorff <chris@rudorff.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://lore.kernel.org/r/20250325-nouveau-fix-hibernate-v2-1-2bd5c13fb953@rudorff.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_drm.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
index e154d08857c55..c69139701056d 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -1079,6 +1079,10 @@ nouveau_pmops_freeze(struct device *dev)
 {
 	struct nouveau_drm *drm = dev_get_drvdata(dev);
 
+	if (drm->dev->switch_power_state == DRM_SWITCH_POWER_OFF ||
+	    drm->dev->switch_power_state == DRM_SWITCH_POWER_DYNAMIC_OFF)
+		return 0;
+
 	return nouveau_do_suspend(drm, false);
 }
 
@@ -1087,6 +1091,10 @@ nouveau_pmops_thaw(struct device *dev)
 {
 	struct nouveau_drm *drm = dev_get_drvdata(dev);
 
+	if (drm->dev->switch_power_state == DRM_SWITCH_POWER_OFF ||
+	    drm->dev->switch_power_state == DRM_SWITCH_POWER_DYNAMIC_OFF)
+		return 0;
+
 	return nouveau_do_resume(drm, false);
 }
 
-- 
2.39.5



