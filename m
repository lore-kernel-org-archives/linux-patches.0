Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89356269826;
	Wed, 23 Apr 2025 14:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419997; cv=none; b=AXDbM/9gOupjlVfGZBaw/WekHEvsyRArOzP5q20ZFjMaDtixI5YBEPXk2yznBgQDtFpxVV1Lx6kw6klG+8YeguTSZwCvoQOUmiSyM9gejsASmlO7xK+5BfKheUG0fVpFWdlCZRBtEyIuXJDQd7Ytb1BDUb3InFB0Kcskwi/49+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419997; c=relaxed/simple;
	bh=NFtx2Qbs+iP6GZt72Z+TVrJ7Kt1B7pz69vo1JDJYdMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jsjtWXUqhpBMdPj1CCqHH06rKI90rKDOfarqwThzV5g+7s1FIDhaQwL2zD8mQBCKeyoSTY2FAG1uMvqtkb6FloYyuqvgVdKUH0Ex1ovB2x6so2erelPssPcK6e/EJ+IUJ5gL5k+pYTklFBQfqRPV+V8KojzagVJsWkKv/72F5Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2tJ/BKEi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2tJ/BKEi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196A2C4CEE2;
	Wed, 23 Apr 2025 14:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419997;
	bh=NFtx2Qbs+iP6GZt72Z+TVrJ7Kt1B7pz69vo1JDJYdMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2tJ/BKEiVBF30s4IywloEx2VcBZvY3AV5o2w2L5llNhqyT5w60mfAV0zvhQMR2e+C
	 MDs9eyHL7fuAnroQAN7Vi0MxfRNZRKJZNmPRYmhi45ZgoX69GwE8MOOKxHHYRewCoE
	 raz34WUxXkF2qWGCog2S0jAGm3L5szsjL3hehj3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 066/223] net: dsa: free routing table on probe failure
Date: Wed, 23 Apr 2025 16:42:18 +0200
Message-ID: <20250423142619.822215226@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/dsa.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index b20be568b9d3b..ac3a252969cb6 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -862,6 +862,16 @@ static void dsa_tree_teardown_lags(struct dsa_switch_tree *dst)
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
@@ -879,7 +889,7 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
 
 	err = dsa_tree_setup_cpu_ports(dst);
 	if (err)
-		return err;
+		goto teardown_rtable;
 
 	err = dsa_tree_setup_switches(dst);
 	if (err)
@@ -911,14 +921,14 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
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
 
@@ -932,10 +942,7 @@ static void dsa_tree_teardown(struct dsa_switch_tree *dst)
 
 	dsa_tree_teardown_cpu_ports(dst);
 
-	list_for_each_entry_safe(dl, next, &dst->rtable, list) {
-		list_del(&dl->list);
-		kfree(dl);
-	}
+	dsa_tree_teardown_routing_table(dst);
 
 	pr_info("DSA: tree %d torn down\n", dst->index);
 
-- 
2.39.5



