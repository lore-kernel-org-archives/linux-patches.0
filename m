Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C083382D6
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301643; cv=none; b=mNVlHwNE7vh2kl3qTvIc24zn0NZTfx26JlXf1TLMiHHd8OVklBR+EEnDmLkmTHGBWN7Q1mjs0Gz6TLK1nGRunTF3qAX7vpByI0OztSXWBbZV5XYk6dbLwM2ymjM6wUgHocQzDd1tVinyMvxCZkFz3/fDXFS1hUUbasikhoz9+sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301643; c=relaxed/simple;
	bh=47hgpYkrvGGFa8Qbly3gzenk/MCRo/bY2x27LT/XCtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldpFZRuUXthAIXQ1QG3LcjoYOGI4MN1O21zzElFgryD4AQMIhaXqE/QLZgoWwl6dJ7VjnO36yUGvKhKSXoXhFbxM6Fm2A+nv79B+wsr+ewHzWyHo7OqKjKTDLtKejn5cCCvNRWyh84ubFL+ZBq58wKhEbGTi3MwAkLREmTNSHNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dQJ/iS4o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dQJ/iS4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31FA1C116D0;
	Sat, 28 Feb 2026 18:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301643;
	bh=47hgpYkrvGGFa8Qbly3gzenk/MCRo/bY2x27LT/XCtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQJ/iS4oDOZZgdEVw9oi0JhEKTidrtvZ+K+keZm4Ixd6VPZBZK0m4ivDsAVvk6i7j
	 wTbJrikGp2/lsva4Pypw8Shc/YtJZTAwSSR7qZmPNaBZNqAYLNYZ1MbEcn2OY0sGZo
	 m9ISxTiuaUSsgmOf3a2eSlxVReVAuFHCm1ycJOLTJL+Gh2ziBXFxx3VkwPCw8Yzawt
	 IqFrRWFULChG5HRYpb2RbXiQ87OChKkbzKITMEWG+k6yuGmfVfm1WJxelyhZYE/KJ6
	 x4kfZYSzHTGolKZqvgjqkcw6jZiAE07FN9JoiYi9LjODGZDKWiOxVWBpsswXr0/ZlS
	 RF8RuSHVXHM4A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Felix Gu <ustc.gu@gmail.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/385] thermal/of: Fix reference leak in thermal_of_cm_lookup()
Date: Sat, 28 Feb 2026 12:54:20 -0500
Message-ID: <20260228180011.1568201-38-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit a1fe789a96fe47733c133134fd264cb7ca832395 ]

In thermal_of_cm_lookup(), tr_np is obtained via of_parse_phandle(), but
never released.

Use the __free(device_node) cleanup attribute to automatically release
the node and fix the leak.

Fixes: 423de5b5bc5b ("thermal/of: Fix cdev lookup in thermal_of_should_bind()")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
[ rjw: Changelog edits ]
Link: https://patch.msgid.link/20260124-thermal_of-v1-1-54d3416948cf@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_of.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
index e0aa9d9d5604b..3e674f2d66316 100644
--- a/drivers/thermal/thermal_of.c
+++ b/drivers/thermal/thermal_of.c
@@ -299,10 +299,10 @@ static bool thermal_of_cm_lookup(struct device_node *cm_np,
 				 struct cooling_spec *c)
 {
 	for_each_child_of_node_scoped(cm_np, child) {
-		struct device_node *tr_np;
 		int count, i;
 
-		tr_np = of_parse_phandle(child, "trip", 0);
+		struct device_node *tr_np __free(device_node) =
+			of_parse_phandle(child, "trip", 0);
 		if (tr_np != trip->priv)
 			continue;
 
-- 
2.51.0

