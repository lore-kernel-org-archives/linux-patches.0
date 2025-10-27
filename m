Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2773314DD;
	Mon, 27 Oct 2025 19:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591897; cv=none; b=jBeYcr1N8x7/gugK1U2XjkaEJuogmcX2l3GIlz/+hyhPx62Ts9Kv/lqOI9MWquY7EDesr+WyMvuvyFVBhyKsKmir5GQ2fjtT87XHzaSmGYvq78sNyFDB39cpGAODLx3BFzcK+/XFFuS8M118R9VxjZRptomuJdqjP9wm1aov4GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591897; c=relaxed/simple;
	bh=wPWJHZAsKoJGdU60vaEyogDl8J3YZ5riSLb9bAqPdN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZuSNbIfVBknjwOvhIYXHjvmC/Z+CqrdVJBjVQXbPcrc81s72NXY7mzkCCCWSV3EtdztEws3uyv9hA/kSYeOp+VW3DXWezMpK5NfNsFGHZ7uf4yisIXKSew4YZkrmkjPwRlTGVzIqQ2CXstCdH3+0JAlh1K7wkldQF0BK5N/u7H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XPHyO7iz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XPHyO7iz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450D5C4CEF1;
	Mon, 27 Oct 2025 19:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591896;
	bh=wPWJHZAsKoJGdU60vaEyogDl8J3YZ5riSLb9bAqPdN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XPHyO7izeKiUtCAqrHXS1V2V8Ix+rfqiMBpaaaddDl4+yQ+v8v4/PQEAalDJLXle2
	 HNTZnEPjgiMBRkQATtKr1pg5SelwP6pYvY7BVThCG2D6HHH1f62RljAa00V0P8gx2b
	 bCM355lv/W4dsC/zOq5bSoh0UsA42JFAsQRQShBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"peterz@infradead.org, mingo@redhat.com, acme@kernel.org, mark.rutland@arm.com, alexander.shishkin@linux.intel.com, jolsa@redhat.com, namhyung@kernel.org, irogers@google.com, sashal@kernel.org, Niko Mauno" <niko.mauno@vaisala.com>,
	Niko Mauno <niko.mauno@vaisala.com>
Subject: [PATCH 5.15 040/123] Revert "perf test: Dont leak workload gopipe in PERF_RECORD_*"
Date: Mon, 27 Oct 2025 19:35:20 +0100
Message-ID: <20251027183447.474391966@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

From: Niko Mauno <niko.mauno@vaisala.com>

This reverts commit b7e5c59f3b0971f56ebbceb9d42cc45e9ac1cd94 which is
commit 48918cacefd226af44373e914e63304927c0e7dc upstream.

Commit in question broke building perf followingly with v5.15.195:

  | ld: perf-in.o: in function `test__PERF_RECORD':
  | tools/perf/tests/perf-record.c:142: undefined reference to `evlist__cancel_workload'

The 'evlist__cancel_workload' seems to be introduced in
commit e880a70f8046 ("perf stat: Close cork_fd when create_perf_stat_counter() failed")
which is currently not included in the 5.15 stable series.

Fixes: b7e5c59f3b09 ("perf test: Don't leak workload gopipe in PERF_RECORD_*")
Cc: stable@vger.kernel.org # 5.15
Signed-off-by: Niko Mauno <niko.mauno@vaisala.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/tests/perf-record.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -115,7 +115,6 @@ int test__PERF_RECORD(struct test *test
 	if (err < 0) {
 		pr_debug("sched__get_first_possible_cpu: %s\n",
 			 str_error_r(errno, sbuf, sizeof(sbuf)));
-		evlist__cancel_workload(evlist);
 		goto out_delete_evlist;
 	}
 
@@ -127,7 +126,6 @@ int test__PERF_RECORD(struct test *test
 	if (sched_setaffinity(evlist->workload.pid, cpu_mask_size, &cpu_mask) < 0) {
 		pr_debug("sched_setaffinity: %s\n",
 			 str_error_r(errno, sbuf, sizeof(sbuf)));
-		evlist__cancel_workload(evlist);
 		goto out_delete_evlist;
 	}
 
@@ -139,7 +137,6 @@ int test__PERF_RECORD(struct test *test
 	if (err < 0) {
 		pr_debug("perf_evlist__open: %s\n",
 			 str_error_r(errno, sbuf, sizeof(sbuf)));
-		evlist__cancel_workload(evlist);
 		goto out_delete_evlist;
 	}
 
@@ -152,7 +149,6 @@ int test__PERF_RECORD(struct test *test
 	if (err < 0) {
 		pr_debug("evlist__mmap: %s\n",
 			 str_error_r(errno, sbuf, sizeof(sbuf)));
-		evlist__cancel_workload(evlist);
 		goto out_delete_evlist;
 	}
 


