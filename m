Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA55DDA9;
	Tue, 20 May 2025 13:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749548; cv=none; b=k69LJlo7xwStg1pVWDs+8tlrkWB/Ea69ewOWx0+32iPUrbKfXxZKMij/CUkRlFPvZ1DjYfbcbxzgfOeHuFkJAs8Hq3JCi/X6tvKRnkZlh20OfxUonlZUAIeR6UOrwk5fYFF1+5KwfSXhsbGH62qLVXH7NPw5Ya5L8lIM1JU7dw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749548; c=relaxed/simple;
	bh=B3N/qrFleAVWvlD0u8fYtgeXPOXLwvSaoElmElQwPpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ch6MEzRSyETXO6HnzhzwAZyMGJWsL9Sp60IREELEh5RMeyWnOFp7r02ctbdGABgye6ofirJlMz61pIDhJKxH0gCmzFfs0Pb12rb4qpV+aneFFIS0P/k1e1fxV2Ds3MI2fNef7n81EeEuQhS2hOx/3X420Jf5t+semWm5jBngRJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n7VvFKIB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n7VvFKIB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96EF9C4CEE9;
	Tue, 20 May 2025 13:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749548;
	bh=B3N/qrFleAVWvlD0u8fYtgeXPOXLwvSaoElmElQwPpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n7VvFKIB02/SJvvU6lCm5ETgoApGei+omBGMXKpOLhD9jl6f9Vm1NVz2wRktskArx
	 M8xZnhN0/Bev+Ye4eZHS2inCuZkM9S2aCba/a/3IPQKH/4Te2f9/tgoGlr3onIWFLC
	 edAhBNuzkOtNWlyDtH1nXdsCwde3fXlmpM4dnyRI=
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
Subject: [PATCH 6.1 79/97] selftests/mm: compaction_test: support platform with huge mount of memory
Date: Tue, 20 May 2025 15:50:44 +0200
Message-ID: <20250520125803.737204953@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -119,11 +121,18 @@ int check_compaction(unsigned long mem_f
 
 	lseek(fd, 0, SEEK_SET);
 
-	/* Request a large number of huge pages. The Kernel will allocate
-	   as much as it can */
-	if (write(fd, "100000", (6*sizeof(char))) != (6*sizeof(char))) {
-		ksft_print_msg("Failed to write 100000 to /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
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
+		ksft_print_msg("Failed to write %lu to /proc/sys/vm/nr_hugepages: %s\n",
+			       nr_hugepages_ul, strerror(errno));
 		goto close_fd;
 	}
 


