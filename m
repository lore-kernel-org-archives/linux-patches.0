Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F66B20ED;
	Sat, 12 Sep 2026 15:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225400; cv=none; b=WVSbR9Ksav3l6FRMGqlsF6lyznSR6s9q5pxJwojzEjhumM2mkoAubU7pegE2tMMgucaosbpSmlQLFFHKhbjoy3ze+3C2LP3hAvKl+6dUInbUGfdW4Dw0RXsjxeWjGqfjIu6L/jyoqt44q+dOkNWB+Xr/L5MFrUvKoHtXGOSf4VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225400; c=relaxed/simple;
	bh=JDginW9WoYbewu3SMNF5ZY++ieM70AiGqf2lsfGL9tQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jzk+m0ZZjoYFQcP0ULtWvkoVd00sWT0wmim5SyJfK7aK+yn97711vl6JWSrBaXWP+IU8C6gxdxMotccGzrJmsadxLy+2F35+UaSxcIC/YFqKO1uWFc4IIUlIep4TCrY6EpdO7A/xtmyUSzbqAIJSEU7BihEti6FYc6w+4GePanA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WKPov7KT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WKPov7KT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169271F000FF;
	Sat, 12 Sep 2026 15:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225399;
	bh=gKdlTrByWtq3GzJ+VlTRNXG0yNGc4ptUI16Mip6lagg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WKPov7KTmApWK1uzgUpj/K0eALuBhN3o/srHunjEkaecx6uSxXYWklP4lTEyfqsAa
	 uA3XdtnjW9Ys6MnUktm8Kydi7PNXsdsjwQ79GkAaeqwvpSdc1AC5ut6nXvXvY0GHT1
	 /0UJwPzaPcFsXOYWBO15hUGra6fuIaGi5XciBvWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammad Abu-Khader <mohammad.abukhader@hotmail.com>,
	David Gow <david@davidgow.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1191/1424] kunit: tool: fix _list_tests filtering wrong variable when list has TAP prefix
Date: Sat, 12 Sep 2026 09:00:23 +0200
Message-ID: <20260912065633.959664471@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index bc74088c458ae..ebe97ba520ce0 100755
--- a/tools/testing/kunit/kunit.py
+++ b/tools/testing/kunit/kunit.py
@@ -121,7 +121,7 @@ def _list_tests(linux: kunit_kernel.LinuxSourceTree, request: KunitExecRequest)
 	lines.pop()
 
 	# Filter out any extraneous non-test output that might have gotten mixed in.
-	return [l for l in output if re.match(r'^[^\s.]+\.[^\s.]+$', l)]
+	return [l for l in lines if re.match(r'^[^\s.]+\.[^\s.]+$', l)]
 
 def _list_tests_attr(linux: kunit_kernel.LinuxSourceTree, request: KunitExecRequest) -> Iterable[str]:
 	args = ['kunit.action=list_attr']
diff --git a/tools/testing/kunit/kunit_tool_test.py b/tools/testing/kunit/kunit_tool_test.py
index 5254a25ad2d9d..052b3a9fb821a 100755
--- a/tools/testing/kunit/kunit_tool_test.py
+++ b/tools/testing/kunit/kunit_tool_test.py
@@ -826,6 +826,18 @@ class KUnitMainTest(unittest.TestCase):
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



