Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA0433A9FC;
	Tue, 21 Jul 2026 20:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666613; cv=none; b=uKMry9nczSwdUULq3uQXluBu1I/YQd08Oik0Ac33qGq8UzQA+TRIHf9bDviTQsrnBRSlzUJzXjcMql9O4EjVGJI+l++aohMyLn8RR94uCkveuxeF3ogZQVSp+Kj9GZRIcCXydeTBTXh3n89nuMGnXSwnOwjZR3YCys8sq+j54NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666613; c=relaxed/simple;
	bh=CLSjXUA/2jzVOxDmZWXLU6UGZ/D7CkBbmXbkw4GqqNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q20TplAZFTZ3C+1BRR9ptN5HE7r5f2V8JQBgiKvHSsRhuw1q3aEpTmElbqQfd06Y7bnVuQUSeJHNFuUzcT/UWGYalb3KHqnv3k8NVfsHl4UwvpncI1ULfre+dUmrp3gq1nXl0Kul9k0BfHlZnoCXV0c/uJA6SLYhqqFUsiUIPgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DJFiaGVT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DJFiaGVT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76C81F000E9;
	Tue, 21 Jul 2026 20:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666612;
	bh=uRirSnUqzDWZCnSyW8IK+tLoyTY7iWvDFO+SZW5gzRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DJFiaGVTXTdo+uLsBlXM5WxeupXgpOhcuy5KeQyvurkmONn+DSF1Ac/a+8PvPM+xp
	 BOpv3pTu7Xm1pzBIFxBNEgpJ+K0fExaoQrNyv1d24DPmC2KP3ntIkoIIYDq6C5eLd6
	 ro+/xRTmCIu42LdjAPp9oWkY6b1bsfBncUh7sAnE=
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
Subject: [PATCH 6.6 0750/1266] selftests/mm: fix exclusive_cow test fork() handling
Date: Tue, 21 Jul 2026 17:19:47 +0200
Message-ID: <20260721152458.653448086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 243dd421ed3842..5286e400ce8bed 100644
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



