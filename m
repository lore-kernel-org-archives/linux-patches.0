Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99E033ADB0;
	Tue, 21 Jul 2026 19:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660927; cv=none; b=m65RZRc+oVmVNBhAbVOm5Rzrz5e6dGi7PEPaxKFfXBjejbEQuGrV4smeemC9e5r0qQ/S5+UNlVwIgGB4lldlH12z1n0u+0hY9lcscK8bQcrdU9jhTGi0O7GT4U2emvMSVjzxHHIv/gED0yGP8Qj48Bm1tnfx5CbUvSIcsZvnVUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660927; c=relaxed/simple;
	bh=m4Nm06E0UeBdCxGFpoiERYbiFSKld1xPwMnfXQMeACE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TyM98ImZeP20sTZjFlNtOuXuae2b35bMxuoyg3mGo8/LA2anSJ93wA3ZIMYxdmXVkKDn27JujWN3s2UcPkk3pKNPAGt65eebB4cqAIEGxy1jmwjB9UqtDqj5I0nz5+XKNbbUXWL/JGvT3C4cPoHB3JKSnDe8qmUlkceSWZBmnmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eYGZ7dke; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eYGZ7dke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1679A1F000E9;
	Tue, 21 Jul 2026 19:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660926;
	bh=09p8qxQPFcNE8V1X0pkkPxdDeLxy76RMwEVJodhDKAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eYGZ7dke3XrEZn7qzMSp4DiXtW1MC/bapKZKQn3qV+el6BVkiWUtiynEpP1xXjKvQ
	 TWqOY/nMQN282Vr4hjMSR8k+DE5oYG4t4hf++vVhb4PXPipqyZzj7NuWiO6QabVfgJ
	 bKZ3X05EmEdYWAaO5RCxTUZg+Ps2e8QNJRomcajA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sayali Patil <sayalip@linux.ibm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
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
Subject: [PATCH 7.1 1166/2077] selftest/mm: register existing mapping with userfaultfd in hugetlb-mremap
Date: Tue, 21 Jul 2026 17:13:59 +0200
Message-ID: <20260721152620.324977496@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Sayali Patil <sayalip@linux.ibm.com>

[ Upstream commit 1df31d5ef58dc6bdf0f2a8b809152d835c60b28e ]

Previously, register_region_with_uffd() created a new anonymous mapping
and overwrote the address supplied by the caller before registering the
range with userfaultfd.

As a result, userfaultfd was applied to an unrelated anonymous mapping
instead of the hugetlb region used by the test.

Remove the extra mmap() and register the caller-provided address range
directly using UFFDIO_REGISTER_MODE_MISSING, so that faults are generated
for the hugetlb mapping used by the test.

This ensures userfaultfd operates on the actual hugetlb test region and
validates the expected fault handling.

Before patch:
 running ./hugetlb-mremap
 -------------------------
 TAP version 13
 1..1
  Map haddr: Returned address is 0x7eaa40000000
  Map daddr: Returned address is 0x7daa40000000
  Map vaddr: Returned address is 0x7faa40000000
  Address returned by mmap() = 0x7fff9d000000
  Mremap: Returned address is 0x7faa40000000
  First hex is 0
  First hex is 3020100
 ok 1 Read same data
 Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
 [PASS]
 ok 1 hugetlb-mremap

After patch:
 running ./hugetb-mremap
 -------------------------
 TAP version 13
 1..1
  Map haddr: Returned address is 0x7eaa40000000
  Map daddr: Returned address is 0x7daa40000000
  Map vaddr: Returned address is 0x7faa40000000
  Registered memory at address 0x7eaa40000000 with userfaultfd
  Mremap: Returned address is 0x7faa40000000
  First hex is 0
  First hex is 3020100
 ok 1 Read same data
 Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
 [PASS]
 ok 1 hugetlb-mremap

Link: https://lore.kernel.org/13845da872ed174316173e8996dbb5f181994017.1779296493.git.sayalip@linux.ibm.com
Fixes: 12b613206474 ("mm, hugepages: add hugetlb vma mremap() test")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
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
 tools/testing/selftests/mm/hugepage-mremap.c | 21 +++++---------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage-mremap.c b/tools/testing/selftests/mm/hugepage-mremap.c
index b8f7d92e5a351b..e611249080d6db 100644
--- a/tools/testing/selftests/mm/hugepage-mremap.c
+++ b/tools/testing/selftests/mm/hugepage-mremap.c
@@ -85,25 +85,14 @@ static void register_region_with_uffd(char *addr, size_t len)
 	if (ioctl(uffd, UFFDIO_API, &uffdio_api) == -1)
 		ksft_exit_fail_msg("ioctl-UFFDIO_API: %s\n", strerror(errno));
 
-	/* Create a private anonymous mapping. The memory will be
-	 * demand-zero paged--that is, not yet allocated. When we
-	 * actually touch the memory, it will be allocated via
-	 * the userfaultfd.
-	 */
-
-	addr = mmap(NULL, len, PROT_READ | PROT_WRITE,
-		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-	if (addr == MAP_FAILED)
-		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
-
-	ksft_print_msg("Address returned by mmap() = %p\n", addr);
-
-	/* Register the memory range of the mapping we just created for
-	 * handling by the userfaultfd object. In mode, we request to track
-	 * missing pages (i.e., pages that have not yet been faulted in).
+	/* Register the passed memory range for handling by the userfaultfd object.
+	 * In mode, we request to track missing pages
+	 * (i.e., pages that have not yet been faulted in).
 	 */
 	if (uffd_register(uffd, addr, len, true, false, false))
 		ksft_exit_fail_msg("ioctl-UFFDIO_REGISTER: %s\n", strerror(errno));
+
+	ksft_print_msg("Registered memory at address %p with userfaultfd\n", addr);
 }
 
 int main(int argc, char *argv[])
-- 
2.53.0



