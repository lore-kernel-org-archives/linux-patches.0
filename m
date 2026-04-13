Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A1B30EF68;
	Mon, 13 Apr 2026 16:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098658; cv=none; b=cnOrZZDTKEmeeXT2AZ0QRht/fBCDIrBHhGavI9+BvtHWPFOGVUtnzYOLGxpB9jwQ2bioR1B2Wl11P5q60gfrnzikbu9jvbzhn84dhIihCJq/sdW7mRyxkpd/QlIqdE/ZDFhXZl0JQ3FNoW6E/0ctRTHxMTk8ai2wy6Ce/SxjvPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098658; c=relaxed/simple;
	bh=0vohfmxsfEgV7u3x2dGa8OHRGEeFgH3SNWbDzwJ58HQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jc3o3W4n4mpYK1oZW67cWTMLT6WTZv3iJeteKvUW1QHcur6V/+OmIl/5lmjutzFx29HFiWp5doY9jmrL8Cw32Do6SHk19d2ecHM05OxL0X/0TgspLMh8FHT9V7QNUXNKjQMyEj9DXKR3NRlgERN+VoBw87Cxn0cPkFsEzgVtqGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VTOEu/4y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VTOEu/4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79413C2BCAF;
	Mon, 13 Apr 2026 16:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098657;
	bh=0vohfmxsfEgV7u3x2dGa8OHRGEeFgH3SNWbDzwJ58HQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VTOEu/4yMUX0mLKNDWgVT0rpNFxBwVmyWWZY42+2C8gWWp9fbFZDxPAA5Ijt7R8Va
	 zdtXp/e1wQ/DTb1NyoB2+rY5YH0vowZhm0zYt0Zugk7aCttK1x1lo/vkcd6Bhotjk6
	 p+py74rSRIWf8f6PRDCC9xU2IgmcNO3pknFfbTcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Qing <wangqing@vivo.com>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 007/491] ARM: OMAP2+: add missing of_node_put before break and return
Date: Mon, 13 Apr 2026 17:54:12 +0200
Message-ID: <20260413155819.326022555@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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
index b7ea609386d52..d86a36120738d 100644
--- a/arch/arm/mach-omap2/cm_common.c
+++ b/arch/arm/mach-omap2/cm_common.c
@@ -333,8 +333,10 @@ int __init omap2_cm_base_init(void)
 		data = (struct omap_prcm_init_data *)match->data;
 
 		ret = of_address_to_resource(np, 0, &res);
-		if (ret)
+		if (ret) {
+			of_node_put(np);
 			return ret;
+		}
 
 		if (data->index == TI_CLKM_CM)
 			mem = &cm_base;
@@ -380,8 +382,10 @@ int __init omap_cm_init(void)
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
index 73338cf80d76c..9bc69caf338f1 100644
--- a/arch/arm/mach-omap2/control.c
+++ b/arch/arm/mach-omap2/control.c
@@ -774,8 +774,10 @@ int __init omap2_control_base_init(void)
 		data = (struct control_init_data *)match->data;
 
 		mem = of_iomap(np, 0);
-		if (!mem)
+		if (!mem) {
+			of_node_put(np);
 			return -ENOMEM;
+		}
 
 		if (data->index == TI_CLKM_CTRL) {
 			omap2_ctrl_base = mem;
@@ -815,22 +817,24 @@ int __init omap_control_init(void)
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
 
@@ -841,6 +845,11 @@ int __init omap_control_init(void)
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



