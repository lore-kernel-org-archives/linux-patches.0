Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AE214C5B8;
	Wed, 19 Jun 2024 13:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803278; cv=none; b=uu8ZygwPSnEbsLrBRCpFhPvWsOlxDQv1fJi5u6GCsdd/jChytEh1fUQ/kojN0vHbxW/lQdYzaaKTp9FZBUF0728eFIoXdkLv+oyEvHXwSbWR7sNqGuDWs8HzuHXtXdpl90jHNLlJ1XOGfNzXRkPiKgu3l33dNYRihiy8CoQi6Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803278; c=relaxed/simple;
	bh=fmT5AtlN1JO0+48DGXsJXNyyTwTOcSrAS3gF25dwG/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bkvkcqj/07pu8gIkDjsNYC9zU7+5x5IeGOj6SPJN8/SqGOSBWutsVisLvpBFQAXmkj9VHbvYGkCH7h6vPXdjd62mQelH4iu0Yf5CkzrS7sMtV/iXHC5HCQWFutgYtN9pBdodgxhdSVtdocJCN29wGYRHeaUTukf2+rx+3HlefVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pbrvIqEt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pbrvIqEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1415BC2BBFC;
	Wed, 19 Jun 2024 13:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803278;
	bh=fmT5AtlN1JO0+48DGXsJXNyyTwTOcSrAS3gF25dwG/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pbrvIqEtCC0zvXy+r5J6u8MaHT0CuscvC3avUky1GdVXynODjf6t+EVy+1P0sdPHm
	 cww2fzC57y8Cy3gPe6LJ6NhqAK7xWaEiok8udKyrV76TjSRivC9C3ZPeY8ujxol08X
	 YvEkM9U1nYv64iERtOMIJDMOrQGRSKc2aDw7Nhcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Riana Tauro <riana.tauro@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 182/281] drm/xe: move disable_c6 call
Date: Wed, 19 Jun 2024 14:55:41 +0200
Message-ID: <20240619125616.839718122@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Riana Tauro <riana.tauro@intel.com>

[ Upstream commit 2470b141bfae2b9695b5b6823e3b978b22d33dde ]

disable c6 called in guc_pc_fini_hw is unreachable.

GuC PC init returns earlier if skip_guc_pc is true and never
registers the finish call thus making disable_c6 unreachable.

move this call to gt idle.

v2: rebase
v3: add fixes tag (Himal)

Fixes: 975e4a3795d4 ("drm/xe: Manually setup C6 when skip_guc_pc is set")
Signed-off-by: Riana Tauro <riana.tauro@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240606100842.956072-3-riana.tauro@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 6800e63cf97bae62bca56d8e691544540d945f53)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_idle.c | 7 +++++++
 drivers/gpu/drm/xe/xe_guc_pc.c  | 6 ------
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_idle.c b/drivers/gpu/drm/xe/xe_gt_idle.c
index 1521b3d9933c7..e7a39ad7adba0 100644
--- a/drivers/gpu/drm/xe/xe_gt_idle.c
+++ b/drivers/gpu/drm/xe/xe_gt_idle.c
@@ -126,6 +126,13 @@ static const struct attribute *gt_idle_attrs[] = {
 static void gt_idle_sysfs_fini(struct drm_device *drm, void *arg)
 {
 	struct kobject *kobj = arg;
+	struct xe_gt *gt = kobj_to_gt(kobj->parent);
+
+	if (gt_to_xe(gt)->info.skip_guc_pc) {
+		XE_WARN_ON(xe_force_wake_get(gt_to_fw(gt), XE_FW_GT));
+		xe_gt_idle_disable_c6(gt);
+		xe_force_wake_put(gt_to_fw(gt), XE_FW_GT);
+	}
 
 	sysfs_remove_files(kobj, gt_idle_attrs);
 	kobject_put(kobj);
diff --git a/drivers/gpu/drm/xe/xe_guc_pc.c b/drivers/gpu/drm/xe/xe_guc_pc.c
index f4b031b8d9deb..dd9d65f923da7 100644
--- a/drivers/gpu/drm/xe/xe_guc_pc.c
+++ b/drivers/gpu/drm/xe/xe_guc_pc.c
@@ -920,12 +920,6 @@ int xe_guc_pc_stop(struct xe_guc_pc *pc)
 static void xe_guc_pc_fini(struct drm_device *drm, void *arg)
 {
 	struct xe_guc_pc *pc = arg;
-	struct xe_device *xe = pc_to_xe(pc);
-
-	if (xe->info.skip_guc_pc) {
-		xe_gt_idle_disable_c6(pc_to_gt(pc));
-		return;
-	}
 
 	xe_force_wake_get(gt_to_fw(pc_to_gt(pc)), XE_FORCEWAKE_ALL);
 	XE_WARN_ON(xe_guc_pc_gucrc_disable(pc));
-- 
2.43.0



