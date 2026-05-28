Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7A12E92BA;
	Thu, 28 May 2026 20:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000477; cv=none; b=BuiRZezUMdSfIu+KS4kxuAEWhKBK6MGsgBpWBugl4l8zsg1WmTlyVSEADSHt2BA0Wa+saQfN0PQM1LpMgR6iEZfce2y3bZuqvrOpgj3b+L78MH9AquYr2W2sKZbsDXNYrzb/zh/59TAXG6PEtp1ku+SeFb5JLtuHffTiY7jR3UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000477; c=relaxed/simple;
	bh=ZJUu3WR2/5HfJsakw960xxF4ljquVu6dj13ma8Fbvwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6YU579G/NbvyIzExML8lPUkrcjASr9wqXoJnmL67UXACD+qpgt4r5R+e5DIEiIy2a5JA1eplUZ6urRC3cte/qwKgI2zdJ3qeVIEXB3TKxkBWOnMtKc3fTyMbxMOk1hiCbfyTODLTaxk0HGkIqnIYUaFOecJaQKjk3hRoW6hGMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J6C8kHSN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J6C8kHSN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177621F000E9;
	Thu, 28 May 2026 20:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000476;
	bh=9k0Am1W7a8JrCod4VuYjWNqEUtXOPbpyicHrcqEGPhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J6C8kHSNyjQVTnXgt5NvmdhFd8lFHwd5OCj7Eoh1g4ps3k0jIxedeihVHnJ6jjZcl
	 FRt0GsXhUd5N1u8AZVQIdFfAtDBsOBd9CPqNwWR5a1FMI/V4MSBjgpXc0rq0OLnpBC
	 Z+0kd9wn65PQGMll+dpUqvMEa6kyqV9TlknA+UL8=
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
Subject: [PATCH 6.12 059/272] mm/memory_hotplug: fix memory block reference leak on remove
Date: Thu, 28 May 2026 21:47:13 +0200
Message-ID: <20260528194631.034486783@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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
@@ -1406,6 +1406,8 @@ static void remove_memory_blocks_and_alt
 
 		altmap = mem->altmap;
 		mem->altmap = NULL;
+		/* drop the ref. we got via find_memory_block() */
+		put_device(&mem->dev);
 
 		remove_memory_block_devices(cur_start, memblock_size);
 


