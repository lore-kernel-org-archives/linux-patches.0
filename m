Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266F82DB7B2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301776; cv=none; b=Jihl0zUBjdtAuvOUjuKmkE60hATZvNd/KQRflrk+VwNXFbdTPDx9F0H9JJBCvI+7AnPkHKkblNBci6l02jHv7g50kLZ806Jmuk9tRuXJa0F7pmOgAtyVtLz6SpvMXGwINc7b+LdZzwEcNaNdXyTk6hubSJTh7EWEy88Ssgy84lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301776; c=relaxed/simple;
	bh=B/YvLYe84fa0saUwSnCrMIpu98pAJIOP8ODHewoIAS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/jzrGmO3aA2Y4I1oyDu+uCwMdiI29mkkpnfjEHna0vKmC3rUHuleyfmjbu5Q0sXUWTgR2QnzAREHDNWsDCQwpTkcvrnJ9BElhlNGPtyfiQhC+R21aJuTQgUzDNKPfGVhS2UUOnoErLvc4NrnWvRmTGP7B54ef1Gm9nIYE06m6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=epQ7GCSo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="epQ7GCSo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD61C2BC87;
	Sat, 28 Feb 2026 18:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301775;
	bh=B/YvLYe84fa0saUwSnCrMIpu98pAJIOP8ODHewoIAS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=epQ7GCSoXeOlDaP+slhOaEjlS00Je8ncPwxa5IhjUmpRpiBsRfTPcK5gJmrDUik2d
	 Hix3kw9CY043+oFuWkuz+beYZ3GBj8ZRYXZpKND9Ld1jDbES7S7DXnkr06bFeAdDKq
	 9++jyvjuX6eKT3nJQmoDArhZ9BTomS6vx6o5XWBa2aiVcMTLLDPl/MLbDsmzkeC6RI
	 ZC9QdKNaAVokxhQyZgN//8+QrakMNnST7HPffi0d6VsLB92SJHAAIi8hdUAIgMx8UL
	 LoGR8VC6eWGrPAS54IHJ1bAKz3VLBrMtPrVgls4C0Vsnh4vlLpJ/oxrj9ZNqm87/yL
	 gsyZXP5J27RkQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 184/385] dm: use READ_ONCE in dm_blk_report_zones
Date: Sat, 28 Feb 2026 12:56:46 -0500
Message-ID: <20260228180011.1568201-184-sashal@kernel.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit e9f5a55b70ae6187ab64ef2d1232ae2738e31d1f ]

The functon dm_blk_report_zones reads md->zone_revalidate_map, however it
may change while the function is running. Use READ_ONCE.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 37f53a2c60d0 ("dm: fix dm_blk_report_zones")
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-zone.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index d7b1c89fcd87b..912b9fe1f5648 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -56,7 +56,7 @@ int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
 {
 	struct mapped_device *md = disk->private_data;
 	struct dm_table *map;
-	struct dm_table *zone_revalidate_map = md->zone_revalidate_map;
+	struct dm_table *zone_revalidate_map = READ_ONCE(md->zone_revalidate_map);
 	int srcu_idx, ret = -EIO;
 	bool put_table = false;
 
-- 
2.51.0

