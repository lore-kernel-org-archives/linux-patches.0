Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442B53B2D18;
	Thu, 16 Jul 2026 13:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209246; cv=none; b=NjS0f0+iukFygtXHQFQlld+q3Y+wsMF1ZRm8Ft432LfH7nsXSvD9uzwy//la63WaUEzXqrIAWtSkxSoqdo4emJuGhRXUlZjqvQzb5VC/3JK5BwFN/dQVMnr1trn/Rf9IdOee2o+mAzRC9QNVO6XzFHWLCGeKf19qTaHtTR4YS4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209246; c=relaxed/simple;
	bh=gLmiAt0UmA3oR9IfDGGe8aPzu1W+jXCNCDf1Tm6xJ0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hGRJQFis5lYOb89WE9sFYrarUPIyo6bB2RjJYWHwIVJvvsHQEqNmbjwXbzYCQtRjnHUxQPkw8xWkmbxfxaxXx82MM3wr/MtaYFJGYLBS7Pum2Nf0R1lJ0zL9z41cyPw98FcEVH4I7m7WxGQsQoVoG4pHRtqKnpm/4ZNlbRKMa7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W8+DNFTa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W8+DNFTa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F2E1F000E9;
	Thu, 16 Jul 2026 13:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209245;
	bh=DcP7OQdYle5ZaDayMCKPuMT9aXahHQuF//miJojmb3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W8+DNFTa9zTZCPhwEmZOjB6dpNEopyFnk4BEJSbJr14nq4ywIkSDZ68WkatvwNZV9
	 OWNG8JerI/uOx1nw3HuCNfsIUGyoxWmWUyRy5K30/kTZVVeE4y1ggeII5owBD+8Ize
	 ZTkuvA0BEN6MOxzHElS7xYOqFDBc+FtVE27yROrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI Review <sashiko-bot@kernel.org>,
	Longfang Liu <liulongfang@huawei.com>,
	Alex Williamson <alex.williamson@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>
Subject: [PATCH 7.1 111/518] vfio: Remove device debugfs before releasing devres
Date: Thu, 16 Jul 2026 15:26:19 +0200
Message-ID: <20260716133050.281205291@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

From: Alex Williamson <alex.williamson@nvidia.com>

commit dc7fe87de492ea7f33a72b78d26650b75bf37f4f upstream.

VFIO device debugfs files created with debugfs_create_devm_seqfile()
store a devres allocated debugfs_devm_entry as inode private data.
vfio_unregister_group_dev() currently calls vfio_device_del() before
vfio_device_debugfs_exit(), but device_del() releases devres.  This can
leave debugfs entries visible with stale inode private data while
unregister waits for userspace references to drain.

Remove the per-device debugfs tree before vfio_device_del().  The debugfs
view is diagnostic only, so losing it at the start of unregister is
preferable to preserving entries whose backing storage may already have
been released.

Complete the teardown by clearing the per-device debugfs root after
removal.  This matches the global debugfs root cleanup and prevents
future users from mistaking a removed dentry for a live debugfs tree
during the remainder of unregister.

Fixes: 2202844e4468 ("vfio/migration: Add debugfs to live migration driver")
Reported-by: Sashiko AI Review <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/r/20260615192725.6A2221F000E9@smtp.kernel.org
Cc: stable@vger.kernel.org
Cc: Longfang Liu <liulongfang@huawei.com>
Assisted-by: OpenAI Codex:gpt-5
Signed-off-by: Alex Williamson <alex.williamson@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20260615204717.735302-1-alex.williamson@nvidia.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/debugfs.c   |    1 +
 drivers/vfio/vfio_main.c |    8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/vfio/debugfs.c
+++ b/drivers/vfio/debugfs.c
@@ -97,6 +97,7 @@ void vfio_device_debugfs_init(struct vfi
 void vfio_device_debugfs_exit(struct vfio_device *vdev)
 {
 	debugfs_remove_recursive(vdev->debug_root);
+	vdev->debug_root = NULL;
 }
 
 void vfio_debugfs_create_root(void)
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -407,6 +407,13 @@ void vfio_unregister_group_dev(struct vf
 	vfio_device_group_unregister(device);
 
 	/*
+	 * Remove debugfs before device_del(), which releases devres.  Some
+	 * debugfs entries are created with debugfs_create_devm_seqfile() and
+	 * therefore rely on devres-managed inode private data.
+	 */
+	vfio_device_debugfs_exit(device);
+
+	/*
 	 * Balances vfio_device_add() in register path, also prevents
 	 * new device opened by userspace in the cdev path.
 	 */
@@ -435,7 +442,6 @@ void vfio_unregister_group_dev(struct vf
 		}
 	}
 
-	vfio_device_debugfs_exit(device);
 	/* Balances vfio_device_set_group in register path */
 	vfio_device_remove_group(device);
 }


