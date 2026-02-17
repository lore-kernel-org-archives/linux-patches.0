Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843C47A13A;
	Tue, 17 Feb 2026 20:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361282; cv=none; b=HKLYICaY8Pxf/X2yOUTjBUFD3zaXdYJMyifz8VkSarSgueq+xIQd+Dz3T+CfwvSD/YUoaI7Q3VW2N/bE9ShiUy4P0PmdusXcYcaouzjogKq14+X/SnmESGhKxhD34gTkKWmd29Q4WPQbAMXShd2GRTT3Ir5oo3GgxC2qM4w4xyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361282; c=relaxed/simple;
	bh=sJ97cQkn/CM6+ouWvTtQ/DwaSTKi8GE+o5HrgJpRLVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwIahiNfsWwsQbigUnWaqHa7Eg+3XtMdkgT0NHZd7r0yzta8fev/0HVNSvWgKVIXWVt3mgNACuRa0klWJBKeAxlik5sLdfBNL45QJ0IvqfFoT19QZpq1C7Ol7WeX0VgCLPpcmd2x/iQTfOjTSG5m5ilQBnuECVBLo6ftqjXXTBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I8vQ4W5H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I8vQ4W5H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E986DC4CEF7;
	Tue, 17 Feb 2026 20:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361282;
	bh=sJ97cQkn/CM6+ouWvTtQ/DwaSTKi8GE+o5HrgJpRLVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I8vQ4W5HkH0i/sZ6Dq3jwNHd/6WMhLRFuBW2m8g/yfGiU+3jnRsQlkr5WsL1B83HJ
	 Nj0DpVxEq2IjuFVOhb5CK6XW1MeX6+Nnlqp3gHI7GftS+blLpuIHBrqYjtDm9J5jD4
	 x7vlP1veN3yIGBGwuM5BNNtUw4ybl+uP0B15cXLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Bin Lan <lanbincn@139.com>
Subject: [PATCH 6.1 54/64] net: dsa: free routing table on probe failure
Date: Tue, 17 Feb 2026 21:31:50 +0100
Message-ID: <20260217200009.532664913@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
References: <20260217200007.505931165@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 8bf108d7161ffc6880ad13a0cc109de3cf631727 ]

If complete = true in dsa_tree_setup(), it means that we are the last
switch of the tree which is successfully probing, and we should be
setting up all switches from our probe path.

After "complete" becomes true, dsa_tree_setup_cpu_ports() or any
subsequent function may fail. If that happens, the entire tree setup is
in limbo: the first N-1 switches have successfully finished probing
(doing nothing but having allocated persistent memory in the tree's
dst->ports, and maybe dst->rtable), and switch N failed to probe, ending
the tree setup process before anything is tangible from the user's PoV.

If switch N fails to probe, its memory (ports) will be freed and removed
from dst->ports. However, the dst->rtable elements pointing to its ports,
as created by dsa_link_touch(), will remain there, and will lead to
use-after-free if dereferenced.

If dsa_tree_setup_switches() returns -EPROBE_DEFER, which is entirely
possible because that is where ds->ops->setup() is, we get a kasan
report like this:

==================================================================
BUG: KASAN: slab-use-after-free in mv88e6xxx_setup_upstream_port+0x240/0x568
Read of size 8 at addr ffff000004f56020 by task kworker/u8:3/42

Call trace:
 __asan_report_load8_noabort+0x20/0x30
 mv88e6xxx_setup_upstream_port+0x240/0x568
 mv88e6xxx_setup+0xebc/0x1eb0
 dsa_register_switch+0x1af4/0x2ae0
 mv88e6xxx_register_switch+0x1b8/0x2a8
 mv88e6xxx_probe+0xc4c/0xf60
 mdio_probe+0x78/0xb8
 really_probe+0x2b8/0x5a8
 __driver_probe_device+0x164/0x298
 driver_probe_device+0x78/0x258
 __device_attach_driver+0x274/0x350

Allocated by task 42:
 __kasan_kmalloc+0x84/0xa0
 __kmalloc_cache_noprof+0x298/0x490
 dsa_switch_touch_ports+0x174/0x3d8
 dsa_register_switch+0x800/0x2ae0
 mv88e6xxx_register_switch+0x1b8/0x2a8
 mv88e6xxx_probe+0xc4c/0xf60
 mdio_probe+0x78/0xb8
 really_probe+0x2b8/0x5a8
 __driver_probe_device+0x164/0x298
 driver_probe_device+0x78/0x258
 __device_attach_driver+0x274/0x350

Freed by task 42:
 __kasan_slab_free+0x48/0x68
 kfree+0x138/0x418
 dsa_register_switch+0x2694/0x2ae0
 mv88e6xxx_register_switch+0x1b8/0x2a8
 mv88e6xxx_probe+0xc4c/0xf60
 mdio_probe+0x78/0xb8
 really_probe+0x2b8/0x5a8
 __driver_probe_device+0x164/0x298
 driver_probe_device+0x78/0x258
 __device_attach_driver+0x274/0x350

The simplest way to fix the bug is to delete the routing table in its
entirety. dsa_tree_setup_routing_table() has no problem in regenerating
it even if we deleted links between ports other than those of switch N,
because dsa_link_touch() first checks whether the port pair already
exists in dst->rtable, allocating if not.

The deletion of the routing table in its entirety already exists in
dsa_tree_teardown(), so refactor that into a function that can also be
called from the tree setup error path.

In my analysis of the commit to blame, it is the one which added
dsa_link elements to dst->rtable. Prior to that, each switch had its own
ds->rtable which is freed when the switch fails to probe. But the tree
is potentially persistent memory.

Fixes: c5f51765a1f6 ("net: dsa: list DSA links in the fabric")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20250414213001.2957964-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Backport the fix to net/dsa/dsa2.c in v6.1.y for dsa2.c was
renamed back into dsa.c by commit
47d2ce03dcfb ("net: dsa: rename dsa2.c back into dsa.c and create its header")
since v6.2. ]
Signed-off-by: Bin Lan <lanbincn@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/dsa2.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1148,6 +1148,16 @@ static void dsa_tree_teardown_lags(struc
 	kfree(dst->lags);
 }
 
+static void dsa_tree_teardown_routing_table(struct dsa_switch_tree *dst)
+{
+	struct dsa_link *dl, *next;
+
+	list_for_each_entry_safe(dl, next, &dst->rtable, list) {
+		list_del(&dl->list);
+		kfree(dl);
+	}
+}
+
 static int dsa_tree_setup(struct dsa_switch_tree *dst)
 {
 	bool complete;
@@ -1165,7 +1175,7 @@ static int dsa_tree_setup(struct dsa_swi
 
 	err = dsa_tree_setup_cpu_ports(dst);
 	if (err)
-		return err;
+		goto teardown_rtable;
 
 	err = dsa_tree_setup_switches(dst);
 	if (err)
@@ -1197,14 +1207,14 @@ teardown_switches:
 	dsa_tree_teardown_switches(dst);
 teardown_cpu_ports:
 	dsa_tree_teardown_cpu_ports(dst);
+teardown_rtable:
+	dsa_tree_teardown_routing_table(dst);
 
 	return err;
 }
 
 static void dsa_tree_teardown(struct dsa_switch_tree *dst)
 {
-	struct dsa_link *dl, *next;
-
 	if (!dst->setup)
 		return;
 
@@ -1218,10 +1228,7 @@ static void dsa_tree_teardown(struct dsa
 
 	dsa_tree_teardown_cpu_ports(dst);
 
-	list_for_each_entry_safe(dl, next, &dst->rtable, list) {
-		list_del(&dl->list);
-		kfree(dl);
-	}
+	dsa_tree_teardown_routing_table(dst);
 
 	pr_info("DSA: tree %d torn down\n", dst->index);
 


