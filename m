Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5263C369990;
	Sat, 12 Sep 2026 08:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203413; cv=none; b=JTzC4cPOnAco8UD6Ixa9YdYamnfkdF5WNc7o2pI3BcYKgbD7vFZNzP5d0hAdygGuuS0o4lUUZnH/L6Mw0ZNothO8+As5ydpWadHHgmlPomlwnkNOAtB1NGVSlQ6+uoLCxVuuZuz0gUqpDVrEKfgo07KK1O74WVm96uoSdUnqCfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203413; c=relaxed/simple;
	bh=qJraCk8UtQn7poHd4EZYyNiDW1DtCTbHVPBD7j1MORg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cNQTX7s/52ivri+npM6korHXTQTqzjFvW4HUKgqBnqg7x7VOEIYN51Yeh7eJY7EJEPSR56dqHoCN0Tc4MalWSHm2ws1NRlab//7Xxlp9BulW+tNDHH2dLc4NoTIrhPXegDqr/m+Obov7xKA0g7bIutTjFPsykNagzKsX05Mm9cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vAyT1ISJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vAyT1ISJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89451F000FF;
	Sat, 12 Sep 2026 08:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203412;
	bh=mURTdrGwHtDRCxTDcbrU55+znELeWEIkNPbOc3szxzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vAyT1ISJ5D5Ph8zgpY7xFmP5XpyY4XCb/X58fU7fsXLRvJ1KED0OjPnJ5lV5eNPzH
	 zDQ7NjscA22FUzV+6orguKqMEg5srjyXzLjs79MWVlzA8hP+Z8DoUkkuaLZRrmApFk
	 b/1a0tHBvpHnuRvA5xcr6ZeFjx2EiLkVYB4DRyEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammad Abu-Khader <mohammad.abukhader@hotmail.com>,
	David Gow <david@davidgow.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1402/1815] kunit: tool: fix _list_tests filtering wrong variable when list has TAP prefix
Date: Sat, 12 Sep 2026 08:52:32 +0200
Message-ID: <20260912065721.937573301@linuxfoundation.org>
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
index ac3f7159e67fe..91d234ac3b579 100755
--- a/tools/testing/kunit/kunit.py
+++ b/tools/testing/kunit/kunit.py
@@ -126,7 +126,7 @@ def _list_tests(linux: kunit_kernel.LinuxSourceTree, request: KunitExecRequest)
 	lines.pop()
 
 	# Filter out any extraneous non-test output that might have gotten mixed in.
-	return [l for l in output if re.match(r'^[^\s.]+\.[^\s.]+$', l)]
+	return [l for l in lines if re.match(r'^[^\s.]+\.[^\s.]+$', l)]
 
 def _list_tests_attr(linux: kunit_kernel.LinuxSourceTree, request: KunitExecRequest) -> Iterable[str]:
 	args = ['kunit.action=list_attr']
diff --git a/tools/testing/kunit/kunit_tool_test.py b/tools/testing/kunit/kunit_tool_test.py
index da88c3a1651d0..85ae21754bdf9 100755
--- a/tools/testing/kunit/kunit_tool_test.py
+++ b/tools/testing/kunit/kunit_tool_test.py
@@ -979,6 +979,18 @@ class KUnitMainTest(unittest.TestCase):
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



