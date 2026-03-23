Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E643BADA2;
	Mon, 23 Mar 2026 16:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282307; cv=none; b=O4/M4aSvZrLsjpWvRzALZW+rsRZGzX/5OrYwdeLSe9J6fEM+Y8kxdV9pmAvxqwuCsAeBCZzGaKxGN99Wq09lHW8r3ucdtasYvPMZDX/ND8vLLPCr4zuy2W3AE2TdRUWJ3OaHipf5dKtTUXFht3GvT7SWBYW5eY7j0Ib1HMOlfIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282307; c=relaxed/simple;
	bh=4bO68dEUu+E9hZilebeWh7W2op/NPfFXh58CpcGRYo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0RH/vrQDDTUrzJPWEKpIipz5u00at4zACjZAs/L8W2OKzEec1zsQwcL1fpjhO7QnUvgAIiQczSVFz2/g9y2sy/ascg1OH9m/aerfdPBYC+/MCQDwmPUBFOGDrl6DZKGUTsEL7l0obbCacho1XBPew/dvD4WEnTJLaJvvotTCkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Todf7KYi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Todf7KYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45A5C4CEF7;
	Mon, 23 Mar 2026 16:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282307;
	bh=4bO68dEUu+E9hZilebeWh7W2op/NPfFXh58CpcGRYo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Todf7KYiqwW/il4ci8OVBTZPSuQw7WmsGzWboybs5jteN/NfRC7O+UaQJotUIyqza
	 xGrF/IME8bhPI2hQU1oYdEDvl/zXjFZ/rL9Viq/57FwtvVXvkGSvZsEMmbKn0KtnbR
	 Jx6oJrY7I1ypbeXd9SM7BiwfTYN3H5IQkmTu3fX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Latypov <dlatypov@google.com>,
	David Gow <davidgow@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 109/481] kunit: tool: make --json do nothing if --raw_ouput is set
Date: Mon, 23 Mar 2026 14:41:31 +0100
Message-ID: <20260323134527.939495684@linuxfoundation.org>
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

[ Upstream commit 309e22effb741a8c65131a2694a49839fd685a27 ]

When --raw_output is set (to any value), we don't actually parse the
test results. So asking to print the test results as json doesn't make
sense.

We internally create a fake test with one passing subtest, so --json
would actually print out something misleading.

This patch:
* Rewords the flag descriptions so hopefully this is more obvious.
* Also updates --raw_output's description to note the default behavior
  is to print out only "KUnit" results (actually any KTAP results)
* also renames and refactors some related logic for clarity (e.g.
  test_result => test, it's a kunit_parser.Test object).

Notably, this patch does not make it an error to specify --json and
--raw_output together. This is an edge case, but I know of at least one
wrapper around kunit.py that always sets --json. You'd never be able to
use --raw_output with that wrapper.

Signed-off-by: Daniel Latypov <dlatypov@google.com>
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Stable-dep-of: 40804c4974b8 ("kunit: tool: copy caller args in run_kernel to prevent mutation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/kunit/kunit.py | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/tools/testing/kunit/kunit.py b/tools/testing/kunit/kunit.py
index 4d4663fb578bd..e7b6549712d66 100755
--- a/tools/testing/kunit/kunit.py
+++ b/tools/testing/kunit/kunit.py
@@ -192,12 +192,11 @@ def _map_to_overall_status(test_status: kunit_parser.TestStatus) -> KunitStatus:
 def parse_tests(request: KunitParseRequest, metadata: kunit_json.Metadata, input_data: Iterable[str]) -> Tuple[KunitResult, kunit_parser.Test]:
 	parse_start = time.time()
 
-	test_result = kunit_parser.Test()
-
 	if request.raw_output:
 		# Treat unparsed results as one passing test.
-		test_result.status = kunit_parser.TestStatus.SUCCESS
-		test_result.counts.passed = 1
+		fake_test = kunit_parser.Test()
+		fake_test.status = kunit_parser.TestStatus.SUCCESS
+		fake_test.counts.passed = 1
 
 		output: Iterable[str] = input_data
 		if request.raw_output == 'all':
@@ -206,14 +205,17 @@ def parse_tests(request: KunitParseRequest, metadata: kunit_json.Metadata, input
 			output = kunit_parser.extract_tap_lines(output, lstrip=False)
 		for line in output:
 			print(line.rstrip())
+		parse_time = time.time() - parse_start
+		return KunitResult(KunitStatus.SUCCESS, parse_time), fake_test
 
-	else:
-		test_result = kunit_parser.parse_run_tests(input_data)
-	parse_end = time.time()
+
+	# Actually parse the test results.
+	test = kunit_parser.parse_run_tests(input_data)
+	parse_time = time.time() - parse_start
 
 	if request.json:
 		json_str = kunit_json.get_json_result(
-					test=test_result,
+					test=test,
 					metadata=metadata)
 		if request.json == 'stdout':
 			print(json_str)
@@ -223,10 +225,10 @@ def parse_tests(request: KunitParseRequest, metadata: kunit_json.Metadata, input
 			stdout.print_with_timestamp("Test results stored in %s" %
 				os.path.abspath(request.json))
 
-	if test_result.status != kunit_parser.TestStatus.SUCCESS:
-		return KunitResult(KunitStatus.TEST_FAILURE, parse_end - parse_start), test_result
+	if test.status != kunit_parser.TestStatus.SUCCESS:
+		return KunitResult(KunitStatus.TEST_FAILURE, parse_time), test
 
-	return KunitResult(KunitStatus.SUCCESS, parse_end - parse_start), test_result
+	return KunitResult(KunitStatus.SUCCESS, parse_time), test
 
 def run_tests(linux: kunit_kernel.LinuxSourceTree,
 	      request: KunitRequest) -> KunitResult:
@@ -359,14 +361,14 @@ def add_exec_opts(parser) -> None:
 			    choices=['suite', 'test'])
 
 def add_parse_opts(parser) -> None:
-	parser.add_argument('--raw_output', help='If set don\'t format output from kernel. '
-			    'If set to --raw_output=kunit, filters to just KUnit output.',
+	parser.add_argument('--raw_output', help='If set don\'t parse output from kernel. '
+			    'By default, filters to just KUnit output. Use '
+			    '--raw_output=all to show everything',
 			     type=str, nargs='?', const='all', default=None, choices=['all', 'kunit'])
 	parser.add_argument('--json',
 			    nargs='?',
-			    help='Stores test results in a JSON, and either '
-			    'prints to stdout or saves to file if a '
-			    'filename is specified',
+			    help='Prints parsed test results as JSON to stdout or a file if '
+			    'a filename is specified. Does nothing if --raw_output is set.',
 			    type=str, const='stdout', default=None, metavar='FILE')
 
 
-- 
2.51.0



