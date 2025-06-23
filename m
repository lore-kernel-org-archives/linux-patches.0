Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B07C7482;
	Mon, 23 Jun 2025 21:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713356; cv=none; b=DrkieWfkumLQiJ+d685v9RKYYMJONkrvhZ8HzWp8/pN4ObsyjP2l2ZZZVCk1q6vb/o+ASTtTu3A0Aq/VbXrUDYou3V0XqK0sd6u4n8QFThaw1E1Kn5ZffcwNAPNLmMfQPqzVRMrklsIK6cAsFveoQis0v3InJ/OchQVEn3q2FKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713356; c=relaxed/simple;
	bh=lYdGjoFeoKonyYh8oUjQ0YknMjHNCJuLP/3ZwSqGNQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjdRgIWfEuM9IMdlT5U3bngfxbCJe4EiqiybvpZpnB+OWOOf+A18vzsdHG14FF470wwy1w6FIlP/2D8YGIKCsZISSgg75PfvV5kxjcCycPdeeLQs99mtIkrBunzz4w1fDKEMg3x+CgGUIrtAG9VCArpmMt3A9Gs4nOaGg38WEfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bL8+/O9c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bL8+/O9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4ECC4CEED;
	Mon, 23 Jun 2025 21:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713356;
	bh=lYdGjoFeoKonyYh8oUjQ0YknMjHNCJuLP/3ZwSqGNQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bL8+/O9cIk2fGBE2MFO34MPvphTWFhQnP5VU85ZTpdw0qt/T69aiM6iwysZQNT4ph
	 jb1yQ+EKjCu9aTBLjeWFNrTJ/os2wyLjDB5Hu+StFSOvBOoaHbaY8CWmScTqFtQI+M
	 iFEF+U2jfTgNoqvo7FQwJYnlpBJKHrS2xVfVwJ2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Lindgren <tony@atomide.com>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>,
	Andreas Kemnade <andreas@kemnade.info>
Subject: [PATCH 5.4 182/222] Revert "bus: ti-sysc: Probe for l4_wkup and l4_cfg interconnect devices first"
Date: Mon, 23 Jun 2025 15:08:37 +0200
Message-ID: <20250623130617.643401010@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 70339f73181ea..5d27c43222fa4 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -602,51 +602,6 @@ static int sysc_parse_and_check_child_range(struct sysc *ddata)
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
@@ -871,10 +826,6 @@ static int sysc_map_and_check_registers(struct sysc *ddata)
 	if (error)
 		return error;
 
-	error = sysc_defer_non_critical(ddata);
-	if (error)
-		return error;
-
 	sysc_check_children(ddata);
 
 	error = sysc_parse_registers(ddata);
-- 
2.39.5



