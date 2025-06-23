Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CAF223DF0;
	Mon, 23 Jun 2025 22:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717523; cv=none; b=oqKKL1c9HE04oeLPmQWNnsOXqYogUphS2OU6KSJzlJUub7i8lOqz5FqtpWXLpKr88WBbh+Df8HtaUnyLUpGAf4k8MJjdeZmJXlH0QImHbEmuIACs/95pfm+ELHvabQNl/ChZQfhCnb42EGJtH7q0D+R3qFtZtOd8oKewfEJpKlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717523; c=relaxed/simple;
	bh=2XNu07roZN47VUlt3r8zWv/H+OoM6jkGfaDMDYA6i28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VRteRWwIXfazBWh6L4qEZ30M5+B0w3pG4/Eoz6LG14QDb39d1Mq3Ak4OhUE+gJ0vhLfVknR/eW8ntzZxbdvJrMf9+z9v+k9Oq3TSiYjqT1Q5sSSZiHkbEPkL/QzzCmTEa5sD5BDf7jhjYN76ZMgH8eTII0mGob3Gfph/OV9tQjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t96FAnUG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t96FAnUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF32C4CEEA;
	Mon, 23 Jun 2025 22:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717523;
	bh=2XNu07roZN47VUlt3r8zWv/H+OoM6jkGfaDMDYA6i28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t96FAnUGPQQjPGoD3d4Pb7W8zPIP21rsMPL/cGFMCEusyQVqBNG9tqdqqBOyUmyBD
	 t9snjCQvYRKb8Pti7YUiCFXqKin3ieIHyu2ICLOjbH1godGqvYZ5BiSajQOeGDA6Uh
	 RFLRpFtMdBgjt5F3+C4uFE4YIdhHMKT67VTL5p30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Lindgren <tony@atomide.com>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>,
	Andreas Kemnade <andreas@kemnade.info>
Subject: [PATCH 6.1 437/508] Revert "bus: ti-sysc: Probe for l4_wkup and l4_cfg interconnect devices first"
Date: Mon, 23 Jun 2025 15:08:02 +0200
Message-ID: <20250623130655.915044436@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

[ Upstream commit 36305857b1ead8f6ca033a913162ebc09bee0b43 ]

This reverts commit 4700a00755fb5a4bb5109128297d6fd2d1272ee6.

It breaks target-module@2b300050 ("ti,sysc-omap2") probe on AM62x in a case
when minimally-configured system tries to network-boot:

[    6.888776] probe of 2b300050.target-module returned 517 after 258 usecs
[   17.129637] probe of 2b300050.target-module returned 517 after 708 usecs
[   17.137397] platform 2b300050.target-module: deferred probe pending: (reason unknown)
[   26.878471] Waiting up to 100 more seconds for network.

There are minimal configurations possible when the deferred device is not
being probed any more (because everything else has been successfully
probed) and deferral lists are not processed any more.

Stable mmc enumeration can be achieved by filling /aliases node properly
(4700a00755fb commit's rationale).

After revert:

[    9.006816] IP-Config: Complete:
[    9.010058]      device=lan0, ...

Tested-by: Andreas Kemnade <andreas@kemnade.info> # GTA04, Panda, BT200
Reviewed-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Link: https://lore.kernel.org/r/20250401090643.2776793-1-alexander.sverdlin@siemens.com
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 49 -------------------------------------------
 1 file changed, 49 deletions(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 15c6b85b125d4..172b17fe87c42 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -689,51 +689,6 @@ static int sysc_parse_and_check_child_range(struct sysc *ddata)
 	return 0;
 }
 
-/* Interconnect instances to probe before l4_per instances */
-static struct resource early_bus_ranges[] = {
-	/* am3/4 l4_wkup */
-	{ .start = 0x44c00000, .end = 0x44c00000 + 0x300000, },
-	/* omap4/5 and dra7 l4_cfg */
-	{ .start = 0x4a000000, .end = 0x4a000000 + 0x300000, },
-	/* omap4 l4_wkup */
-	{ .start = 0x4a300000, .end = 0x4a300000 + 0x30000,  },
-	/* omap5 and dra7 l4_wkup without dra7 dcan segment */
-	{ .start = 0x4ae00000, .end = 0x4ae00000 + 0x30000,  },
-};
-
-static atomic_t sysc_defer = ATOMIC_INIT(10);
-
-/**
- * sysc_defer_non_critical - defer non_critical interconnect probing
- * @ddata: device driver data
- *
- * We want to probe l4_cfg and l4_wkup interconnect instances before any
- * l4_per instances as l4_per instances depend on resources on l4_cfg and
- * l4_wkup interconnects.
- */
-static int sysc_defer_non_critical(struct sysc *ddata)
-{
-	struct resource *res;
-	int i;
-
-	if (!atomic_read(&sysc_defer))
-		return 0;
-
-	for (i = 0; i < ARRAY_SIZE(early_bus_ranges); i++) {
-		res = &early_bus_ranges[i];
-		if (ddata->module_pa >= res->start &&
-		    ddata->module_pa <= res->end) {
-			atomic_set(&sysc_defer, 0);
-
-			return 0;
-		}
-	}
-
-	atomic_dec_if_positive(&sysc_defer);
-
-	return -EPROBE_DEFER;
-}
-
 static struct device_node *stdout_path;
 
 static void sysc_init_stdout_path(struct sysc *ddata)
@@ -959,10 +914,6 @@ static int sysc_map_and_check_registers(struct sysc *ddata)
 	if (error)
 		return error;
 
-	error = sysc_defer_non_critical(ddata);
-	if (error)
-		return error;
-
 	sysc_check_children(ddata);
 
 	if (!of_get_property(np, "reg", NULL))
-- 
2.39.5



