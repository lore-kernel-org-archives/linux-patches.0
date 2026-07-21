Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE3247125C;
	Tue, 21 Jul 2026 18:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657690; cv=none; b=aDZ68GPj6fmbC480sGhnuxPtKnONrNO8Hv9Eo4l+wrGjLI2JGmE1ZWuBhDdowNHocRm6RbYG0GV056CzLaAFRAjPVWNwNfB33Ipsyj+ShmCiGPnIw+016hR+gVlu6INF+QCDLVa394jm4Cf0Xfd2foabcRbJ4yjld/Cm7Sjb5SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657690; c=relaxed/simple;
	bh=/RBKXXGsYwNbD32bevkfDBfgMuaEJ3QGNA05U2nA1NY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UwhYxLw6J7sz5jtAARuX11y76IQEIQI7sP51kVzG2opStOPy0z3nu71iHMgZA/qtfSgTG/RIBNsMUAJscji0C42sd+v4JXJC9MBNBrLDFbMdOXdz8AoPbt6DBoWgxEjssfzrpQ1w2Lwt12piqvq67k6ajXvLezk17eyUJ/qvsnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMgMJg87; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMgMJg87"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8391F000E9;
	Tue, 21 Jul 2026 18:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657688;
	bh=14nhiwF0BVMuavX2E78GeTNL2oIamG7gi5FZN0BBGwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yMgMJg873iaxJFtnu48RLt1Z2KC7ozDsa3hhjdxf8BHKyR4bBo96hRDzJW5b6IhG2
	 +DBMYYQSmE+UAo+lHEsl+/U8y49WZilxgsM1rCGuhndplOLv7c+Vz4wOR3/EUojJH4
	 /JZpcJl2synYQ/ViEOwAfEHfP6lFhwSmOFYBR4Pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sayali Patil <sayalip@linux.ibm.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	Alex Sierra <alex.sierra@amd.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0860/1611] selftests/mm: allow PUD-level entries in compound testcase of hmm tests
Date: Tue, 21 Jul 2026 17:16:16 +0200
Message-ID: <20260721152534.734382917@linuxfoundation.org>
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

[ Upstream commit 224ed0e019b122d08580362abe57574a78f2b5fa ]

Patch series "selftests/mm: assorted fixes for hmm-tests", v3.

This series fixes a few issues in hmm-tests that show up when page-size
and huge-page configuration differ from the hardcoded assumptions the
tests were written for (PMD/THP sizing, default hugepage size, and related
cases).

It also includes a fix to exclusive_cow: the test ignored the return value
of fork(), so both parent and child ran the same teardown path.

This patch (of 3):

The HMM compound testcase currently assumes only PMD-level mappings and
fails on systems where default_hugepagesz=1G is set, because the region is
then reported by the device at PUD level.

Determine the mapping level (PMD or PUD) the device reports for the first
page of the range and require every page to match that level exactly via
ASSERT_EQ().  This accepts PUD-level mappings while preserving the
expected/observed protection values printed on failure, and rejects a
fragmented mapping that mixes PMD- and PUD-level entries within the same
range (which a per-page OR check would have let pass).

Link: https://lore.kernel.org/20260611034102.1030738-1-aboorvad@linux.ibm.com
Link: https://lore.kernel.org/20260611034102.1030738-2-aboorvad@linux.ibm.com
Fixes: e478425bec93 ("mm/hmm: add tests for hmm_pfn_to_map_order()")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Co-developed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/hmm-tests.c | 32 +++++++++++++++++++-------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index c13b779bf11844..cfc5ed3585b3f3 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -1612,8 +1612,8 @@ TEST_F(hmm2, snapshot)
 }
 
 /*
- * Test the hmm_range_fault() HMM_PFN_PMD flag for large pages that
- * should be mapped by a large page table entry.
+ * Test the hmm_range_fault() handling of large pages (PMD or PUD)
+ * that should be mapped by a large page table entry.
  */
 TEST_F(hmm, compound)
 {
@@ -1623,6 +1623,7 @@ TEST_F(hmm, compound)
 	unsigned long default_hsize;
 	int *ptr;
 	unsigned char *m;
+	unsigned char prot;
 	int ret;
 	unsigned long i;
 
@@ -1661,11 +1662,20 @@ TEST_F(hmm, compound)
 	ASSERT_EQ(ret, 0);
 	ASSERT_EQ(buffer->cpages, npages);
 
-	/* Check what the device saw. */
+	/*
+	 * Check what the device saw.  The region is backed by a single huge
+	 * page that the device reports either at PMD or at PUD level depending
+	 * on the configured default hugepage size.  Determine that level from
+	 * the first page and require every page in the range to match it
+	 * exactly, so that a fragmented mapping mixing levels (or a missing
+	 * large-page bit) is still caught and reported with its actual value.
+	 */
 	m = buffer->mirror;
+	prot = HMM_DMIRROR_PROT_WRITE |
+	       ((m[0] & HMM_DMIRROR_PROT_PUD) ? HMM_DMIRROR_PROT_PUD :
+						HMM_DMIRROR_PROT_PMD);
 	for (i = 0; i < npages; ++i)
-		ASSERT_EQ(m[i], HMM_DMIRROR_PROT_WRITE |
-				HMM_DMIRROR_PROT_PMD);
+		ASSERT_EQ(m[i], prot);
 
 	/* Make the region read-only. */
 	ret = mprotect(buffer->ptr, size, PROT_READ);
@@ -1676,11 +1686,17 @@ TEST_F(hmm, compound)
 	ASSERT_EQ(ret, 0);
 	ASSERT_EQ(buffer->cpages, npages);
 
-	/* Check what the device saw. */
+	/*
+	 * Check what the device saw after mprotect(PROT_READ).  Same
+	 * approach as above: determine the mapping level from the first
+	 * page and require every page to match it exactly.
+	 */
 	m = buffer->mirror;
+	prot = HMM_DMIRROR_PROT_READ |
+	       ((m[0] & HMM_DMIRROR_PROT_PUD) ? HMM_DMIRROR_PROT_PUD :
+						HMM_DMIRROR_PROT_PMD);
 	for (i = 0; i < npages; ++i)
-		ASSERT_EQ(m[i], HMM_DMIRROR_PROT_READ |
-				HMM_DMIRROR_PROT_PMD);
+		ASSERT_EQ(m[i], prot);
 
 	munmap(buffer->ptr, buffer->size);
 	buffer->ptr = NULL;
-- 
2.53.0



