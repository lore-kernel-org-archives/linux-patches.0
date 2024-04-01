Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F3F1CA8F;
	Mon,  1 Apr 2024 16:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987385; cv=none; b=FU6SHtzW6BEiCuPtVtXvS1cseA8AsA04c4W3pjQHw0RYY8n+G5wQTf/5HJOYZL4e+xTlVoCrcM2l+X+79iZk7IqWh8uLOOo76YKBjBbx9gqvoqDH3j8eOXabtZrqguCabDZKnDjUQYw8pV6vQNrksGEC8vget7Bp2BK7/tLMA14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987385; c=relaxed/simple;
	bh=Cmv5D3z5UuaIWaS3+SO4jMDAMaqQclVZxEqhjEBqK9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qh43+bMmc9sYTlTlirAlcljUHXzsHm4EnnfvzjexqaPrgOMZSg+I5YAbRSfrX5K3VXd6tkt5Hv375RAnQQ9j9VUR5A63BkQBfVLxBt0G6Md+Hp0lqAbxH6RaUEHSs985OGBvdVEu706SjuJ0sYAZosd/U2gx+L1/+MQXfVfSRdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VVfCaVcf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVfCaVcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91561C43390;
	Mon,  1 Apr 2024 16:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987385;
	bh=Cmv5D3z5UuaIWaS3+SO4jMDAMaqQclVZxEqhjEBqK9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VVfCaVcfXMubRtmSGE/4e5o7nrGnAVxzV+SbRnsZVW0GVd/Ex8fiwUmOOUSY9v4fc
	 3yVRsY9I8DMYh6XtYvaYFiI1uaNXVQ05oP7PshxDtBCIkP9Vwa0vhVhHgEAaumMnhA
	 SUjfE0SYNbSFjZKY/y9tBsBmrXo8tU/c5fNR00os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Chikunov <vt@altlinux.org>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Yang Shi <shy828301@gmail.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Nadav Amit <nadav.amit@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 272/399] selftests/mm: Fix build with _FORTIFY_SOURCE
Date: Mon,  1 Apr 2024 17:43:58 +0200
Message-ID: <20240401152557.303087004@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Chikunov <vt@altlinux.org>

[ Upstream commit 8b65ef5ad4862904e476a8f3d4e4418c950ddb90 ]

Add missing flags argument to open(2) call with O_CREAT.

Some tests fail to compile if _FORTIFY_SOURCE is defined (to any valid
value) (together with -O), resulting in similar error messages such as:

  In file included from /usr/include/fcntl.h:342,
                   from gup_test.c:1:
  In function 'open',
      inlined from 'main' at gup_test.c:206:10:
  /usr/include/bits/fcntl2.h:50:11: error: call to '__open_missing_mode' declared with attribute error: open with O_CREAT or O_TMPFILE in second argument needs 3 arguments
     50 |           __open_missing_mode ();
        |           ^~~~~~~~~~~~~~~~~~~~~~

_FORTIFY_SOURCE is enabled by default in some distributions, so the
tests are not built by default and are skipped.

open(2) man-page warns about missing flags argument: "if it is not
supplied, some arbitrary bytes from the stack will be applied as the
file mode."

Link: https://lkml.kernel.org/r/20240318023445.3192922-1-vt@altlinux.org
Fixes: aeb85ed4f41a ("tools/testing/selftests/vm/gup_benchmark.c: allow user specified file")
Fixes: fbe37501b252 ("mm: huge_memory: debugfs for file-backed THP split")
Fixes: c942f5bd17b3 ("selftests: soft-dirty: add test for mprotect")
Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/gup_test.c             | 2 +-
 tools/testing/selftests/mm/soft-dirty.c           | 2 +-
 tools/testing/selftests/mm/split_huge_page_test.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/gup_test.c b/tools/testing/selftests/mm/gup_test.c
index cbe99594d319b..18a49c70d4c63 100644
--- a/tools/testing/selftests/mm/gup_test.c
+++ b/tools/testing/selftests/mm/gup_test.c
@@ -203,7 +203,7 @@ int main(int argc, char **argv)
 	ksft_print_header();
 	ksft_set_plan(nthreads);
 
-	filed = open(file, O_RDWR|O_CREAT);
+	filed = open(file, O_RDWR|O_CREAT, 0664);
 	if (filed < 0)
 		ksft_exit_fail_msg("Unable to open %s: %s\n", file, strerror(errno));
 
diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
index cc5f144430d4d..7dbfa53d93a05 100644
--- a/tools/testing/selftests/mm/soft-dirty.c
+++ b/tools/testing/selftests/mm/soft-dirty.c
@@ -137,7 +137,7 @@ static void test_mprotect(int pagemap_fd, int pagesize, bool anon)
 		if (!map)
 			ksft_exit_fail_msg("anon mmap failed\n");
 	} else {
-		test_fd = open(fname, O_RDWR | O_CREAT);
+		test_fd = open(fname, O_RDWR | O_CREAT, 0664);
 		if (test_fd < 0) {
 			ksft_test_result_skip("Test %s open() file failed\n", __func__);
 			return;
diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 0e74635c8c3d9..dff3be23488b4 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -253,7 +253,7 @@ void split_file_backed_thp(void)
 		goto cleanup;
 	}
 
-	fd = open(testfile, O_CREAT|O_WRONLY);
+	fd = open(testfile, O_CREAT|O_WRONLY, 0664);
 	if (fd == -1) {
 		perror("Cannot open testing file\n");
 		goto cleanup;
-- 
2.43.0



