Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A617D2ECD2F;
	Tue, 17 Jun 2025 15:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175095; cv=none; b=T4xfuf4SkZAfXsBu27o7bJQ8AAKphUd6C2QQn1XfQ0OYcMK541pc5tec1BBl0kUyCRNOE2FFlR8l9UyXgisk3uSafjHHayfNde73YNM517BGRXkOi87Il8cq13jx8bT41592BfE2x3XdNfgJAoiH2CLuK7jpaxXKUlKA8TJaHU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175095; c=relaxed/simple;
	bh=tnX4EgJK0xZDtXNwolo+JUo7qE4UaIrsgImcMUHyqr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yp0GKPcj+dqZC4g7EwY950g/g3VG7O4f6sD7rFcb2DgSGxCjaKX/345nc52DYkiUYIVt2dvXIZWsKgHCV4A1eUVDjWXLxJ4GJPDUKzoDoSEfGxGCsx+m5iixpOnSs8lBxXEbNLVyC+5bmQNAOO3Zlllcv7uJrLCXwb1gOFECmGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j3q6RKvx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j3q6RKvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BD4C4CEE3;
	Tue, 17 Jun 2025 15:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175095;
	bh=tnX4EgJK0xZDtXNwolo+JUo7qE4UaIrsgImcMUHyqr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j3q6RKvxH0I69YXJ9ByMa+fSryh/0PKzB/Kk9fmgqPdsxxfY7vHNdjsp+gRfsoTwS
	 gNNlKf3tq8G/0ZoA5YVGpg7/qqIBakAT50d+Kmpg9WRA2V+FZKhRDhQWsNYY6sXi9x
	 mN9fEfgu2K432rPPSqwQCf5txupUgVavUuzZv25Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 091/512] drm/tegra: rgb: Fix the unbound reference count
Date: Tue, 17 Jun 2025 17:20:57 +0200
Message-ID: <20250617152423.267285311@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 3c3642335065c3bde0742b0edc505b6ea8fdc2b3 ]

The of_get_child_by_name() increments the refcount in tegra_dc_rgb_probe,
but the driver does not decrement the refcount during unbind. Fix the
unbound reference count using devm_add_action_or_reset() helper.

Fixes: d8f4a9eda006 ("drm: Add NVIDIA Tegra20 support")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20250205112137.36055-1-biju.das.jz@bp.renesas.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/rgb.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tegra/rgb.c b/drivers/gpu/drm/tegra/rgb.c
index 1e8ec50b759e4..ff5a749710db3 100644
--- a/drivers/gpu/drm/tegra/rgb.c
+++ b/drivers/gpu/drm/tegra/rgb.c
@@ -200,6 +200,11 @@ static const struct drm_encoder_helper_funcs tegra_rgb_encoder_helper_funcs = {
 	.atomic_check = tegra_rgb_encoder_atomic_check,
 };
 
+static void tegra_dc_of_node_put(void *data)
+{
+	of_node_put(data);
+}
+
 int tegra_dc_rgb_probe(struct tegra_dc *dc)
 {
 	struct device_node *np;
@@ -207,7 +212,14 @@ int tegra_dc_rgb_probe(struct tegra_dc *dc)
 	int err;
 
 	np = of_get_child_by_name(dc->dev->of_node, "rgb");
-	if (!np || !of_device_is_available(np))
+	if (!np)
+		return -ENODEV;
+
+	err = devm_add_action_or_reset(dc->dev, tegra_dc_of_node_put, np);
+	if (err < 0)
+		return err;
+
+	if (!of_device_is_available(np))
 		return -ENODEV;
 
 	rgb = devm_kzalloc(dc->dev, sizeof(*rgb), GFP_KERNEL);
-- 
2.39.5



