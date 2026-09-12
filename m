Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9902369224;
	Sat, 12 Sep 2026 09:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203861; cv=none; b=Zf4WDXHA3kpHrz9NRxW5AUAb1YCPZpmXqkbBwnThup8rLVs74oSIi4v8zp9Vbz7otcyPfQ5RnpFpWM9f8aRkp//bDKIdbiGUvwlywqmcXg9+KOHjtnUN1kfCa74JLdFHhxbTRz11oiTBZSLo+2CgTWQF63I2ANpDSpYeKJoO8UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203861; c=relaxed/simple;
	bh=2V1K2qey3ORjijv85UWw6XTdiCkLLQhGZaErl2FJtPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qSFJJzRiKJT7Bii8FrXHZkounYNGVAavYDMuSV1y0zAUhVrWkhbSo+ndNpYS1Prl3nhPRUJCXMHsDYX4miOYGhRd/7Ms96ZwkuVex/GHSG5SMfkowsV5mq5TlsLBFgK9w/tjDBJyjC+BXK5MJLFQWZr1sJXp2lqlswSi/9jEC7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eObL4oYh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eObL4oYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405C11F000FF;
	Sat, 12 Sep 2026 09:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203860;
	bh=admYzrpB2RiC6tqDRUWH2DRb6DRRfyyiYlZJ3hDKfho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eObL4oYhm7fxZzDZtl0GG7WHPk1XAT0np3CA/WFZoLooRSww6Rt92Lt8mCIzvNmsS
	 7PvS8hQtvKYQ84qrPb5ihpCylxr2jFWru2b0YmgRDN+UVX/IvLkx9qk/4bvmfOSx/3
	 pzt9VxRP4jgGzjPdtoNT9PlFnXvaA/MJ6+FwWUA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1493/1815] selftests/mm: thuge-gen: fix test_shmget() for PAGE_SIZE check
Date: Sat, 12 Sep 2026 08:54:03 +0200
Message-ID: <20260912065724.051391170@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

[ Upstream commit 08745c62350126bc31b09548137be87e2866f628 ]

Commit 49a4e7186b08 ("selftests/mm: thuge-gen: add setup of HugeTLB
pages") changed thuge-gen test to use common functions for reading hugetlb
attributes from sysfs, but it missed that the original read_free()
function special cased PAGE_SIZE tests.

For PAGE_SIZE tests, failure to read sysfs was ignored and read_free()
returned 0.

This allowed test_shmget() to essentially skip the check of how many huge
pages was consumed when it ran with PAGE_SIZE.

Commit 3199b0c09efa ("selftests/mm: fix read_file() return value check")
fixed checks for read_file() return value and this exposed the issue in
test_shmget() that checks the number of free hugetlb pages even for
PAGE_SIZE test, tries to access

/sys/kernel/mm/hugepages/hugepages-<PAGE_SIZE>/free_hugepages

and obviously fails there.

Gate the checks for free huge pages on size != getpagesize() and
initialize before and after variables to values matching PAGE_SIZE test.

Link: https://lore.kernel.org/20260812-selftests-thuge-gen-fix-v2-1-9adaa693e73b@kernel.org
Fixes: 49a4e7186b08 ("selftests/mm: thuge-gen: add setup of HugeTLB pages")
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/thuge-gen.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/mm/thuge-gen.c b/tools/testing/selftests/mm/thuge-gen.c
index 22b9c2f1c35d2..50d0805b65db9 100644
--- a/tools/testing/selftests/mm/thuge-gen.c
+++ b/tools/testing/selftests/mm/thuge-gen.c
@@ -71,12 +71,16 @@ void test_mmap(unsigned long size, unsigned flags)
 
 void test_shmget(unsigned long size, unsigned flags)
 {
-	int id;
-	unsigned long before, after;
+	/* values for PAGE_SIZE test */
+	unsigned long before = NUM_PAGES;
+	unsigned long after = 0;
 	struct shm_info i;
 	char *map;
+	int id;
+
+	if (size != getpagesize())
+		before = hugetlb_free_pages(size);
 
-	before = hugetlb_free_pages(size);
 	id = shmget(IPC_PRIVATE, size * NUM_PAGES, IPC_CREAT|0600|flags);
 	if (id < 0) {
 		if (errno == EPERM) {
@@ -97,10 +101,11 @@ void test_shmget(unsigned long size, unsigned flags)
 	shmctl(id, IPC_RMID, NULL);
 
 	memset(map, 0xff, size*NUM_PAGES);
-	after = hugetlb_free_pages(size);
+	if (size != getpagesize())
+		after = hugetlb_free_pages(size);
 
 	show(size);
-	ksft_test_result(size == getpagesize() || (before - after) == NUM_PAGES,
+	ksft_test_result((before - after) == NUM_PAGES,
 			 "%s: mmap %lu %x\n", __func__, size, flags);
 	if (shmdt(map))
 		ksft_exit_fail_msg("%s: shmdt: %s\n", __func__, strerror(errno));
-- 
2.53.0



