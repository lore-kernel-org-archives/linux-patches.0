Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449F938C42D;
	Sun,  7 Jun 2026 11:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780830214; cv=none; b=nIujqmiYTxQ3OUR/OVcmh7tAY+KOlIkX9rH9T+OUgUnUgALcyqrB7fjYprFjHoSC87IUGMIyhI1vOVvcB/ccMxNZIYwwWEBAgRxh1F08PnIkEDEDle77JAI9Gr4C88SnSYTXCHXXDjO7+B3DAzj75yir3QQvDYdc9TlwiUCqOPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780830214; c=relaxed/simple;
	bh=lJP9jjIr4TgOud/p7BKLaykE84HZsK5EAPTg5U3aVVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9AButEhmhFhdJz5R5cmUDoh4EUq9YhDgCJzDem98ov3ahYpy/wRm7o9hlBdx9Dp6VjttQmrf/VhgfLuZlDcdUcIvEuCk27KzQwttGvOaTj/CEcvZJZUAddcWO7H8wAvT7B2NFZZp6NUa12wdoR1gPNSl1PeWpOya7Fk4XCIa04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IKMOo3CL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IKMOo3CL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898DB1F00893;
	Sun,  7 Jun 2026 11:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780830213;
	bh=mTWsdKu4BJmcO8UqP1J7xUD1DFL9IcFn38nD4mUaxaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IKMOo3CLVeMgRZb9V/xW5D5pft8isc4OeOG+oRQM5MQE9qEb4zs0omJ9zmNRZPXKQ
	 pkRLjYvuwTsE6dwCeledjMuD+O5m1IkFlPpKx3mfXEzzMmLG5ByPtcV5Ie39CALkZ0
	 kfMW7ePmCvfC2l1fSfgUaqCY5JSA23l4M6SLqQnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 289/307] mm/damon/sysfs-schemes: delete tried region in regions_rmdirs()
Date: Sun,  7 Jun 2026 12:01:26 +0200
Message-ID: <20260607095738.349473085@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: SeongJae Park <sj@kernel.org>

[ Upstream commit 441f92f7d386b85bad16de49db95a307cba048a2 ]

DAMON sysfs maintains the DAMOS tried region directory objects via a
linked list.  When the user requests refresh of the directories, DAMON
sysfs removes all the region directories first, and then generate updated
regions directory on the empty space.  The removal function
(damon_sysfs_scheme_regions_rm_dirs()) only puts the kobj objects.
Deletion of the container region object from the linked list is done
inside the kobj release callback function.

If somehow the callback invocation is delayed, the list will contain
regions list that gonna be freed.  If the updated region directories
creation is started in this situation, the list can be corrupted and
use-after-free can happen.

Because the kobj objects are managed by only DAMON sysfs, the issue cannot
happen in normal situation.  But, such delays can be made on kernels that
built with CONFIG_DEBUG_KOBJECT_RELEASE.  On the kernel, the issue can
indeed be reproduced like below.

    # damo start --damos_action stat
    # cd /sys/kernel/mm/damon/admin/kdamonds/0/
    # for i in {1..10}; do echo update_schemes_tried_regions > state; done
    # dmesg | grep underflow
    [   89.296152] refcount_t: underflow; use-after-free.

Fix the issue by removing the region object from the list when
decrementing the reference count.

Also update damos_sysfs_populate_region_dir() to add the region object to
the list only after the kobject_init_and_add() is success, so that fail of
kobject_init_and_add() is not leaving the deallocated object on the list.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260518152559.93038-1-sj@kernel.org
Link: https://lore.kernel.org/20260513011920.119183-1-sj@kernel.org [1]
Fixes: 9277d0367ba1 ("mm/damon/sysfs-schemes: implement scheme region directory")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.2.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs-schemes.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -79,7 +79,6 @@ static void damon_sysfs_scheme_region_re
 	struct damon_sysfs_scheme_region *region = container_of(kobj,
 			struct damon_sysfs_scheme_region, kobj);
 
-	list_del(&region->list);
 	kfree(region);
 }
 
@@ -197,7 +196,7 @@ static void damon_sysfs_scheme_regions_r
 	struct damon_sysfs_scheme_region *r, *next;
 
 	list_for_each_entry_safe(r, next, &regions->regions_list, list) {
-		/* release function deletes it from the list */
+		list_del(&r->list);
 		kobject_put(&r->kobj);
 		regions->nr_regions--;
 	}
@@ -2186,14 +2185,15 @@ static int damon_sysfs_before_damos_appl
 	region = damon_sysfs_scheme_region_alloc(r);
 	if (!region)
 		return 0;
-	list_add_tail(&region->list, &sysfs_regions->regions_list);
-	sysfs_regions->nr_regions++;
 	if (kobject_init_and_add(&region->kobj,
 				&damon_sysfs_scheme_region_ktype,
 				&sysfs_regions->kobj, "%d",
 				damon_sysfs_schemes_region_idx++)) {
 		kobject_put(&region->kobj);
+		return 0;
 	}
+	list_add_tail(&region->list, &sysfs_regions->regions_list);
+	sysfs_regions->nr_regions++;
 	return 0;
 }
 


