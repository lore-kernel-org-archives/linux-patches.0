Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78533A0B36;
	Sat, 12 Sep 2026 12:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214920; cv=none; b=XrkgjOG70REuHdfhNUO6FTAsSW52lih3wwiNq/lBNuPSYz0WLXDJeNa4JW28U7NAxEoXGrTmLg/7MPPaP7VHHmOoIcK8fnY8+VPj4MRRj1IbkKrcqlMIM9id7HTSw1KwQ9klpb5DaF4uRyNMC9j1VmENawJwzvn1nD2h54oRu4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214920; c=relaxed/simple;
	bh=zIda5zTEGJGLN2oihD0qD6moseZ/nxftzVZKK6ZnjCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jiPhYuG4XnUDc5hbtaVKNEb2jLekd3kxZUMaxoJ0PdTBC0k7Vp2xoVKMpYMidJxjgyfXiiomvx0z25PQzOuLVxDxw49A00SWj/eIOZjrRZXBmj0agcyEcBCcmy+tQWoHYGXYoK8FDN146IpFDYzKYiFjj4tVDcngHrNDozLNNOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UW9DVFSm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UW9DVFSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBE91F000FF;
	Sat, 12 Sep 2026 12:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214918;
	bh=xct9TLEHhxGWORAb9nGdWWd0cDzEieRhRokSLo/n5Ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UW9DVFSmg4VazyiONaYcaa8/eZZaGig904UBw/DMkC5bVpvnP+fQnFRLzgw12m3aF
	 CiGMgyN6gsAq089DpyxRMzbIxqGAdMxKv6w8fr8GeFW14xMF7ZHL5oXKuUWmUznhmn
	 nksq52/Nx4HFfw5bkky8tOUPoUUjJrKCkt7drkkQ=
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
Subject: [PATCH 6.12 0382/1376] mm: convert memory block states (MEM_*) macros to enum
Date: Sat, 12 Sep 2026 08:46:48 +0200
Message-ID: <20260912065616.060372248@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index c0afee5d126ef..4b9be8afdc849 100644
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



