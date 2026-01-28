Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5312D6E63;
	Wed, 28 Jan 2026 15:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614717; cv=none; b=Ve3jhKX94R39sUubsku867M+b+NS91PmcGmhAWckVF9xl5a22Invq01J76262GXJbEH/GKfJsCKk+HoKdiXUljcH2McfAROwYIqqtf3lnbNMXE+lhiZxzfIa1nk4SZNZUlwlKWZc7c1vS0L+UFPbp7SstW+6BwJ6V2GXOQdsTFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614717; c=relaxed/simple;
	bh=TN73Z+vUolQIibn6Oa4B2+sTFD2adKZaMty5aMxI0IQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hw9gj6y4p3UVVfLxWgF78h4zUvh2socP9P/NYOEEm28WyBaGLy6ck6uAgEtB7raqToHFwokuQZuXVIh7PYCedjx4Am6fQqtdkBg7YZBlpBlcBLmBtONs/t0aIC3+RvlB88qb6zh3SLybnPjPzqGZxTOHjdI6dHmjh8Omak9Slv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ry1hHE5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ry1hHE5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F95BC4AF09;
	Wed, 28 Jan 2026 15:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614716;
	bh=TN73Z+vUolQIibn6Oa4B2+sTFD2adKZaMty5aMxI0IQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ry1hHE5i+vsx3rRzjObgyodwcIFzgvB+pwJyoX/24nr0VYcMts81XEGrEp4rTLnpC
	 iyrX0s4BlvLUIkwE86oTqcNj83UpZFNe/BsUxCft/3+CTExZU7kAH4gsyXFLiMa5r7
	 63UkCxs8WK+jL5vuLK0twGYUBaGg04sH74i9z2x8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ihor Solodrai <ihor.solodrai@pm.me>,
	Andrii Nakryiko <andrii@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.6 221/254] selftests/bpf: Check for timeout in perf_link test
Date: Wed, 28 Jan 2026 16:23:17 +0100
Message-ID: <20260128145352.739990201@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ihor Solodrai <ihor.solodrai@pm.me>

commit e6c209da7e0e9aaf955a7b59e91ed78c2b6c96fb upstream.

Recently perf_link test started unreliably failing on libbpf CI:
  * https://github.com/libbpf/libbpf/actions/runs/11260672407/job/31312405473
  * https://github.com/libbpf/libbpf/actions/runs/11260992334/job/31315514626
  * https://github.com/libbpf/libbpf/actions/runs/11263162459/job/31320458251

Part of the test is running a dummy loop for a while and then checking
for a counter incremented by the test program.

Instead of waiting for an arbitrary number of loop iterations once,
check for the test counter in a loop and use get_time_ns() helper to
enforce a 100ms timeout.

v1: https://lore.kernel.org/bpf/zuRd072x9tumn2iN4wDNs5av0nu5nekMNV4PkR-YwCT10eFFTrUtZBRkLWFbrcCe7guvLStGQlhibo8qWojCO7i2-NGajes5GYIyynexD-w=@pm.me/

Signed-off-by: Ihor Solodrai <ihor.solodrai@pm.me>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20241011153104.249800-1-ihor.solodrai@pm.me
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/prog_tests/perf_link.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/bpf/prog_tests/perf_link.c
+++ b/tools/testing/selftests/bpf/prog_tests/perf_link.c
@@ -4,8 +4,12 @@
 #include <pthread.h>
 #include <sched.h>
 #include <test_progs.h>
+#include "testing_helpers.h"
 #include "test_perf_link.skel.h"
 
+#define BURN_TIMEOUT_MS 100
+#define BURN_TIMEOUT_NS BURN_TIMEOUT_MS * 1000000
+
 static void burn_cpu(void)
 {
 	volatile int j = 0;
@@ -32,6 +36,7 @@ void serial_test_perf_link(void)
 	int run_cnt_before, run_cnt_after;
 	struct bpf_link_info info;
 	__u32 info_len = sizeof(info);
+	__u64 timeout_time_ns;
 
 	/* create perf event */
 	memset(&attr, 0, sizeof(attr));
@@ -63,8 +68,14 @@ void serial_test_perf_link(void)
 	ASSERT_GT(info.prog_id, 0, "link_prog_id");
 
 	/* ensure we get at least one perf_event prog execution */
-	burn_cpu();
-	ASSERT_GT(skel->bss->run_cnt, 0, "run_cnt");
+	timeout_time_ns = get_time_ns() + BURN_TIMEOUT_NS;
+	while (true) {
+		burn_cpu();
+		if (skel->bss->run_cnt > 0)
+			break;
+	        if (!ASSERT_LT(get_time_ns(), timeout_time_ns, "run_cnt_timeout"))
+			break;
+	}
 
 	/* perf_event is still active, but we close link and BPF program
 	 * shouldn't be executed anymore


