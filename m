Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE01D48C403;
	Fri,  9 Oct 2026 14:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556756; cv=none; b=FZ7a7BYeZykuVdwYNobj9JAJIyGKXJ97mMq2eFsd/F7ljmuncU+Q7PsHk0JRy0AifU360u19V+uDNk0oFZu1G43c5/t+Dl9N8iEga9cfo9vAFa+XAVDAjZ77BX8SL/TuUIQSO8lavWHghd6jst+2I3tiRt002JcRPLWAQokQKW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556756; c=relaxed/simple;
	bh=zIFe/62OJU4JrAnzsYQnCuDkZRzc6Gwh+8vxC0rQtLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMGi6562fLs48ZnZBW8F1/3xkZaiWt7fs2PjHu5xSdCSCRZVx5vOGG6bw1qx9GI+vsAGS4MuRhflHVVJfiiye7CRZ/FWHTUod/bQO8RNgDeKqYSi9k1ohRygH2PYtmVU7hYbD5WyLl7bxNGFy+Xi46BjuT8dmNtD2sRojmKF/Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L5orFUQG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5orFUQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2055D1F000FF;
	Fri,  9 Oct 2026 14:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556755;
	bh=1tMt/BpZvBay/hX7Nun+GOwpcPNuiRx4NJ6pL7QpP88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L5orFUQGlt8VyY6j3bfg7XLkyPyZt20shioaOB5Q20RGE19rTFEgiLsCkV2n+mhJB
	 02ryOEWy3VnKq0eFt5C4PywE9i/nQg9iCEOO5rQoaKbW0XAsnYwznbkwKXvhkC1Ngr
	 JT1JV5fiz5z+K/BaP0dKozCMG0YAZjktOPpaDPc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Peter <sven@kernel.org>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.18 288/403] thunderbolt: Hold a router reference for each allocated HopID
Date: Fri,  9 Oct 2026 16:10:49 +0200
Message-ID: <20261009140958.934630092@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Peter <sven@kernel.org>

commit 032c59c7681c661b63123231824170c025afb7e7 upstream.

tb_stop() drops the reference to all DP tunnels but does not deactivate
them, thus nothing cancels a dprx_work still in flight (which holds its
own tunnel reference) and the tunnel can outlive tb_switch_remove(). The
HopID releases in tb_path_free() then operate on freed IDAs and trigger
warnings like

  ida_free called for id=8 which is not allocated.

This can be triggered by unbinding the driver while a DP tunnel is still
waiting for the DPRX capabilities read to finish. On the Apple NHI
unplugging the cable runs into just that reliably because the read can
never finish right now and because the unplug powers down the entire
USB4 complex and removes the NHI device.

Take a router reference whenever an input or output HopID is allocated
and drop it again after the HopID is released. This keeps the ports and
their HopID IDAs alive for as long as they are used.

The KUnit tests allocate routers without ever registering their devices
so initialize the embedded struct device there as well and drop its
initial reference when the test is finished.

Fixes: d6d458d42e1e ("thunderbolt: Handle DisplayPort tunnel activation asynchronously")
Cc: stable@vger.kernel.org
Signed-off-by: Sven Peter <sven@kernel.org>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/switch.c |    9 ++++++++-
 drivers/thunderbolt/test.c   |   21 +++++++++++++++++++++
 2 files changed, 29 insertions(+), 1 deletion(-)

--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -768,6 +768,7 @@ static int tb_port_alloc_hopid(struct tb
 {
 	int port_max_hopid;
 	struct ida *ida;
+	int ret;
 
 	if (in) {
 		port_max_hopid = port->config.max_in_hop_id;
@@ -787,7 +788,11 @@ static int tb_port_alloc_hopid(struct tb
 	if (max_hopid < 0 || max_hopid > port_max_hopid)
 		max_hopid = port_max_hopid;
 
-	return ida_alloc_range(ida, min_hopid, max_hopid, GFP_KERNEL);
+	ret = ida_alloc_range(ida, min_hopid, max_hopid, GFP_KERNEL);
+	if (ret >= 0)
+		tb_switch_get(port->sw);
+
+	return ret;
 }
 
 /**
@@ -826,6 +831,7 @@ int tb_port_alloc_out_hopid(struct tb_po
 void tb_port_release_in_hopid(struct tb_port *port, int hopid)
 {
 	ida_free(&port->in_hopids, hopid);
+	tb_switch_put(port->sw);
 }
 
 /**
@@ -836,6 +842,7 @@ void tb_port_release_in_hopid(struct tb_
 void tb_port_release_out_hopid(struct tb_port *port, int hopid)
 {
 	ida_free(&port->out_hopids, hopid);
+	tb_switch_put(port->sw);
 }
 
 static inline bool tb_switch_is_reachable(const struct tb_switch *parent,
--- a/drivers/thunderbolt/test.c
+++ b/drivers/thunderbolt/test.c
@@ -33,6 +33,18 @@ static void kunit_ida_init(struct kunit
 	kunit_alloc_resource(test, __ida_init, __ida_destroy, GFP_KERNEL, ida);
 }
 
+static void tb_test_switch_release(struct device *dev)
+{
+	/* The memory is owned by KUnit, nothing to do here */
+}
+
+static void tb_test_switch_put(void *data)
+{
+	struct tb_switch *sw = data;
+
+	put_device(&sw->dev);
+}
+
 static struct tb_switch *alloc_switch(struct kunit *test, u64 route,
 				      u8 upstream_port, u8 max_port_number)
 {
@@ -44,6 +56,15 @@ static struct tb_switch *alloc_switch(st
 	if (!sw)
 		return NULL;
 
+	/*
+	 * HopID allocations take a reference to their routers and those devices
+	 * have to be initialized for that to work.
+	 */
+	sw->dev.release = tb_test_switch_release;
+	device_initialize(&sw->dev);
+	if (kunit_add_action_or_reset(test, tb_test_switch_put, sw))
+		return NULL;
+
 	sw->config.upstream_port_number = upstream_port;
 	sw->config.depth = tb_route_length(route);
 	sw->config.route_hi = upper_32_bits(route);


