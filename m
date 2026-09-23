Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0316A530DFF;
	Wed, 23 Sep 2026 14:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174889; cv=none; b=L+M0ZKhmXijNKYNSEIOtYa67KX/5fUBy/xnuQNarIMp+2rkpfbW0qYsdNfNMpur7y0bAK2uVb/ZdlxT0kUXLuRFvlctEQyuyqP62SlHzPsLFdTEXEVm6v+dhQ2c+UBH7xSMWCWLmSQVP4LjHQ2jkM6F1+bZ2GW93RIEBdeANlmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174889; c=relaxed/simple;
	bh=GmROYx+opRd3/WBMdysuhoCPe99dd4gUtc+m0QEBGV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qx9o0Fb/xrodc1ynMX8Qi0eLFc/dEmsJVdTrYXR7fgQDykaCOCBpcOCLsmW6Nfyu5rRiWri35kowzvLegLKfAHFYI3b5w3biGkW6oMGeSAa9Cc/AZ8AF53OklwBYIe+Yod4/Q+L0L5/FRX8QkKomh9P3ULoHIVA2dunGV8gZsik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=acggRDIs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="acggRDIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC3D1F000FF;
	Wed, 23 Sep 2026 14:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174887;
	bh=JfHq/OPxPB4sCuMfRfdZybNF1q2NXIcS3YIIQS8P+CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=acggRDIsUixK3w9A14Eh2ZJiDxPBS4ZFmPAopwPF8V88J/S3Zdmj2sF3HTfL3a/9t
	 OxEw5ghbtC5FIygTl9VLYnjOHFFtzCl75oyalg5DIfvMt0UQO3qVy6mEueUW/frq8m
	 69K9hoPX2a32yy/n5DtOLZs+Sr1pxyTdlTTrbZF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Muchun Song <muchun.song@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 257/398] memcg: avoid charging the root memcg from obj_cgroup_charge_pages()
Date: Wed, 23 Sep 2026 16:05:31 +0200
Message-ID: <20260923140650.076942355@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Shakeel Butt <shakeel.butt@linux.dev>

commit 6e673d0879ef78c395cfe0d3ba316690a60055d8 upstream.

obj_cgroup_charge_pages() resolves the objcg to its memcg and calls
try_charge_memcg(), which does not short circuit the root memcg.  That
memcg can be the root memcg: obj_cgroup_is_root() reflects the memcg the
objcg was created for and is never updated, while memcg_reparent_objcgs()
does redirect objcg->memcg to the parent on rmdir.  An objcg of a dying
child of root therefore passes every obj_cgroup_is_root() filter but
resolves to the root memcg.

Folios keep the objcg they were charged with, so this is easy to reach
through zswap: allocate anon memory in a cgroup, move the task out, remove
the cgroup, then write to the root cgroup's memory.reclaim.  The reclaimed
folios are charged through the reparented objcg and end up in
refill_stock() with the root memcg:

  WARNING: mm/memcontrol.c:2198 at refill_stock+0x644/0x940
   refill_stock+0x644/0x940
   try_charge_memcg+0x12d6/0x1570
   __obj_cgroup_charge+0x35/0xf0
   obj_cgroup_charge+0x1de/0x210
   obj_cgroup_charge_zswap+0x83/0x270
   zswap_store+0x1620/0x2000
   swap_writeout+0x94c/0x14c0
   shrink_folio_list+0x3388/0x52b0
   [...]
   try_to_free_mem_cgroup_pages+0x30d/0x830
   user_proactive_reclaim+0x504/0x840
   memory_reclaim+0x1f/0x30

Beyond the warning, the charge is asymmetric: obj_cgroup_uncharge_pages()
skips refill_stock() for the root memcg, so the root's page counter grows
and is never uncharged.  It is not user visible, since memory.current is
not exposed on the root, but it is a leak.

Use try_charge(), which returns early for the root memcg, restoring the
symmetry with obj_cgroup_uncharge_pages().

The above sequence was scripted into a standalone reproducer (zswap on,
swap on a virtio disk, 512MB of anon memory faulted in inside a child of
the root cgroup, the task then migrated to the root cgroup, the child
removed, followed by "echo 600M swappiness=max > memory.reclaim" on the
root) and run in a CONFIG_DEBUG_VM=y VM.  It reproduces the splat on the
first zswap store of a reparented folio, with the same call chain as the
report.  With this patch applied the splat is gone while the zswap store
count over the run is unchanged, so the same path is still exercised.
cgroup selftests test_zswap, test_kmem and test_memcontrol show no new
failures.

Link: https://lore.kernel.org/20260829023251.474083-1-shakeel.butt@linux.dev
Fixes: 20d6c1725228 ("memcg: avoid refill_stock for root memcg")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Closes: https://lore.kernel.org/all/CA+0ovCgWzUMK+nNbbtH7eV65Ca=fDN4Ozu7iASgryjvv8Tk8zQ@mail.gmail.com/
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2812,7 +2812,7 @@ static int obj_cgroup_charge_pages(struc
 
 	memcg = get_mem_cgroup_from_objcg(objcg);
 
-	ret = try_charge_memcg(memcg, gfp, nr_pages);
+	ret = try_charge(memcg, gfp, nr_pages);
 	if (ret)
 		goto out;
 


