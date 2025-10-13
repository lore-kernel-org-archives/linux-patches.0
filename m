Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A580E30DD17;
	Mon, 13 Oct 2025 15:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369964; cv=none; b=k2koqKOtoPyJEqKCUAtg1HoJ9XPtMCw08NT/MJsqJ+hVN+0kxgITLgtLr2/E6t82e4OjG/EqSwOgHtqMlVGN+ITGrs6d3t+riZfCgaDrBPfJwvRU0BnHkBGM/tqd13FqMnJnQftcYGkB8NKqA2Ok/0+OI8Wdk4ZDOwfshUk+Oik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369964; c=relaxed/simple;
	bh=fkSeF5wDAv+J2M7n3Zy+fa+bntFaETUZcr9ULOElHrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YgxRMJfSpUqcwaa7MJ6Rm/OUGblDej2JA/HAw6tOwAOApvuWwD2QwFBhSsXhPFA5Nd9sgZNFYwFFsqBvi6ewp9vhxnpOcuaRLiwPwnRDYhqr7Nc+tWKvyuhAegbvSmDlhOsqfrx7ggtwF0ZAUFXDMJ+Cb96ELE47vjzSzjC7xgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tApHkwIY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tApHkwIY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10306C4CEE7;
	Mon, 13 Oct 2025 15:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369964;
	bh=fkSeF5wDAv+J2M7n3Zy+fa+bntFaETUZcr9ULOElHrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tApHkwIYkVuH7q32inNFjsOm9/XOHBySVkxKxYrFePNJ5WmwyQbcxZC5MTIyOqMeY
	 TUndzXX/D/9j4PKdKACZVUxx/AR1k1HYMnZVq5fJDOrxmq7ur1fqaf+BA5Izdoc7yx
	 9uEMGI1UHCSSgX/d8zZqhHjpZq6+EbF05V4IgyAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunyu Hu <chuhu@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 413/563] selftests/mm: fix va_high_addr_switch.sh failure on x86_64
Date: Mon, 13 Oct 2025 16:44:34 +0200
Message-ID: <20251013144426.250577037@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chunyu Hu <chuhu@redhat.com>

[ Upstream commit c56325259abc026205c98964616dcc0df5648912 ]

The test will fail as below on x86_64 with cpu la57 support (will skip if
no la57 support).  Note, the test requries nr_hugepages to be set first.

  # running bash ./va_high_addr_switch.sh
  # -------------------------------------
  # mmap(addr_switch_hint - pagesize, pagesize): 0x7f55b60fa000 - OK
  # mmap(addr_switch_hint - pagesize, (2 * pagesize)): 0x7f55b60f9000 - OK
  # mmap(addr_switch_hint, pagesize): 0x800000000000 - OK
  # mmap(addr_switch_hint, 2 * pagesize, MAP_FIXED): 0x800000000000 - OK
  # mmap(NULL): 0x7f55b60f9000 - OK
  # mmap(low_addr): 0x40000000 - OK
  # mmap(high_addr): 0x1000000000000 - OK
  # mmap(high_addr) again: 0xffff55b6136000 - OK
  # mmap(high_addr, MAP_FIXED): 0x1000000000000 - OK
  # mmap(-1): 0xffff55b6134000 - OK
  # mmap(-1) again: 0xffff55b6132000 - OK
  # mmap(addr_switch_hint - pagesize, pagesize): 0x7f55b60fa000 - OK
  # mmap(addr_switch_hint - pagesize, 2 * pagesize): 0x7f55b60f9000 - OK
  # mmap(addr_switch_hint - pagesize/2 , 2 * pagesize): 0x7f55b60f7000 - OK
  # mmap(addr_switch_hint, pagesize): 0x800000000000 - OK
  # mmap(addr_switch_hint, 2 * pagesize, MAP_FIXED): 0x800000000000 - OK
  # mmap(NULL, MAP_HUGETLB): 0x7f55b5c00000 - OK
  # mmap(low_addr, MAP_HUGETLB): 0x40000000 - OK
  # mmap(high_addr, MAP_HUGETLB): 0x1000000000000 - OK
  # mmap(high_addr, MAP_HUGETLB) again: 0xffff55b5e00000 - OK
  # mmap(high_addr, MAP_FIXED | MAP_HUGETLB): 0x1000000000000 - OK
  # mmap(-1, MAP_HUGETLB): 0x7f55b5c00000 - OK
  # mmap(-1, MAP_HUGETLB) again: 0x7f55b5a00000 - OK
  # mmap(addr_switch_hint - pagesize, 2*hugepagesize, MAP_HUGETLB): 0x800000000000 - FAILED
  # mmap(addr_switch_hint , 2*hugepagesize, MAP_FIXED | MAP_HUGETLB): 0x800000000000 - OK
  # [FAIL]

addr_switch_hint is defined as DFEFAULT_MAP_WINDOW in the failed test (for
x86_64, DFEFAULT_MAP_WINDOW is defined as (1UL<<47) - pagesize) in 64 bit.

Before commit cc92882ee218 ("mm: drop hugetlb_get_unmapped_area{_*}
functions"), for x86_64 hugetlb_get_unmapped_area() is handled in arch
code arch/x86/mm/hugetlbpage.c and addr is checked with
map_address_hint_valid() after align with 'addr &= huge_page_mask(h)'
which is a round down way, and it will fail the check because the addr is
within the DEFAULT_MAP_WINDOW but (addr + len) is above the
DFEFAULT_MAP_WINDOW.  So it wil go through the
hugetlb_get_unmmaped_area_top_down() to find an area within the
DFEFAULT_MAP_WINDOW.

After commit cc92882ee218 ("mm: drop hugetlb_get_unmapped_area{_*}
functions").  The addr hint for hugetlb_get_unmmaped_area() will be
rounded up and aligned to hugepage size with ALIGN() for all arches.  And
after the align, the addr will be above the default MAP_DEFAULT_WINDOW,
and the map_addresshint_valid() check will pass because both aligned addr
(addr0) and (addr + len) are above the DEFAULT_MAP_WINDOW, and the aligned
hint address (0x800000000000) is returned as an suitable gap is found
there, in arch_get_unmapped_area_topdown().

To still cover the case that addr is within the DEFAULT_MAP_WINDOW, and
addr + len is above the DFEFAULT_MAP_WINDOW, change to choose the last
hugepage aligned address within the DEFAULT_MAP_WINDOW as the hint addr,
and the addr + len (2 hugepages) will be one hugepage above the
DEFAULT_MAP_WINDOW.  An aligned address won't be affected by the page
round up or round down from kernel, so it's determistic.

Link: https://lkml.kernel.org/r/20250912013711.3002969-4-chuhu@redhat.com
Fixes: cc92882ee218 ("mm: drop hugetlb_get_unmapped_area{_*} functions")
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/va_high_addr_switch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/va_high_addr_switch.c b/tools/testing/selftests/mm/va_high_addr_switch.c
index 896b3f73fc53b..306eba8251077 100644
--- a/tools/testing/selftests/mm/va_high_addr_switch.c
+++ b/tools/testing/selftests/mm/va_high_addr_switch.c
@@ -230,10 +230,10 @@ void testcases_init(void)
 			.msg = "mmap(-1, MAP_HUGETLB) again",
 		},
 		{
-			.addr = (void *)(addr_switch_hint - pagesize),
+			.addr = (void *)(addr_switch_hint - hugepagesize),
 			.size = 2 * hugepagesize,
 			.flags = MAP_HUGETLB | MAP_PRIVATE | MAP_ANONYMOUS,
-			.msg = "mmap(addr_switch_hint - pagesize, 2*hugepagesize, MAP_HUGETLB)",
+			.msg = "mmap(addr_switch_hint - hugepagesize, 2*hugepagesize, MAP_HUGETLB)",
 			.low_addr_required = 1,
 			.keep_mapped = 1,
 		},
-- 
2.51.0



