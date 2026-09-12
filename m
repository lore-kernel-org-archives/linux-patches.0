Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD08208D0;
	Sat, 12 Sep 2026 09:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206299; cv=none; b=i5p/D280IeXhuugScMDXiMJwKI8/mRqCHzLHoh/gOktMXPUr9ieoTnlV2t/6vCx2YSUi+lMgMAubDlO+zyrYvZ+lZnmOqRaRzq7IUwm28e5tMNSbpEtx0t/GXjVK7zYqNo4K0XqUFc3f7y3c0cSAxne8pAouU2kqm60IE0y/12E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206299; c=relaxed/simple;
	bh=AyHtMIbdf7iDEOBgJCsOhatncDfVRYBmTpN7FqXDeLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tl9pcmsraFsRQ0ghv8dVecbXomrWo4FKCaBHqLb5SX9u4HMk7hgAlHj0YqEqUADHxanK9fXK8jGtm6mRpTM8sp7o7RmVfCSUuYJUwH/NMtH2Z2AkckS3RoP9hmdnojstdRQ6KpIUR2IvsJ3N6c3fNnn5H7gZYcrg/nqYlNioWes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0wgvI1v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0wgvI1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0116F1F000FF;
	Sat, 12 Sep 2026 09:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206297;
	bh=cIDKnCjqsDSCHZ+BAiQCWykECHT0FIWmjv3LKdPFgUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z0wgvI1vZKYcVgZmkx5ftnVoXTPSyCW3IJPKB7FoodQJOdef0GbsnqjrWvWK54l+K
	 iSZlHd6R0OxlgcfYdgu/JN5tYwLFpjK9WSMLWNyKMmD7s8VsSZr0xuHrGqgH4UGOAe
	 KuogqyXtrsMwUEHHIKMEsnTdODjt7Lvo/onrByxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Israel Batista <linux@israelbatista.dev.br>,
	David Hildenbrand <david@redhat.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Omar Sandoval <osandov@osandov.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0176/1518] mm: convert memory block states (MEM_*) macros to enum
Date: Sat, 12 Sep 2026 08:39:05 +0200
Message-ID: <20260912065627.473768333@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Israel Batista <linux@israelbatista.dev.br>

[ Upstream commit 1a4f70f6851a1916c4f0e52731c7ecfe99bf36e6 ]

Patch series "mm: Convert memory block states (MEM_*) macros to enums", v2.

The MEM_* constants indicating the state of a memory block are currently
defined as macros, meaning their definitions will be omitted from the
debuginfo on most kernel builds.  This makes it harder for debuggers to
correctly map the block state at runtime, which can be quite useful when
analysing errors related to memory hot plugging and unplugging with tools
such as drgn.

Converting the constants to an enum ensures the correct information is
emitted by the compiler and available for the debugger, without needing to
hard-code them into the debugger and track their changes.

This patch series aims to replace the current macros with a newly created
enum named memory_block_state, while also taking advantage of the compile
time guarantees that we get when using enums.

The first patch does the conversion of the macros to an enum, while the
2nd and 3rd patches use this enum to clean up some type declarations and
make sure that only valid values are used.

This patch (of 3):

Converting the MEM_* constants from macros to an enum ensures that their
values will be correctly emitted in the debug symbols, making it easier to
trace the meaning of each value when debugging with tools such as drgn,
without the need to hard-code the values.

Since the values are mutually exclusive and they are not exposed directly
to userspace, I also dropped the misleading pattern (1<<X) that made it
look like they were combinable flags.

Link: https://lkml.kernel.org/r/20251029195617.2210700-1-linux@israelbatista.dev.br
Link: https://lkml.kernel.org/r/20251029195617.2210700-2-linux@israelbatista.dev.br
Signed-off-by: Israel Batista <linux@israelbatista.dev.br>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Omar Sandoval <osandov@osandov.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 2ebce860bdd7 ("mm/mm_init: handle alloc_percpu failure in free_area_init_core_hotplug")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/memory.h | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/linux/memory.h b/include/linux/memory.h
index 0c214256216f6..f4e358477c6a7 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -64,6 +64,18 @@ struct memory_group {
 	};
 };
 
+enum memory_block_state {
+	/* These states are exposed to userspace as text strings in sysfs */
+	MEM_ONLINE,		/* exposed to userspace */
+	MEM_GOING_OFFLINE,	/* exposed to userspace */
+	MEM_OFFLINE,		/* exposed to userspace */
+	MEM_GOING_ONLINE,
+	MEM_CANCEL_ONLINE,
+	MEM_CANCEL_OFFLINE,
+	MEM_PREPARE_ONLINE,
+	MEM_FINISH_OFFLINE,
+};
+
 struct memory_block {
 	unsigned long start_section_nr;
 	unsigned long state;		/* serialized by the dev->lock */
@@ -89,16 +101,6 @@ int arch_get_memory_phys_device(unsigned long start_pfn);
 unsigned long memory_block_size_bytes(void);
 int set_memory_block_size_order(unsigned int order);
 
-/* These states are exposed to userspace as text strings in sysfs */
-#define	MEM_ONLINE		(1<<0) /* exposed to userspace */
-#define	MEM_GOING_OFFLINE	(1<<1) /* exposed to userspace */
-#define	MEM_OFFLINE		(1<<2) /* exposed to userspace */
-#define	MEM_GOING_ONLINE	(1<<3)
-#define	MEM_CANCEL_ONLINE	(1<<4)
-#define	MEM_CANCEL_OFFLINE	(1<<5)
-#define	MEM_PREPARE_ONLINE	(1<<6)
-#define	MEM_FINISH_OFFLINE	(1<<7)
-
 struct memory_notify {
 	/*
 	 * The altmap_start_pfn and altmap_nr_pages fields are designated for
-- 
2.53.0



