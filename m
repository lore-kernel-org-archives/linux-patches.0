Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9667734D3BE;
	Fri,  9 Oct 2026 14:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557410; cv=none; b=FrxBXc4AJl1AnzuCy1d4KMiWAoFTOIvLjAdQOnZBE/AO1MC4axwMJC5c0RLZ1xzlIGbK0FTeJGfl0wMfubu2GqmbJZoQTK6miQffQdPPKXSddVpm6A2UMwa3mbYnII5s/xNDW+jcO3AWCOroldM8iKWYxTZCAi0orJ/XhAAdJKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557410; c=relaxed/simple;
	bh=TKAYHc/7o7aoAWZHjBnGwWtVrES5UeH0vknt4nT3w40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QU1symU1X9zJo6jmhcy3n+GIWRcQAmRQWj+KtULGGvEaOTyGiIg2+hZK0+1+aeUJexmS3O26SutUaf9mmRjTQHUxRAMsJXDuit4cv9RVGhXi/f1DIWVJphoBSOmaf35VXztx4oDzC/1vTXjnGYQS/EFcIgnB9XSTsrUhuYvphWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QixXo52r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QixXo52r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE071F000FF;
	Fri,  9 Oct 2026 14:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557409;
	bh=4bv3vT86HQhtoKE5ixGd14/HTuPrdbdR67Wk+9XM5+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QixXo52rhDpDN59LoM5b4P4rORMBS+rsZTphSmh7BZf+zuKn3y1sl4nLD/NOHG8dY
	 0bsFstNwFCVR7AqvauZzLlzqi0eOkJeU4jKTJeeuAj4k3L7FBdY41CYhFHWpIVMTiI
	 1tm4FL0g4wJRwH/fzOhOxs2KDCPbsXVo27sLFdMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Peter <sven@kernel.org>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 7.2 351/428] thunderbolt: Hold a router reference for each allocated HopID
Date: Fri,  9 Oct 2026 16:11:28 +0200
Message-ID: <20261009140953.874010547@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -765,6 +765,7 @@ static int tb_port_alloc_hopid(struct tb
 {
 	int port_max_hopid;
 	struct ida *ida;
+	int ret;
 
 	if (in) {
 		port_max_hopid = port->config.max_in_hop_id;
@@ -784,7 +785,11 @@ static int tb_port_alloc_hopid(struct tb
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
@@ -823,6 +828,7 @@ int tb_port_alloc_out_hopid(struct tb_po
 void tb_port_release_in_hopid(struct tb_port *port, int hopid)
 {
 	ida_free(&port->in_hopids, hopid);
+	tb_switch_put(port->sw);
 }
 
 /**
@@ -833,6 +839,7 @@ void tb_port_release_in_hopid(struct tb_
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


