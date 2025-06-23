Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392FF248191;
	Mon, 23 Jun 2025 13:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685178; cv=none; b=gN9coa7D8LwXi+nl8hRka9NtaeO4hKGNE79Sw1WPuAGrdxtGk5xd78l10S/gE4Mt9WANHuNYDw3jm7EzrEaPJt8J3XqaVyaDR3YalZn8OFUJ/w/tjxF6ccEEASM+4Wzx++JLoPqZKU1gBpVD0aVswBmQtVEVeE4SGBPSXewChWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685178; c=relaxed/simple;
	bh=lH1Q7cB1jUoGVUP47LP/eO1zC988DzIQoXHeDscEy1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDIJF9cyYqpgP5QerODLCnPkViXcu4Bh7zDjQuNz+XJi7BQYPYJWXKsjr4UHJZrdvQZUUtAKencNAnA9XtIVfnptaHlMQrbWnUBVy+zRE7pRMD3Ct5fa2fHIKJZ2ThgnVOYRO9raID3+mMZ/RH/oZVYXa7uA4eoHCtiytnzuskc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZuvuOwLq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZuvuOwLq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F38C4CEF0;
	Mon, 23 Jun 2025 13:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685178;
	bh=lH1Q7cB1jUoGVUP47LP/eO1zC988DzIQoXHeDscEy1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZuvuOwLq56S9df7AuPQ0UsFKYmstHeqySxEdXsZH/RP3dhVIC/GGa86sEuMNJbsmc
	 clBaA+vo03faQ4xedhY9QPVdZlgOBF875OnsRg7weE1UTe+SjeJg/PQMJDjJwlcFYe
	 tPzI/cLhAsIWIDsxS3ya4pumwk03Pgc9mhyIEGKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/355] drm/tegra: rgb: Fix the unbound reference count
Date: Mon, 23 Jun 2025 15:03:53 +0200
Message-ID: <20250623130627.776519244@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4142a56ca7644..a3052f645c473 100644
--- a/drivers/gpu/drm/tegra/rgb.c
+++ b/drivers/gpu/drm/tegra/rgb.c
@@ -170,6 +170,11 @@ static const struct drm_encoder_helper_funcs tegra_rgb_encoder_helper_funcs = {
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
@@ -177,7 +182,14 @@ int tegra_dc_rgb_probe(struct tegra_dc *dc)
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



