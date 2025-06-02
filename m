Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF4819EEBD;
	Mon,  2 Jun 2025 14:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875359; cv=none; b=g2nZsjPSiArZzRY/d49EZrCTs+tGVuixHfABF/2x1VKS9o+QY2CsAKoE/mOa8ka38YL5NW9jUhnUuY8dA4eY61ofHlUl749CudFD3Zs8IlzYQSDF8CnVmEMS+QdZ4b7I0zsxgJbOWtlNFoHy8Xv54y+plAiPfCy9/fa0752JI84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875359; c=relaxed/simple;
	bh=ZU9BbzxoHvY8IX8vk6Gk9I8FNr7uOuKTNPv22mnCSNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rX14FTmB4cXWT259r6ot0FmadMlDSEwOutmu7qgutWKt92n46tUwhBDydR06Z2a04rK+USZW/4DyfjApv1BbIW9wa8BJHa6y6SleBuwkduSE46FMBUmD5VaR2/fjTsfAFXMeXAtU3DJA1OFt4vj9Ig4yK7LPRZfoNUuADdiAd6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tqPqw4lj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tqPqw4lj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0513AC4CEEB;
	Mon,  2 Jun 2025 14:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875358;
	bh=ZU9BbzxoHvY8IX8vk6Gk9I8FNr7uOuKTNPv22mnCSNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tqPqw4ljHp1WfzSK0+wzaFAno+nzzIzOQtdk1J0g4FB0kAAe7gMtjqqJIlUWWznur
	 k/UF0iu1PbN2ZcET0Jb5L14/AKoqtGJki4u1iTo6xI0vdHdFMbXFVPxDRNxjOPIP3B
	 clBzqbALNjF7tuhPDL5fcM88qROPpzV3wf/yKu5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Dev Jain <dev.jain@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Baolin Wang <baolin.wang@inux.alibaba.com>,
	Shuah Khan <shuah@kernel.org>,
	Sri Jayaramappa <sjayaram@akamai.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 110/270] selftests/mm: compaction_test: support platform with huge mount of memory
Date: Mon,  2 Jun 2025 15:46:35 +0200
Message-ID: <20250602134311.731423742@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Tang <feng.tang@linux.alibaba.com>

commit ab00ddd802f80e31fc9639c652d736fe3913feae upstream.

When running mm selftest to verify mm patches, 'compaction_test' case
failed on an x86 server with 1TB memory.  And the root cause is that it
has too much free memory than what the test supports.

The test case tries to allocate 100000 huge pages, which is about 200 GB
for that x86 server, and when it succeeds, it expects it's large than 1/3
of 80% of the free memory in system.  This logic only works for platform
with 750 GB ( 200 / (1/3) / 80% ) or less free memory, and may raise false
alarm for others.

Fix it by changing the fixed page number to self-adjustable number
according to the real number of free memory.

Link: https://lkml.kernel.org/r/20250423103645.2758-1-feng.tang@linux.alibaba.com
Fixes: bd67d5c15cc1 ("Test compaction of mlocked memory")
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Acked-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@inux.alibaba.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Sri Jayaramappa <sjayaram@akamai.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/vm/compaction_test.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/vm/compaction_test.c
+++ b/tools/testing/selftests/vm/compaction_test.c
@@ -89,6 +89,8 @@ int check_compaction(unsigned long mem_f
 	int compaction_index = 0;
 	char initial_nr_hugepages[20] = {0};
 	char nr_hugepages[20] = {0};
+	char target_nr_hugepages[24] = {0};
+	int slen;
 
 	/* We want to test with 80% of available memory. Else, OOM killer comes
 	   in to play */
@@ -118,11 +120,18 @@ int check_compaction(unsigned long mem_f
 
 	lseek(fd, 0, SEEK_SET);
 
-	/* Request a large number of huge pages. The Kernel will allocate
-	   as much as it can */
-	if (write(fd, "100000", (6*sizeof(char))) != (6*sizeof(char))) {
-		ksft_test_result_fail("Failed to write 100000 to /proc/sys/vm/nr_hugepages: %s\n",
-				      strerror(errno));
+	/*
+	 * Request huge pages for about half of the free memory. The Kernel
+	 * will allocate as much as it can, and we expect it will get at least 1/3
+	 */
+	nr_hugepages_ul = mem_free / hugepage_size / 2;
+	snprintf(target_nr_hugepages, sizeof(target_nr_hugepages),
+		 "%lu", nr_hugepages_ul);
+
+	slen = strlen(target_nr_hugepages);
+	if (write(fd, target_nr_hugepages, slen) != slen) {
+		ksft_test_result_fail("Failed to write %lu to /proc/sys/vm/nr_hugepages: %s\n",
+			       nr_hugepages_ul, strerror(errno));
 		goto close_fd;
 	}
 


