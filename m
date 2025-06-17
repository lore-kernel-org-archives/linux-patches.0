Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08592EB10;
	Tue, 17 Jun 2025 15:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175694; cv=none; b=aHtM61dWduAXsVdoE7V9/OswKqRx5DXxbK2Uj3O9JXJdxNSaRndf3vKmMgm9UlXRgOKOXiMIekBZ0So7NPw0DO7j056QwXGEWwD85MquDX0odWDkFRqzWTkIaiFOvbLyK6e8mL/9yAG+zztsMkac69UIul0OO9GpeA2BrZR0wdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175694; c=relaxed/simple;
	bh=MaKsC7yqtYrbZhzrRCoMxxD7w/LqhxBhNaN9PxUoPks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fVpJPoYpkNVaG35psyjLuglSIE8HQwSHOGg4/xfkiQcu/6Q806392Efu4G0ZQ6LomzOPBabASiEduK3XGGcNkk5eklxTcxqj+VduLdVH2YARQtHB8d7pZJ4DUQsUl9LBoM7HHr5o4AHRZct9FFfaTn8VW+VcUXhvwiyKPe9t1/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+Gil6ZD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+Gil6ZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23DC3C4CEF0;
	Tue, 17 Jun 2025 15:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175694;
	bh=MaKsC7yqtYrbZhzrRCoMxxD7w/LqhxBhNaN9PxUoPks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y+Gil6ZDLQ1o2r1wY8BnSNLyZ2FufN89fBZ3fuV90xaTi4c+tcpVkXdAyEfmFfdzK
	 dgtHlSSO9rb+zqH/PoZeNf2X1VEXk2zw0cI1/fIxLhgO4Pf85uP8cFfV/RJ7bR+d0B
	 jOLy4mn2CxkZZQe0LpcpmzW/wrF0sr7HPRBvwAco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 201/356] dm: free table mempools if not used in __bind
Date: Tue, 17 Jun 2025 17:25:16 +0200
Message-ID: <20250617152346.303638409@linuxfoundation.org>
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

[ Upstream commit e8819e7f03470c5b468720630d9e4e1d5b99159e ]

With request-based dm, the mempools don't need reloading when switching
tables, but the unused table mempools are not freed until the active
table is finally freed. Free them immediately if they are not needed.

Fixes: 29dec90a0f1d9 ("dm: fix bio_set allocation")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index d154c89305fbe..44424554e6b52 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2235,10 +2235,10 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 		 * requests in the queue may refer to bio from the old bioset,
 		 * so you must walk through the queue to unprep.
 		 */
-		if (!md->mempools) {
+		if (!md->mempools)
 			md->mempools = t->mempools;
-			t->mempools = NULL;
-		}
+		else
+			dm_free_md_mempools(t->mempools);
 	} else {
 		/*
 		 * The md may already have mempools that need changing.
@@ -2247,8 +2247,8 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 		 */
 		dm_free_md_mempools(md->mempools);
 		md->mempools = t->mempools;
-		t->mempools = NULL;
 	}
+	t->mempools = NULL;
 
 	old_map = rcu_dereference_protected(md->map, lockdep_is_held(&md->suspend_lock));
 	rcu_assign_pointer(md->map, (void *)t);
-- 
2.39.5



