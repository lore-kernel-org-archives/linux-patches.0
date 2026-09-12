Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED8B478E25;
	Sat, 12 Sep 2026 13:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219319; cv=none; b=fejtlHHOip4Oq4OI9CcDn5b7bqYdnxaamUu2C10Q/gyp+G600z3YD6BDCrGvSYqd1OKEYTs6LzS89pYGp72fmsiX5yf0kPVlhJjL+1MoNmzbYjIs9YZlenKI7JEYuM6EUWDuTEPs/0+r0lwd2K9RznNxuj2MMilksaquVszWPxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219319; c=relaxed/simple;
	bh=xHG3sNHlSVJsGs1EOTTsMrylm4cVe2c3WPGGUwpFgJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TywDnp1XN06AJPFY261Z7xII+V4HwGYv+woM95RLDnGkPo+rOaVl6DdaX6be6uhVOEEHi+E8b6FWnCq+yUqSUsTTRQtsdXaFSXRRAkbWwU1mOZShzlrqLLeh+NVO6QBEo/bf+Q8BpNRgOyP+JYpEJ+OcAWi1rQPxMtPqBitwPQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lp3nwQss; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lp3nwQss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D231F000FF;
	Sat, 12 Sep 2026 13:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219317;
	bh=7U1vW1mkwg8+ew1GsYs8fxwbO8QfETelvFWhPTtsOwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lp3nwQsslSGMvEnBuNxCPm2LrT4OXoB2as070a8P12fglYcrr2eHsLVVsz+5yTEG4
	 45MYoKI9AUOGZ+z0kpMMcVUI8TjXIZ3Slpvr0ahD9Dif1l/bIpTH84pq4GOcgYQHNK
	 gMO2+e+nvTTuDoojCo3u2yNvaWrvXY8h41i/tK08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1325/1376] selftests/arm64: Print missing MTE TAP headers
Date: Sat, 12 Sep 2026 09:02:31 +0200
Message-ID: <20260912065637.061481788@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1dbbbd47dd501..639ea469969a9 100644
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
index 7597fc632cadf..7017a4851ff49 100644
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
index 17694caaff532..703ccd4685a8e 100644
--- a/tools/testing/selftests/arm64/mte/check_mmap_options.c
+++ b/tools/testing/selftests/arm64/mte/check_mmap_options.c
@@ -188,6 +188,8 @@ int main(int argc, char *argv[])
 	int err;
 	int item = ARRAY_SIZE(sizes);
 
+	ksft_print_header();
+
 	err = mte_default_setup();
 	if (err)
 		return err;
diff --git a/tools/testing/selftests/arm64/mte/check_tags_inclusion.c b/tools/testing/selftests/arm64/mte/check_tags_inclusion.c
index a3d1e23fe02af..c73b4641d01a7 100644
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
index f4ae5f87a3b77..8c790331d67c4 100644
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



