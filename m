Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439DE27CCF0;
	Tue, 27 May 2025 17:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368250; cv=none; b=hnzTpGo6nZQqe7ip3/dnje2BTJ1ikg2uCB9/g1pbpkMa7uLNJ8Y+YpljliZBI9Cs8ceurWI5djm4dgx24/Jg0nW+WnIf7sJekFyRCRJX1z7tsH82be0NWIHNMQF79sHZXerr7t8WavRghsvCJDTK8SCTtAyjEEgEt4M4j5TPE2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368250; c=relaxed/simple;
	bh=rZlocFC/9CXgnRdHmDkkDp9F2s0elXvjb2m/90bPpzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1cY7lwdR1X51O2IWqSQ+1Fpo+ubGYsHKyTqrQzlrPZXOZ7heZJm9hhPawOpDy5O0wLx6wCzR9s0RJjGXyvGveJAhXFfYnbQW2IVdrkESUTApM/aQudbkobFacsp8wYaB85vGvVXHeyi0+uAYevL0S66TO8atZguML0gcy+jkQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3pxRcvl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3pxRcvl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C630BC4CEEA;
	Tue, 27 May 2025 17:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368250;
	bh=rZlocFC/9CXgnRdHmDkkDp9F2s0elXvjb2m/90bPpzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w3pxRcvlDy485v4CC2XdJdvpnphOecURJiFjswU7cvXoNCwQ/T+RGslyRuzI8mq/+
	 5jBg1o4CAHG/nl7pQJV/xQA0XWW4tTpOz8dNo578ydXF6EZ1nUzPl8ZsVYDGjzR410
	 +dlzVDzE9NAdpWQ0KIW61zQeUGBQsmouy0yDYWGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 616/783] drm/xe: Move suballocator init to after display init
Date: Tue, 27 May 2025 18:26:53 +0200
Message-ID: <20250527162538.234194269@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maarten Lankhorst <dev@lankhorst.se>

[ Upstream commit 380b0cdaa76bc8f5c16db16eaf48751e792ff041 ]

No allocations should be done before we have had a chance to preserve
the display fb.

Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241210083111.230484-4-dev@lankhorst.se
Signed-off-by: Maarten Lankhorst <dev@lankhorst.se>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_device.c |  6 ++++++
 drivers/gpu/drm/xe/xe_tile.c   | 12 ++++++++----
 drivers/gpu/drm/xe/xe_tile.h   |  1 +
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
index e22f29ac96631..74516e73ba4e5 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -736,6 +736,12 @@ int xe_device_probe(struct xe_device *xe)
 	if (err)
 		goto err;
 
+	for_each_tile(tile, xe, id) {
+		err = xe_tile_init(tile);
+		if (err)
+			goto err;
+	}
+
 	for_each_gt(gt, xe, id) {
 		last_gt = id;
 
diff --git a/drivers/gpu/drm/xe/xe_tile.c b/drivers/gpu/drm/xe/xe_tile.c
index 37f170effcd67..377438ea6b838 100644
--- a/drivers/gpu/drm/xe/xe_tile.c
+++ b/drivers/gpu/drm/xe/xe_tile.c
@@ -170,15 +170,19 @@ int xe_tile_init_noalloc(struct xe_tile *tile)
 	if (err)
 		return err;
 
-	tile->mem.kernel_bb_pool = xe_sa_bo_manager_init(tile, SZ_1M, 16);
-	if (IS_ERR(tile->mem.kernel_bb_pool))
-		return PTR_ERR(tile->mem.kernel_bb_pool);
-
 	xe_wa_apply_tile_workarounds(tile);
 
 	return xe_tile_sysfs_init(tile);
 }
 
+int xe_tile_init(struct xe_tile *tile)
+{
+	tile->mem.kernel_bb_pool = xe_sa_bo_manager_init(tile, SZ_1M, 16);
+	if (IS_ERR(tile->mem.kernel_bb_pool))
+		return PTR_ERR(tile->mem.kernel_bb_pool);
+
+	return 0;
+}
 void xe_tile_migrate_wait(struct xe_tile *tile)
 {
 	xe_migrate_wait(tile->migrate);
diff --git a/drivers/gpu/drm/xe/xe_tile.h b/drivers/gpu/drm/xe/xe_tile.h
index 1c9e42ade6b05..eb939316d55b0 100644
--- a/drivers/gpu/drm/xe/xe_tile.h
+++ b/drivers/gpu/drm/xe/xe_tile.h
@@ -12,6 +12,7 @@ struct xe_tile;
 
 int xe_tile_init_early(struct xe_tile *tile, struct xe_device *xe, u8 id);
 int xe_tile_init_noalloc(struct xe_tile *tile);
+int xe_tile_init(struct xe_tile *tile);
 
 void xe_tile_migrate_wait(struct xe_tile *tile);
 
-- 
2.39.5



