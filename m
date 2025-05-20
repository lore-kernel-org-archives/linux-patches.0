Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB66F242907;
	Tue, 20 May 2025 14:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749955; cv=none; b=a0B6nwRZtaRPis9veVZ8KJUJpA+neVe9Fm3yZeanBYDYdMxYe9ei+9SflZjf07ItDWq/+/qJ3YYTCqtz2xat9gMPBjzI5DrmoMxCM+GPT62OHpqeQBq+MXF/wFvka650iW0zudldrCsQAHVTnGCJRv3XGjkTpvtT8Z5cCw7FsuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749955; c=relaxed/simple;
	bh=bgQ0W7L9igsBdnBQXOr40EiX4HMfDhjJN2NK1SypqtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgWW0KaPokGGnd3kqSf2SHm9HI5DBOIxSVq2QOAub2NB0OgAe8OV1bH6qbZ8rtcauUwVL5tIHWXI9+9bdHbfecnpsS5ZVCqJQh0ndNRE5u9L3QiiYkEYmwUbJcYWgpgWxvIsnSrbR3PNP7ehR0nrB6NlCR5mwOFaz4Hzdei81fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1xjtk6RZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1xjtk6RZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A34C4CEE9;
	Tue, 20 May 2025 14:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749955;
	bh=bgQ0W7L9igsBdnBQXOr40EiX4HMfDhjJN2NK1SypqtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1xjtk6RZZJxrOiPzw0zHChFuWMjMYrGG3wm0kjNKlQLeRj8vagF8zt/2f2AxPOKFy
	 j3br7ros2bYO2/iIbAmt5tFB12XmtEmNq/vwaVJR7gzbBqvImxBuToj68PCbNPg3as
	 clyeh+O0YUHQr+zAyW5/VCLs6saCZr77XhDZbS/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 6.6 112/117] memblock: Accept allocated memory before use in memblock_double_array()
Date: Tue, 20 May 2025 15:51:17 +0200
Message-ID: <20250520125808.444075823@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -460,7 +460,14 @@ static int __init_memblock memblock_doub
 				min(new_area_start, memblock.current_limit),
 				new_alloc_size, PAGE_SIZE);
 
-		new_array = addr ? __va(addr) : NULL;
+		if (addr) {
+			/* The memory may not have been accepted, yet. */
+			accept_memory(addr, addr + new_alloc_size);
+
+			new_array = __va(addr);
+		} else {
+			new_array = NULL;
+		}
 	}
 	if (!addr) {
 		pr_err("memblock: Failed to double %s array from %ld to %ld entries !\n",


