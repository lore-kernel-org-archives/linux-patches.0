Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AD3168C2
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:55:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DD9C4339B;
	Mon,  8 May 2023 09:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539713;
	bh=l2h9YjMDLRAr2jcFEQLSgFunBEL/0rLcx0zq/JwBzXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oi+S6D8+ENyJY6JQFDzyOKYauokNVOlv3OUipjR3Vdj54CY0T4F2FSEKNRK2Hrv2t
	 VWJytmAsGrN8fusE+dkggNWc/ooxuCxLQML5nk+Kyk28xYxXN9Uzxg0mrgYNUdSB2J
	 03a8X3c67Z05YfHbvhRStRa2fXWPas4wppkiS7PU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rae Moar <rmoar@google.com>,
	David Gow <davidgow@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 114/611] kunit: fix bug in the order of lines in debugfs logs
Date: Mon,  8 May 2023 11:39:16 +0200
Message-Id: <20230508094425.973743565@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rae Moar <rmoar@google.com>

[ Upstream commit f9a301c3317daa921375da0aec82462ddf019928 ]

Fix bug in debugfs logs that causes an incorrect order of lines in the
debugfs log.

Currently, the test counts lines that show the number of tests passed,
failed, and skipped, as well as any suite diagnostic lines,
appear prior to the individual results, which is a bug.

Ensure the order of printing for the debugfs log is correct. Additionally,
add a KTAP header to so the debugfs logs can be valid KTAP.

This is an example of a log prior to these fixes:

     KTAP version 1

     # Subtest: kunit_status
     1..2
 # kunit_status: pass:2 fail:0 skip:0 total:2
 # Totals: pass:2 fail:0 skip:0 total:2
     ok 1 kunit_status_set_failure_test
     ok 2 kunit_status_mark_skipped_test
 ok 1 kunit_status

Note the two lines with stats are out of order. This is the same debugfs
log after the fixes (in combination with the third patch to remove the
extra line):

 KTAP version 1
 1..1
     KTAP version 1
     # Subtest: kunit_status
     1..2
     ok 1 kunit_status_set_failure_test
     ok 2 kunit_status_mark_skipped_test
 # kunit_status: pass:2 fail:0 skip:0 total:2
 # Totals: pass:2 fail:0 skip:0 total:2
 ok 1 kunit_status

Signed-off-by: Rae Moar <rmoar@google.com>
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/debugfs.c | 14 ++++++++++++--
 lib/kunit/test.c    | 21 ++++++++++++++-------
 2 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/lib/kunit/debugfs.c b/lib/kunit/debugfs.c
index de0ee2e03ed60..b08bb1fba106d 100644
--- a/lib/kunit/debugfs.c
+++ b/lib/kunit/debugfs.c
@@ -55,14 +55,24 @@ static int debugfs_print_results(struct seq_file *seq, void *v)
 	enum kunit_status success = kunit_suite_has_succeeded(suite);
 	struct kunit_case *test_case;
 
-	if (!suite || !suite->log)
+	if (!suite)
 		return 0;
 
-	seq_printf(seq, "%s", suite->log);
+	/* Print KTAP header so the debugfs log can be parsed as valid KTAP. */
+	seq_puts(seq, "KTAP version 1\n");
+	seq_puts(seq, "1..1\n");
+
+	/* Print suite header because it is not stored in the test logs. */
+	seq_puts(seq, KUNIT_SUBTEST_INDENT "KTAP version 1\n");
+	seq_printf(seq, KUNIT_SUBTEST_INDENT "# Subtest: %s\n", suite->name);
+	seq_printf(seq, KUNIT_SUBTEST_INDENT "1..%zd\n", kunit_suite_num_test_cases(suite));
 
 	kunit_suite_for_each_test_case(suite, test_case)
 		debugfs_print_result(seq, suite, test_case);
 
+	if (suite->log)
+		seq_printf(seq, "%s", suite->log);
+
 	seq_printf(seq, "%s %d %s\n",
 		   kunit_status_to_ok_not_ok(success), 1, suite->name);
 	return 0;
diff --git a/lib/kunit/test.c b/lib/kunit/test.c
index 0391159d0c235..184df6f701b48 100644
--- a/lib/kunit/test.c
+++ b/lib/kunit/test.c
@@ -149,10 +149,18 @@ EXPORT_SYMBOL_GPL(kunit_suite_num_test_cases);
 
 static void kunit_print_suite_start(struct kunit_suite *suite)
 {
-	kunit_log(KERN_INFO, suite, KUNIT_SUBTEST_INDENT "KTAP version 1\n");
-	kunit_log(KERN_INFO, suite, KUNIT_SUBTEST_INDENT "# Subtest: %s",
+	/*
+	 * We do not log the test suite header as doing so would
+	 * mean debugfs display would consist of the test suite
+	 * header prior to individual test results.
+	 * Hence directly printk the suite status, and we will
+	 * separately seq_printf() the suite header for the debugfs
+	 * representation.
+	 */
+	pr_info(KUNIT_SUBTEST_INDENT "KTAP version 1\n");
+	pr_info(KUNIT_SUBTEST_INDENT "# Subtest: %s\n",
 		  suite->name);
-	kunit_log(KERN_INFO, suite, KUNIT_SUBTEST_INDENT "1..%zd",
+	pr_info(KUNIT_SUBTEST_INDENT "1..%zd\n",
 		  kunit_suite_num_test_cases(suite));
 }
 
@@ -169,10 +177,9 @@ static void kunit_print_ok_not_ok(void *test_or_suite,
 
 	/*
 	 * We do not log the test suite results as doing so would
-	 * mean debugfs display would consist of the test suite
-	 * description and status prior to individual test results.
-	 * Hence directly printk the suite status, and we will
-	 * separately seq_printf() the suite status for the debugfs
+	 * mean debugfs display would consist of an incorrect test
+	 * number. Hence directly printk the suite result, and we will
+	 * separately seq_printf() the suite results for the debugfs
 	 * representation.
 	 */
 	if (suite)
-- 
2.39.2



