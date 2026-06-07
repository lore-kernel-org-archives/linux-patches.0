Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2367E13DBA0;
	Sun,  7 Jun 2026 10:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828019; cv=none; b=NSeobx6BOlIbZmDdZs1AC31NMQ05s/xFohalKQEQszWUBBM+r06n2Ywi2jeY+fqP2JWgz+kFmNW1OS1qemAVUvCTw5tgehLjb8VyZHe4pt6Ji6IH6E3vWgS/zJh69VU+T8/QGRksKAwTrHI4ZQ4rOkdgDo4y5jNxtgrCUOt2GFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828019; c=relaxed/simple;
	bh=NaOLVGnteeLyvRkA1xoFPVg5MEbXIJ4svJspzePe638=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=glYm833uTUL5o6QLC3vmqUjFt5eTB95mxwM/XSu7jJf66WrFrRHhtrHMDok4ze8nLsj2mZ2Lrs6Ndm6H2fSOmnLeQpFpTblns8bzY39nwnNVm9Avo9H7WAXypEIK1gfZY51qqz3nnN2wCs1VNrUG36ydjTHxckSYgfBqUjDkBsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dAyFPcBx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dAyFPcBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FEDF1F00893;
	Sun,  7 Jun 2026 10:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828018;
	bh=yhUFyOqi7MMJH3F74/baxnMNsrwbgXJMNEX39Z/1ffk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dAyFPcBx7U8BCtjQ80pBR/Sw9xZgX8kMaF1hyGJ5tGKEAqQCVhUKLKBSk44FK8fR0
	 0oawGh2NfTh2RBPwA0ku4SiImYjsPfAAApEBZ7aodD0+2P8hqBg6jN9iCdWDNvT1EN
	 /A6JDKcI3u4kMcQIGBr/EPC1C0/moEp40Wze0kdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 121/315] mm/damon/sysfs-schemes: delete tried region in regions_rmdirs()
Date: Sun,  7 Jun 2026 11:58:28 +0200
Message-ID: <20260607095732.070614251@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 441f92f7d386b85bad16de49db95a307cba048a2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs-schemes.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -89,7 +89,6 @@ static void damon_sysfs_scheme_region_re
 	struct damon_sysfs_scheme_region *region = container_of(kobj,
 			struct damon_sysfs_scheme_region, kobj);
 
-	list_del(&region->list);
 	kfree(region);
 }
 
@@ -166,7 +165,7 @@ static void damon_sysfs_scheme_regions_r
 	struct damon_sysfs_scheme_region *r, *next;
 
 	list_for_each_entry_safe(r, next, &regions->regions_list, list) {
-		/* release function deletes it from the list */
+		list_del(&r->list);
 		kobject_put(&r->kobj);
 		regions->nr_regions--;
 	}
@@ -2767,14 +2766,15 @@ void damos_sysfs_populate_region_dir(str
 	if (!region)
 		return;
 	region->sz_filter_passed = sz_filter_passed;
-	list_add_tail(&region->list, &sysfs_regions->regions_list);
-	sysfs_regions->nr_regions++;
 	if (kobject_init_and_add(&region->kobj,
 				&damon_sysfs_scheme_region_ktype,
 				&sysfs_regions->kobj, "%d",
 				sysfs_regions->nr_regions++)) {
 		kobject_put(&region->kobj);
+		return;
 	}
+	list_add_tail(&region->list, &sysfs_regions->regions_list);
+	sysfs_regions->nr_regions++;
 }
 
 int damon_sysfs_schemes_clear_regions(


