Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268A6296FA0;
	Mon, 12 May 2025 17:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072066; cv=none; b=ncHG7uLQP57SNs/sOD4cKRpke7Gvi/TFaFTIYC2Ce19D7N85EZ9/gPMmjZSWzHqfqmBrDXaX4k1bDcqCkk+3V318+lm+neGlP9ok5M6xclqp4BIZoMMSUP9CjCvppntis6uOEw6a9esl+5Ru/ZJzfSEpAt3vEi5YBTHCeT6/UDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072066; c=relaxed/simple;
	bh=MmI0i1YGavtSyeqI/bddvluL2UD2B8Tc+vjoyQdzPCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Baw68SSgJxNhBLyP6NVDXPyuADA2Mccj72m7MdsQmv2MNkUFZStYTY8dLLh24vfklhriUEEa/adQGM9RcCPRbQ9VttAm22fXuWAs4W8c21c2pxxuTcv9YFfeWtcjat9Xkhk5eYd5q8WGNR34gnRo7XOB4IqK7F1I7x4WSlUpVpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/QqRb2E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/QqRb2E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE39EC4CEE7;
	Mon, 12 May 2025 17:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072066;
	bh=MmI0i1YGavtSyeqI/bddvluL2UD2B8Tc+vjoyQdzPCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/QqRb2E/M9lhnTC+v73Yrq+qSBTPxlI6jX/xI66tDt1kh0HEV4Gx3N0RyF8yIjV2
	 gGwWo6ENs2y2PDNQtfyehCAUJ9+laLxXNkEjMV9MDuhS2XcS9wk9AaNtyJ9gpUzLaH
	 3TLI4JPWjwJTT5QiKXoEYzQVBJBdXK9UmknHeRKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 6.14 126/197] memblock: Accept allocated memory before use in memblock_double_array()
Date: Mon, 12 May 2025 19:39:36 +0200
Message-ID: <20250512172049.517558497@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Lendacky <thomas.lendacky@amd.com>

commit da8bf5daa5e55a6af2b285ecda460d6454712ff4 upstream.

When increasing the array size in memblock_double_array() and the slab
is not yet available, a call to memblock_find_in_range() is used to
reserve/allocate memory. However, the range returned may not have been
accepted, which can result in a crash when booting an SNP guest:

  RIP: 0010:memcpy_orig+0x68/0x130
  Code: ...
  RSP: 0000:ffffffff9cc03ce8 EFLAGS: 00010006
  RAX: ff11001ff83e5000 RBX: 0000000000000000 RCX: fffffffffffff000
  RDX: 0000000000000bc0 RSI: ffffffff9dba8860 RDI: ff11001ff83e5c00
  RBP: 0000000000002000 R08: 0000000000000000 R09: 0000000000002000
  R10: 000000207fffe000 R11: 0000040000000000 R12: ffffffff9d06ef78
  R13: ff11001ff83e5000 R14: ffffffff9dba7c60 R15: 0000000000000c00
  memblock_double_array+0xff/0x310
  memblock_add_range+0x1fb/0x2f0
  memblock_reserve+0x4f/0xa0
  memblock_alloc_range_nid+0xac/0x130
  memblock_alloc_internal+0x53/0xc0
  memblock_alloc_try_nid+0x3d/0xa0
  swiotlb_init_remap+0x149/0x2f0
  mem_init+0xb/0xb0
  mm_core_init+0x8f/0x350
  start_kernel+0x17e/0x5d0
  x86_64_start_reservations+0x14/0x30
  x86_64_start_kernel+0x92/0xa0
  secondary_startup_64_no_verify+0x194/0x19b

Mitigate this by calling accept_memory() on the memory range returned
before the slab is available.

Prior to v6.12, the accept_memory() interface used a 'start' and 'end'
parameter instead of 'start' and 'size', therefore the accept_memory()
call must be adjusted to specify 'start + size' for 'end' when applying
to kernels prior to v6.12.

Cc: stable@vger.kernel.org # see patch description, needs adjustments for <= 6.11
Fixes: dcdfdd40fa82 ("mm: Add support for unaccepted memory")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/da1ac73bf4ded761e21b4e4bb5178382a580cd73.1746725050.git.thomas.lendacky@amd.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memblock.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -456,7 +456,14 @@ static int __init_memblock memblock_doub
 				min(new_area_start, memblock.current_limit),
 				new_alloc_size, PAGE_SIZE);
 
-		new_array = addr ? __va(addr) : NULL;
+		if (addr) {
+			/* The memory may not have been accepted, yet. */
+			accept_memory(addr, new_alloc_size);
+
+			new_array = __va(addr);
+		} else {
+			new_array = NULL;
+		}
 	}
 	if (!addr) {
 		pr_err("memblock: Failed to double %s array from %ld to %ld entries !\n",


