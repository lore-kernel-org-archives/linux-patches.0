Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305D7471255;
	Tue, 21 Jul 2026 18:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657682; cv=none; b=KxeCz9XVNr70fPNVL8XFcFIf0EyPqHnmUWuY2tvqZZUdg4FUSAKXThOySIIQQllf4BrW7UwgJhgFySRZA2VPYi23hbCPZMVNnHEaDqDod0FsbP0ItdKiq+YQY3/g1Qe6hPGNynsZx7eqASWyTIvZ3VYJzlk6i5Eaiz73l4dvzu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657682; c=relaxed/simple;
	bh=y0S4evg+QgDxIocv4N1cLsY6+8+nii91n99Pz4tvo/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZtwGgL4nraTxjTyARjAQb+9ItXb0AAcXjZU34Y3dbJBvKiQ8xR+gO7aFjP+zyLivVTZ9whPIRxHMKUUVF2DgZeszgM0LYdlnXr6Wgr4wAI/lDUgcVNGh4JHUNdNHNn7WaIT2EM9no5szQD7W35NA/9WhUtzJL7vd53WtewrmTPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oQfcslKd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oQfcslKd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899091F000E9;
	Tue, 21 Jul 2026 18:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657681;
	bh=POqLdCqfofu6WKsjhj1SnP0OB87tFmA3AxQEikJ3PpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oQfcslKdmwrcMUzv045jlsh0XX9cfjaRYQDoPgZFtbtfeAxfoBrpnUGIYOE7eTJRJ
	 uor/HDkgva+LK+c90i+BF1UN23l/w39r2esqlgPsSAu2MFI3BKluySqXqPN1ymc85b
	 5UbNNymqzFJaiLxGQY+iUEc4iwl6cqi74ub7a7CU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sayali Patil <sayalip@linux.ibm.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Michal Hocko <mhocko@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0857/1611] selftests/mm: ensure destination is hugetlb-backed in hugetlb-mremap
Date: Tue, 21 Jul 2026 17:16:13 +0200
Message-ID: <20260721152534.667651502@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Sayali Patil <sayalip@linux.ibm.com>

[ Upstream commit f20ca8972e83f111c4300c60d74314568c8964bc ]

The hugetlb-mremap selftest reserves the destination address using a
anonymous base-page mapping before calling mremap() with MREMAP_FIXED,
while the source region is hugetlb-backed.

When remapping a hugetlb mapping into a base-page VMA may fail with:

    mremap: Device or resource busy

This is observed on powerpc hash MMU systems where slice constraints and
page size incompatibilities prevent the remap.

Ensure the destination region is created using MAP_HUGETLB so that both
source and destination VMAs are hugetlb-backed and compatible.

Update the FLAGS macro to include MAP_HUGETLB | MAP_SHARED so that both
mappings are hugetlb-backed and compatible.  Also use the macro for the
mmap() calls to avoid repeating the flag combination.

This ensures the test reliably exercises hugetlb mremap instead of failing
due to VMA type mismatch.

Link: https://lore.kernel.org/367644df45c65098f23e3945c6a80f4b8a8964a6.1779296493.git.sayalip@linux.ibm.com
Fixes: 12b613206474 ("mm, hugepages: add hugetlb vma mremap() test")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/hugepage-mremap.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage-mremap.c b/tools/testing/selftests/mm/hugepage-mremap.c
index cd862a619471e7..928c1045e29548 100644
--- a/tools/testing/selftests/mm/hugepage-mremap.c
+++ b/tools/testing/selftests/mm/hugepage-mremap.c
@@ -31,7 +31,7 @@
 #define MB_TO_BYTES(x) (x * 1024 * 1024)
 
 #define PROTECTION (PROT_READ | PROT_WRITE | PROT_EXEC)
-#define FLAGS (MAP_SHARED | MAP_ANONYMOUS)
+#define FLAGS (MAP_HUGETLB | MAP_SHARED)
 
 static void check_bytes(char *addr)
 {
@@ -121,23 +121,20 @@ int main(int argc, char *argv[])
 
 	/* mmap to a PUD aligned address to hopefully trigger pmd sharing. */
 	unsigned long suggested_addr = 0x7eaa40000000;
-	void *haddr = mmap((void *)suggested_addr, length, PROTECTION,
-			   MAP_HUGETLB | MAP_SHARED | MAP_POPULATE, fd, 0);
+	void *haddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
 	ksft_print_msg("Map haddr: Returned address is %p\n", haddr);
 	if (haddr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap1: %s\n", strerror(errno));
 
 	/* mmap again to a dummy address to hopefully trigger pmd sharing. */
 	suggested_addr = 0x7daa40000000;
-	void *daddr = mmap((void *)suggested_addr, length, PROTECTION,
-			   MAP_HUGETLB | MAP_SHARED | MAP_POPULATE, fd, 0);
+	void *daddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
 	ksft_print_msg("Map daddr: Returned address is %p\n", daddr);
 	if (daddr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap3: %s\n", strerror(errno));
 
 	suggested_addr = 0x7faa40000000;
-	void *vaddr =
-		mmap((void *)suggested_addr, length, PROTECTION, FLAGS, -1, 0);
+	void *vaddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
 	ksft_print_msg("Map vaddr: Returned address is %p\n", vaddr);
 	if (vaddr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap2: %s\n", strerror(errno));
-- 
2.53.0



