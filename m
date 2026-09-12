Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74E037204A;
	Sat, 12 Sep 2026 07:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197187; cv=none; b=I93j1HWxIITqtbJTmX9fdvD1r/npIJRtLoMgfjMEH7u0bgdRFcJirNAN5qxeGrCAxHzmcV+9pvB91PO7Fqy+stNjfPf0zbYgvtjUH8CaNn7H3gK3VVkFuJO1BrQURQ0R9MgGeiQXhBq6qG4SBB6WeWxsXO/9StwDLcC18BzdYy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197187; c=relaxed/simple;
	bh=Rh8fBYV5+4uFkdR9UQsCta/QDuVZGIpZWw8BGoRpZn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yfy9I5SRAsGr1sDkieNVfa8F2+H+2gYrg1eyYv4HEe0fQlwbFerol708wfqTM+5Bmkw95jOhnQ93gHFQWfjyGJ+v4XOtHz6Z7GL+NzsDItgDQl7sHORytTBgzVXV1d/ie3bk2RbycvtTmZxdbXHTy1yzP67d7UfbnnrTaCRtSRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RAk9x0IQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RAk9x0IQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F651F000FF;
	Sat, 12 Sep 2026 07:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197185;
	bh=Wm6n42nwcNmzf9u0izMy0+R1vot92kiMfMImEW3FQ/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RAk9x0IQ0n8QF+ED9/19v0jtffa00ntC19EFNHe6PWto4Ji1iXx5pm6yV/HdmtOHE
	 xPeJ85Ocw1jbyWhJbJMIXNFbYp75xzoKDG7tUK00Sq/2+jjquCtWMpxMZDfwQaIT0h
	 +GaS/ZTb0oZzojHAnfy5G+Zbwk7epCHs9Qndz7zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Andreas Kemnade <andreas@kemnade.info>,
	"Kevin Hilman (TI)" <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0092/1815] ARM: OMAP2+: Fix OF node reference leaks in omap_hwmod
Date: Sat, 12 Sep 2026 08:30:42 +0200
Message-ID: <20260912065651.168739192@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 76103814279724e5c98b1c16a730f56ebede9f74 ]

The OF helpers that return device nodes acquire references that must be
released by the caller.

_init() leaks the "ocp" bus node returned by of_find_node_by_name() on
all paths after lookup, and also leaks the child returned by
of_get_next_child() when parsing module flags. Route the post-lookup
returns through a common cleanup path and release the child after use.

omap_hwmod_setup_earlycon_flags() leaks the /chosen node and the UART
node resolved from stdout-path. Track them separately and drop both
references after use.

Fixes: 1aa8f0cb19e5 ("ARM: OMAP2+: Remove unused legacy code for interconnects")
Fixes: 4f2122473363 ("ARM: OMAP2+: Check also the first dts child for hwmod flags")
Fixes: 8dd6666f4937 ("ARM: OMAP2+: omap_hwmod: Add support for earlycon")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Reviewed-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://patch.msgid.link/20260504164711.2854116-1-dbgh9129@gmail.com
Signed-off-by: Kevin Hilman (TI) <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/omap_hwmod.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index 974107ff18b4e..03cd523dff874 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -2331,13 +2331,15 @@ static int __init _init(struct omap_hwmod *oh, void *data)
 	if (r < 0) {
 		WARN(1, "omap_hwmod: %s: doesn't have mpu register target base\n",
 		     oh->name);
-		return 0;
+		r = 0;
+		goto out_put_node;
 	}
 
 	r = _init_clocks(oh, np);
 	if (r < 0) {
 		WARN(1, "omap_hwmod: %s: couldn't init clocks\n", oh->name);
-		return -EINVAL;
+		r = -EINVAL;
+		goto out_put_node;
 	}
 
 	if (np) {
@@ -2345,13 +2347,19 @@ static int __init _init(struct omap_hwmod *oh, void *data)
 
 		parse_module_flags(oh, np);
 		child = of_get_next_child(np, NULL);
-		if (child)
+		if (child) {
 			parse_module_flags(oh, child);
+			of_node_put(child);
+		}
 	}
 
 	oh->_state = _HWMOD_STATE_INITIALIZED;
 
-	return 0;
+	r = 0;
+
+out_put_node:
+	of_node_put(bus);
+	return r;
 }
 
 /**
@@ -3608,13 +3616,13 @@ int omap_hwmod_init_module(struct device *dev,
 #ifdef CONFIG_SERIAL_EARLYCON
 static void __init omap_hwmod_setup_earlycon_flags(void)
 {
-	struct device_node *np;
+	struct device_node *np, *chosen;
 	struct omap_hwmod *oh;
 	const char *uart;
 
-	np = of_find_node_by_path("/chosen");
-	if (np) {
-		uart = of_get_property(np, "stdout-path", NULL);
+	chosen = of_find_node_by_path("/chosen");
+	if (chosen) {
+		uart = of_get_property(chosen, "stdout-path", NULL);
 		if (uart) {
 			np = of_find_node_by_path(uart);
 			if (np) {
@@ -3629,8 +3637,10 @@ static void __init omap_hwmod_setup_earlycon_flags(void)
 				if (oh)
 					oh->flags |= DEBUG_OMAPUART_FLAGS;
 			}
+			of_node_put(np);
 		}
 	}
+	of_node_put(chosen);
 }
 #endif
 
-- 
2.53.0



