Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEFF1DDC23;
	Wed,  7 May 2025 18:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643723; cv=none; b=CdQ/JwVj4g2WOe66bL4qbgEyItw4sxgjdvb+6BRFfk8ltzEMGkMqBxaoNvLA8LzLBCbqeglpgl2TD9eFR52Vb5/xPBIyI7PvsfY/+oy6v2dnL7bYmvKz0evPBBGtockDoeNLvE/VxQGBii1fVYKRfrzdeE9Lw+T6ufy9MKwjPs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643723; c=relaxed/simple;
	bh=bs33OlJ2GKKUebo1ybu2VZfTVSlzgvlcojp3hePXHm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m9zSIC0mn9LucexyZSzVjnJkCYLNG4V3/lUdJJ3ylLFileNTD5gU0aZjzAJ/jN5XgfB7Gq3UelDoelkr/HDxBusg/jxDpOeSNiCIXv1YLx2UWk5mM7KuuWa3hJ+ANnmihwjBGRUsvZqbQmp9PenfJ0twtRYI3bfhoRRLq2WvGe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xbFm8gjC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xbFm8gjC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 347D4C4CEE2;
	Wed,  7 May 2025 18:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643722;
	bh=bs33OlJ2GKKUebo1ybu2VZfTVSlzgvlcojp3hePXHm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xbFm8gjCga1GX2QVvthsnvjlTuz3P+5pzNPfU5JmwwOmkZ7KYSDiTV7VC/MZu2u73
	 gdvFmjByFZgFi/B7o9dxiFtO8WBehQm7PlE/14Lx1zUnAoLp+NpQTLuen8UZgQ8j0Y
	 9ga07+y61vlVryF8nxEZTbsnvdIobhu9Y8GFU9X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Bainbridge <chris.bainbridge@gmail.com>,
	Alex Hung <alex.hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 95/97] drm/amd/display: Fix slab-use-after-free in hdcp
Date: Wed,  7 May 2025 20:40:10 +0200
Message-ID: <20250507183810.798210248@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Bainbridge <chris.bainbridge@gmail.com>

[ Upstream commit be593d9d91c5a3a363d456b9aceb71029aeb3f1d ]

The HDCP code in amdgpu_dm_hdcp.c copies pointers to amdgpu_dm_connector
objects without incrementing the kref reference counts. When using a
USB-C dock, and the dock is unplugged, the corresponding
amdgpu_dm_connector objects are freed, creating dangling pointers in the
HDCP code. When the dock is plugged back, the dangling pointers are
dereferenced, resulting in a slab-use-after-free:

[   66.775837] BUG: KASAN: slab-use-after-free in event_property_validate+0x42f/0x6c0 [amdgpu]
[   66.776171] Read of size 4 at addr ffff888127804120 by task kworker/0:1/10

[   66.776179] CPU: 0 UID: 0 PID: 10 Comm: kworker/0:1 Not tainted 6.14.0-rc7-00180-g54505f727a38-dirty #233
[   66.776183] Hardware name: HP HP Pavilion Aero Laptop 13-be0xxx/8916, BIOS F.17 12/18/2024
[   66.776186] Workqueue: events event_property_validate [amdgpu]
[   66.776494] Call Trace:
[   66.776496]  <TASK>
[   66.776497]  dump_stack_lvl+0x70/0xa0
[   66.776504]  print_report+0x175/0x555
[   66.776507]  ? __virt_addr_valid+0x243/0x450
[   66.776510]  ? kasan_complete_mode_report_info+0x66/0x1c0
[   66.776515]  kasan_report+0xeb/0x1c0
[   66.776518]  ? event_property_validate+0x42f/0x6c0 [amdgpu]
[   66.776819]  ? event_property_validate+0x42f/0x6c0 [amdgpu]
[   66.777121]  __asan_report_load4_noabort+0x14/0x20
[   66.777124]  event_property_validate+0x42f/0x6c0 [amdgpu]
[   66.777342]  ? __lock_acquire+0x6b40/0x6b40
[   66.777347]  ? enable_assr+0x250/0x250 [amdgpu]
[   66.777571]  process_one_work+0x86b/0x1510
[   66.777575]  ? pwq_dec_nr_in_flight+0xcf0/0xcf0
[   66.777578]  ? assign_work+0x16b/0x280
[   66.777580]  ? lock_is_held_type+0xa3/0x130
[   66.777583]  worker_thread+0x5c0/0xfa0
[   66.777587]  ? process_one_work+0x1510/0x1510
[   66.777588]  kthread+0x3a2/0x840
[   66.777591]  ? kthread_is_per_cpu+0xd0/0xd0
[   66.777594]  ? trace_hardirqs_on+0x4f/0x60
[   66.777597]  ? _raw_spin_unlock_irq+0x27/0x60
[   66.777599]  ? calculate_sigpending+0x77/0xa0
[   66.777602]  ? kthread_is_per_cpu+0xd0/0xd0
[   66.777605]  ret_from_fork+0x40/0x90
[   66.777607]  ? kthread_is_per_cpu+0xd0/0xd0
[   66.777609]  ret_from_fork_asm+0x11/0x20
[   66.777614]  </TASK>

[   66.777643] Allocated by task 10:
[   66.777646]  kasan_save_stack+0x39/0x60
[   66.777649]  kasan_save_track+0x14/0x40
[   66.777652]  kasan_save_alloc_info+0x37/0x50
[   66.777655]  __kasan_kmalloc+0xbb/0xc0
[   66.777658]  __kmalloc_cache_noprof+0x1c8/0x4b0
[   66.777661]  dm_dp_add_mst_connector+0xdd/0x5c0 [amdgpu]
[   66.777880]  drm_dp_mst_port_add_connector+0x47e/0x770 [drm_display_helper]
[   66.777892]  drm_dp_send_link_address+0x1554/0x2bf0 [drm_display_helper]
[   66.777901]  drm_dp_check_and_send_link_address+0x187/0x1f0 [drm_display_helper]
[   66.777909]  drm_dp_mst_link_probe_work+0x2b8/0x410 [drm_display_helper]
[   66.777917]  process_one_work+0x86b/0x1510
[   66.777919]  worker_thread+0x5c0/0xfa0
[   66.777922]  kthread+0x3a2/0x840
[   66.777925]  ret_from_fork+0x40/0x90
[   66.777927]  ret_from_fork_asm+0x11/0x20

[   66.777932] Freed by task 1713:
[   66.777935]  kasan_save_stack+0x39/0x60
[   66.777938]  kasan_save_track+0x14/0x40
[   66.777940]  kasan_save_free_info+0x3b/0x60
[   66.777944]  __kasan_slab_free+0x52/0x70
[   66.777946]  kfree+0x13f/0x4b0
[   66.777949]  dm_dp_mst_connector_destroy+0xfa/0x150 [amdgpu]
[   66.778179]  drm_connector_free+0x7d/0xb0
[   66.778184]  drm_mode_object_put.part.0+0xee/0x160
[   66.778188]  drm_mode_object_put+0x37/0x50
[   66.778191]  drm_atomic_state_default_clear+0x220/0xd60
[   66.778194]  __drm_atomic_state_free+0x16e/0x2a0
[   66.778197]  drm_mode_atomic_ioctl+0x15ed/0x2ba0
[   66.778200]  drm_ioctl_kernel+0x17a/0x310
[   66.778203]  drm_ioctl+0x584/0xd10
[   66.778206]  amdgpu_drm_ioctl+0xd2/0x1c0 [amdgpu]
[   66.778375]  __x64_sys_ioctl+0x139/0x1a0
[   66.778378]  x64_sys_call+0xee7/0xfb0
[   66.778381]  do_syscall_64+0x87/0x140
[   66.778385]  entry_SYSCALL_64_after_hwframe+0x4b/0x53

Fix this by properly incrementing and decrementing the reference counts
when making and deleting copies of the amdgpu_dm_connector pointers.

(Mario: rebase on current code and update fixes tag)

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4006
Signed-off-by: Chris Bainbridge <chris.bainbridge@gmail.com>
Fixes: da3fd7ac0bcf3 ("drm/amd/display: Update CP property based on HW query")
Reviewed-by: Alex Hung <alex.hung@amd.com>
Link: https://lore.kernel.org/r/20250417215005.37964-1-mario.limonciello@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d4673f3c3b3dcb74e36e53cdfc880baa7a87b330)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/amdgpu_dm/amdgpu_dm_hdcp.c    | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
index 6222d5a168832..6110d88efdbba 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
@@ -173,6 +173,9 @@ void hdcp_update_display(struct hdcp_workqueue *hdcp_work,
 	unsigned int conn_index = aconnector->base.index;
 
 	guard(mutex)(&hdcp_w->mutex);
+	drm_connector_get(&aconnector->base);
+	if (hdcp_w->aconnector[conn_index])
+		drm_connector_put(&hdcp_w->aconnector[conn_index]->base);
 	hdcp_w->aconnector[conn_index] = aconnector;
 
 	memset(&link_adjust, 0, sizeof(link_adjust));
@@ -220,7 +223,6 @@ static void hdcp_remove_display(struct hdcp_workqueue *hdcp_work,
 	unsigned int conn_index = aconnector->base.index;
 
 	guard(mutex)(&hdcp_w->mutex);
-	hdcp_w->aconnector[conn_index] = aconnector;
 
 	/* the removal of display will invoke auth reset -> hdcp destroy and
 	 * we'd expect the Content Protection (CP) property changed back to
@@ -236,7 +238,10 @@ static void hdcp_remove_display(struct hdcp_workqueue *hdcp_work,
 	}
 
 	mod_hdcp_remove_display(&hdcp_w->hdcp, aconnector->base.index, &hdcp_w->output);
-
+	if (hdcp_w->aconnector[conn_index]) {
+		drm_connector_put(&hdcp_w->aconnector[conn_index]->base);
+		hdcp_w->aconnector[conn_index] = NULL;
+	}
 	process_output(hdcp_w);
 }
 
@@ -254,6 +259,10 @@ void hdcp_reset_display(struct hdcp_workqueue *hdcp_work, unsigned int link_inde
 	for (conn_index = 0; conn_index < AMDGPU_DM_MAX_DISPLAY_INDEX; conn_index++) {
 		hdcp_w->encryption_status[conn_index] =
 			MOD_HDCP_ENCRYPTION_STATUS_HDCP_OFF;
+		if (hdcp_w->aconnector[conn_index]) {
+			drm_connector_put(&hdcp_w->aconnector[conn_index]->base);
+			hdcp_w->aconnector[conn_index] = NULL;
+		}
 	}
 
 	process_output(hdcp_w);
@@ -496,6 +505,7 @@ static void update_config(void *handle, struct cp_psp_stream_config *config)
 	struct hdcp_workqueue *hdcp_work = handle;
 	struct amdgpu_dm_connector *aconnector = config->dm_stream_ctx;
 	int link_index = aconnector->dc_link->link_index;
+	unsigned int conn_index = aconnector->base.index;
 	struct mod_hdcp_display *display = &hdcp_work[link_index].display;
 	struct mod_hdcp_link *link = &hdcp_work[link_index].link;
 	struct hdcp_workqueue *hdcp_w = &hdcp_work[link_index];
@@ -551,7 +561,10 @@ static void update_config(void *handle, struct cp_psp_stream_config *config)
 	guard(mutex)(&hdcp_w->mutex);
 
 	mod_hdcp_add_display(&hdcp_w->hdcp, link, display, &hdcp_w->output);
-
+	drm_connector_get(&aconnector->base);
+	if (hdcp_w->aconnector[conn_index])
+		drm_connector_put(&hdcp_w->aconnector[conn_index]->base);
+	hdcp_w->aconnector[conn_index] = aconnector;
 	process_output(hdcp_w);
 }
 
-- 
2.39.5



