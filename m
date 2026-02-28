Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5CC332628
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301250; cv=none; b=OfPKKdcpOj5nFYWH3o279L0oA/qX4bfxNcpzwMGLsOgHo8DUvXkY+EfktH2F1ItCEboL0/3x8V2rFUkql8lH9JD8FbM2QtmW8trEzCbjGz+vSmf6XI6UltdlC6+eEivAYtMmuvUuQtn/pWyuyPrPx4tyyoR5lDoyyPhu18PoQgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301250; c=relaxed/simple;
	bh=H2/NdalFP6eHHkDqaSO4ghxmtbECxKFkSBb3MuuJlEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GnqkeGsh1hOk3poENpvdXKrHvx/mj+jJhKC7ek3KsPKbUz1gG5Bon/AhE+scRp+C/knd0+dQD8VrWP6ChmIGG3bPnXDjUcf90X74jgC6IcGr0dLS1bavFA8yLLwcqRUG6Fejryt0a9cWQpIfSNCQmJf/QHanHtfd+16+W+e8QU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QLGcjhOP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QLGcjhOP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2FF6C116D0;
	Sat, 28 Feb 2026 17:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301250;
	bh=H2/NdalFP6eHHkDqaSO4ghxmtbECxKFkSBb3MuuJlEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QLGcjhOPY78QwMOhKNn94t1DcrtYBUIWOVQcPoydP31xOKA1LPz1JYqv30hVm1Pxc
	 TS+RG1t6IZbDNm1aJuw/x84ZsEc3GVnM3/kY6wpDH1nPn1WN7ZNv/bdb/DuCtR6Xlm
	 1+4/9ti+CPpzN7kiujN7mKeYhaC8goqLpj8txS3IcFJXqmtt3kiiFbgtuqrG+tf1aO
	 Y+7d/an+VZDoVVGok6jonMoPUfQvMbILE4T5lBC2KAgAK8uz2a3akKckhcqQIfn5HC
	 8fr6Bf/4Gz0mOQvjS9Et3RmIMPVYBZRNITCICHXFo0rv67+P7SOiQJs+De4qx6SGMR
	 yZY/3GVc8AJrg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jiri Pirko <jiri@nvidia.com>,
	syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 432/752] RDMA/core: Fix stale RoCE GIDs during netdev events at registration
Date: Sat, 28 Feb 2026 12:42:23 -0500
Message-ID: <20260228174750.1542406-432-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jiri Pirko <jiri@nvidia.com>

[ Upstream commit 9af0feae8016ba58ad7ff784a903404986b395b1 ]

RoCE GID entries become stale when netdev properties change during the
IB device registration window. This is reproducible with a udev rule
that sets a MAC address when a VF netdev appears:

  ACTION=="add", SUBSYSTEM=="net", KERNEL=="eth4", \
    RUN+="/sbin/ip link set eth4 address 88:22:33:44:55:66"

After VF creation, show_gids displays GIDs derived from the original
random MAC rather than the configured one.

The root cause is a race between netdev event processing and device
registration:

  CPU 0 (driver)                    CPU 1 (udev/workqueue)
  ──────────────                    ──────────────────────
  ib_register_device()
    ib_cache_setup_one()
      gid_table_setup_one()
        _gid_table_setup_one()
          ← GID table allocated
        rdma_roce_rescan_device()
          ← GIDs populated with
            OLD MAC
                                    ip link set eth4 addr NEW_MAC
                                    NETDEV_CHANGEADDR queued
                                    netdevice_event_work_handler()
                                      ib_enum_all_roce_netdevs()
                                        ← Iterates DEVICE_REGISTERED
                                        ← Device NOT marked yet, SKIP!
    enable_device_and_get()
      xa_set_mark(DEVICE_REGISTERED)
          ← Too late, event was lost

The netdev event handler uses ib_enum_all_roce_netdevs() which only
iterates devices marked DEVICE_REGISTERED. However, this mark is set
late in the registration process, after the GID cache is already
populated. Events arriving in this window are silently dropped.

Fix this by introducing a new xarray mark DEVICE_GID_UPDATES that is
set immediately after the GID table is allocated and initialized. Use
the new mark in ib_enum_all_roce_netdevs() function to iterate devices
instead of DEVICE_REGISTERED.

This is safe because:
- After _gid_table_setup_one(), all required structures exist (port_data,
  immutable, cache.gid)
- The GID table mutex serializes concurrent access between the initial
  rescan and event handlers
- Event handlers correctly update stale GIDs even when racing with rescan
- The mark is cleared in ib_cache_cleanup_one() before teardown

This also fixes similar races for IP address events (inetaddr_event,
inet6addr_event) which use the same enumeration path.

Fixes: 0df91bb67334 ("RDMA/devices: Use xarray to store the client_data")
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Link: https://patch.msgid.link/20260127093839.126291-1-jiri@resnulli.us
Reported-by: syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=881d65229ca4f9ae8c84
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cache.c     | 13 +++++++++++
 drivers/infiniband/core/core_priv.h |  3 +++
 drivers/infiniband/core/device.c    | 34 ++++++++++++++++++++++++++++-
 3 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 0fc1c5bce2f0d..78bc7d83edc65 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -927,6 +927,13 @@ static int gid_table_setup_one(struct ib_device *ib_dev)
 	if (err)
 		return err;
 
+	/*
+	 * Mark the device as ready for GID cache updates. This allows netdev
+	 * event handlers to update the GID cache even before the device is
+	 * fully registered.
+	 */
+	ib_device_enable_gid_updates(ib_dev);
+
 	rdma_roce_rescan_device(ib_dev);
 
 	return err;
@@ -1639,6 +1646,12 @@ void ib_cache_release_one(struct ib_device *device)
 
 void ib_cache_cleanup_one(struct ib_device *device)
 {
+	/*
+	 * Clear the GID updates mark first to prevent event handlers from
+	 * accessing the device while it's being torn down.
+	 */
+	ib_device_disable_gid_updates(device);
+
 	/* The cleanup function waits for all in-progress workqueue
 	 * elements and cleans up the GID cache. This function should be
 	 * called after the device was removed from the devices list and
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 05102769a918a..a2c36666e6fcb 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -100,6 +100,9 @@ void ib_enum_all_roce_netdevs(roce_netdev_filter filter,
 			      roce_netdev_callback cb,
 			      void *cookie);
 
+void ib_device_enable_gid_updates(struct ib_device *device);
+void ib_device_disable_gid_updates(struct ib_device *device);
+
 typedef int (*nldev_callback)(struct ib_device *device,
 			      struct sk_buff *skb,
 			      struct netlink_callback *cb,
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index e3ba236d7c09f..ac9aaef1e5e61 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -93,6 +93,7 @@ static struct workqueue_struct *ib_unreg_wq;
 static DEFINE_XARRAY_FLAGS(devices, XA_FLAGS_ALLOC);
 static DECLARE_RWSEM(devices_rwsem);
 #define DEVICE_REGISTERED XA_MARK_1
+#define DEVICE_GID_UPDATES XA_MARK_2
 
 static u32 highest_client_id;
 #define CLIENT_REGISTERED XA_MARK_1
@@ -2441,11 +2442,42 @@ void ib_enum_all_roce_netdevs(roce_netdev_filter filter,
 	unsigned long index;
 
 	down_read(&devices_rwsem);
-	xa_for_each_marked (&devices, index, dev, DEVICE_REGISTERED)
+	xa_for_each_marked(&devices, index, dev, DEVICE_GID_UPDATES)
 		ib_enum_roce_netdev(dev, filter, filter_cookie, cb, cookie);
 	up_read(&devices_rwsem);
 }
 
+/**
+ * ib_device_enable_gid_updates - Mark device as ready for GID cache updates
+ * @device: Device to mark
+ *
+ * Called after GID table is allocated and initialized. After this mark is set,
+ * netdevice event handlers can update the device's GID cache. This allows
+ * events that arrive during device registration to be processed, avoiding
+ * stale GID entries when netdev properties change during the device
+ * registration process.
+ */
+void ib_device_enable_gid_updates(struct ib_device *device)
+{
+	down_write(&devices_rwsem);
+	xa_set_mark(&devices, device->index, DEVICE_GID_UPDATES);
+	up_write(&devices_rwsem);
+}
+
+/**
+ * ib_device_disable_gid_updates - Clear the GID updates mark
+ * @device: Device to unmark
+ *
+ * Called before GID table cleanup to prevent event handlers from accessing
+ * the device while it's being torn down.
+ */
+void ib_device_disable_gid_updates(struct ib_device *device)
+{
+	down_write(&devices_rwsem);
+	xa_clear_mark(&devices, device->index, DEVICE_GID_UPDATES);
+	up_write(&devices_rwsem);
+}
+
 /*
  * ib_enum_all_devs - enumerate all ib_devices
  * @cb: Callback to call for each found ib_device
-- 
2.51.0

