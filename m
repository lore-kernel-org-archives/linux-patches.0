Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D502A331A61;
	Fri,  7 Aug 2026 14:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114706; cv=none; b=fmHyuKmqr+mP7fA+mb5TdKmaIDsGYC+rbJ/yDNZVm4QWr3sAwB5I/fVmWSVzJWnHdrE5tcaR/bqxABNIBiKtv8tb3nwmQPjlIcMMhpEanOAnPv/RP6gGlzhZo/qeynhdj+qen0n06k+G6LtwwidZGIFOLzQuIvJeSDV8TYaRCLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114706; c=relaxed/simple;
	bh=c18JxW6AThItmnvma3VRjU7mmSZdIwxb1SmM6CZ2NtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsXe5wcF6FaNf8mafdFRLwVFf2WQTujFQs/mdcKUx+bKcJKUZc9pmToWC0gn9WRg6b9QyHf6WiZ+cDNyivvEJAnXT65NSSnqSkEWxyJHQQzXvlYIyFwAAiELIxnzJUVzRMwF1OFPsFoW8l9ibqzSUpEUkCsACEc6A2o56VlfM3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LgEJuLUu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LgEJuLUu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370B61F000E9;
	Fri,  7 Aug 2026 14:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114704;
	bh=6etRDXVQN0rLEC22FDyTrMNIfvcn414dZxu2vWVfEI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LgEJuLUu502DzSZNEMDxTNfIAoAA+Bu7d+yC3GvE6svU1JirpVgWdiu6Mz/1OPanR
	 c2nwPTiUBKDQPUqmJofbHqxyg6SKO7wyJTxtjkxB6z/Ookj/CcPx2n6Ztk+szXVlFH
	 TvSh5OXJDWh6WCRdldp5aJ0c1j4ATrTv2OpxL2v0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	David Gow <david@davidgow.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 002/396] kunit: tool: skip stty when stdin is not a tty
Date: Fri,  7 Aug 2026 16:32:42 +0200
Message-ID: <20260807143424.328334248@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Shuvam Pandey <shuvampandey1@gmail.com>

[ Upstream commit e42c349f4cdfa43cb39a68c8f764f8cafc23a9a9 ]

run_kernel() cleanup and signal_handler() invoke stty unconditionally.
When stdin is not a tty (for example in CI or unit tests), this writes
noise to stderr.

Call stty only when stdin is a tty.

Add regression tests for these paths:
- run_kernel() with non-tty stdin
- signal_handler() with non-tty stdin
- signal_handler() with tty stdin

Signed-off-by: Shuvam Pandey <shuvampandey1@gmail.com>
Reviewed-by: David Gow <david@davidgow.net>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/kunit/kunit_kernel.py    | 10 ++++--
 tools/testing/kunit/kunit_tool_test.py | 42 ++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/tools/testing/kunit/kunit_kernel.py b/tools/testing/kunit/kunit_kernel.py
index 2998e1bc088b..b610fcf0715a 100644
--- a/tools/testing/kunit/kunit_kernel.py
+++ b/tools/testing/kunit/kunit_kernel.py
@@ -345,6 +345,12 @@ class LinuxSourceTree:
 			return False
 		return self.validate_config(build_dir)
 
+	def _restore_terminal_if_tty(self) -> None:
+		# stty requires a controlling terminal; skip headless runs.
+		if sys.stdin is None or not sys.stdin.isatty():
+			return
+		subprocess.call(['stty', 'sane'])
+
 	def run_kernel(self, args: Optional[List[str]]=None, build_dir: str='', filter_glob: str='', filter: str='', filter_action: Optional[str]=None, timeout: Optional[int]=None) -> Iterator[str]:
 		# Copy to avoid mutating the caller-supplied list. exec_tests() reuses
 		# the same args across repeated run_kernel() calls (e.g. --run_isolated),
@@ -386,8 +392,8 @@ class LinuxSourceTree:
 			process.stdout.close()
 
 			waiter.join()
-			subprocess.call(['stty', 'sane'])
+			self._restore_terminal_if_tty()
 
 	def signal_handler(self, unused_sig: int, unused_frame: Optional[FrameType]) -> None:
 		logging.error('Build interruption occurred. Cleaning console.')
-		subprocess.call(['stty', 'sane'])
+		self._restore_terminal_if_tty()
diff --git a/tools/testing/kunit/kunit_tool_test.py b/tools/testing/kunit/kunit_tool_test.py
index ed45bac1548d..0eb61de9abd4 100755
--- a/tools/testing/kunit/kunit_tool_test.py
+++ b/tools/testing/kunit/kunit_tool_test.py
@@ -515,6 +515,48 @@ class LinuxSourceTreeTest(unittest.TestCase):
 				self.assertIn('kunit.filter_glob=suite.test1', start_calls[0])
 				self.assertIn('kunit.filter_glob=suite.test2', start_calls[1])
 
+	def test_run_kernel_skips_terminal_reset_without_tty(self):
+		def fake_start(unused_args, unused_build_dir):
+			return subprocess.Popen(['printf', 'KTAP version 1\n'],
+						text=True, stdout=subprocess.PIPE)
+
+		non_tty_stdin = mock.Mock()
+		non_tty_stdin.isatty.return_value = False
+
+		with tempfile.TemporaryDirectory('') as build_dir:
+			tree = kunit_kernel.LinuxSourceTree(build_dir, kunitconfig_paths=[os.devnull])
+			with mock.patch.object(tree._ops, 'start', side_effect=fake_start), \
+			     mock.patch.object(kunit_kernel.sys, 'stdin', non_tty_stdin), \
+			     mock.patch.object(kunit_kernel.subprocess, 'call') as mock_call:
+				for _ in tree.run_kernel(build_dir=build_dir):
+					pass
+
+				mock_call.assert_not_called()
+
+	def test_signal_handler_skips_terminal_reset_without_tty(self):
+		non_tty_stdin = mock.Mock()
+		non_tty_stdin.isatty.return_value = False
+		tree = kunit_kernel.LinuxSourceTree('', kunitconfig_paths=[os.devnull])
+
+		with mock.patch.object(kunit_kernel.sys, 'stdin', non_tty_stdin), \
+		     mock.patch.object(kunit_kernel.subprocess, 'call') as mock_call, \
+		     mock.patch.object(kunit_kernel.logging, 'error') as mock_error:
+			tree.signal_handler(signal.SIGINT, None)
+			mock_error.assert_called_once()
+			mock_call.assert_not_called()
+
+	def test_signal_handler_resets_terminal_with_tty(self):
+		tty_stdin = mock.Mock()
+		tty_stdin.isatty.return_value = True
+		tree = kunit_kernel.LinuxSourceTree('', kunitconfig_paths=[os.devnull])
+
+		with mock.patch.object(kunit_kernel.sys, 'stdin', tty_stdin), \
+		     mock.patch.object(kunit_kernel.subprocess, 'call') as mock_call, \
+		     mock.patch.object(kunit_kernel.logging, 'error') as mock_error:
+			tree.signal_handler(signal.SIGINT, None)
+			mock_error.assert_called_once()
+			mock_call.assert_called_once_with(['stty', 'sane'])
+
 	def test_build_reconfig_no_config(self):
 		with tempfile.TemporaryDirectory('') as build_dir:
 			with open(kunit_kernel.get_kunitconfig_path(build_dir), 'w') as f:
-- 
2.53.0



