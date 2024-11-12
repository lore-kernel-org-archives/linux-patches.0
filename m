Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC13C21B451;
	Tue, 12 Nov 2024 10:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408467; cv=none; b=L1XZhZkCPwVRYc6GVk4YS1R4ofN7fPFBSf2kq8GSyzq9qHGDJLwIOxdKheBzgYigACwbzoxEhFwjiMoRVWRC6o9+wbI4HkDOuBsxxGSFfq98g2kWS1qqTH950OR/p7JOEEnSafSqqCprOalSjtSyQse/TTLJHzCGnFuyeuyV5qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408467; c=relaxed/simple;
	bh=S39WOH8cc6W3hlYOuGbudMYwoVXjWuk/hcdqOnj6ims=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dcFcKvWcs3AfX3Otm0JVHE4pA/08kSPgnhFf8hZZ5GIdrFwJMg1aLA5ptcUXyz8VTZtpnJ4ctoRuAEUrkNNjV+7LmkEGTYuJV+BaT5/IvuZCFcvnAvaFuFCvRw51R0IwqPxvBjZiBkALQ9oAXxdjCms4AC1clpINBa222hwfSSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YXeO7Wol; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YXeO7Wol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27AF8C4CECD;
	Tue, 12 Nov 2024 10:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408467;
	bh=S39WOH8cc6W3hlYOuGbudMYwoVXjWuk/hcdqOnj6ims=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YXeO7WolXQYy0bSqb0uAG1WTqJ5s8zsy7HjzPitKcIhuDiNA1uhZaWzT/e175VV+f
	 idoSWEdsEzf3itB7JFq9iHNALFPgZdnzuwb6RcGQ1vV5QKHFeYf/qZUu7xTn0JYutR
	 EwjAQLdNrZm4+rekSYxwk7Z1HNMy114hI4ZyDMGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Shuah Khan <shuah@kernel.org>,
	Donet Tom <donettom@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 172/184] selftests: hugetlb_dio: check for initial conditions to skip in the start
Date: Tue, 12 Nov 2024 11:22:10 +0100
Message-ID: <20241112101907.466930520@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Usama Anjum <usama.anjum@collabora.com>

commit 0268d4579901821ff17259213c2d8c9679995d48 upstream.

The test should be skipped if initial conditions aren't fulfilled in the
start instead of failing and outputting non-compliant TAP logs.  This kind
of failure pollutes the results.  The initial conditions are:

- The test should only execute if /tmp file can be allocated.
- The test should only execute if huge pages are free.

Before:
TAP version 13
1..4
Bail out! Error opening file
: Read-only file system (30)
 # Planned tests != run tests (4 != 0)
 # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0

After:
TAP version 13
1..0 # SKIP Unable to allocate file: Read-only file system

Link: https://lkml.kernel.org/r/20241101141557.3159432-1-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Fixes: 3a103b5315b7 ("selftest: mm: Test if hugepage does not get leaked during __bio_release_pages()")
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/hugetlb_dio.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_dio.c b/tools/testing/selftests/mm/hugetlb_dio.c
index f9ac20c657ec..60001c142ce9 100644
--- a/tools/testing/selftests/mm/hugetlb_dio.c
+++ b/tools/testing/selftests/mm/hugetlb_dio.c
@@ -44,13 +44,6 @@ void run_dio_using_hugetlb(unsigned int start_off, unsigned int end_off)
 	if (fd < 0)
 		ksft_exit_fail_perror("Error opening file\n");
 
-	/* Get the free huge pages before allocation */
-	free_hpage_b = get_free_hugepages();
-	if (free_hpage_b == 0) {
-		close(fd);
-		ksft_exit_skip("No free hugepage, exiting!\n");
-	}
-
 	/* Allocate a hugetlb page */
 	orig_buffer = mmap(NULL, h_pagesize, mmap_prot, mmap_flags, -1, 0);
 	if (orig_buffer == MAP_FAILED) {
@@ -94,8 +87,20 @@ void run_dio_using_hugetlb(unsigned int start_off, unsigned int end_off)
 int main(void)
 {
 	size_t pagesize = 0;
+	int fd;
 
 	ksft_print_header();
+
+	/* Open the file to DIO */
+	fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
+	if (fd < 0)
+		ksft_exit_skip("Unable to allocate file: %s\n", strerror(errno));
+	close(fd);
+
+	/* Check if huge pages are free */
+	if (!get_free_hugepages())
+		ksft_exit_skip("No free hugepage, exiting\n");
+
 	ksft_set_plan(4);
 
 	/* Get base page size */
-- 
2.47.0



