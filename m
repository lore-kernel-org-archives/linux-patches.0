Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BCF471257;
	Tue, 21 Jul 2026 19:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662978; cv=none; b=AZbKUnLHPoeNaRRGjmOEYBr3N0m0WeHSkCABtqit1QA7lMGF4zzDtD5h5rmHfRmq79WS/bMLBmrGR5/a0KlalBgz4RFxp2tLYaMzvG5Wmpbsdx4OZWMQ6wAPm5oIj5WS86Vxb5GeOvjeWuMZQxi2ZJJMCZ4tohjlMf8V+p1soEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662978; c=relaxed/simple;
	bh=nmahHFUXdHIdQm7vE6Sx3fQ+zspmheD+6ldN/zWQ4Ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APUe8dyyuxzgCYuK54wCkuzcSN1DxkVyYcSW0sLtgnG/Aso+LUI9AOQRbRmnEDUHZAQUCitt1MahFuYeocL7SI9+k4p9W5GNHIzlPjPAtClOOuMaSRQlrwiuz2LS/hRe5cFX+IYgRzU3mp0r6MhNQ4ENj4uiXczBL6p9yZVA0hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A8ddyZZ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A8ddyZZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1591F000E9;
	Tue, 21 Jul 2026 19:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662977;
	bh=SYMhOxk7GtySTRVWH+ZvX1zwRNxyXExk8ERgVVx7rXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A8ddyZZ1NdVKCBlTQ1TXjlJagDIWFQ/v45Byywciyq6ru0tStG2PcSQafcDVmwno8
	 k+OGdgcTSVsxRtGqYi+rdRYl9d0kXStbnndWg9/tdvt1yfjMYivNBhaEcup5bf3/P4
	 tiitT9s25QpUpV5AFrLdfpgCk+A21xz34WLMleFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
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
	Sayali Patil <sayalip@linux.ibm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0606/1276] selftests/mm: fix exclusive_cow test fork() handling
Date: Tue, 21 Jul 2026 17:17:29 +0200
Message-ID: <20260721152459.670746067@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aboorva Devarajan <aboorvad@linux.ibm.com>

[ Upstream commit cea5702144615878600d3a39b5d8b3cc34719012 ]

The test ignores the return value of fork(), so both the parent and the
(newly created) child run the COW verification loops and then call
hmm_buffer_free() before returning into the kselftest harness, which
_exit()s each side.  This duplicated teardown sequence has been observed
to manifest as a SIGSEGV in the test child, e.g.:

  hmm-tests[360141]: segfault (11) at 0 nip 10006964 lr 1000ac3c code 1
  in hmm-tests[6964,10000000+30000]

Fix this by adopting the same fork()-then-wait pattern already used by the
nearby anon_write_child / anon_write_child_shared tests in this file: the
child performs the COW verification and then _exit(0)s so it does not run
the test teardown, while the parent independently verifies COW, waits for
the child, and only then frees the buffer.

Link: https://lore.kernel.org/20260611034102.1030738-4-aboorvad@linux.ibm.com
Fixes: b659baea75469 ("mm: selftests for exclusive device memory")
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
Cc: Sayali Patil <sayalip@linux.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/hmm-tests.c | 31 +++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index 912fecb59a92cd..722beaa6da1b9d 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -1896,6 +1896,8 @@ TEST_F(hmm, exclusive_cow)
 	unsigned long i;
 	int *ptr;
 	int ret;
+	pid_t pid;
+	int status;
 
 	npages = ALIGN(HMM_BUFFER_SIZE, self->page_size) >> self->page_shift;
 	ASSERT_NE(npages, 0);
@@ -1924,14 +1926,37 @@ TEST_F(hmm, exclusive_cow)
 	ASSERT_EQ(ret, 0);
 	ASSERT_EQ(buffer->cpages, npages);
 
-	fork();
+	pid = fork();
+	if (pid == -1)
+		ASSERT_EQ(pid, 0);
 
-	/* Fault pages back to system memory and check them. */
+	if (pid == 0) {
+		/*
+		 * Child verifies COW independently, then _exit(0)s so it does
+		 * not run the test teardown.  A failed ASSERT_* here makes the
+		 * harness abort() the child, so the parent sees
+		 * !WIFEXITED(status) below and fails in turn.
+		 */
+		for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+			ASSERT_EQ(ptr[i]++, i);
+
+		for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+			ASSERT_EQ(ptr[i], i + 1);
+
+		_exit(0);
+	}
+
+	/* Parent: also increment to verify COW works for both processes. */
 	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
 		ASSERT_EQ(ptr[i]++, i);
 
 	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
-		ASSERT_EQ(ptr[i], i+1);
+		ASSERT_EQ(ptr[i], i + 1);
+
+	/* Parent: wait for child and then free the buffer. */
+	ASSERT_EQ(waitpid(pid, &status, 0), pid);
+	ASSERT_TRUE(WIFEXITED(status));
+	ASSERT_EQ(WEXITSTATUS(status), 0);
 
 	hmm_buffer_free(buffer);
 }
-- 
2.53.0



