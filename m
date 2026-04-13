Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CB12459D1;
	Mon, 13 Apr 2026 16:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097120; cv=none; b=LV/KUNip7S4IMzmwujTayRNXWce0XHynwO9tnI3sPYbqqlTsgj/jhnvbwcLMlxJG2XMdFH0/TF8B/UuWTAeGyys3cm/0OgetGeReLJNJCotjpgY2wuM9VpIRdMOGW82Qcun1SI4b28zw/Y67FQEB0VDeCyfqsxeO0RQlpcmYvIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097120; c=relaxed/simple;
	bh=3aC3utC5CDRGCPaTmhlq/xz+CRO+0mQ03QsMTIREQRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=StBXt4oe43iQVOn0kTETNkAr0n7GNoDvTcCK1Ktdsu3Ckaf6bY7YZpbzY4Iokh2nffysVRKZN+3g9i5NTwgVsutU5dKp/mWpy++3yCDDkqwvd2hlShOqNuYWFyUTBo3dMVHBjA6/qyPQwER7TvfHK3kwTw57ejnfsJ53xcj4JJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VofMNFGh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VofMNFGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3452C2BCAF;
	Mon, 13 Apr 2026 16:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097120;
	bh=3aC3utC5CDRGCPaTmhlq/xz+CRO+0mQ03QsMTIREQRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VofMNFGhDs8tubi1FncEb24p7Brmzr7fXzF6VlNQSQV+bQTh86Vemn7jo54Xf1CkO
	 UbG42qvdI7VX/PeiXzEG3BGL9L414k5aAqGKdFxEb+16pFDrBOUytCnzuC19v/DgHq
	 qO+zKLrm2KdGlOF+zeMGNFDun4SisQ/n10v0x1QY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Qing <wangqing@vivo.com>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 014/570] ARM: OMAP2+: add missing of_node_put before break and return
Date: Mon, 13 Apr 2026 17:52:25 +0200
Message-ID: <20260413155830.948895594@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Qing <wangqing@vivo.com>

[ Upstream commit 883f464c1d23663047eda4f2bcf622365e2d0dd0 ]

Fix following coccicheck warning:
WARNING: Function "for_each_matching_node_and_match"
should have of_node_put() before return.

Early exits from for_each_matching_node_and_match should decrement the
node reference counter.

Signed-off-by: Wang Qing <wangqing@vivo.com>
Message-Id: <1639388545-63615-1-git-send-email-wangqing@vivo.com>
[tony@atomide.com: updated for omap_hwmod.c that was already patched]
Signed-off-by: Tony Lindgren <tony@atomide.com>
Stable-dep-of: 93a04ab480c8 ("ARM: omap2: Fix reference count leaks in omap_control_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/cm_common.c  |  8 ++++++--
 arch/arm/mach-omap2/control.c    | 19 ++++++++++++++-----
 arch/arm/mach-omap2/prm_common.c |  8 ++++++--
 3 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-omap2/cm_common.c b/arch/arm/mach-omap2/cm_common.c
index e2d069fe67f18..87f2c2d2d7544 100644
--- a/arch/arm/mach-omap2/cm_common.c
+++ b/arch/arm/mach-omap2/cm_common.c
@@ -320,8 +320,10 @@ int __init omap2_cm_base_init(void)
 		data = (struct omap_prcm_init_data *)match->data;
 
 		ret = of_address_to_resource(np, 0, &res);
-		if (ret)
+		if (ret) {
+			of_node_put(np);
 			return ret;
+		}
 
 		if (data->index == TI_CLKM_CM)
 			mem = &cm_base;
@@ -367,8 +369,10 @@ int __init omap_cm_init(void)
 			continue;
 
 		ret = omap2_clk_provider_init(np, data->index, NULL, data->mem);
-		if (ret)
+		if (ret) {
+			of_node_put(np);
 			return ret;
+		}
 	}
 
 	return 0;
diff --git a/arch/arm/mach-omap2/control.c b/arch/arm/mach-omap2/control.c
index 062d431fc33a8..c514a96022699 100644
--- a/arch/arm/mach-omap2/control.c
+++ b/arch/arm/mach-omap2/control.c
@@ -769,8 +769,10 @@ int __init omap2_control_base_init(void)
 		data = (struct control_init_data *)match->data;
 
 		mem = of_iomap(np, 0);
-		if (!mem)
+		if (!mem) {
+			of_node_put(np);
 			return -ENOMEM;
+		}
 
 		if (data->index == TI_CLKM_CTRL) {
 			omap2_ctrl_base = mem;
@@ -810,22 +812,24 @@ int __init omap_control_init(void)
 		if (scm_conf) {
 			syscon = syscon_node_to_regmap(scm_conf);
 
-			if (IS_ERR(syscon))
-				return PTR_ERR(syscon);
+			if (IS_ERR(syscon)) {
+				ret = PTR_ERR(syscon);
+				goto of_node_put;
+			}
 
 			if (of_get_child_by_name(scm_conf, "clocks")) {
 				ret = omap2_clk_provider_init(scm_conf,
 							      data->index,
 							      syscon, NULL);
 				if (ret)
-					return ret;
+					goto of_node_put;
 			}
 		} else {
 			/* No scm_conf found, direct access */
 			ret = omap2_clk_provider_init(np, data->index, NULL,
 						      data->mem);
 			if (ret)
-				return ret;
+				goto of_node_put;
 		}
 	}
 
@@ -836,6 +840,11 @@ int __init omap_control_init(void)
 	}
 
 	return 0;
+
+of_node_put:
+	of_node_put(np);
+	return ret;
+
 }
 
 /**
diff --git a/arch/arm/mach-omap2/prm_common.c b/arch/arm/mach-omap2/prm_common.c
index 65b2d82efa27b..fb2d48cfe756b 100644
--- a/arch/arm/mach-omap2/prm_common.c
+++ b/arch/arm/mach-omap2/prm_common.c
@@ -752,8 +752,10 @@ int __init omap2_prm_base_init(void)
 		data = (struct omap_prcm_init_data *)match->data;
 
 		ret = of_address_to_resource(np, 0, &res);
-		if (ret)
+		if (ret) {
+			of_node_put(np);
 			return ret;
+		}
 
 		data->mem = ioremap(res.start, resource_size(&res));
 
@@ -799,8 +801,10 @@ int __init omap_prcm_init(void)
 		data = match->data;
 
 		ret = omap2_clk_provider_init(np, data->index, NULL, data->mem);
-		if (ret)
+		if (ret) {
+			of_node_put(np);
 			return ret;
+		}
 	}
 
 	omap_cm_init();
-- 
2.51.0



