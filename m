Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C16A47D449;
	Thu, 20 Aug 2026 16:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244253; cv=none; b=i6+Tr8aFvO+4H7y+NsSqUuo7JaaAN7Za+AniaorSMYKcy2Z5XOTVj6hC38Z0cf7UtvhcJydBxiuf0GM5tjCHDUMix635alVX+i2k38LSuMVJB+Lo08kkVcUHlnkVFoz1O0w1ZGraIWQzpcgbl3RtuOIADwICnGMc2g4XQABz0ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244253; c=relaxed/simple;
	bh=xvG1CR8CqAeOMvpBj1mDNZPsxdSukf8bpa6blOnKet0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kt7G3ZKs+MCMczpWQj8UFn3rLW3NM6iQWlZ07x24DYgtSKQgjVICWBIilI9A26Kn9VfTsBczX8s5RkNSDS88jBrNdCQ8BF7xBn/oyiYZ3u36UiMa5yfgpsbJkeZcBsBNDZo8HUUthl5z/vTYLHFC1fiAkvEo1VmcEqyrXBXxqWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vnSqDMdb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vnSqDMdb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E558A1F000E9;
	Thu, 20 Aug 2026 16:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244251;
	bh=h7z/WcWJj28jFvSuJ9ofA+8O1WlefWKak1X8NwiAQDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vnSqDMdbQ2aI4HE/ZwhGCAy/b/s7UtU9bGhGlQzK1WZKR5+T6eu2cZJ3yTSMvu1AZ
	 qJcuunRPkROefmGmu1R0/cHw8yzaqMoLWxRo6Oj6RKvVuIfclzctouCkuiw4x4V36o
	 K8AYr7OqCJ+Sw+VBvgI6Y3ePUKFg6mNFJFxtTEU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/235] thunderbolt: Remove XDomain from the bus without holding tb->lock
Date: Thu, 20 Aug 2026 16:55:41 +0200
Message-ID: <20260820145219.636671639@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit a8937f35cf39c39c64325aa84d0463d866850857 ]

Currently we call device_unregister() for services and the XDomain
itself with tb->lock held. This prevents the service drivers from
calling any functions that may take it. For this reason separate
removing the XDomain from the topology data structures (where we need
the lock) from unregistering the device from the bus (where remove
callbacks of the drivers are being called).

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Stable-dep-of: 2c5d2d3c3f70 ("thunderbolt: Prevent XDomain delayed work use-after-free on disconnect")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/domain.c  |   30 +++++++++++++++++++++
 drivers/thunderbolt/icm.c     |    5 +++
 drivers/thunderbolt/switch.c  |   14 ++++++++++
 drivers/thunderbolt/tb.c      |   58 +++++++++++++++++++++---------------------
 drivers/thunderbolt/tb.h      |    2 +
 drivers/thunderbolt/xdomain.c |   48 ++++++++++++++++++++++------------
 6 files changed, 111 insertions(+), 46 deletions(-)

--- a/drivers/thunderbolt/domain.c
+++ b/drivers/thunderbolt/domain.c
@@ -823,6 +823,36 @@ int tb_domain_disconnect_all_paths(struc
 	return bus_for_each_dev(&tb_bus_type, NULL, tb, disconnect_xdomain);
 }
 
+struct unregister_context {
+	const struct tb *tb;
+	int n;
+};
+
+static int unregister_unplugged_xdomain(struct device *dev, void *data)
+{
+	struct unregister_context *ctx = data;
+	struct tb_xdomain *xd;
+
+	xd = tb_to_xdomain(dev);
+	if (xd && xd->tb == ctx->tb && xd->is_unplugged) {
+		tb_xdomain_unregister(xd);
+		ctx->n++;
+	}
+	return 0;
+}
+
+int tb_domain_unregister_unplugged_xdomains(struct tb *tb)
+{
+	struct unregister_context ctx;
+
+	ctx.tb = tb_domain_get(tb);
+	ctx.n = 0;
+	bus_for_each_dev(&tb_bus_type, NULL, &ctx, unregister_unplugged_xdomain);
+	tb_domain_put(tb);
+
+	return ctx.n;
+}
+
 int tb_domain_init(void)
 {
 	int ret;
--- a/drivers/thunderbolt/icm.c
+++ b/drivers/thunderbolt/icm.c
@@ -695,6 +695,7 @@ static void remove_xdomain(struct tb_xdo
 
 	sw = tb_to_switch(xd->dev.parent);
 	tb_port_at(xd->route, sw)->xdomain = NULL;
+	xd->is_unplugged = true;
 	tb_xdomain_remove(xd);
 }
 
@@ -1682,6 +1683,8 @@ static void icm_handle_notification(stru
 
 	kfree(n->pkg);
 	kfree(n);
+
+	tb_domain_unregister_unplugged_xdomains(tb);
 }
 
 static void icm_handle_event(struct tb *tb, enum tb_cfg_pkg_type type,
@@ -2023,6 +2026,8 @@ static void icm_rescan_work(struct work_
 	if (tb->root_switch)
 		icm_free_unplugged_children(tb->root_switch);
 	mutex_unlock(&tb->lock);
+
+	tb_domain_unregister_unplugged_xdomains(tb);
 }
 
 static void icm_complete(struct tb *tb)
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -2737,6 +2737,20 @@ int tb_switch_resume(struct tb_switch *s
 				tb_port_warn(port,
 					     "lost during suspend, disconnecting\n");
 				tb_sw_set_unplugged(port->remote->sw);
+			} else if (port->xdomain) {
+				/*
+				 * If the user replaced the XDomain with
+				 * another router, this will succeed in
+				 * which case we must remove the XDomain
+				 * before adding the new router.
+				 */
+				err = tb_cfg_get_upstream_port(sw->tb->ctl,
+							       port->xdomain->route);
+				if (err > 0) {
+					tb_port_warn(port,
+						     "XDomain was disconnected\n");
+					port->xdomain->is_unplugged = true;
+				}
 			}
 		}
 	}
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -1208,6 +1208,8 @@ put_sw:
 out:
 	mutex_unlock(&tb->lock);
 
+	tb_domain_unregister_unplugged_xdomains(tb);
+
 	pm_runtime_mark_last_busy(&tb->dev);
 	pm_runtime_put_autosuspend(&tb->dev);
 
@@ -1375,6 +1377,24 @@ static void tb_restore_children(struct t
 	}
 }
 
+static void tb_free_unplugged_xdomains(struct tb_switch *sw)
+{
+	struct tb_port *port;
+
+	tb_switch_for_each_port(sw, port) {
+		if (tb_is_upstream_port(port))
+			continue;
+		if (port->xdomain && port->xdomain->is_unplugged) {
+			tb_retimer_remove_all(port);
+			tb_xdomain_remove(port->xdomain);
+			tb_port_unconfigure_xdomain(port);
+			port->xdomain = NULL;
+		} else if (port->remote) {
+			tb_free_unplugged_xdomains(port->remote->sw);
+		}
+	}
+}
+
 static int tb_resume_noirq(struct tb *tb)
 {
 	struct tb_cm *tcm = tb_priv(tb);
@@ -1388,6 +1408,7 @@ static int tb_resume_noirq(struct tb *tb
 	tb_switch_resume(tb->root_switch, false);
 	tb_free_invalid_tunnels(tb);
 	tb_free_unplugged_children(tb->root_switch);
+	tb_free_unplugged_xdomains(tb->root_switch);
 	tb_restore_children(tb->root_switch);
 	list_for_each_entry_safe(tunnel, n, &tcm->tunnel_list, list)
 		tb_tunnel_restart(tunnel);
@@ -1406,28 +1427,6 @@ static int tb_resume_noirq(struct tb *tb
 	return 0;
 }
 
-static int tb_free_unplugged_xdomains(struct tb_switch *sw)
-{
-	struct tb_port *port;
-	int ret = 0;
-
-	tb_switch_for_each_port(sw, port) {
-		if (tb_is_upstream_port(port))
-			continue;
-		if (port->xdomain && port->xdomain->is_unplugged) {
-			tb_retimer_remove_all(port);
-			tb_xdomain_remove(port->xdomain);
-			tb_port_unconfigure_xdomain(port);
-			port->xdomain = NULL;
-			ret++;
-		} else if (port->remote) {
-			ret += tb_free_unplugged_xdomains(port->remote->sw);
-		}
-	}
-
-	return ret;
-}
-
 static int tb_freeze_noirq(struct tb *tb)
 {
 	struct tb_cm *tcm = tb_priv(tb);
@@ -1447,14 +1446,15 @@ static int tb_thaw_noirq(struct tb *tb)
 static void tb_complete(struct tb *tb)
 {
 	/*
-	 * Release any unplugged XDomains and if there is a case where
+	 * Unregister unplugged XDomains and if there is a case where
 	 * another domain is swapped in place of unplugged XDomain we
 	 * need to run another rescan.
 	 */
-	mutex_lock(&tb->lock);
-	if (tb_free_unplugged_xdomains(tb->root_switch))
+	if (tb_domain_unregister_unplugged_xdomains(tb)) {
+		mutex_lock(&tb->lock);
 		tb_scan_switch(tb->root_switch);
-	mutex_unlock(&tb->lock);
+		mutex_unlock(&tb->lock);
+	}
 }
 
 static int tb_runtime_suspend(struct tb *tb)
@@ -1475,11 +1475,11 @@ static void tb_remove_work(struct work_s
 	struct tb *tb = tcm_to_tb(tcm);
 
 	mutex_lock(&tb->lock);
-	if (tb->root_switch) {
+	if (tb->root_switch)
 		tb_free_unplugged_children(tb->root_switch);
-		tb_free_unplugged_xdomains(tb->root_switch);
-	}
 	mutex_unlock(&tb->lock);
+
+	tb_free_unplugged_xdomains(tb->root_switch);
 }
 
 static int tb_runtime_resume(struct tb *tb)
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -623,6 +623,7 @@ int tb_domain_disconnect_pcie_paths(stru
 int tb_domain_approve_xdomain_paths(struct tb *tb, struct tb_xdomain *xd);
 int tb_domain_disconnect_xdomain_paths(struct tb *tb, struct tb_xdomain *xd);
 int tb_domain_disconnect_all_paths(struct tb *tb);
+int tb_domain_unregister_unplugged_xdomains(struct tb *tb);
 
 static inline struct tb *tb_domain_get(struct tb *tb)
 {
@@ -939,6 +940,7 @@ struct tb_xdomain *tb_xdomain_alloc(stru
 				    const uuid_t *remote_uuid);
 void tb_xdomain_add(struct tb_xdomain *xd);
 void tb_xdomain_remove(struct tb_xdomain *xd);
+void tb_xdomain_unregister(struct tb_xdomain *xd);
 struct tb_xdomain *tb_xdomain_find_by_link_depth(struct tb *tb, u8 link,
 						 u8 depth);
 
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -1358,32 +1358,46 @@ static int unregister_service(struct dev
 }
 
 /**
- * tb_xdomain_remove() - Remove XDomain from the bus
+ * tb_xdomain_remove() - Remove XDomain
  * @xd: XDomain to remove
  *
- * This will stop all ongoing configuration work and remove the XDomain
- * along with any services from the bus. When the last reference to @xd
- * is released the object will be released as well.
+ * This will stop all ongoing configuration work. XDomain is not removed
+ * from the bus if it was added. That needs to be done separately by
+ * calling tb_xdomain_unregister().
+ *
+ * Called with @tb->lock held.
  */
 void tb_xdomain_remove(struct tb_xdomain *xd)
 {
 	stop_handshake(xd);
 
-	device_for_each_child_reverse(&xd->dev, xd, unregister_service);
+	if (!device_is_registered(&xd->dev)) {
+		/*
+		 * Undo runtime PM here explicitly because it is
+		 * possible that the XDomain was never added to the bus
+		 * and thus device_del() is not called for it
+		 * (device_del() would handle this otherwise).
+		 */
+		pm_runtime_disable(&xd->dev);
+		pm_runtime_put_noidle(&xd->dev);
+		pm_runtime_set_suspended(&xd->dev);
+		put_device(&xd->dev);
+	}
+}
 
-	/*
-	 * Undo runtime PM here explicitly because it is possible that
-	 * the XDomain was never added to the bus and thus device_del()
-	 * is not called for it (device_del() would handle this otherwise).
-	 */
-	pm_runtime_disable(&xd->dev);
-	pm_runtime_put_noidle(&xd->dev);
-	pm_runtime_set_suspended(&xd->dev);
+/**
+ * tb_xdomain_unregister() - Unregister XDomain
+ * @xd: XDomain to unregister
+ *
+ * This will unregister the XDomain along with any services from the
+ * bus. When the last reference to @xd is released the object will be
+ * released as well.
+ */
+void tb_xdomain_unregister(struct tb_xdomain *xd)
+{
+	device_for_each_child_reverse(&xd->dev, xd, unregister_service);
 
-	if (!device_is_registered(&xd->dev))
-		put_device(&xd->dev);
-	else
-		device_unregister(&xd->dev);
+	device_unregister(&xd->dev);
 }
 
 /**


