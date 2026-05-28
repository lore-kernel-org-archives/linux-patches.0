Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8132DF6E6;
	Thu, 28 May 2026 20:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999373; cv=none; b=UMzGqR6uZEOmzaxzY0yNOWsbXF8dP65xhTy88TAlpBZslNqlTpO0KqaS4PGPbIoms1J4W0NA1p5v/9xCqTQcm2YzH5MOLXe35L4iyLdLKol4ksKZXdVKMe8FrC8bomlB5nxvnpkVa558WlbTKpOsVgcqnNtP6VfW8YscsLEbUXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999373; c=relaxed/simple;
	bh=lbHd8Gm04ZZVLgYnA3/BhZrKhPfi+X8BS2jNql/BLcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTTOOWF3YWv5dt7rLu/z+dHCnCCp0FAUuYh/sUSACUDRgCRSEJWHQycjzNgpi/iqeAVm5w9RjjQaWrnixZqvzJnED334L7Lj8jByAV8sj6Dp1OOZOICTS6tOvPEnpO+WTkqAAI06LDaCmUrBbE8LrzBSOOMNZcvh892kpEN+aE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rqz005NK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rqz005NK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B84A41F000E9;
	Thu, 28 May 2026 20:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999372;
	bh=qX4l0WoQ0GDf74uAzzisiXKzhPAdA6/YeFHzQiyNT6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rqz005NKabiYlS5UtiTyq3zJJODiv+mnfYQIIkr28ybBX2q6yoTH/GPUv1pcaRoKi
	 0EJeHgRhXcRwiOsU4f25y+DvLIdLaH/EiUMeWtwo30yjNnLrX9qiO3JAfkb55TmKpH
	 f6ZrE4DaFKwfGVtMoM+HVU39A6phhgXKmmq9jGUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muchun Song <songmuchun@bytedance.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Oscar Salvador <osalvador@suse.de>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	"Huang, Ying" <huang.ying.caritas@gmail.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 044/377] drivers/base/memory: fix memory block reference leak in poison accounting
Date: Thu, 28 May 2026 21:44:42 +0200
Message-ID: <20260528194639.649518185@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Muchun Song <songmuchun@bytedance.com>

commit 03a2cc1756a0570f887d624cd6c535ea0cbd4951 upstream.

memblk_nr_poison_inc() and memblk_nr_poison_sub() look up a memory block
via find_memory_block_by_id(), which acquires a reference to the memory
block device.

Both helpers use the returned memory block without dropping that
reference, leaking the device reference on each successful lookup.  Drop
the reference after updating nr_hwpoison.

Link: https://lore.kernel.org/20260428085219.1316047-3-songmuchun@bytedance.com
Fixes: 5033091de814 ("mm/hwpoison: introduce per-memory_block hwpoison counter")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Huang, Ying" <huang.ying.caritas@gmail.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/memory.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -1251,8 +1251,10 @@ void memblk_nr_poison_inc(unsigned long
 	const unsigned long block_id = pfn_to_block_id(pfn);
 	struct memory_block *mem = find_memory_block_by_id(block_id);
 
-	if (mem)
+	if (mem) {
 		atomic_long_inc(&mem->nr_hwpoison);
+		put_device(&mem->dev);
+	}
 }
 
 void memblk_nr_poison_sub(unsigned long pfn, long i)
@@ -1260,8 +1262,10 @@ void memblk_nr_poison_sub(unsigned long
 	const unsigned long block_id = pfn_to_block_id(pfn);
 	struct memory_block *mem = find_memory_block_by_id(block_id);
 
-	if (mem)
+	if (mem) {
 		atomic_long_sub(i, &mem->nr_hwpoison);
+		put_device(&mem->dev);
+	}
 }
 
 static unsigned long memblk_nr_poison(struct memory_block *mem)


