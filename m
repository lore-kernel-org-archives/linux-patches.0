Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B74114A99
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2lxzJJuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CFCFC433C7;
	Mon, 23 Oct 2023 11:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059627;
	bh=sIf8pjXiE3HWAtBxfceHS7E0xXuTOp578BX20HeLsTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2lxzJJuY/fEYD5xJRodXIiDHOTkm5IyJ/9Wa3rvztz8mUZI94xQ54F9xafsDthbvA
	 1kAN9liGXsZyScLkDc0rCTlmnGOq6aBZOi/b6HUEGBFuI1BTCX+CfYw4zVM3AciQzd
	 GqzgjUct+vVTrhqfi0YM8fj0w9iM1oeepyJ8Rwbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Michael Roth <michael.roth@amd.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 233/241] efi/unaccepted: Fix soft lockups caused by parallel memory acceptance
Date: Mon, 23 Oct 2023 12:56:59 +0200
Message-ID: <20231023104839.554621938@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

[ Upstream commit 50e782a86c980d4f8292ef82ed8139282ca07a98 ]

Michael reported soft lockups on a system that has unaccepted memory.
This occurs when a user attempts to allocate and accept memory on
multiple CPUs simultaneously.

The root cause of the issue is that memory acceptance is serialized with
a spinlock, allowing only one CPU to accept memory at a time. The other
CPUs spin and wait for their turn, leading to starvation and soft lockup
reports.

To address this, the code has been modified to release the spinlock
while accepting memory. This allows for parallel memory acceptance on
multiple CPUs.

A newly introduced "accepting_list" keeps track of which memory is
currently being accepted. This is necessary to prevent parallel
acceptance of the same memory block. If a collision occurs, the lock is
released and the process is retried.

Such collisions should rarely occur. The main path for memory acceptance
is the page allocator, which accepts memory in MAX_ORDER chunks. As long
as MAX_ORDER is equal to or larger than the unit_size, collisions will
never occur because the caller fully owns the memory block being
accepted.

Aside from the page allocator, only memblock and deferered_free_range()
accept memory, but this only happens during boot.

The code has been tested with unit_size == 128MiB to trigger collisions
and validate the retry codepath.

Fixes: 2053bc57f367 ("efi: Add unaccepted memory support")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Michael Roth <michael.roth@amd.com
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Michael Roth <michael.roth@amd.com>
[ardb: drop unnecessary cpu_relax() call]
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/unaccepted_memory.c | 64 ++++++++++++++++++++++--
 1 file changed, 60 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/unaccepted_memory.c b/drivers/firmware/efi/unaccepted_memory.c
index 853f7dc3c21d8..135278ddaf627 100644
--- a/drivers/firmware/efi/unaccepted_memory.c
+++ b/drivers/firmware/efi/unaccepted_memory.c
@@ -5,9 +5,17 @@
 #include <linux/spinlock.h>
 #include <asm/unaccepted_memory.h>
 
-/* Protects unaccepted memory bitmap */
+/* Protects unaccepted memory bitmap and accepting_list */
 static DEFINE_SPINLOCK(unaccepted_memory_lock);
 
+struct accept_range {
+	struct list_head list;
+	unsigned long start;
+	unsigned long end;
+};
+
+static LIST_HEAD(accepting_list);
+
 /*
  * accept_memory() -- Consult bitmap and accept the memory if needed.
  *
@@ -24,6 +32,7 @@ void accept_memory(phys_addr_t start, phys_addr_t end)
 {
 	struct efi_unaccepted_memory *unaccepted;
 	unsigned long range_start, range_end;
+	struct accept_range range, *entry;
 	unsigned long flags;
 	u64 unit_size;
 
@@ -78,20 +87,67 @@ void accept_memory(phys_addr_t start, phys_addr_t end)
 	if (end > unaccepted->size * unit_size * BITS_PER_BYTE)
 		end = unaccepted->size * unit_size * BITS_PER_BYTE;
 
-	range_start = start / unit_size;
-
+	range.start = start / unit_size;
+	range.end = DIV_ROUND_UP(end, unit_size);
+retry:
 	spin_lock_irqsave(&unaccepted_memory_lock, flags);
+
+	/*
+	 * Check if anybody works on accepting the same range of the memory.
+	 *
+	 * The check is done with unit_size granularity. It is crucial to catch
+	 * all accept requests to the same unit_size block, even if they don't
+	 * overlap on physical address level.
+	 */
+	list_for_each_entry(entry, &accepting_list, list) {
+		if (entry->end < range.start)
+			continue;
+		if (entry->start >= range.end)
+			continue;
+
+		/*
+		 * Somebody else accepting the range. Or at least part of it.
+		 *
+		 * Drop the lock and retry until it is complete.
+		 */
+		spin_unlock_irqrestore(&unaccepted_memory_lock, flags);
+		goto retry;
+	}
+
+	/*
+	 * Register that the range is about to be accepted.
+	 * Make sure nobody else will accept it.
+	 */
+	list_add(&range.list, &accepting_list);
+
+	range_start = range.start;
 	for_each_set_bitrange_from(range_start, range_end, unaccepted->bitmap,
-				   DIV_ROUND_UP(end, unit_size)) {
+				   range.end) {
 		unsigned long phys_start, phys_end;
 		unsigned long len = range_end - range_start;
 
 		phys_start = range_start * unit_size + unaccepted->phys_base;
 		phys_end = range_end * unit_size + unaccepted->phys_base;
 
+		/*
+		 * Keep interrupts disabled until the accept operation is
+		 * complete in order to prevent deadlocks.
+		 *
+		 * Enabling interrupts before calling arch_accept_memory()
+		 * creates an opportunity for an interrupt handler to request
+		 * acceptance for the same memory. The handler will continuously
+		 * spin with interrupts disabled, preventing other task from
+		 * making progress with the acceptance process.
+		 */
+		spin_unlock(&unaccepted_memory_lock);
+
 		arch_accept_memory(phys_start, phys_end);
+
+		spin_lock(&unaccepted_memory_lock);
 		bitmap_clear(unaccepted->bitmap, range_start, len);
 	}
+
+	list_del(&range.list);
 	spin_unlock_irqrestore(&unaccepted_memory_lock, flags);
 }
 
-- 
2.42.0



