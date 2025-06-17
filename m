Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0832EB10;
	Tue, 17 Jun 2025 15:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175684; cv=none; b=aDCsa7+6cw7/7hHI5pX02kJzxxHnziEzntrk1dLfuUD8TmivamB2j+nUBZKgH31yd6bIdgr8ZX5MHjr+UbSVRENlF8/hbRwTdoEMITK9g1VGEEfmMKNiH3xKRv20sp6HUPh4sOByx3dktZFMxoT1WgphVkyEAcm3fcXmtH5iQGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175684; c=relaxed/simple;
	bh=CtvUjagTb1S+Ie5LIBnTl+EKByD8mWSOhdP7O//Lc6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u86nu9MIcEGqEFGDsM4qVzUgSBfdNKar9dnQrdAa0WGLC0Ta51qxDRughrcFVEcdX3L12z5NrcQYWttsy+W4P3PjTKjdXbrSD1C0tyronnKovDcv88oTKQk8XtxsrpOh4iONyP1f1uVULLriyO+6fjl/JzGCZNM+gnUl5cN0hBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ydTsMNuR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ydTsMNuR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579A7C4CEE3;
	Tue, 17 Jun 2025 15:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175684;
	bh=CtvUjagTb1S+Ie5LIBnTl+EKByD8mWSOhdP7O//Lc6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ydTsMNuR4RgE4JbKIJXUTYzMTMOo5B+zaigIZfGNODBgIEKp9SLkirb7mpJ/cR7/N
	 8NjWBUugkCrUmbRK26rxUBBV+O2BTfB/Dk/Qi7TriGsBOZhNDl3o9d+45N2CUIAD4n
	 n3BbJA1KKpGiXcpS/Le+JLZfjEy45LLu5cVMwce8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 200/356] dm: dont change md if dm_table_set_restrictions() fails
Date: Tue, 17 Jun 2025 17:25:15 +0200
Message-ID: <20250617152346.266054583@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Marzinski <bmarzins@redhat.com>

[ Upstream commit 9eb7109a5bfc5b8226e9517e9f3cc6d414391884 ]

__bind was changing the disk capacity, geometry and mempools of the
mapped device before calling dm_table_set_restrictions() which could
fail, forcing dm to drop the new table. Failing here would leave the
device using the old table but with the wrong capacity and mempools.

Move dm_table_set_restrictions() earlier in __bind(). Since it needs the
capacity to be set, save the old version and restore it on failure.

Fixes: bb37d77239af2 ("dm: introduce zone append emulation")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9ea868bd0d129..d154c89305fbe 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2195,21 +2195,29 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 			       struct queue_limits *limits)
 {
 	struct dm_table *old_map;
-	sector_t size;
+	sector_t size, old_size;
 	int ret;
 
 	lockdep_assert_held(&md->suspend_lock);
 
 	size = dm_table_get_size(t);
 
+	old_size = dm_get_size(md);
+	set_capacity(md->disk, size);
+
+	ret = dm_table_set_restrictions(t, md->queue, limits);
+	if (ret) {
+		set_capacity(md->disk, old_size);
+		old_map = ERR_PTR(ret);
+		goto out;
+	}
+
 	/*
 	 * Wipe any geometry if the size of the table changed.
 	 */
-	if (size != dm_get_size(md))
+	if (size != old_size)
 		memset(&md->geometry, 0, sizeof(md->geometry));
 
-	set_capacity(md->disk, size);
-
 	dm_table_event_callback(t, event_callback, md);
 
 	if (dm_table_request_based(t)) {
@@ -2242,12 +2250,6 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 		t->mempools = NULL;
 	}
 
-	ret = dm_table_set_restrictions(t, md->queue, limits);
-	if (ret) {
-		old_map = ERR_PTR(ret);
-		goto out;
-	}
-
 	old_map = rcu_dereference_protected(md->map, lockdep_is_held(&md->suspend_lock));
 	rcu_assign_pointer(md->map, (void *)t);
 	md->immutable_target_type = dm_table_get_immutable_target_type(t);
-- 
2.39.5



