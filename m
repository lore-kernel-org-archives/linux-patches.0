Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9273254A8;
	Thu, 28 May 2026 19:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998053; cv=none; b=BNfXa4fHCpYZFlPWUu567cTsnntkRhP6hjF7nMg/Cx9lPGjBFW0UALRsJIi8ReqwXK9QIn+QDFOA+nb0LRArbXBcfEZsmJhcesPO5sp6pcTUjeaF4LeAASebU6K5YdITbkJhmS/e6hbDLi3vlUR0v3LBh0KE2OBRQFQ4RiwTvpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998053; c=relaxed/simple;
	bh=9cd3pgU1cE+Za0n8KHo8FKi6rTXaIt9s4t8ATON3bHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OdDziD0k4RyU+iD1BJnBLUtdP2tQ8JFKyp8Z8wVEBg6F3PhUtY7OVTWE0dHF5ZERcvZY8dI5SBJkTLzxhdzRVSSgJUqdZ4Bb/l3rh9E41a5GDbZHNPDHYasIXDOL80zVfFSzreJZtiozg36haX2UbYZCh5c6sIvWoyo3p/qQE4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhAR845j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhAR845j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C10A1F000E9;
	Thu, 28 May 2026 19:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998051;
	bh=XrnXhra2iGzqrZifH6Ch3TSYvnoxLyY7gtB6e6M32o4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bhAR845jIQCHAOxkxPeMHjX0d8U6444pbJBpkEhTyYPj1/KrsO+VBvyDUsalJ9kJt
	 0v4nppB67NXit1YnvMDYG/uG9mkeaGRc4AWcy+2VbyvovWmDOZNMm8SH10bfy+43o3
	 fn6OOJRRSpTpZBDKqFoxXSk1lqGLpfVTrjsXfCuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muchun Song <songmuchun@bytedance.com>,
	Oscar Salvador <osalvador@suse.de>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	"Huang, Ying" <huang.ying.caritas@gmail.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 035/461] mm/memory_hotplug: fix memory block reference leak on remove
Date: Thu, 28 May 2026 21:42:44 +0200
Message-ID: <20260528194647.912667748@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muchun Song <songmuchun@bytedance.com>

commit 93866f55f7e292fe3d47d36c9efe5ee10213a06b upstream.

Patch series "mm: Fix memory block leaks and locking", v2.

This series fixes two memory block device reference leaks and one locking
issue around the per-memory_block hwpoison counter.


This patch (of 2):

remove_memory_blocks_and_altmaps() looks up each memory block with
find_memory_block(), which acquires a reference to the memory block
device.

That reference is never dropped on this path, resulting in a leaked device
reference when removing memory blocks and their altmaps.  Drop the
reference after retrieving mem->altmap and clearing mem->altmap, before
removing the memory block device.

Link: https://lore.kernel.org/20260428085219.1316047-1-songmuchun@bytedance.com
Link: https://lore.kernel.org/20260428085219.1316047-2-songmuchun@bytedance.com
Fixes: 6b8f0798b85a ("mm/memory_hotplug: split memmap_on_memory requests across memblocks")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Huang, Ying" <huang.ying.caritas@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory_hotplug.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1430,6 +1430,8 @@ static void remove_memory_blocks_and_alt
 
 		altmap = mem->altmap;
 		mem->altmap = NULL;
+		/* drop the ref. we got via find_memory_block() */
+		put_device(&mem->dev);
 
 		remove_memory_block_devices(cur_start, memblock_size);
 


