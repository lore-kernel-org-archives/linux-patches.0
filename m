Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCEF379966;
	Thu, 20 Aug 2026 15:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238045; cv=none; b=S1pC26T+0MZgVK+SKxBnGPMofszQQrxW8R5CHr09/l1P0pwHqMZLHEn2oBuRmPi/6wNK9Bcvu+fzkblMbsX5Am2bgYwLjbfMnIY6Ns/ovqHOKXYgvqcqwJB8Tv9TXm9THKY/kMX9ZPNmtW+0jHOL7U7VA+hjeTj1JuQ0JYs1A4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238045; c=relaxed/simple;
	bh=bB71JRRezSR198c3N8h4J48N5u4kc/YMZMlNmZMVrys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxQfAEpkoiL2iOt6zoHkLtCyJ3/t3fZQngaDSn4Pm7rnO3LY9IDpTJir/xH6vgtbEbnwTM+Ug3RraRCKOlnymIFDS+sv0pBqocsMpTP/wwkBFN5Dyg8kuxXn3qe2wLLnhfFcCeggwA9Lcu5scTh6jdr2UQIv8C4n72JHDXvTf0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=seCfZoHi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="seCfZoHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1401F000E9;
	Thu, 20 Aug 2026 15:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238043;
	bh=7AOOb+XxjceA9/VZ+LfTSwzmIpBmI9J9ZdmG5QGlvgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=seCfZoHiUFEIXSwWmsV1yfDnmSn4fTv+ipcviDOj+3rJClEeN93UQhYvYmUiZxP3D
	 /ycZyumOQiaKm19tob48E6ukaalE7mFTH7/aQlurfOdH9fqsDK8tslvjcr/45h5J6x
	 mgCrOCidkXKW7iYpxBC+OYnutV4ttCXZ+P1Fb4vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramin Moussavi <ramin.moussavi@yacoub.de>,
	Michal Simek <monstr@monstr.eu>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 014/228] microblaze: restore the page alignment of swapper_pg_dir
Date: Thu, 20 Aug 2026 16:52:36 +0200
Message-ID: <20260820145244.893436952@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ramin Moussavi <ramin.moussavi@yacoub.de>

commit c2689266e5f70ecc960e64d40516518c038ae34e upstream.

microblaze handles TLB misses in software, and the handler builds the
address of the L1 entry by ORing the index into the page directory base
instead of adding it (hw_exception_handler.S):

		bsrli	r5, r3, PGDIR_SHIFT - 2
		andi	r5, r5, PAGE_SIZE - 4
	/* Assume pgdir aligned on 4K boundary, no need for
	   "andi r4,r4,0xfffff003" */
		or	r4, r4, r5
		lwi	r4, r4, 0		/* Get L1 entry */

The index is masked to the low 12 bits, so the OR only works if those bits
of the base are zero -- which is exactly the assumption the comment states
and the reason the masking of the base can be skipped.

swapper_pg_dir had no alignment directive of its own.  It was aligned
because it followed empty_zero_page in head.S, and that one carried the
.align 12:

	.section .data
	.global empty_zero_page
	.align 12
	empty_zero_page:
		.space	PAGE_SIZE
	.global swapper_pg_dir
	swapper_pg_dir:
		.space	PAGE_SIZE

Commit 6215d9f4470f ("arch, mm: consolidate empty_zero_page") removed
empty_zero_page from head.S, and with it the .align 12 that -- despite
sitting next to empty_zero_page -- was what page aligned swapper_pg_dir.
Since then swapper_pg_dir lands wherever .data happens to put it, its low
bits are no longer zero, and every kernel TLB miss ORs the index into a
base with a nonzero offset.  The resulting L1 lookups read the wrong
words, no valid translation is ever installed, and the kernel spins in
exceptions long before it can print anything.  On qemu-system-microblazeel
(petalogix-s3adsp1800) the console stays completely silent at 100% CPU;
there is no oops and no guest error reported by qemu, which makes this
awkward to diagnose.

Give swapper_pg_dir the alignment it requires, rather than relying on a
neighbour to provide it.

microblaze has no noMMU variant left in mainline -- CONFIG_MMU is def_bool
y and mmu_defconfig is the only defconfig -- so this is not a corner case:
every mainline microblaze kernel since v7.1-rc1 fails to boot, including
the v7.1 release.

	v7.0:                    swapper_pg_dir = 0xc05fd000  (aligned)
	v7.1-rc1:                swapper_pg_dir = 0xc0603140  (offset 320)
	v7.1-rc1 + this fix:     swapper_pg_dir = 0xc0604000  (aligned)
	next-20260726:           swapper_pg_dir = 0xc0615140  (offset 320)
	next-20260726 + this fix: swapper_pg_dir = 0xc0616000  (aligned)

Verified on qemu-system-microblazeel (petalogix-s3adsp1800) with
mmu_defconfig and microblazeel gcc 12.5.0: v7.1-rc1 and next-20260726 both
print nothing at all without the fix, and both boot to userspace with it.

Link: https://lore.kernel.org/20260727215823.1422701-1-ramin.moussavi@yacoub.de
Fixes: 6215d9f4470f ("arch, mm: consolidate empty_zero_page")
Signed-off-by: Ramin Moussavi <ramin.moussavi@yacoub.de>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/microblaze/kernel/head.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/microblaze/kernel/head.S b/arch/microblaze/kernel/head.S
index 808019c3b7ac..9bd3e513c89b 100644
--- a/arch/microblaze/kernel/head.S
+++ b/arch/microblaze/kernel/head.S
@@ -39,6 +39,8 @@
 #include <asm/processor.h>
 
 .section .data
+/* The MMU requires a page aligned page directory. */
+.align 12
 .global swapper_pg_dir
 swapper_pg_dir:
 	.space	PAGE_SIZE
-- 
2.55.0



