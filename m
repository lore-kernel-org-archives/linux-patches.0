Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC0114386B;
	Thu, 13 Jun 2024 11:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279516; cv=none; b=oKou4qqCrEf4sNahXa4elXX4Tl428XNqhv5GGNUCCniiOdVBFtiqQVPvlMKEXSvNQ+cImwHBu3c4a0Q4W23CnizbzmZbm5FNmBj4maIH6gPdGiVAkxg3ZNq3g9AKGHSV5lo9IsJou7rJSg+05y2v7kpdlMGAClcnrMfc13rl3Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279516; c=relaxed/simple;
	bh=s4Q0crqw4gNY41OZAFYxthUE1HV0VMn28+pmFloQ8Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GiL6o69vlHT7bspi6zdzcBmD5nzseTTXnacnPC0oAA4YruMiQwOvNTphHz4rFrU/TytHv+p0iCnc4nzh55sTFuKl9djJYOkbmlcmaXmPbagCAp5s9OSZE/CblxW2tXD+2fkWvvfvZbEkt7uOJzcVUkjOUSCfs+2qUnUThscUjo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iuM8QhV4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iuM8QhV4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82A7C2BBFC;
	Thu, 13 Jun 2024 11:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279516;
	bh=s4Q0crqw4gNY41OZAFYxthUE1HV0VMn28+pmFloQ8Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iuM8QhV4bLNUAIS4A9mW2Sql3uoQMGVpru44IX6FpnNaaCi2U4oe/Rm8NdRlxgasC
	 HpOajQw4MW+RTZDfWb9G6r3i6lxg4x92rHA26GynNSmU4gExo0JHjm6Q5Zg5oWF6bq
	 joa3oY2HG/B+DlYBt1dk250rAVWh7aObI+M5tzO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dev Jain <dev.jain@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Sri Jayaramappa <sjayaram@akamai.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.9 103/157] selftests/mm: compaction_test: fix bogus test success on Aarch64
Date: Thu, 13 Jun 2024 13:33:48 +0200
Message-ID: <20240613113231.404948601@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dev Jain <dev.jain@arm.com>

commit d4202e66a4b1fe6968f17f9f09bbc30d08f028a1 upstream.

Patch series "Fixes for compaction_test", v2.

The compaction_test memory selftest introduces fragmentation in memory
and then tries to allocate as many hugepages as possible. This series
addresses some problems.

On Aarch64, if nr_hugepages == 0, then the test trivially succeeds since
compaction_index becomes 0, which is less than 3, due to no division by
zero exception being raised. We fix that by checking for division by
zero.

Secondly, correctly set the number of hugepages to zero before trying
to set a large number of them.

Now, consider a situation in which, at the start of the test, a non-zero
number of hugepages have been already set (while running the entire
selftests/mm suite, or manually by the admin). The test operates on 80%
of memory to avoid OOM-killer invocation, and because some memory is
already blocked by hugepages, it would increase the chance of OOM-killing.
Also, since mem_free used in check_compaction() is the value before we
set nr_hugepages to zero, the chance that the compaction_index will
be small is very high if the preset nr_hugepages was high, leading to a
bogus test success.


This patch (of 3):

Currently, if at runtime we are not able to allocate a huge page, the test
will trivially pass on Aarch64 due to no exception being raised on
division by zero while computing compaction_index.  Fix that by checking
for nr_hugepages == 0.  Anyways, in general, avoid a division by zero by
exiting the program beforehand.  While at it, fix a typo, and handle the
case where the number of hugepages may overflow an integer.

Link: https://lkml.kernel.org/r/20240521074358.675031-1-dev.jain@arm.com
Link: https://lkml.kernel.org/r/20240521074358.675031-2-dev.jain@arm.com
Fixes: bd67d5c15cc1 ("Test compaction of mlocked memory")
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Sri Jayaramappa <sjayaram@akamai.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/compaction_test.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/mm/compaction_test.c
+++ b/tools/testing/selftests/mm/compaction_test.c
@@ -82,12 +82,13 @@ int prereq(void)
 	return -1;
 }
 
-int check_compaction(unsigned long mem_free, unsigned int hugepage_size)
+int check_compaction(unsigned long mem_free, unsigned long hugepage_size)
 {
+	unsigned long nr_hugepages_ul;
 	int fd, ret = -1;
 	int compaction_index = 0;
-	char initial_nr_hugepages[10] = {0};
-	char nr_hugepages[10] = {0};
+	char initial_nr_hugepages[20] = {0};
+	char nr_hugepages[20] = {0};
 
 	/* We want to test with 80% of available memory. Else, OOM killer comes
 	   in to play */
@@ -136,7 +137,12 @@ int check_compaction(unsigned long mem_f
 
 	/* We should have been able to request at least 1/3 rd of the memory in
 	   huge pages */
-	compaction_index = mem_free/(atoi(nr_hugepages) * hugepage_size);
+	nr_hugepages_ul = strtoul(nr_hugepages, NULL, 10);
+	if (!nr_hugepages_ul) {
+		ksft_print_msg("ERROR: No memory is available as huge pages\n");
+		goto close_fd;
+	}
+	compaction_index = mem_free/(nr_hugepages_ul * hugepage_size);
 
 	lseek(fd, 0, SEEK_SET);
 
@@ -147,11 +153,11 @@ int check_compaction(unsigned long mem_f
 		goto close_fd;
 	}
 
-	ksft_print_msg("Number of huge pages allocated = %d\n",
-		       atoi(nr_hugepages));
+	ksft_print_msg("Number of huge pages allocated = %lu\n",
+		       nr_hugepages_ul);
 
 	if (compaction_index > 3) {
-		ksft_print_msg("ERROR: Less that 1/%d of memory is available\n"
+		ksft_print_msg("ERROR: Less than 1/%d of memory is available\n"
 			       "as huge pages\n", compaction_index);
 		goto close_fd;
 	}


