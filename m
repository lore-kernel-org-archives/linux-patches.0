Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE04153CA71;
	Wed, 23 Sep 2026 14:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174837; cv=none; b=JKA2Szs6wdFk9Bem02sos6+5zi2H41abWFbHtiNrkshs6czGfAN4h92B9QWQkFpq4FGHA1SDMD3KTTCpBzTtoxRluG5mNqdciQblVDBu+oAOfCGxSrpOlNspjQqgQXciM2TggC06+eRnbWuF9PUSD9lE2qCxIOEGKtdb3IWwGeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174837; c=relaxed/simple;
	bh=K3rfcnKEmCxH+DGULTQ/Wv2j+wTl9A4xzu1wq5dlfkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PP89Bd+GHv7QrzJ8E35U9l2khlkg0v8vQPVcxWJShqijtalhwwZZ+jFCaEJEErDi/92h52uE3SYG/TDcB76AqKJafkQB9ZKoVvwH7suUoJhEgae92YeHO+jlxG6Dbis+FH15J5K7rW/xtWfcVl50fF47xfm7dC2k2eNTBYhh9RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wcoy1w6G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wcoy1w6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF9F1F000FF;
	Wed, 23 Sep 2026 14:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174835;
	bh=QS+xDCk4kNDICClUisq1aGmDp7HYkXq2OkaNzTXrrs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wcoy1w6GozCR8Y+cTst0wMqeLBlkOFrjmq3cBbu1VFT02X7chsFORNTxQXgL01gGb
	 SDZbB/91KFd/1F38Aa7FgybVQihlwY0UYmYtwGqfPbOfr9zKb4YeRNjm6/cR4GwVM4
	 CbzVrDnCc3vtuwNwUQ2mZ0S3jtK+XEt3o/RAaiDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seunguk Shin <seunguk.shin@arm.com>,
	Jan Kara <jack@suse.cz>,
	Alistair Popple <apopple@nvidia.com>,
	Kiara Grouwstra <cinereal@riseup.net>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 206/398] fs/dax: check zero or empty entry before converting xarray entry
Date: Wed, 23 Sep 2026 16:04:40 +0200
Message-ID: <20260923140648.761407876@linuxfoundation.org>
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

From: Seunguk Shin <seunguk.shin@arm.com>

commit 8e2b8614039853e68d5338e37821e8bcee9fc05f upstream.

Calling dax_to_folio() with empty entry causes kernel panic below when
booting a VM with DAX enabled storage.

This patch checks empty entry before calling dax_to_folio() on
dax_associate_entry(), dax_disassociate_entry(), and dax_busy_page().

Commit 98c183a4fccf ("fs/dax: don't disassociate zero page entries") added
guards in the associate and disassociate paths, but the guards still come
after dax_to_folio(), and dax_busy_page() still has the same problem.

[    0.737679] EXT4-fs (pmem0p1): mounted filesystem 79676804-7c8b-491a-b2a6-9bae3c72af70 ro with ordered data mode. Quota mode: disabled.
[    0.737891] VFS: Mounted root (ext4 filesystem) readonly on device 259:1.
[    0.739119] devtmpfs: mounted
[    0.739476] Freeing unused kernel memory: 1920K
[    0.740156] Run /sbin/init as init process
[    0.740229]   with arguments:
[    0.740286]     /sbin/init
[    0.740321]   with environment:
[    0.740369]     HOME=/
[    0.740400]     TERM=linux
[    0.743162] Unable to handle kernel paging request at virtual address fffffdffbf000008
[    0.743285] Mem abort info:
[    0.743316]   ESR = 0x0000000096000006
[    0.743371]   EC = 0x25: DABT (current EL), IL = 32 bits
[    0.743444]   SET = 0, FnV = 0
[    0.743489]   EA = 0, S1PTW = 0
[    0.743545]   FSC = 0x06: level 2 translation fault
[    0.743610] Data abort info:
[    0.743656]   ISV = 0, ISS = 0x00000006, ISS2 = 0x00000000
[    0.743720]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[    0.743785]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[    0.743848] swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000000b9d17000
[    0.743931] [fffffdffbf000008] pgd=10000000bfa3d403, p4d=10000000bfa3d403, pud=1000000040bfe403, pmd=0000000000000000
[    0.744070] Internal error: Oops: 0000000096000006 [#1]  SMP
[    0.748888] CPU: 0 UID: 0 PID: 1 Comm: init Not tainted 6.18.4 #1 NONE
[    0.749421] pstate: 004000c5 (nzcv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    0.749969] pc : dax_disassociate_entry.constprop.0+0x20/0x50
[    0.750444] lr : dax_insert_entry+0xcc/0x408
[    0.750802] sp : ffff80008000b9e0
[    0.751083] x29: ffff80008000b9e0 x28: 0000000000000000 x27: 0000000000000000
[    0.751682] x26: 0000000001963d01 x25: ffff0000004f7d90 x24: 0000000000000000
[    0.752264] x23: 0000000000000000 x22: ffff80008000bcc8 x21: 0000000000000011
[    0.752836] x20: ffff80008000ba90 x19: 0000000001963d01 x18: 0000000000000000
[    0.753407] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
[    0.753970] x14: ffffbf3154b9ae70 x13: 0000000000000000 x12: ffffbf3154b9ae70
[    0.754548] x11: ffffffffffffffff x10: 0000000000000000 x9 : 0000000000000000
[    0.755122] x8 : 000000000000000d x7 : 000000000000001f x6 : 0000000000000000
[    0.755707] x5 : 0000000000000000 x4 : 0000000000000000 x3 : fffffdffc0000000
[    0.756287] x2 : 0000000000000008 x1 : 0000000040000000 x0 : fffffdffbf000000
[    0.756871] Call trace:
[    0.757107]  dax_disassociate_entry.constprop.0+0x20/0x50 (P)
[    0.757592]  dax_iomap_pte_fault+0x4fc/0x808
[    0.757951]  dax_iomap_fault+0x28/0x30
[    0.758258]  ext4_dax_huge_fault+0x80/0x2dc
[    0.758594]  ext4_dax_fault+0x10/0x3c
[    0.758892]  __do_fault+0x38/0x12c
[    0.759175]  __handle_mm_fault+0x530/0xcf0
[    0.759518]  handle_mm_fault+0xe4/0x230
[    0.759833]  do_page_fault+0x17c/0x4dc
[    0.760144]  do_translation_fault+0x30/0x38
[    0.760483]  do_mem_abort+0x40/0x8c
[    0.760771]  el0_ia+0x4c/0x170
[    0.761032]  el0t_64_sync_handler+0xd8/0xdc
[    0.761371]  el0t_64_sync+0x168/0x16c
[    0.761677] Code: f9453021 f2dfbfe3 cb813080 8b001860 (f9400401)
[    0.762168] ---[ end trace 0000000000000000 ]---
[    0.762550] note: init[1] exited with irqs disabled
[    0.762631] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

Link: https://lore.kernel.org/m2y0enxtzk.fsf@arm.com
Fixes: 38607c62b34b ("fs/dax: properly refcount fs dax pages")
Signed-off-by: Seunguk Shin <seunguk.shin@arm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Reported-by: Kiara Grouwstra <cinereal@riseup.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dax.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/dax.c
+++ b/fs/dax.c
@@ -443,11 +443,12 @@ static void dax_associate_entry(void *en
 				unsigned long address, bool shared)
 {
 	unsigned long size = dax_entry_size(entry), index;
-	struct folio *folio = dax_to_folio(entry);
+	struct folio *folio;
 
 	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
 		return;
 
+	folio = dax_to_folio(entry);
 	index = linear_page_index(vma, address & ~(size - 1));
 	if (shared && (folio->mapping || dax_folio_is_shared(folio))) {
 		if (folio->mapping)
@@ -468,21 +469,23 @@ static void dax_associate_entry(void *en
 static void dax_disassociate_entry(void *entry, struct address_space *mapping,
 				bool trunc)
 {
-	struct folio *folio = dax_to_folio(entry);
+	struct folio *folio;
 
 	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
 		return;
 
+	folio = dax_to_folio(entry);
 	dax_folio_put(folio);
 }
 
 static struct page *dax_busy_page(void *entry)
 {
-	struct folio *folio = dax_to_folio(entry);
+	struct folio *folio;
 
 	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
 		return NULL;
 
+	folio = dax_to_folio(entry);
 	if (folio_ref_count(folio) - folio_mapcount(folio))
 		return &folio->page;
 	else


