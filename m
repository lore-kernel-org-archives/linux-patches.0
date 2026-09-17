Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD9A4B44B1;
	Thu, 17 Sep 2026 15:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659470; cv=none; b=EUtqeLBMbVWJ7w+KUnkArMCA+wm3bV0YLe0YYWSUXMpriM+oIlgq+n4VUXWH7bsva2HwrkEcwk5IL6h50mNmLglPKVikcWiHLgpHq8Q0HHYgMQjZ7R/bFKcBUZXSATzl2VikjHQOElwIcD+tq2IUxcDfmiIeM9LfkCLcTdDs+3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659470; c=relaxed/simple;
	bh=t6btjatQ7ak57yw7N41EdrfOBclTR4dd9wbcEXaaVPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HVXaMXOtYwllZ/dbZMYQFdwZ3EjPuS7Vag/mGsRHTxj3YU9MuCtR5VZGUh3hHcG3h7zj1CTtJYCSw7IeagIAOEnmqZDUPah+phUOIUf/cQX1OxmlCv8PojWqKDsk4wZCVKnBPhkcPwuVezxjzyti/irqOREUE/sTkgo8ys3d644=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EFffqVLa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EFffqVLa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394381F0089B;
	Thu, 17 Sep 2026 15:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659463;
	bh=70k5nfNSWQLuXLm7Hf7xN8LOAB1nfLsldkltv7f4zo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EFffqVLa3S/4AyUBRTEZ0g/XZtQ8MNJrf7YoMXgluUI7ezUpgoA7G4b7Jq5qG6ve+
	 zx2QbZZ16kT4WVdH23eKZqQT+ZhwKf9vGjUT0YN3rVCAbpmQgqg9EXT5fLgNVyZrgH
	 4bn7skj414+0ZU29E0luhp0QeUqpVLi87rUehEV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 265/733] bpf: Cancel special fields when recycling rhtab elements
Date: Thu, 17 Sep 2026 16:09:33 +0100
Message-ID: <20260917151357.935347529@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>

[ Upstream commit 65cc95eba9e8b46312cac38c227473605a4b996a ]

rhtab_map_update_existing() and rhtab_delete_elem() call
bpf_obj_free_fields() when replacing or deleting a value. These map
operations can run from BPF programs in NMI context, where releasing a
referenced kptr or another complex field is not generally safe.

Array and hash maps avoid that problem by cancelling only the asynchronous
fields which can be stopped safely in the caller context. Other ownership
state remains attached to the allocation until its memory allocator
destructor performs the final cleanup.

Use bpf_obj_cancel_fields() for the corresponding rhtab paths as well. This
cancels timers, workqueues, and task work while allowing rhtab_mem_dtor() to
release referenced kptrs when the allocation is eventually destroyed.

Fixes: 6905f8601298 ("bpf: Allow special fields in resizable hashtab")
Signed-off-by: Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>
Acked-by: Mykyta Yatsenko <yatsenko@meta.com>
[ kkd: Rebased, used direct helper calls, and rewrote the commit log ]
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20260904104203.345917-4-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/hashtab.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index df22236d1ccf9..59406da06424d 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -2869,16 +2869,6 @@ static int rhtab_map_alloc_check(union bpf_attr *attr)
 	return htab_map_alloc_check(attr);
 }
 
-static void rhtab_check_and_free_fields(struct bpf_rhtab *rhtab,
-					struct rhtab_elem *elem)
-{
-	if (IS_ERR_OR_NULL(rhtab->map.record))
-		return;
-
-	bpf_obj_free_fields(rhtab->map.record,
-			    rhtab_elem_value(elem, rhtab->map.key_size));
-}
-
 static void rhtab_mem_dtor(void *obj, void *ctx)
 {
 	struct htab_btf_record *hrec = ctx;
@@ -2968,8 +2958,8 @@ static int rhtab_delete_elem(struct bpf_rhtab *rhtab, struct rhtab_elem *elem, v
 		rhtab_read_elem_value(&rhtab->map, copy, elem, flags);
 		check_and_init_map_value(&rhtab->map, copy);
 	}
-	/* Release internal structs: kptr, bpf_timer, task_work, wq */
-	rhtab_check_and_free_fields(rhtab, elem);
+	bpf_obj_cancel_fields(&rhtab->map,
+			      rhtab_elem_value(elem, rhtab->map.key_size));
 	bpf_mem_cache_free_rcu(&rhtab->ma, elem);
 	return 0;
 }
@@ -3011,7 +3001,6 @@ static int rhtab_map_lookup_and_delete_elem(struct bpf_map *map, void *key, void
 static long rhtab_map_update_existing(struct bpf_map *map, struct rhtab_elem *elem, void *value,
 				      u64 map_flags)
 {
-	struct bpf_rhtab *rhtab = container_of(map, struct bpf_rhtab, map);
 	void *old_val = rhtab_elem_value(elem, map->key_size);
 
 	if (map_flags & BPF_NOEXIST)
@@ -3031,7 +3020,7 @@ static long rhtab_map_update_existing(struct bpf_map *map, struct rhtab_elem *el
 	 * kptrs/etc. still sit in the slot. Cancel them after the copy
 	 * to match arraymap's update semantics.
 	 */
-	rhtab_check_and_free_fields(rhtab, elem);
+	bpf_obj_cancel_fields(map, old_val);
 	return 0;
 }
 
-- 
2.53.0



