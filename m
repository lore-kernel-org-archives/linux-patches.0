Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE60221F26;
	Sat, 12 Sep 2026 11:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211078; cv=none; b=HxnBJXXo0Tubjg5mnrBTH+dk/Ijs951eXfOPAOsE8E/E2eJ+andkkrfC1g9xRPaPapqdpotGXCd/ld07Zp21YTGOHYc70StIVKcAN2WJQ+yN3Qd7DBr6IrdIXwL6O8E4S3jY4yhgv9fDacVowFLKJ6LihlmL+nOXWd1sYooFtoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211078; c=relaxed/simple;
	bh=d16SQjJHjMLD4LFYcffLcAgvXlRVxEUSynDOJTevhe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JcXkQC14RXtB59Ub4izR23TFAdW/UD3oGFPGf4+kQOkoENCSQLrE5r/60IXJtGISr2/IdqUNpAdlHX/R0IWrOirapG67YqBbA7GtIgtKbko0+6o8MdQ5tOl/6vFVHRUYTypW75cL0ElZpL0nxg/WNpUxTXWquUn1+RUDpEL8IiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZBtoQg/h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZBtoQg/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1061F000FF;
	Sat, 12 Sep 2026 11:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211077;
	bh=Ts5L0aPXMx7gxG12QuqRKP9LgaTznyUAm52jU1sPmTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZBtoQg/hxcLc9jCh8fsZXs6jNAmvZ13ktHhhNUwtpvDyOuvwm2B/rZMiDSsMvH/4R
	 jbH5h/pAwp7sOdGkDoQW9WB3xBfHfni6NxJBQaDoR844rdumImlFFC/Q7tjlcOTpUy
	 KF5zRxSNMIe+tm/7iKBRjLmz2oSwuR55LT9erq+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammad Abu-Khader <mohammad.abukhader@hotmail.com>,
	David Gow <david@davidgow.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1158/1518] kunit: tool: fix _list_tests filtering wrong variable when list has TAP prefix
Date: Sat, 12 Sep 2026 08:55:27 +0200
Message-ID: <20260912065649.654726408@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohammad Abu-Khader <mohammad.abukhader@hotmail.com>

[ Upstream commit dea754ded9518b51740c417d2c1e02ff540784c6 ]

`_list_tests()` runs the kernel to list tests, strips printk timestamp
lines via `extract_tap_lines()`, then drops the dummy TAP header from
the cleaned `lines`.  However the subsequent regex filter mistakenly
operates on the original `output` instead of the cleaned `lines`.  When
the kernel output includes timestamp prefixes (common with UML or slower
setups), e.g.:

  [    0.100000] suite.test1
  [    0.100000] suite.test2

the anchored regex `^[^\s.]+\.[^\s.]+$` rejects them and `--list_tests`
returns an empty list.

Filter `lines` instead of `output`, matching the behavior of the
adjacent `_list_tests_attr()` which already returns the cleaned list.

Add a regression test with timestamp-prefixed input to verify the fix.

Link: https://lore.kernel.org/r/20260803190059.36491-1-mohammad.abukhader@hotmail.com
Fixes: 723c8258c8fe ("kunit: tool: Add command line interface to filter and report attributes")
Signed-off-by: Mohammad Abu-Khader <mohammad.abukhader@hotmail.com>
Reviewed-by: David Gow <david@davidgow.net>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/kunit/kunit.py           |  2 +-
 tools/testing/kunit/kunit_tool_test.py | 12 ++++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/testing/kunit/kunit.py b/tools/testing/kunit/kunit.py
index cd99c1956331d..f3392cb3b7af7 100755
--- a/tools/testing/kunit/kunit.py
+++ b/tools/testing/kunit/kunit.py
@@ -123,7 +123,7 @@ def _list_tests(linux: kunit_kernel.LinuxSourceTree, request: KunitExecRequest)
 	lines.pop()
 
 	# Filter out any extraneous non-test output that might have gotten mixed in.
-	return [l for l in output if re.match(r'^[^\s.]+\.[^\s.]+$', l)]
+	return [l for l in lines if re.match(r'^[^\s.]+\.[^\s.]+$', l)]
 
 def _list_tests_attr(linux: kunit_kernel.LinuxSourceTree, request: KunitExecRequest) -> Iterable[str]:
 	args = ['kunit.action=list_attr']
diff --git a/tools/testing/kunit/kunit_tool_test.py b/tools/testing/kunit/kunit_tool_test.py
index 0eb61de9abd4b..a8eb223e57e10 100755
--- a/tools/testing/kunit/kunit_tool_test.py
+++ b/tools/testing/kunit/kunit_tool_test.py
@@ -896,6 +896,18 @@ class KUnitMainTest(unittest.TestCase):
 		self.linux_source_mock.run_kernel.assert_called_once_with(
 			args=['kunit.action=list'], build_dir='.kunit', filter_glob='suite*', filter='', filter_action=None, timeout=300)
 
+	def test_list_tests_with_prefix(self):
+		want = ['suite.test1', 'suite.test2', 'suite2.test1']
+		self.linux_source_mock.run_kernel.return_value = [
+			'[    0.100000] TAP version 14',
+			'[    0.200000] suite.test1',
+			'[    0.200000] suite.test2',
+			'[    0.300000] suite2.test1']
+
+		got = kunit._list_tests(self.linux_source_mock,
+				     kunit.KunitExecRequest(None, None, None, False, False, '.kunit', 300, 'suite*', '', None, None, 'suite', False, False, False))
+		self.assertEqual(got, want)
+
 	@mock.patch.object(kunit, '_list_tests')
 	def test_run_isolated_by_suite(self, mock_tests):
 		mock_tests.return_value = ['suite.test1', 'suite.test2', 'suite2.test1']
-- 
2.53.0



