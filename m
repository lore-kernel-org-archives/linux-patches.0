Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BF5415B8E;
	Sat, 12 Sep 2026 09:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205460; cv=none; b=FfjYFrobAh4shkq+YkaKWx8fk7NUvbgvWKe4t4iPSz0KSd6njeN7MnQug99WQIB4UrldqmwbZvN07ThIJeAdWas+QdvzAw02bCr2J3/SEyYgA3OtBfBx3N111pxdnfVO34aL5SCzwtqt5UR+NTH8NRCOHE0ED6cyhrx/P+nOXO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205460; c=relaxed/simple;
	bh=nriQU0Yhhr932JALmCk8s4U7W2KiZwjEYJbhR8mulHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nf+tqMrAjXUXQul4vWeio1eKwAlfFybwmS6G2Zeek6JRArW6vNG83gtLHhuqCtIqr4o1PFpAIlmhaX0XxQ7Qaz9aJan/AdXFshusuRC401mUY2sR5QOPpmyyND37Z+1dTkuT0dO+Wzoi7NFmEeEu8n349mhOXBht4IRVdr8kZVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xx88iqTU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xx88iqTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648071F00898;
	Sat, 12 Sep 2026 09:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205453;
	bh=tf2vhiQWB5aR2i11/h6HzL7d0KriEpnL26U4stgxSh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xx88iqTUseK3dm4jL37yLEdalbDqDPbskQEEANvWDYD7GF/3QmIbFKKk20oM3CHZJ
	 BPyKgi2V9+5a7TEIUJo9fo6acCsUY4Ab+DqdYiLMqNtXkB9jksUcZRpLfOpfeV0eI3
	 vLSrFCRCIq5bPQabISNqcYzq5OlymmH0kscfCj1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1790/1815] selftests/arm64: Print missing MTE TAP headers
Date: Sat, 12 Sep 2026 08:59:00 +0200
Message-ID: <20260912065731.057791178@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index ff4e075033493..039b1d7d85663 100644
--- a/tools/testing/selftests/arm64/mte/check_buffer_fill.c
+++ b/tools/testing/selftests/arm64/mte/check_buffer_fill.c
@@ -406,6 +406,8 @@ int main(int argc, char *argv[])
 	size_t page_size = getpagesize();
 	int item = ARRAY_SIZE(sizes);
 
+	ksft_print_header();
+
 	sizes[item - 3] = page_size - 1;
 	sizes[item - 2] = page_size;
 	sizes[item - 1] = page_size + 1;
diff --git a/tools/testing/selftests/arm64/mte/check_child_memory.c b/tools/testing/selftests/arm64/mte/check_child_memory.c
index 5e97ee792e4d2..e6a8acca2a941 100644
--- a/tools/testing/selftests/arm64/mte/check_child_memory.c
+++ b/tools/testing/selftests/arm64/mte/check_child_memory.c
@@ -146,6 +146,8 @@ int main(int argc, char *argv[])
 	int err;
 	int item = ARRAY_SIZE(sizes);
 
+	ksft_print_header();
+
 	page_size = getpagesize();
 	if (!page_size) {
 		ksft_print_msg("ERR: Unable to get page size\n");
diff --git a/tools/testing/selftests/arm64/mte/check_gcr_el1_cswitch.c b/tools/testing/selftests/arm64/mte/check_gcr_el1_cswitch.c
index 325bca0de0f6e..d23f154d3288c 100644
--- a/tools/testing/selftests/arm64/mte/check_gcr_el1_cswitch.c
+++ b/tools/testing/selftests/arm64/mte/check_gcr_el1_cswitch.c
@@ -131,6 +131,7 @@ int main(int argc, char *argv[])
 	if (err)
 		return err;
 
+	ksft_print_header();
 	ksft_set_plan(1);
 
 	evaluate_test(mte_gcr_fork_test(),
diff --git a/tools/testing/selftests/arm64/mte/check_hugetlb_options.c b/tools/testing/selftests/arm64/mte/check_hugetlb_options.c
index aad1234c7e0fe..23e4a7a9950c1 100644
--- a/tools/testing/selftests/arm64/mte/check_hugetlb_options.c
+++ b/tools/testing/selftests/arm64/mte/check_hugetlb_options.c
@@ -230,6 +230,8 @@ int main(int argc, char *argv[])
 	void *map_ptr;
 	unsigned long map_size;
 
+	ksft_print_header();
+
 	err = mte_default_setup();
 	if (err)
 		return err;
diff --git a/tools/testing/selftests/arm64/mte/check_ksm_options.c b/tools/testing/selftests/arm64/mte/check_ksm_options.c
index 0cf5faef17248..866f0929b6647 100644
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
index c100af3012cbb..492f2cd41f43b 100644
--- a/tools/testing/selftests/arm64/mte/check_mmap_options.c
+++ b/tools/testing/selftests/arm64/mte/check_mmap_options.c
@@ -945,6 +945,8 @@ int main(int argc, char *argv[])
 		},
 	};
 
+	ksft_print_header();
+
 	err = mte_default_setup();
 	if (err)
 		return err;
diff --git a/tools/testing/selftests/arm64/mte/check_tags_inclusion.c b/tools/testing/selftests/arm64/mte/check_tags_inclusion.c
index 4b764f2a81857..6b4fa6705d7c1 100644
--- a/tools/testing/selftests/arm64/mte/check_tags_inclusion.c
+++ b/tools/testing/selftests/arm64/mte/check_tags_inclusion.c
@@ -175,6 +175,8 @@ int main(int argc, char *argv[])
 {
 	int err;
 
+	ksft_print_header();
+
 	err = mte_default_setup();
 	if (err)
 		return err;
diff --git a/tools/testing/selftests/arm64/mte/check_user_mem.c b/tools/testing/selftests/arm64/mte/check_user_mem.c
index fb7936c4e0978..af343aa617323 100644
--- a/tools/testing/selftests/arm64/mte/check_user_mem.c
+++ b/tools/testing/selftests/arm64/mte/check_user_mem.c
@@ -201,6 +201,8 @@ int main(int argc, char *argv[])
 	int tag_offsets[] = {page_sz, MT_GRANULE_SIZE};
 	char test_name[TEST_NAME_MAX];
 
+	ksft_print_header();
+
 	page_sz = getpagesize();
 	if (!page_sz) {
 		ksft_print_msg("ERR: Unable to get page size\n");
-- 
2.53.0



