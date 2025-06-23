Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366452367B0;
	Mon, 23 Jun 2025 13:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685103; cv=none; b=Qx3lfWyPZGr+nCnJkzFzmp4GxUe0au4sV1gZqV8e9xwQhickGfnnxI70FyrVFRx5T81YCKPfHQy0CRWO60fswsbH237Cw6mXHtG4eZn3WIgUYTBTWwmlWQX1Aco17WIVs5PGKryPQZmt6+nLZxwCzSmKYvvS/AFzHMupw2xY4U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685103; c=relaxed/simple;
	bh=J70sczd/ukHJKhEhnapA8d6FP4WwfXeRvRpYiv954TM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2hk0c7YQu//+yydb1EopmiBmVy6kP+AwxN+PyvW3xriuQJue9F0Fw9BpvyNzHZa7m4e9UwdyRPvY+9It9eBDvQHa+yIcIzj0k/p9bhZsiQpNy2YDOd8T+fhHOqZKd5CN8t42p5U0J4tXhPMgcjmT64kXuyyOqK10+7oYstGbQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nfV83yCY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nfV83yCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0015C4CEEA;
	Mon, 23 Jun 2025 13:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685103;
	bh=J70sczd/ukHJKhEhnapA8d6FP4WwfXeRvRpYiv954TM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nfV83yCY8Zl/P++YfADNy2mrHzTRmPqmdFRB0cCszDcC2fLXWQDHMTLWer6aDySkD
	 i7f2Toatt2Y1PAnBL3MRf2imNHj3SDQRGG1MLofCkGQMGh4A/A9oQ3K/rSX6d+A1JB
	 DX80IfORI1gR8Q3Tj+3VtEia5oBtz6Ju6Jyb2wL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/411] drm/tegra: rgb: Fix the unbound reference count
Date: Mon, 23 Jun 2025 15:02:59 +0200
Message-ID: <20250623130634.059620507@linuxfoundation.org>
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
index 761cfd49c4876..fab24d77bb986 100644
--- a/drivers/gpu/drm/tegra/rgb.c
+++ b/drivers/gpu/drm/tegra/rgb.c
@@ -193,6 +193,11 @@ static const struct drm_encoder_helper_funcs tegra_rgb_encoder_helper_funcs = {
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
@@ -200,7 +205,14 @@ int tegra_dc_rgb_probe(struct tegra_dc *dc)
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



