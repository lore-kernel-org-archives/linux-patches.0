Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4994441167E;
	Tue, 21 Jul 2026 19:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660925; cv=none; b=nhSGX1/Is8Bcvd+Xb73hIfxU1O6+p59EmQeFB5lFuosk714migBZcmUuJU9v4yfryFqv/Il2o5FfcZURhVsNrAFZ52DUBQdArBj4SibWLeSFjs//t5I3OHeLzjA0ns/JNtJpsdtvxW4FSOSddJr2FdqGV1FOb2ELkQn3GFkEt2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660925; c=relaxed/simple;
	bh=41cRUYSMHhPdgxjHyjy51c3c6/HZznj/Iu+fLMYEVhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=byVDTjRN7Wrrq00Sao7bVoE2exQD2VvFxnQ6sP3Lom+Dk18ZQQrpe0zZGWSl8wh6MQwvtn2ak3XnojG7K204+3rc5PQ2kbLS32b2vmLf/0OU0cqWMISvlZjcrdwSAGtDe87qZ6SKn5Nsj9INoFSnbqNoqf85s7ddWDqBg4dFM1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SDCQ6feI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SDCQ6feI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DEB81F000E9;
	Tue, 21 Jul 2026 19:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660924;
	bh=7e0uusHjtNb0VXghc9z66g7RI4XKGNrf6heRtH99CuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SDCQ6feIwFBNHj1tebcrN1tqt3EaTpPUkLyN33G8qt26NXrYHweTEjrzWcON8WdFB
	 a/JSRuaOsLg0RJIH4XPZ93n9EmvPh9uu/1Iygq4u6cYbagHz7XmNEZsGGFm5UcDEGA
	 yK4mqq+APp6k6IkIz9ZERxKVMvBlHqj9e6FWh0mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sayali Patil <sayalip@linux.ibm.com>,
	Zi Yan <ziy@nvidia.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Michal Hocko <mhocko@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1165/2077] selftests/mm: free dynamically allocated PMD-sized buffers in split_huge_page_test
Date: Tue, 21 Jul 2026 17:13:58 +0200
Message-ID: <20260721152620.301728994@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sayali Patil <sayalip@linux.ibm.com>

[ Upstream commit e5d3e1422e92d54e28e81fad8bfc7c1ecb41a353 ]

Dynamically allocated buffers of PMD size for file-backed THP operations
(file_buf1 and file_buf2) were not freed on the success path and some
failure paths.  Since the function is called repeatedly in a loop for each
split order, this can cause significant memory leaks.

On architectures with large PMD sizes, repeated leaks could exhaust system
memory and trigger the OOM killer during test execution.

Ensure all allocated buffers are freed to maintain stable repeated test
runs.

Link: https://lore.kernel.org/060c673b376bbeeed2b1fb1d48a825e846654191.1779296493.git.sayalip@linux.ibm.com
Fixes: 035a112e5fd5 ("selftests/mm: make file-backed THP split work by writing PMD size data")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/mm/split_huge_page_test.c       | 22 ++++++++++++++-----
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 02938f38b880c6..ee256afecd8fe9 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -473,12 +473,15 @@ static void split_file_backed_thp(int order)
 	unsigned long size = 2 * pmd_pagesize;
 	char opts[64];
 	ssize_t num_written, num_read;
-	char *file_buf1, *file_buf2;
+	char *file_buf1 = NULL, *file_buf2 = NULL;
 	uint64_t pgoff_start = 0, pgoff_end = 1024;
 	int i;
 
 	ksft_print_msg("Please enable pr_debug in split_huge_pages_in_file() for more info.\n");
 
+	if (!tmpfs_loc)
+		ksft_exit_fail_msg("mkdtemp failed\n");
+
 	file_buf1 = (char *)malloc(pmd_pagesize);
 	file_buf2 = (char *)malloc(pmd_pagesize);
 
@@ -494,8 +497,10 @@ static void split_file_backed_thp(int order)
 	snprintf(opts, sizeof(opts), "huge=always,size=%lu", size);
 	status = mount("tmpfs", tmpfs_loc, "tmpfs", 0, opts);
 
-	if (status)
-		ksft_exit_fail_msg("Unable to create a tmpfs for testing\n");
+	if (status) {
+		ksft_print_msg("Unable to create a tmpfs for testing\n");
+		goto out;
+	}
 
 	status = snprintf(testfile, INPUT_MAX, "%s/thp_file", tmpfs_loc);
 	if (status >= INPUT_MAX) {
@@ -547,10 +552,13 @@ static void split_file_backed_thp(int order)
 
 	status = umount(tmpfs_loc);
 	if (status) {
-		rmdir(tmpfs_loc);
-		ksft_exit_fail_msg("Unable to umount %s\n", tmpfs_loc);
+		ksft_print_msg("Unable to umount %s\n", tmpfs_loc);
+		goto out;
 	}
 
+	free(file_buf1);
+	free(file_buf2);
+
 	status = rmdir(tmpfs_loc);
 	if (status)
 		ksft_exit_fail_msg("cannot remove tmp dir: %s\n", strerror(errno));
@@ -563,8 +571,10 @@ static void split_file_backed_thp(int order)
 	close(fd);
 cleanup:
 	umount(tmpfs_loc);
-	rmdir(tmpfs_loc);
 out:
+	free(file_buf1);
+	free(file_buf2);
+	rmdir(tmpfs_loc);
 	ksft_exit_fail_msg("Error occurred\n");
 }
 
-- 
2.53.0



