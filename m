Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943C867727;
	Tue, 23 Jan 2024 02:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975286; cv=none; b=kKzU0cHbDKuLOOOZWQ8zn6qYjXoJDD0n/7IzzDJR8M9aW5Wartl/Th/j2FLK7D52o48+wAeuQiD/iiMbdhAVJiFxygbYY6p6w6tYw9V6AEo/4vtIa2OgjZI/wli5n/KPKqy8nbKLrVpbPc0ujR3njVlOOdN2d1lS+yvmoHKlwpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975286; c=relaxed/simple;
	bh=rCkw2SIp3NXDuvoCwwMF0HL2lneWALL4JzyQiS46K14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmj3FWRzSN4flmHRyNgyN/zBBhgVgFklbTcE5sr4rU7d0ewOxm7zYcn/XhMeiaoz5B+qJv6hy1eASqJBAXRf2sif1CxnpdCD50lCL9yMtYmknsDDns3OZgB4gzoB6eQ6pr1zbylPTIXtg/JAHkuIiUUyLoyu+0KRerj12iNM0jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GXEwt+45; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GXEwt+45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D1EC43390;
	Tue, 23 Jan 2024 02:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975286;
	bh=rCkw2SIp3NXDuvoCwwMF0HL2lneWALL4JzyQiS46K14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GXEwt+45py78MzNlK+wcby96vubjLa1rj0YmLeOUhkhInWSy58Dv4hhRQn6sEfuRF
	 YaDFi88VJbHT/Ob8myc2PVnfUaGFydgyakv9Xvfj+X0leZrQ7IX10QzB8UPBGgUMf1
	 SePs9VURg1RySO3jL6fNjDGbW5km9FsQ7hI+LQrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 247/583] drm/tidss: Fix dss reset
Date: Mon, 22 Jan 2024 15:54:58 -0800
Message-ID: <20240122235819.552655115@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit bc288a927815efcf9d7f4a54d4d89c5df478c635 ]

The probe function calls dispc_softreset() before runtime PM is enabled
and without enabling any of the DSS clocks. This happens to work by
luck, and we need to make sure the DSS HW is active and the fclk is
enabled.

To fix the above, add a new function, dispc_init_hw(), which does:

- pm_runtime_set_active()
- clk_prepare_enable(fclk)
- dispc_softreset().

This ensures that the reset can be successfully accomplished.

Note that we use pm_runtime_set_active(), not the normal
pm_runtime_get(). The reason for this is that at this point we haven't
enabled the runtime PM yet and also we don't want the normal resume
callback to be called: the dispc resume callback does some initial HW
setup, and it expects that the HW was off (no video ports are
streaming). If the bootloader has enabled the DSS and has set up a
boot time splash-screen, the DSS would be enabled and streaming which
might lead to issues with the normal resume callback.

Fixes: c9b2d923befd ("drm/tidss: Soft Reset DISPC on startup")
Reviewed-by: Aradhya Bhatia <a-bhatia1@ti.com>
Link: https://lore.kernel.org/r/20231109-tidss-probe-v2-8-ac91b5ea35c0@ideasonboard.com
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tidss/tidss_dispc.c | 45 ++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tidss/tidss_dispc.c b/drivers/gpu/drm/tidss/tidss_dispc.c
index 2af623842cfb..98efbaf3b0c2 100644
--- a/drivers/gpu/drm/tidss/tidss_dispc.c
+++ b/drivers/gpu/drm/tidss/tidss_dispc.c
@@ -2724,6 +2724,49 @@ static int dispc_softreset(struct dispc_device *dispc)
 	return 0;
 }
 
+static int dispc_init_hw(struct dispc_device *dispc)
+{
+	struct device *dev = dispc->dev;
+	int ret;
+
+	ret = pm_runtime_set_active(dev);
+	if (ret) {
+		dev_err(dev, "Failed to set DSS PM to active\n");
+		return ret;
+	}
+
+	ret = clk_prepare_enable(dispc->fclk);
+	if (ret) {
+		dev_err(dev, "Failed to enable DSS fclk\n");
+		goto err_runtime_suspend;
+	}
+
+	ret = dispc_softreset(dispc);
+	if (ret)
+		goto err_clk_disable;
+
+	clk_disable_unprepare(dispc->fclk);
+	ret = pm_runtime_set_suspended(dev);
+	if (ret) {
+		dev_err(dev, "Failed to set DSS PM to suspended\n");
+		return ret;
+	}
+
+	return 0;
+
+err_clk_disable:
+	clk_disable_unprepare(dispc->fclk);
+
+err_runtime_suspend:
+	ret = pm_runtime_set_suspended(dev);
+	if (ret) {
+		dev_err(dev, "Failed to set DSS PM to suspended\n");
+		return ret;
+	}
+
+	return ret;
+}
+
 int dispc_init(struct tidss_device *tidss)
 {
 	struct device *dev = tidss->dev;
@@ -2833,7 +2876,7 @@ int dispc_init(struct tidss_device *tidss)
 	of_property_read_u32(dispc->dev->of_node, "max-memory-bandwidth",
 			     &dispc->memory_bandwidth_limit);
 
-	r = dispc_softreset(dispc);
+	r = dispc_init_hw(dispc);
 	if (r)
 		return r;
 
-- 
2.43.0



