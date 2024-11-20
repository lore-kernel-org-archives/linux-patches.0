Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39F81AB539;
	Wed, 20 Nov 2024 12:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107570; cv=none; b=ZYIEWf4xSQid3meTtso86M1hOHwmcF1BRzYfb72tPp+fNBAHFWRzup6nW9kZu9gxlqboVPc4aAmLPEEdHWjmO+cdLYa3JrJkhqaZOBOC9H41XH+gBEiWXQ9gPSncbagDDjQPchAUMjivITFaYM3s6BUaW5nqmkOCGoGOW0gh+oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107570; c=relaxed/simple;
	bh=V1c6JubxB/wcbIe5pmyb/SF/rQuuhCnVQWhwzrflgNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V4gY2AdjX8zsmvY1MNAVjqaaWnErHGpdyf0DCswO5Q5nMiWw9jkv9UwARcFiDTwQ/kcPMtdjCScoQeuuKb+yBPtOZUDz72KUI9+9KC3EOC9wMuhbl82HFgA503XSCV8ytFj8knLQxSxRzSV4u020EmV7EccmAxMgnHBwoN8rJQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KVg2g7dz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KVg2g7dz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C165EC4CED2;
	Wed, 20 Nov 2024 12:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107569;
	bh=V1c6JubxB/wcbIe5pmyb/SF/rQuuhCnVQWhwzrflgNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KVg2g7dzN7EJ7qxiiARsgdMCyCV3Kg4tMnwMsghBJ4+Njh5H1zt2okB+1YQe2ZHju
	 atu4IB3XZObYukRqmi3ekbaHRd2Etpqn4iqvmHNtGgTjCznqP1Ltlv8JyGr3VFlFTo
	 O7lMkHX6B7+duR2Rdqlxh6NGpsp1zHBjyKmJb6lA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donet Tom <donettom@linux.ibm.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 075/107] selftests: hugetlb_dio: fixup check for initial conditions to skip in the start
Date: Wed, 20 Nov 2024 13:56:50 +0100
Message-ID: <20241120125631.371988303@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

From: Donet Tom <donettom@linux.ibm.com>

commit fae1980347bfd23325099b69db6638b94149a94c upstream.

This test verifies that a hugepage, used as a user buffer for DIO
operations, is correctly freed upon unmapping.  To test this, we read the
count of free hugepages before and after the mmap, DIO, and munmap
operations, then check if the free hugepage count is the same.

Reading free hugepages before the test was removed by commit 0268d4579901
('selftests: hugetlb_dio: check for initial conditions to skip at the
start'), causing the test to always fail.

This patch adds back reading the free hugepages before starting the test.
With this patch, the tests are now passing.

Test results without this patch:

./tools/testing/selftests/mm/hugetlb_dio
TAP version 13
1..4
 # No. Free pages before allocation : 0
 # No. Free pages after munmap : 100
not ok 1 : Huge pages not freed!
 # No. Free pages before allocation : 0
 # No. Free pages after munmap : 100
not ok 2 : Huge pages not freed!
 # No. Free pages before allocation : 0
 # No. Free pages after munmap : 100
not ok 3 : Huge pages not freed!
 # No. Free pages before allocation : 0
 # No. Free pages after munmap : 100
not ok 4 : Huge pages not freed!
 # Totals: pass:0 fail:4 xfail:0 xpass:0 skip:0 error:0

Test results with this patch:

/tools/testing/selftests/mm/hugetlb_dio
TAP version 13
1..4
# No. Free pages before allocation : 100
# No. Free pages after munmap : 100
ok 1 : Huge pages freed successfully !
# No. Free pages before allocation : 100
# No. Free pages after munmap : 100
ok 2 : Huge pages freed successfully !
# No. Free pages before allocation : 100
# No. Free pages after munmap : 100
ok 3 : Huge pages freed successfully !
# No. Free pages before allocation : 100
# No. Free pages after munmap : 100
ok 4 : Huge pages freed successfully !

# Totals: pass:4 fail:0 xfail:0 xpass:0 skip:0 error:0

Link: https://lkml.kernel.org/r/20241110064903.23626-1-donettom@linux.ibm.com
Fixes: 0268d4579901 ("selftests: hugetlb_dio: check for initial conditions to skip in the start")
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/hugetlb_dio.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/mm/hugetlb_dio.c b/tools/testing/selftests/mm/hugetlb_dio.c
index 60001c142ce9..432d5af15e66 100644
--- a/tools/testing/selftests/mm/hugetlb_dio.c
+++ b/tools/testing/selftests/mm/hugetlb_dio.c
@@ -44,6 +44,13 @@ void run_dio_using_hugetlb(unsigned int start_off, unsigned int end_off)
 	if (fd < 0)
 		ksft_exit_fail_perror("Error opening file\n");
 
+	/* Get the free huge pages before allocation */
+	free_hpage_b = get_free_hugepages();
+	if (free_hpage_b == 0) {
+		close(fd);
+		ksft_exit_skip("No free hugepage, exiting!\n");
+	}
+
 	/* Allocate a hugetlb page */
 	orig_buffer = mmap(NULL, h_pagesize, mmap_prot, mmap_flags, -1, 0);
 	if (orig_buffer == MAP_FAILED) {
-- 
2.47.0



