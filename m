Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E20E221F14;
	Tue, 17 Jun 2025 16:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176275; cv=none; b=U0VnhZom1fkRLcyZwGwNMB6QU6hgykDh7BDQszAIyEoS5Xt/5VNUaOzwecS4PojBG7Wl31u2d8euDX61JO2a7qDjKt5E/1LCromJIeW3ZB6wmtCxpJsgF5BJnwTARbM9pW9Zq1HztgsKrED5KHrWV0B0nhYhzezOIecAcFD2dzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176275; c=relaxed/simple;
	bh=aZy3ypc3QMVVFsIjZB8s9Ycd0JKSb9h8kKppu7S7F8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zg4YGLjMXCEk+8gEkKpYa1yger57ugcSzsXv6yDUMpkR48Tpc410xlTmj32fOqDtqCIrAA8WJ7z6jHEfygfXf7o3Uvepo/ybmQAn6vTKARjVEk4AA9+kZHAFrk0r/LaVAOx5lEzORSeSJywKu9X3MKvIry/r6za1/zRY1+SfH2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yWiK2Zsf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWiK2Zsf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A851FC4CEE3;
	Tue, 17 Jun 2025 16:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176275;
	bh=aZy3ypc3QMVVFsIjZB8s9Ycd0JKSb9h8kKppu7S7F8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yWiK2ZsfJsVDqZgJ6A0kRFcLG5OonQ500ex//QIMgU2cLiPcF4j2ut//AyFGKyoUz
	 b4GVkylbTJwAY+ci7/xc+5Zw6dIAsCOFQNVH0VVhmQzjkBDhYviWzHfNxnphuo1YEc
	 9sgMw0mNt01hD/I46lW+9gYZUrhzfOa9UIovzrFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 156/780] drm/xe/guc: Refactor GuC debugfs initialization
Date: Tue, 17 Jun 2025 17:17:44 +0200
Message-ID: <20250617152457.849019049@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit e15826bb3c2c5377eedc757f2adec8dcaa5255f7 ]

We don't have to drmm_kmalloc() local copy of debugfs_list to
write there our pointer to the struct xe_guc as we can extract
pointer to the struct xe_gt from the grandparent debugfs entry,
in similar way to what we did for GT debugfs files.

Note that there is no change in file/directory structure, just
refactored how files are created and how functions are called.

Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://lore.kernel.org/r/20250403142635.1821-2-michal.wajdeczko@intel.com
Stable-dep-of: e22d7acf9f47 ("drm/xe/guc: Make creation of SLPC debugfs files conditional")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_debugfs.c | 130 ++++++++++++++--------------
 1 file changed, 67 insertions(+), 63 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_debugfs.c b/drivers/gpu/drm/xe/xe_guc_debugfs.c
index c569ff456e741..9a1c78b89f457 100644
--- a/drivers/gpu/drm/xe/xe_guc_debugfs.c
+++ b/drivers/gpu/drm/xe/xe_guc_debugfs.c
@@ -17,101 +17,105 @@
 #include "xe_macros.h"
 #include "xe_pm.h"
 
-static struct xe_guc *node_to_guc(struct drm_info_node *node)
-{
-	return node->info_ent->data;
-}
-
-static int guc_info(struct seq_file *m, void *data)
+/*
+ * guc_debugfs_show - A show callback for struct drm_info_list
+ * @m: the &seq_file
+ * @data: data used by the drm debugfs helpers
+ *
+ * This callback can be used in struct drm_info_list to describe debugfs
+ * files that are &xe_guc specific in similar way how we handle &xe_gt
+ * specific files using &xe_gt_debugfs_simple_show.
+ *
+ * It is assumed that those debugfs files will be created on directory entry
+ * which grandparent struct dentry d_inode->i_private points to &xe_gt.
+ *
+ *      /sys/kernel/debug/dri/0/
+ *      ├── gt0			# dent->d_parent->d_parent (d_inode->i_private == gt)
+ *      │   ├── uc		# dent->d_parent
+ *      │   │   ├── guc_info	# dent
+ *      │   │   ├── guc_...
+ *
+ * This function assumes that &m->private will be set to the &struct
+ * drm_info_node corresponding to the instance of the info on a given &struct
+ * drm_minor (see struct drm_info_list.show for details).
+ *
+ * This function also assumes that struct drm_info_list.data will point to the
+ * function code that will actually print a file content::
+ *
+ *    int (*print)(struct xe_guc *, struct drm_printer *)
+ *
+ * Example::
+ *
+ *    int foo(struct xe_guc *guc, struct drm_printer *p)
+ *    {
+ *        drm_printf(p, "enabled %d\n", guc->submission_state.enabled);
+ *        return 0;
+ *    }
+ *
+ *    static const struct drm_info_list bar[] = {
+ *        { name = "foo", .show = guc_debugfs_show, .data = foo },
+ *    };
+ *
+ *    parent = debugfs_create_dir("uc", gtdir);
+ *    drm_debugfs_create_files(bar, ARRAY_SIZE(bar), parent, minor);
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+static int guc_debugfs_show(struct seq_file *m, void *data)
 {
-	struct xe_guc *guc = node_to_guc(m->private);
-	struct xe_device *xe = guc_to_xe(guc);
 	struct drm_printer p = drm_seq_file_printer(m);
+	struct drm_info_node *node = m->private;
+	struct dentry *parent = node->dent->d_parent;
+	struct dentry *grandparent = parent->d_parent;
+	struct xe_gt *gt = grandparent->d_inode->i_private;
+	struct xe_device *xe = gt_to_xe(gt);
+	int (*print)(struct xe_guc *, struct drm_printer *) = node->info_ent->data;
+	int ret;
 
 	xe_pm_runtime_get(xe);
-	xe_guc_print_info(guc, &p);
+	ret = print(&gt->uc.guc, &p);
 	xe_pm_runtime_put(xe);
 
-	return 0;
+	return ret;
 }
 
-static int guc_log(struct seq_file *m, void *data)
+static int guc_log(struct xe_guc *guc, struct drm_printer *p)
 {
-	struct xe_guc *guc = node_to_guc(m->private);
-	struct xe_device *xe = guc_to_xe(guc);
-	struct drm_printer p = drm_seq_file_printer(m);
-
-	xe_pm_runtime_get(xe);
-	xe_guc_log_print(&guc->log, &p);
-	xe_pm_runtime_put(xe);
-
+	xe_guc_log_print(&guc->log, p);
 	return 0;
 }
 
-static int guc_log_dmesg(struct seq_file *m, void *data)
+static int guc_log_dmesg(struct xe_guc *guc, struct drm_printer *p)
 {
-	struct xe_guc *guc = node_to_guc(m->private);
-	struct xe_device *xe = guc_to_xe(guc);
-
-	xe_pm_runtime_get(xe);
 	xe_guc_log_print_dmesg(&guc->log);
-	xe_pm_runtime_put(xe);
-
 	return 0;
 }
 
-static int guc_ctb(struct seq_file *m, void *data)
+static int guc_ctb(struct xe_guc *guc, struct drm_printer *p)
 {
-	struct xe_guc *guc = node_to_guc(m->private);
-	struct xe_device *xe = guc_to_xe(guc);
-	struct drm_printer p = drm_seq_file_printer(m);
-
-	xe_pm_runtime_get(xe);
-	xe_guc_ct_print(&guc->ct, &p, true);
-	xe_pm_runtime_put(xe);
-
+	xe_guc_ct_print(&guc->ct, p, true);
 	return 0;
 }
 
-static int guc_pc(struct seq_file *m, void *data)
+static int guc_pc(struct xe_guc *guc, struct drm_printer *p)
 {
-	struct xe_guc *guc = node_to_guc(m->private);
-	struct xe_device *xe = guc_to_xe(guc);
-	struct drm_printer p = drm_seq_file_printer(m);
-
-	xe_pm_runtime_get(xe);
-	xe_guc_pc_print(&guc->pc, &p);
-	xe_pm_runtime_put(xe);
-
+	xe_guc_pc_print(&guc->pc, p);
 	return 0;
 }
 
 static const struct drm_info_list debugfs_list[] = {
-	{"guc_info", guc_info, 0},
-	{"guc_log", guc_log, 0},
-	{"guc_log_dmesg", guc_log_dmesg, 0},
-	{"guc_ctb", guc_ctb, 0},
-	{"guc_pc", guc_pc, 0},
+	{ "guc_info", .show = guc_debugfs_show, .data = xe_guc_print_info },
+	{ "guc_log", .show = guc_debugfs_show, .data = guc_log },
+	{ "guc_log_dmesg", .show = guc_debugfs_show, .data = guc_log_dmesg },
+	{ "guc_ctb", .show = guc_debugfs_show, .data = guc_ctb },
+	{ "guc_pc", .show = guc_debugfs_show, .data = guc_pc },
 };
 
 void xe_guc_debugfs_register(struct xe_guc *guc, struct dentry *parent)
 {
 	struct drm_minor *minor = guc_to_xe(guc)->drm.primary;
-	struct drm_info_list *local;
-	int i;
-
-#define DEBUGFS_SIZE	(ARRAY_SIZE(debugfs_list) * sizeof(struct drm_info_list))
-	local = drmm_kmalloc(&guc_to_xe(guc)->drm, DEBUGFS_SIZE, GFP_KERNEL);
-	if (!local)
-		return;
-
-	memcpy(local, debugfs_list, DEBUGFS_SIZE);
-#undef DEBUGFS_SIZE
-
-	for (i = 0; i < ARRAY_SIZE(debugfs_list); ++i)
-		local[i].data = guc;
 
-	drm_debugfs_create_files(local,
+	drm_debugfs_create_files(debugfs_list,
 				 ARRAY_SIZE(debugfs_list),
 				 parent, minor);
 }
-- 
2.39.5



