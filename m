Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796E84409;
	Mon, 23 Jun 2025 22:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716095; cv=none; b=ZxG5ZzWT7xAwrDApFq4C6UuZuVWvnW8MyHNMLn2vA4jJZiOWn5jbJii23dV5vUwdar0Eod9XK/HQsUIQeyuaLAxGofM6ixPZiSBrGcXY4EQ5vDGZbd5RcUShkxkVsf892vPVjESH44YmBJEkMRwilRbiN+yhN4erqNY3OZIFp4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716095; c=relaxed/simple;
	bh=WuXfuZWcf9hI4X8mYQ+F55SUH8gyIZgDxCOqeZwcHPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s38I0L+CTXkLiZdENId1MaBdoqvY43Ri4B7x0VZ5tAc4McNEZ1CCGJCtHXmC7eCFHYfKU6B+eHWbGj7BbJ/eVotT85KjQ3h3QYlv7c2WHTqdd1cluNyxq/3I4Wrc4jdfa6aDj+AZxltduJh2Sa1OQcWYIOhMZMacUPKlrgw60As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bt8i0uQl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bt8i0uQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDBAC4CEEA;
	Mon, 23 Jun 2025 22:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716095;
	bh=WuXfuZWcf9hI4X8mYQ+F55SUH8gyIZgDxCOqeZwcHPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bt8i0uQlQw9gp3DwyWfb5N4Fislsurn2lU6rrqrWsBESeF7QuaNFuu/MpOgYPYEZF
	 5I4gQ3W1f3UxwnO/vgUVLijP1wFPhZ5FWy4czyvskptZICkU8LodVQQif4ClM4eYZR
	 X64CkuWa/j5f8gh8KNkl7YJSEMtORFa8ZopxnM80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sukrut Bellary <sbellary@baylibre.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Judith Mendez <jm@ti.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 302/411] pmdomain: ti: Fix STANDBY handling of PER power domain
Date: Mon, 23 Jun 2025 15:07:26 +0200
Message-ID: <20250623130641.249318542@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sukrut Bellary <sbellary@baylibre.com>

[ Upstream commit 36795548dcc841c73f03793ed6cf741a88130922 ]

Per AM335x TRM[1](section 8.1.4.3 Power mode), in case of STANDBY,
PER domain should be ON. So, fix the PER power domain handling on standby.

[1] https://www.ti.com/lit/ug/spruh73q/spruh73q.pdf

Signed-off-by: Sukrut Bellary <sbellary@baylibre.com>
Reviewed-by: Kevin Hilman <khilman@baylibre.com>
Tested-by: Judith Mendez <jm@ti.com>
Link: https://lore.kernel.org/r/20250318230042.3138542-3-sbellary@baylibre.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/omap_prm.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/ti/omap_prm.c b/drivers/soc/ti/omap_prm.c
index 1248d5d56c8d4..544e57fff96ca 100644
--- a/drivers/soc/ti/omap_prm.c
+++ b/drivers/soc/ti/omap_prm.c
@@ -19,7 +19,9 @@
 #include <linux/pm_domain.h>
 #include <linux/reset-controller.h>
 #include <linux/delay.h>
-
+#if IS_ENABLED(CONFIG_SUSPEND)
+#include <linux/suspend.h>
+#endif
 #include <linux/platform_data/ti-prm.h>
 
 enum omap_prm_domain_mode {
@@ -89,6 +91,7 @@ struct omap_reset_data {
 #define OMAP_PRM_HAS_RSTST	BIT(1)
 #define OMAP_PRM_HAS_NO_CLKDM	BIT(2)
 #define OMAP_PRM_RET_WHEN_IDLE	BIT(3)
+#define OMAP_PRM_ON_WHEN_STANDBY	BIT(4)
 
 #define OMAP_PRM_HAS_RESETS	(OMAP_PRM_HAS_RSTCTRL | OMAP_PRM_HAS_RSTST)
 
@@ -405,7 +408,8 @@ static const struct omap_prm_data am3_prm_data[] = {
 		.name = "per", .base = 0x44e00c00,
 		.pwrstctrl = 0xc, .pwrstst = 0x8, .dmap = &omap_prm_noinact,
 		.rstctrl = 0x0, .rstmap = am3_per_rst_map,
-		.flags = OMAP_PRM_HAS_RSTCTRL, .clkdm_name = "pruss_ocp"
+		.flags = OMAP_PRM_HAS_RSTCTRL | OMAP_PRM_ON_WHEN_STANDBY,
+		.clkdm_name = "pruss_ocp",
 	},
 	{
 		.name = "wkup", .base = 0x44e00d00,
-- 
2.39.5



