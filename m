Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E3B67740;
	Tue, 23 Jan 2024 02:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975281; cv=none; b=eEGB8T6YadnpYRkgRO2UDlhevmJ7G++oQ7j0JRWYsc8jibmG60GbTR1HtPOM0aU3fWZzTgy119/EDoQOc2BimuwEfZpo0iqZIS3K4QrfMi4Jq372RnfSxp0oNuEy13pdN1j4cE/eEOiE9asdWdAVxFd8yujafV/RzwFKZ26gNxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975281; c=relaxed/simple;
	bh=D7o97E6zF5YzF1um1dRo7TuJW6vIiXnonKpTWQyPDV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVq3rz3UuhV9d9E9DcQwncf+peSVxbBjmcnulJp6F1TwoFJyFGlAhc5jh3n7wG5WQ5gjgPjskwUhqGHbSVAnRvErkGGvX6TWt/7oxKuI4WQuNp9wJi0Wo1fz5nMrKT9rJXe4AChFDlNxwpiUATAbO64fc+Bm+WiTsZOCXex0ykw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0WV+qPGv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0WV+qPGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88601C433C7;
	Tue, 23 Jan 2024 02:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975280;
	bh=D7o97E6zF5YzF1um1dRo7TuJW6vIiXnonKpTWQyPDV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0WV+qPGv03gvP15YvbAJHdCzg+A+gjjIdFdGIwEYarLEdw4JXBDE+48K6+xohtA3A
	 mrLpkizNdLo45RAEMyxTGPHwfPIl0/QIyie9k/+xAcIEQg3UqoLvYfnbhIuLzHvM1u
	 6ZI1GKU0/7Pfaji8slUP9ht+GUs6FHf6bxiK2B6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 244/583] drm/tidss: Move reset to the end of dispc_init()
Date: Mon, 22 Jan 2024 15:54:55 -0800
Message-ID: <20240122235819.465304578@linuxfoundation.org>
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

[ Upstream commit 36d1e0852680aa038e2428d450673390111b165c ]

We do a DSS reset in the middle of the dispc_init(). While that happens
to work now, we should really make sure that e..g the fclk, which is
acquired only later in the function, is enabled when doing a reset. This
will be handled in a later patch, but for now, let's move the
dispc_softreset() call to the end of dispc_init(), which is a sensible
place for it anyway.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Aradhya Bhatia <a-bhatia1@ti.com>
Link: https://lore.kernel.org/r/20231109-tidss-probe-v2-4-ac91b5ea35c0@ideasonboard.com
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Stable-dep-of: bc288a927815 ("drm/tidss: Fix dss reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tidss/tidss_dispc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/tidss/tidss_dispc.c b/drivers/gpu/drm/tidss/tidss_dispc.c
index 9d9dee7abaef..8d822372bf94 100644
--- a/drivers/gpu/drm/tidss/tidss_dispc.c
+++ b/drivers/gpu/drm/tidss/tidss_dispc.c
@@ -2777,10 +2777,6 @@ int dispc_init(struct tidss_device *tidss)
 			return r;
 	}
 
-	/* K2G display controller does not support soft reset */
-	if (feat->subrev != DISPC_K2G)
-		dispc_softreset(dispc);
-
 	for (i = 0; i < dispc->feat->num_vps; i++) {
 		u32 gamma_size = dispc->feat->vp_feat.color.gamma_size;
 		u32 *gamma_table;
@@ -2829,6 +2825,10 @@ int dispc_init(struct tidss_device *tidss)
 	of_property_read_u32(dispc->dev->of_node, "max-memory-bandwidth",
 			     &dispc->memory_bandwidth_limit);
 
+	/* K2G display controller does not support soft reset */
+	if (feat->subrev != DISPC_K2G)
+		dispc_softreset(dispc);
+
 	tidss->dispc = dispc;
 
 	return 0;
-- 
2.43.0



