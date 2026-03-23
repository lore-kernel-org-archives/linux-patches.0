Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D13C2580D7;
	Mon, 23 Mar 2026 16:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282304; cv=none; b=pA9rrS8/l/C4aN15AzTtPyrd91u51UzzVrVBJHw0Y6AawhGed7PJU16z+KB+iARzYSzimLT/N1hMYO9Pi1eeK3T9cVAkPB0wYVnyTplpI2Sao3bFwnoesDWQbSJcasbYPDQZqcqZOWV2K/4kcbVfdVd04ctvUajcTGv4A08crV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282304; c=relaxed/simple;
	bh=+nrVYSUHmsyXqMovfnF/PfGNCjCdSPOqck0y/QGz98s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QI0VmStoRIsr7e9KGdiRJh6MisRF2AAAqraihvPV2haKG3lnlT/sjxpo7jsxLZjbqtudcBhW2s4fNYj19CuSFJ8h+fiYOY2aERY6A/OCmubpcKW1NHGfdcdNoeB0fpfupcTFRpxgsg7S4ahVviAiptnq39xYWj2nSVfoG9gzZ8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DWZNAp4M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DWZNAp4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31689C4CEF7;
	Mon, 23 Mar 2026 16:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282304;
	bh=+nrVYSUHmsyXqMovfnF/PfGNCjCdSPOqck0y/QGz98s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DWZNAp4MXzJPW6ymtVvQ51JUVKbkwLcH4+huhtufCP2Ki/VBkZsu8HrLkHL2KtAmO
	 bRhI3CAlpwhVhIpKzCWkcemx8JMawnIhN8LKGU695MNlbBHybam56Tq9X47zzsd+hl
	 3au2SLQwoksVDeZhOlSk5794ODFWRglD9ySYFTtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Latypov <dlatypov@google.com>,
	David Gow <davidgow@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/481] kunit: tool: print summary of failed tests if a few failed out of a lot
Date: Mon, 23 Mar 2026 14:41:30 +0100
Message-ID: <20260323134527.916016790@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Latypov <dlatypov@google.com>

[ Upstream commit f19dd011d8de6f0c1d20abea5158aa4f5d9cea44 ]

E.g. all the hw_breakpoint tests are failing right now.
So if I run `kunit.py run --altests --arch=x86_64`, then I see
> Testing complete. Ran 408 tests: passed: 392, failed: 9, skipped: 7

Seeing which 9 tests failed out of the hundreds is annoying.
If my terminal doesn't have scrollback support, I have to resort to
looking at `.kunit/test.log` for the `not ok` lines.

Teach kunit.py to print a summarized list of failures if the # of tests
reachs an arbitrary threshold (>=100 tests).

To try and keep the output from being too long/noisy, this new logic
a) just reports "parent_test failed" if every child test failed
b) won't print anything if there are >10 failures (also arbitrary).

With this patch, we get an extra line of output showing:
> Testing complete. Ran 408 tests: passed: 392, failed: 9, skipped: 7
> Failures: hw_breakpoint

This also works with parameterized tests, e.g. if I add a fake failure
> Failures: kcsan.test_atomic_builtins_missing_barrier.threads=6

Note: we didn't have enough tests for this to be a problem before.
But with commit 980ac3ad0512 ("kunit: tool: rename all_test_uml.config,
use it for --alltests"), --alltests works and thus running >100 tests
will probably become more common.

Signed-off-by: Daniel Latypov <dlatypov@google.com>
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Stable-dep-of: 40804c4974b8 ("kunit: tool: copy caller args in run_kernel to prevent mutation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/kunit/kunit_parser.py    | 47 ++++++++++++++++++++++++++
 tools/testing/kunit/kunit_tool_test.py | 22 ++++++++++++
 2 files changed, 69 insertions(+)

diff --git a/tools/testing/kunit/kunit_parser.py b/tools/testing/kunit/kunit_parser.py
index 1ae873e3e3415..94dba66feec50 100644
--- a/tools/testing/kunit/kunit_parser.py
+++ b/tools/testing/kunit/kunit_parser.py
@@ -58,6 +58,10 @@ class Test:
 		self.counts.errors += 1
 		stdout.print_with_timestamp(stdout.red('[ERROR]') + f' Test: {self.name}: {error_message}')
 
+	def ok_status(self) -> bool:
+		"""Returns true if the status was ok, i.e. passed or skipped."""
+		return self.status in (TestStatus.SUCCESS, TestStatus.SKIPPED)
+
 class TestStatus(Enum):
 	"""An enumeration class to represent the status of a test."""
 	SUCCESS = auto()
@@ -565,6 +569,40 @@ def print_test_footer(test: Test) -> None:
 	stdout.print_with_timestamp(format_test_divider(message,
 		len(message) - stdout.color_len()))
 
+
+
+def _summarize_failed_tests(test: Test) -> str:
+	"""Tries to summarize all the failing subtests in `test`."""
+
+	def failed_names(test: Test, parent_name: str) -> List[str]:
+		# Note: we use 'main' internally for the top-level test.
+		if not parent_name or parent_name == 'main':
+			full_name = test.name
+		else:
+			full_name = parent_name + '.' + test.name
+
+		if not test.subtests:  # this is a leaf node
+			return [full_name]
+
+		# If all the children failed, just say this subtest failed.
+		# Don't summarize it down "the top-level test failed", though.
+		failed_subtests = [sub for sub in test.subtests if not sub.ok_status()]
+		if parent_name and len(failed_subtests) ==  len(test.subtests):
+			return [full_name]
+
+		all_failures = []  # type: List[str]
+		for t in failed_subtests:
+			all_failures.extend(failed_names(t, full_name))
+		return all_failures
+
+	failures = failed_names(test, '')
+	# If there are too many failures, printing them out will just be noisy.
+	if len(failures) > 10:  # this is an arbitrary limit
+		return ''
+
+	return 'Failures: ' + ', '.join(failures)
+
+
 def print_summary_line(test: Test) -> None:
 	"""
 	Prints summary line of test object. Color of line is dependent on
@@ -587,6 +625,15 @@ def print_summary_line(test: Test) -> None:
 		color = stdout.red
 	stdout.print_with_timestamp(color(f'Testing complete. {test.counts}'))
 
+	# Summarize failures that might have gone off-screen since we had a lot
+	# of tests (arbitrarily defined as >=100 for now).
+	if test.ok_status() or test.counts.total() < 100:
+		return
+	summarized = _summarize_failed_tests(test)
+	if not summarized:
+		return
+	stdout.print_with_timestamp(color(summarized))
+
 # Other methods:
 
 def bubble_up_test_results(test: Test) -> None:
diff --git a/tools/testing/kunit/kunit_tool_test.py b/tools/testing/kunit/kunit_tool_test.py
index e2cd2cc2e98f6..42cbf28bfa6c6 100755
--- a/tools/testing/kunit/kunit_tool_test.py
+++ b/tools/testing/kunit/kunit_tool_test.py
@@ -309,6 +309,28 @@ class KUnitParserTest(unittest.TestCase):
 				result.status)
 			self.assertEqual('kunit-resource-test', result.subtests[0].name)
 
+	def test_summarize_failures(self):
+		output = """
+		KTAP version 1
+		1..2
+			# Subtest: all_failed_suite
+			1..2
+			not ok 1 - test1
+			not ok 2 - test2
+		not ok 1 - all_failed_suite
+			# Subtest: some_failed_suite
+			1..2
+			ok 1 - test1
+			not ok 2 - test2
+		not ok 1 - some_failed_suite
+		"""
+		result = kunit_parser.parse_run_tests(output.splitlines())
+		self.assertEqual(kunit_parser.TestStatus.FAILURE, result.status)
+
+		self.assertEqual(kunit_parser._summarize_failed_tests(result),
+			'Failures: all_failed_suite, some_failed_suite.test2')
+
+
 def line_stream_from_strs(strs: Iterable[str]) -> kunit_parser.LineStream:
 	return kunit_parser.LineStream(enumerate(strs, start=1))
 
-- 
2.51.0



