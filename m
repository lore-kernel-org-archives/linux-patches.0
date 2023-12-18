Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBB93D556;
	Mon, 18 Dec 2023 14:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="djSNAdmL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41FEC433C9;
	Mon, 18 Dec 2023 14:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908292;
	bh=Ctklw3eBTZXY4VBll/7KfVBROvqk9GZZycxptTbsP9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=djSNAdmLlGY3Em+vTbdZBNcJ9UPCLIx1wkem+joezQuOKMYopT+6zUu7dKHzKyaPE
	 KhAn69xMu8Bjx7t4oEqEaflrrl69cn0mtVeC9ElCW7WcOFr9shIqi7oVXTnX9onz4p
	 Oy8ySqUUYCaEiyrIMr24TTtmeeBXiEmBN4b/+zuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/166] selftests/mm: cow: print ksft header before printing anything else
Date: Mon, 18 Dec 2023 14:50:50 +0100
Message-ID: <20231218135108.761544446@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

[ Upstream commit a6fcd57cf2df409d35e9225b8dbad6f937b28df0 ]

Doing a ksft_print_msg() before the ksft_print_header() seems to confuse
the ksft framework in a strange way: running the test on the cmdline
results in the expected output.

But piping the output somewhere else, results in some odd output,
whereby we repeatedly get the same info printed:
	# [INFO] detected THP size: 2048 KiB
	# [INFO] detected hugetlb page size: 2048 KiB
	# [INFO] detected hugetlb page size: 1048576 KiB
	# [INFO] huge zeropage is enabled
	TAP version 13
	1..190
	# [INFO] Anonymous memory tests in private mappings
	# [RUN] Basic COW after fork() ... with base page
	# [INFO] detected THP size: 2048 KiB
	# [INFO] detected hugetlb page size: 2048 KiB
	# [INFO] detected hugetlb page size: 1048576 KiB
	# [INFO] huge zeropage is enabled
	TAP version 13
	1..190
	# [INFO] Anonymous memory tests in private mappings
	# [RUN] Basic COW after fork() ... with base page
	ok 1 No leak from parent into child
	# [RUN] Basic COW after fork() ... with swapped out base page
	# [INFO] detected THP size: 2048 KiB
	# [INFO] detected hugetlb page size: 2048 KiB
	# [INFO] detected hugetlb page size: 1048576 KiB
	# [INFO] huge zeropage is enabled

Doing the ksft_print_header() first seems to resolve that and gives us
the output we expect:
	TAP version 13
	# [INFO] detected THP size: 2048 KiB
	# [INFO] detected hugetlb page size: 2048 KiB
	# [INFO] detected hugetlb page size: 1048576 KiB
	# [INFO] huge zeropage is enabled
	1..190
	# [INFO] Anonymous memory tests in private mappings
	# [RUN] Basic COW after fork() ... with base page
	ok 1 No leak from parent into child
	# [RUN] Basic COW after fork() ... with swapped out base page
	ok 2 No leak from parent into child
	# [RUN] Basic COW after fork() ... with THP
	ok 3 No leak from parent into child
	# [RUN] Basic COW after fork() ... with swapped-out THP
	ok 4 No leak from parent into child
	# [RUN] Basic COW after fork() ... with PTE-mapped THP
	ok 5 No leak from parent into child

Link: https://lkml.kernel.org/r/20231206103558.38040-1-david@redhat.com
Fixes: f4b5fd6946e2 ("selftests/vm: anon_cow: THP tests")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Nico Pache <npache@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/cow.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index 7324ce5363c0c..6f2f839904416 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -1680,6 +1680,8 @@ int main(int argc, char **argv)
 {
 	int err;
 
+	ksft_print_header();
+
 	pagesize = getpagesize();
 	thpsize = read_pmd_pagesize();
 	if (thpsize)
@@ -1689,7 +1691,6 @@ int main(int argc, char **argv)
 						    ARRAY_SIZE(hugetlbsizes));
 	detect_huge_zeropage();
 
-	ksft_print_header();
 	ksft_set_plan(ARRAY_SIZE(anon_test_cases) * tests_per_anon_test_case() +
 		      ARRAY_SIZE(anon_thp_test_cases) * tests_per_anon_thp_test_case() +
 		      ARRAY_SIZE(non_anon_test_cases) * tests_per_non_anon_test_case());
-- 
2.43.0



