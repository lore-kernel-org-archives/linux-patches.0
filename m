Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1867A3C10BF;
	Wed, 30 Sep 2026 19:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794891; cv=none; b=RWv63lZ5GOE/QwaHUCYhvb0dtF1zYDdSc/VMPM4pED3mO4XovM/9jQbauCntsk+MPt+OPPN5m2sNZqpSYkIzUsECqZEtmhR7QkcUI62hWyf1PbrbwDCoNZUvg6QFwH9MH8Th0LHFRGdYHNv+/rZF6FWxizIWmwfxtFZAP4ZxQJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794891; c=relaxed/simple;
	bh=DmHRfnOEyIcXbJ2NMN3olKv6oRSF9yGEgaTUZwgmqk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lbQXbVwoG6HBM3+1KFo1HzmpSNWU4qQDwx+/01dJg/Uew+ya7kFPPJFYOjJxmKy1sxxIZx0h2k3YeS49BZ+Yan4+qZKSGO/0Z7ktoDEWKQZFpWgnJjNtxAD+9QQXymBdBirEciU1lWsa8Y4v37blofGfkpfkOX33rfw2DQvLGpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nVZvgwws; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nVZvgwws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DAC1F000FF;
	Wed, 30 Sep 2026 19:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794889;
	bh=+vfvVLa4ZxwhdvF+UxDq0Xgt3VFbvvbEXtOykaZ4Hhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nVZvgwwsAEttLV6y0f+ZehAdtWkYxqawTWk+bWS9/0zboHX0l6Sh85fWEKRwddStw
	 8gbI+k6BOklrISTgQnpUajh/zbCP+xosme9ZFdsn+QwBbTDVv+vRO7jdQDOFi11qxF
	 WudCUj3thHPcIy4uJX5CXzmHKsUOmGl962xjLxD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Saravana Kannan <saravanak@google.com>,
	Kalle Niemi <kaleposti@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0367/1193] of: dynamic: Fix overlayed devices not probing because of fw_devlink
Date: Wed, 30 Sep 2026 17:17:31 +0200
Message-ID: <20260930152442.331319268@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saravana Kannan <saravanak@google.com>

[ Upstream commit 81e7c6befa36cecdcbf7244393bd67e8f8c59bf5 ]

When an overlay is applied, if the target device has already probed
successfully and bound to a device, then some of the fw_devlink logic
that ran when the device was probed needs to be rerun. This allows newly
created dangling consumers of the overlayed device tree nodes to be
moved to become consumers of the target device.

[Herve: Add the call to driver_deferred_probe_trigger()]
[Herve: Use fwnode_test_flag() to test fwnode flags value]

Fixes: 1a50d9403fb9 ("treewide: Fix probing of devices in DT overlays")
Reported-by: Herve Codina <herve.codina@bootlin.com>
Closes: https://lore.kernel.org/lkml/CAMuHMdXEnSD4rRJ-o90x4OprUacN_rJgyo8x6=9F9rZ+-KzjOg@mail.gmail.com/
Closes: https://lore.kernel.org/all/20240221095137.616d2aaa@bootlin.com/
Closes: https://lore.kernel.org/lkml/20240312151835.29ef62a0@bootlin.com/
Signed-off-by: Saravana Kannan <saravanak@google.com>
Link: https://lore.kernel.org/lkml/20240411235623.1260061-3-saravanak@google.com/
[Herve: Rebase on top of recent kernel]
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Tested-by: Kalle Niemi <kaleposti@gmail.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Link: https://patch.msgid.link/20260511155755.34428-3-herve.codina@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c    | 81 ++++++++++++++++++++++++++++++++++++++----
 drivers/of/overlay.c   | 15 ++++++++
 include/linux/fwnode.h |  1 +
 3 files changed, 90 insertions(+), 7 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 5048849cb97a9..72ca11da6986f 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -235,6 +235,79 @@ static void __fw_devlink_pickup_dangling_consumers(struct fwnode_handle *fwnode,
 		__fw_devlink_pickup_dangling_consumers(child, new_sup);
 }
 
+static void fw_devlink_pickup_dangling_consumers(struct device *dev)
+{
+	struct fwnode_handle *child;
+
+	guard(mutex)(&fwnode_link_lock);
+
+	fwnode_for_each_available_child_node(dev->fwnode, child)
+		__fw_devlink_pickup_dangling_consumers(child, dev->fwnode);
+	__fw_devlink_link_to_consumers(dev);
+}
+
+/**
+ * fw_devlink_refresh_fwnode - Recheck the tree under this firmware node
+ * @fwnode: The fwnode under which the fwnode tree has changed
+ *
+ * This function is mainly meant to adjust the supplier/consumer dependencies
+ * after a fwnode tree overlay has occurred.
+ */
+void fw_devlink_refresh_fwnode(struct fwnode_handle *fwnode)
+{
+	struct device *dev;
+
+	/*
+	 * Find the closest ancestor fwnode that has been converted to a device
+	 * that can bind to a driver (bus device).
+	 */
+	fwnode_handle_get(fwnode);
+	do {
+		if (fwnode_test_flag(fwnode, FWNODE_FLAG_NOT_DEVICE))
+			continue;
+
+		dev = get_dev_from_fwnode(fwnode);
+		if (!dev)
+			continue;
+
+		if (dev->bus)
+			break;
+
+		put_device(dev);
+	} while ((fwnode = fwnode_get_next_parent(fwnode)));
+
+	/*
+	 * If none of the ancestor fwnodes have (yet) been converted to a device
+	 * that can bind to a driver, there's nothing to fix up.
+	 */
+	if (!fwnode)
+		return;
+
+	WARN(device_is_bound(dev) && dev->links.status != DL_DEV_DRIVER_BOUND,
+	     "Don't multithread overlaying and probing the same device!\n");
+
+	/*
+	 * If the device has already bound to a driver, then we need to redo
+	 * some of the work that was done after the device was bound to a
+	 * driver. If the device hasn't bound to a driver, running things too
+	 * soon would incorrectly pick up consumers that it shouldn't.
+	 */
+	if (dev->links.status == DL_DEV_DRIVER_BOUND) {
+		fw_devlink_pickup_dangling_consumers(dev);
+		/*
+		 * Some of dangling consumers could have been put previously in
+		 * the deferred probe list due to the unavailability of their
+		 * suppliers. Those consumers have been picked up and some of
+		 * their suppliers links have been updated. Time to re-try their
+		 * probe sequence.
+		 */
+		driver_deferred_probe_trigger();
+	}
+
+	put_device(dev);
+	fwnode_handle_put(fwnode);
+}
+
 static DEFINE_MUTEX(device_links_lock);
 DEFINE_STATIC_SRCU(device_links_srcu);
 
@@ -1320,14 +1393,8 @@ void device_links_driver_bound(struct device *dev)
 	 * child firmware node.
 	 */
 	if (dev->fwnode && dev->fwnode->dev == dev) {
-		struct fwnode_handle *child;
 		fwnode_links_purge_suppliers(dev->fwnode);
-		mutex_lock(&fwnode_link_lock);
-		fwnode_for_each_available_child_node(dev->fwnode, child)
-			__fw_devlink_pickup_dangling_consumers(child,
-							       dev->fwnode);
-		__fw_devlink_link_to_consumers(dev);
-		mutex_unlock(&fwnode_link_lock);
+		fw_devlink_pickup_dangling_consumers(dev);
 	}
 	device_remove_file(dev, &dev_attr_waiting_for_supplier);
 
diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
index dc13299586414..1a52acff72add 100644
--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -179,6 +179,15 @@ static int overlay_notify(struct overlay_changeset *ovcs,
 	return 0;
 }
 
+static void overlay_fw_devlink_refresh(struct overlay_changeset *ovcs)
+{
+	for (int i = 0; i < ovcs->count; i++) {
+		struct device_node *np = ovcs->fragments[i].target;
+
+		fw_devlink_refresh_fwnode(of_fwnode_handle(np));
+	}
+}
+
 /*
  * The values of properties in the "/__symbols__" node are paths in
  * the ovcs->overlay_root.  When duplicating the properties, the paths
@@ -948,6 +957,12 @@ static int of_overlay_apply(struct overlay_changeset *ovcs,
 		pr_err("overlay apply changeset entry notify error %d\n", ret);
 	/* notify failure is not fatal, continue */
 
+	/*
+	 * Needs to happen after changeset notify to give the listeners a chance
+	 * to finish creating all the devices they need to create.
+	 */
+	overlay_fw_devlink_refresh(ovcs);
+
 	ret_tmp = overlay_notify(ovcs, OF_OVERLAY_POST_APPLY);
 	if (ret_tmp)
 		if (!ret)
diff --git a/include/linux/fwnode.h b/include/linux/fwnode.h
index 4b6bf73f27239..610c38e14677c 100644
--- a/include/linux/fwnode.h
+++ b/include/linux/fwnode.h
@@ -238,5 +238,6 @@ extern bool fw_devlink_is_strict(void);
 int fwnode_link_add(struct fwnode_handle *con, struct fwnode_handle *sup);
 void fwnode_links_purge(struct fwnode_handle *fwnode);
 void fw_devlink_purge_absent_suppliers(struct fwnode_handle *fwnode);
+void fw_devlink_refresh_fwnode(struct fwnode_handle *fwnode);
 
 #endif
-- 
2.53.0



