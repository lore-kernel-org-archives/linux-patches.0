Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90041175A7B;
	Sat, 28 Feb 2026 17:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301386; cv=none; b=F6HQFH9GzHI1xm2SMUmTbHH2WcZ90g475do6ow32iZDPQglaR451Nc11KRI17LnQVNfzBQESgRaTz1+koNbVmOhd6CIXmIzDm6Hv7/qyyyWjgQjbeb+VWKXdsi9NlM1SljUWi5sLwsGwaKjHnlcqrCcYMTce1DSyletALzH7IPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301386; c=relaxed/simple;
	bh=F4MJejqL9xPFVLoPwmRms9z9fysULGQptS0CePkzVu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+Z2ISTj0sMdynD14rdmoNUlDsiaNkf860i+kliK5w7xtwP3VsmrPb5o+OMY/srzjWerSsGGv6KGbjsphK0ByPEutrbh+zBbd4wlYcdxm6MPJlu6IsjicYOSlz1FEa9fkDcghd2j/4+9Ik2Ug3EzsjWP9v2DMNA5DMfqVh8qUy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OCRG8OKF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OCRG8OKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD897C19424;
	Sat, 28 Feb 2026 17:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301386;
	bh=F4MJejqL9xPFVLoPwmRms9z9fysULGQptS0CePkzVu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OCRG8OKFzmlZsQymXYyLFF6BxgD4sKOLHZireZVeBDNXT3tAuoYKy4opBaN1A2d3b
	 xBHg3YgZ2f9cMD69zdcP2cgs8Btt69LD8EF+SYMq5eEd7fRvcrWvzx/rxTzZq936FU
	 pPVqbvMTEcaeMlndNsRoXkqCKUukxxlmdFliDIsZ8BXne3iKbXDIjYThgl4p1LcG8r
	 fzBMujGOAV8O1eHKk0I03cJCW36OSB5dva50ciPqYk63ZWYB+7yA0rri7n7hP7zhpV
	 9kvyVNnHNM0Su07QlqKZxSnRmup9NeGM7c/Bwrymf/VTdrWISN6uoMIKr4fYs6h03D
	 L95+RTYUJFnOg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Luca Ceresoli <luca.ceresoli@bootlin.com>,
	stable@vger.kernel.org,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 575/752] drm: of: drm_of_panel_bridge_remove(): fix device_node leak
Date: Sat, 28 Feb 2026 12:44:46 -0500
Message-ID: <20260228174750.1542406-575-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

[ Upstream commit a4b4385d0523e39a7c058cb5a6c8269e513126ca ]

drm_of_panel_bridge_remove() uses of_graph_get_remote_node() to get a
device_node but does not put the node reference.

Fixes: c70087e8f16f ("drm/drm_of: add drm_of_panel_bridge_remove function")
Cc: stable@vger.kernel.org # v4.15
Acked-by: Maxime Ripard <mripard@kernel.org>
Link: https://patch.msgid.link/20260109-drm-bridge-alloc-getput-drm_of_find_bridge-2-v2-1-8bad3ef90b9f@bootlin.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/drm_of.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/drm/drm_of.h b/include/drm/drm_of.h
index 7f0256dae3f13..f3e55ea2174c0 100644
--- a/include/drm/drm_of.h
+++ b/include/drm/drm_of.h
@@ -5,6 +5,7 @@
 #include <linux/err.h>
 #include <linux/of_graph.h>
 #if IS_ENABLED(CONFIG_OF) && IS_ENABLED(CONFIG_DRM_PANEL_BRIDGE)
+#include <linux/of.h>
 #include <drm/drm_bridge.h>
 #endif
 
@@ -173,6 +174,8 @@ static inline int drm_of_panel_bridge_remove(const struct device_node *np,
 	bridge = of_drm_find_bridge(remote);
 	drm_panel_bridge_remove(bridge);
 
+	of_node_put(remote);
+
 	return 0;
 #else
 	return -EINVAL;
-- 
2.51.0

