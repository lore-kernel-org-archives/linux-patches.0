Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97264253F3A;
	Mon, 23 Jun 2025 13:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684975; cv=none; b=W32LRWCf47u5n1484Rqww1KAg7nnmvmgztEqKn1gXT4CdoKtFC6sugXIDRy+RRc+QB7yscJu9lR4+2xzZJLyiO+lJ1LSWsxT2vdfvOpbxFsGA/MY5aBnndM0QB/GPNPNdyIMwo1Gar6HZ+lSOw2lt/+t6ZWTf5y4UXZ0y7/CQKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684975; c=relaxed/simple;
	bh=3ScfD/jPzSY6mk9VvE/JnJHPCZsnlXxp3lRvr5FfuKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sbgCBIcggJtbG/j74whhtLcClBH9kfwXdmZyHB7ob320rt0ziZuwJYWyP5BY9GSrL+Y/Jq31NAurHdujxYGnilJTht0OBEQjvW7YT5hyEmtTo/ZvROagoKu+MgwKnNNgfSXI6XtZ99eeV6zjV6+JHvStwBRJ/XZ4J0Fqq3eJVWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fYlkO20e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fYlkO20e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A67BC4CEEA;
	Mon, 23 Jun 2025 13:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684975;
	bh=3ScfD/jPzSY6mk9VvE/JnJHPCZsnlXxp3lRvr5FfuKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fYlkO20e+k5PV0bfcuiCrIRXjt3kRNWA+n4ZugOh3MdTnmTU9r+Z++pP0VqVFqMKM
	 NRqKeZ7C+sAVd44+cvFnsrWPCkDWpoj4EEBFx1Il0OAJOg2a8F9zzykyysJsyIvK7x
	 kXlL9vMX3IPSDNy1HqJp5rtnxKlkewdkVoNDb12Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 025/222] drm/tegra: rgb: Fix the unbound reference count
Date: Mon, 23 Jun 2025 15:06:00 +0200
Message-ID: <20250623130612.656503433@linuxfoundation.org>
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
index 4be4dfd4a68a3..a2168866f5520 100644
--- a/drivers/gpu/drm/tegra/rgb.c
+++ b/drivers/gpu/drm/tegra/rgb.c
@@ -211,6 +211,11 @@ static const struct drm_encoder_helper_funcs tegra_rgb_encoder_helper_funcs = {
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
@@ -218,7 +223,14 @@ int tegra_dc_rgb_probe(struct tegra_dc *dc)
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



