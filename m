Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD08D6088F;
	Wed,  6 Nov 2024 12:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896244; cv=none; b=dJIo68Cjv2CwccXI6Lrgph47FUfdUcrpIYNwYXrFWoEgZ1ToEasQkT/fp4gJBYqUvtk2VdZJuWDA7wc9SjPZhRx1FQvUeMTMi2beVBoekuInAF9XYeSS+FsSmGV22lOSi4Uz4mWKRHX6ipfpU7Ct3EoNFfW3ZCee+JAwQFXGYZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896244; c=relaxed/simple;
	bh=5sLTHDGyob/IznoMa1ZR9YwTKibZ4OutxfoGfCb7kuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDV0zvsb0dm527Xvt+/sw6i3YiB39qMFSUO5HuDqae5/+NQkXZ9MozMJgf3Nqdw1/C5Lf6egJGfvdqokK9GmLpIYQ9bLPSdYTwmX/3dFN89TlipwPrqNUgybkWMs3Alvm//2LK0B/fuM0B3yQlqJ3w/n9aMdp6T3/Tk0BUVjIWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XoR82tso; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XoR82tso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE74DC4CECD;
	Wed,  6 Nov 2024 12:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896244;
	bh=5sLTHDGyob/IznoMa1ZR9YwTKibZ4OutxfoGfCb7kuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XoR82tsomC4S97DrYJegJbXkU5Ah8W4SJosYNMNqmYsbcBokVQk17anOIMDdvxclk
	 4K1E32vbwelia7GCqCClFdlWDPTjph0MR0ssBd+125ltsutGgzCnk2PHKFLqKo9i7R
	 Vv6B1Ve9Kh46k5w1UeJVeF255/Ly7QKNA9iVkbHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Chinner <dchinner@redhat.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Muchun Song <muchun.song@linux.dev>,
	Wang Weiyang <wangweiyang2@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 138/245] mm: shrinker: avoid memleak in alloc_shrinker_info
Date: Wed,  6 Nov 2024 13:03:11 +0100
Message-ID: <20241106120322.626040519@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ridong <chenridong@huawei.com>

commit 15e8156713cc38031642fafc8baf7d53f19f2e83 upstream.

A memleak was found as below:

unreferenced object 0xffff8881010d2a80 (size 32):
  comm "mkdir", pid 1559, jiffies 4294932666
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    40 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  @...............
  backtrace (crc 2e7ef6fa):
    [<ffffffff81372754>] __kmalloc_node_noprof+0x394/0x470
    [<ffffffff813024ab>] alloc_shrinker_info+0x7b/0x1a0
    [<ffffffff813b526a>] mem_cgroup_css_online+0x11a/0x3b0
    [<ffffffff81198dd9>] online_css+0x29/0xa0
    [<ffffffff811a243d>] cgroup_apply_control_enable+0x20d/0x360
    [<ffffffff811a5728>] cgroup_mkdir+0x168/0x5f0
    [<ffffffff8148543e>] kernfs_iop_mkdir+0x5e/0x90
    [<ffffffff813dbb24>] vfs_mkdir+0x144/0x220
    [<ffffffff813e1c97>] do_mkdirat+0x87/0x130
    [<ffffffff813e1de9>] __x64_sys_mkdir+0x49/0x70
    [<ffffffff81f8c928>] do_syscall_64+0x68/0x140
    [<ffffffff8200012f>] entry_SYSCALL_64_after_hwframe+0x76/0x7e

alloc_shrinker_info(), when shrinker_unit_alloc() returns an errer, the
info won't be freed.  Just fix it.

Link: https://lkml.kernel.org/r/20241025060942.1049263-1-chenridong@huaweicloud.com
Fixes: 307bececcd12 ("mm: shrinker: add a secondary array for shrinker_info::{map, nr_deferred}")
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Wang Weiyang <wangweiyang2@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shrinker.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -76,19 +76,21 @@ void free_shrinker_info(struct mem_cgrou
 
 int alloc_shrinker_info(struct mem_cgroup *memcg)
 {
-	struct shrinker_info *info;
 	int nid, ret = 0;
 	int array_size = 0;
 
 	mutex_lock(&shrinker_mutex);
 	array_size = shrinker_unit_size(shrinker_nr_max);
 	for_each_node(nid) {
-		info = kvzalloc_node(sizeof(*info) + array_size, GFP_KERNEL, nid);
+		struct shrinker_info *info = kvzalloc_node(sizeof(*info) + array_size,
+							   GFP_KERNEL, nid);
 		if (!info)
 			goto err;
 		info->map_nr_max = shrinker_nr_max;
-		if (shrinker_unit_alloc(info, NULL, nid))
+		if (shrinker_unit_alloc(info, NULL, nid)) {
+			kvfree(info);
 			goto err;
+		}
 		rcu_assign_pointer(memcg->nodeinfo[nid]->shrinker_info, info);
 	}
 	mutex_unlock(&shrinker_mutex);


