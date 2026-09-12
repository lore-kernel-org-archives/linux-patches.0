Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35C92F6931;
	Sat, 12 Sep 2026 19:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240658; cv=none; b=kdQH4+H4M6otBw2LHGbdkLmAZpcoN+eRdxCquUjuq2nOVQkmYP7UfxXPWBoxEY5MoaqWuk61Kq81O3+6OtDEJrWC3JOIU3xVMMK/25XB2nswNEEdbGQmyf+ISIeswVom4mAUBlfvKJUlCYwRBD9vw+YUqtk26WhzxriPZvT2ckM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240658; c=relaxed/simple;
	bh=/B3aMW6FGRnw4JbNuBMPlUlGzHVuE/hhhd4wwbFY+v4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GeZ7Tah9v3dcWb4lHcSbadN9S0YKzMWG3lyVjgH/Y2mSXOB/pYprPEJP84f5yedegQT3Fcm6+RY5usuDtNCTVvgjhga2p1C5jYk3QjHLoV/y7IY8NDC3tifkZVBAGhrZ2Kg2u8IESLJjTpzkuA2Qf45vk0ziHpfB9W5DWfRvauE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=en0QqbPE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="en0QqbPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 171981F000FF;
	Sat, 12 Sep 2026 19:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240657;
	bh=CW3vzlki9VrpaKLV836zzry594heEHxw539tS94PSS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=en0QqbPEYd9XWfPTiDTM1WQWkb9AcNXYI07vOld1NeO2I9ZoP2pSz2bjk37kWCtyn
	 IXVjJoDeWYS6w6tBXbXrcE75INRHel0sVnzK08QVOlCPbYnIrh/mlGrz6jQrEEObHU
	 3VPvIo463hMGALqGyeRmix6E8RcWRX8IQ+wSKKkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 914/935] selftests/arm64: Print missing MTE TAP headers
Date: Sat, 12 Sep 2026 09:05:44 +0200
Message-ID: <20260912065547.780462662@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Usama Anjum <usama.anjum@arm.com>

[ Upstream commit 8d2237e9d6902e234bb89aabb9cd6a9e91357223 ]

Most MTE tests set a TAP plan and emit results without first printing
the TAP version header. Direct execution therefore starts with a plan
such as "1..20" instead of "TAP version 13".

The problem is particularly visible in the GCR_EL1 context-switch test.
It prints its plan before forking 1,024 child processes. When stdout is
fully buffered, the plan remains in the stdio buffer. Each child inherits
the pending "1..1" line and flushes its copy from exit(), producing
repeated plan lines.

ksft_print_header() prints the TAP header and enables line buffering.
Call it in every MTE test that is missing it. In the GCR_EL1 test, call
it before the plan so the plan is flushed before the children are
forked. In the remaining tests, call it before setup and prerequisite
checks so early failures and whole-test skips also retain the header.

Fixes: 29f080881601 ("kselftest/arm64: check GCR_EL1 after context switch")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/mte/check_buffer_fill.c     | 2 ++
 tools/testing/selftests/arm64/mte/check_child_memory.c    | 2 ++
 tools/testing/selftests/arm64/mte/check_gcr_el1_cswitch.c | 1 +
 tools/testing/selftests/arm64/mte/check_hugetlb_options.c | 2 ++
 tools/testing/selftests/arm64/mte/check_ksm_options.c     | 2 ++
 tools/testing/selftests/arm64/mte/check_mmap_options.c    | 2 ++
 tools/testing/selftests/arm64/mte/check_tags_inclusion.c  | 2 ++
 tools/testing/selftests/arm64/mte/check_user_mem.c        | 2 ++
 8 files changed, 15 insertions(+)

diff --git a/tools/testing/selftests/arm64/mte/check_buffer_fill.c b/tools/testing/selftests/arm64/mte/check_buffer_fill.c
index 75fc482d63b68..a6b04f06f2e10 100644
--- a/tools/testing/selftests/arm64/mte/check_buffer_fill.c
+++ b/tools/testing/selftests/arm64/mte/check_buffer_fill.c
@@ -406,6 +406,8 @@ int main(int argc, char *argv[])
 	size_t page_size = getpagesize();
 	int item = sizeof(sizes)/sizeof(int);
 
+	ksft_print_header();
+
 	sizes[item - 3] = page_size - 1;
 	sizes[item - 2] = page_size;
 	sizes[item - 1] = page_size + 1;
diff --git a/tools/testing/selftests/arm64/mte/check_child_memory.c b/tools/testing/selftests/arm64/mte/check_child_memory.c
index 43bd94f853ba7..d8be91f0df4a7 100644
--- a/tools/testing/selftests/arm64/mte/check_child_memory.c
+++ b/tools/testing/selftests/arm64/mte/check_child_memory.c
@@ -146,6 +146,8 @@ int main(int argc, char *argv[])
 	int err;
 	int item = sizeof(sizes)/sizeof(int);
 
+	ksft_print_header();
+
 	page_size = getpagesize();
 	if (!page_size) {
 		ksft_print_msg("ERR: Unable to get page size\n");
diff --git a/tools/testing/selftests/arm64/mte/check_gcr_el1_cswitch.c b/tools/testing/selftests/arm64/mte/check_gcr_el1_cswitch.c
index a876db1f096ab..07e70323fbd1e 100644
--- a/tools/testing/selftests/arm64/mte/check_gcr_el1_cswitch.c
+++ b/tools/testing/selftests/arm64/mte/check_gcr_el1_cswitch.c
@@ -142,6 +142,7 @@ int main(int argc, char *argv[])
 	if (err)
 		return err;
 
+	ksft_print_header();
 	ksft_set_plan(1);
 
 	evaluate_test(mte_gcr_fork_test(),
diff --git a/tools/testing/selftests/arm64/mte/check_hugetlb_options.c b/tools/testing/selftests/arm64/mte/check_hugetlb_options.c
index 303260a6dc65b..a8087c9288176 100644
--- a/tools/testing/selftests/arm64/mte/check_hugetlb_options.c
+++ b/tools/testing/selftests/arm64/mte/check_hugetlb_options.c
@@ -228,6 +228,8 @@ int main(int argc, char *argv[])
 {
 	int err;
 
+	ksft_print_header();
+
 	err = mte_default_setup();
 	if (err)
 		return err;
diff --git a/tools/testing/selftests/arm64/mte/check_ksm_options.c b/tools/testing/selftests/arm64/mte/check_ksm_options.c
index 88c74bc46d4fc..b5c0845fdbb35 100644
--- a/tools/testing/selftests/arm64/mte/check_ksm_options.c
+++ b/tools/testing/selftests/arm64/mte/check_ksm_options.c
@@ -132,6 +132,8 @@ int main(int argc, char *argv[])
 {
 	int err;
 
+	ksft_print_header();
+
 	err = mte_default_setup();
 	if (err)
 		return err;
diff --git a/tools/testing/selftests/arm64/mte/check_mmap_options.c b/tools/testing/selftests/arm64/mte/check_mmap_options.c
index a04b12c21ac90..8d03ed26f89cf 100644
--- a/tools/testing/selftests/arm64/mte/check_mmap_options.c
+++ b/tools/testing/selftests/arm64/mte/check_mmap_options.c
@@ -189,6 +189,8 @@ int main(int argc, char *argv[])
 	int err;
 	int item = sizeof(sizes)/sizeof(int);
 
+	ksft_print_header();
+
 	err = mte_default_setup();
 	if (err)
 		return err;
diff --git a/tools/testing/selftests/arm64/mte/check_tags_inclusion.c b/tools/testing/selftests/arm64/mte/check_tags_inclusion.c
index 74a3727f640de..0b9da19a848a7 100644
--- a/tools/testing/selftests/arm64/mte/check_tags_inclusion.c
+++ b/tools/testing/selftests/arm64/mte/check_tags_inclusion.c
@@ -163,6 +163,8 @@ int main(int argc, char *argv[])
 {
 	int err;
 
+	ksft_print_header();
+
 	err = mte_default_setup();
 	if (err)
 		return err;
diff --git a/tools/testing/selftests/arm64/mte/check_user_mem.c b/tools/testing/selftests/arm64/mte/check_user_mem.c
index 1de7a0abd0ae3..72060a2784998 100644
--- a/tools/testing/selftests/arm64/mte/check_user_mem.c
+++ b/tools/testing/selftests/arm64/mte/check_user_mem.c
@@ -85,6 +85,8 @@ int main(int argc, char *argv[])
 {
 	int err;
 
+	ksft_print_header();
+
 	page_sz = getpagesize();
 	if (!page_sz) {
 		ksft_print_msg("ERR: Unable to get page size\n");
-- 
2.53.0



