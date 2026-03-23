Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688783BC685;
	Mon, 23 Mar 2026 16:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282331; cv=none; b=an88iptnj2eYIDOy5nqSZ8423dQY2TSj/kWEzECol6DRj/BqFWV7b8A/uX4z1ANqxaKCTGux9M6U38FeOWTKDDwBOkBtUXQtfIMvYSJjUvPvsANZYiHK6fgC6XdFQompVBa0WBXR505cLrCFIdU3WZdt7UtPMxurYC+A7ApmkUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282331; c=relaxed/simple;
	bh=2rM3QNxpPIcYmP4FtSSlhwyPOa7Lmh3Wi9B1n5VKnSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCumXPJ75GmGQeW66X6gOz+LiyXKHZuhb52MKFVm+QGxGjSya+Fc5hG/PrRxUFOD+fAFY0ehSHokOxx+mR1mCz/GPVrEPTgP08YEstJP6M8ROHNKq1YQ3Q+mD+SPLarKoH1yYjIYnM6KZB3pjD0e5D8lmN+9o2OBN/QIIrX/Af0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RmbMHCH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RmbMHCH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC49EC4CEF7;
	Mon, 23 Mar 2026 16:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282331;
	bh=2rM3QNxpPIcYmP4FtSSlhwyPOa7Lmh3Wi9B1n5VKnSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RmbMHCH4mntT+bOM0xpjUbi4GbQtoa5MJJoat01ASomHMR1lhleBJJXBnNRfiRwWS
	 COpPEVxPicmPg8VZSJhsaFVN7D5um6mS6+ZiDKnXrJTCTUGPTh1f7AKhejEcFv4L4o
	 iXknSCbtyvVJrX/Aet61pfnuGWe1pan3boSBIf9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	David Gow <david@davidgow.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 117/481] kunit: tool: copy caller args in run_kernel to prevent mutation
Date: Mon, 23 Mar 2026 14:41:39 +0100
Message-ID: <20260323134528.134107519@linuxfoundation.org>
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

From: Shuvam Pandey <shuvampandey1@gmail.com>

[ Upstream commit 40804c4974b8df2adab72f6475d343eaff72b7f6 ]

run_kernel() appended KUnit flags directly to the caller-provided args
list. When exec_tests() calls run_kernel() repeatedly (e.g. with
--run_isolated), each call mutated the same list, causing later runs
to inherit stale filter_glob values and duplicate kunit.enable flags.

Fix this by copying args at the start of run_kernel(). Add a regression
test that calls run_kernel() twice with the same list and verifies the
original remains unchanged.

Fixes: ff9e09a3762f ("kunit: tool: support running each suite/test separately")
Signed-off-by: Shuvam Pandey <shuvampandey1@gmail.com>
Reviewed-by: David Gow <david@davidgow.net>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/kunit/kunit_kernel.py    |  6 ++++--
 tools/testing/kunit/kunit_tool_test.py | 26 ++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/tools/testing/kunit/kunit_kernel.py b/tools/testing/kunit/kunit_kernel.py
index 86accd53644c1..2343f9a77a65a 100644
--- a/tools/testing/kunit/kunit_kernel.py
+++ b/tools/testing/kunit/kunit_kernel.py
@@ -330,8 +330,10 @@ class LinuxSourceTree:
 		return self.validate_config(build_dir)
 
 	def run_kernel(self, args: Optional[List[str]]=None, build_dir: str='', filter_glob: str='', filter: str='', filter_action: Optional[str]=None, timeout: Optional[int]=None) -> Iterator[str]:
-		if not args:
-			args = []
+		# Copy to avoid mutating the caller-supplied list. exec_tests() reuses
+		# the same args across repeated run_kernel() calls (e.g. --run_isolated),
+		# so appending to the original would accumulate stale flags on each call.
+		args = list(args) if args else []
 		if filter_glob:
 			args.append('kunit.filter_glob=' + filter_glob)
 		if filter:
diff --git a/tools/testing/kunit/kunit_tool_test.py b/tools/testing/kunit/kunit_tool_test.py
index 04714f59fced6..29063d9ae2851 100755
--- a/tools/testing/kunit/kunit_tool_test.py
+++ b/tools/testing/kunit/kunit_tool_test.py
@@ -479,6 +479,32 @@ class LinuxSourceTreeTest(unittest.TestCase):
 			with open(kunit_kernel.get_outfile_path(build_dir), 'rt') as outfile:
 				self.assertEqual(outfile.read(), 'hi\nbye\n', msg='Missing some output')
 
+	def test_run_kernel_args_not_mutated(self):
+		"""Verify run_kernel() copies args so callers can reuse them."""
+		start_calls = []
+
+		def fake_start(start_args, unused_build_dir):
+			start_calls.append(list(start_args))
+			return subprocess.Popen(['printf', 'KTAP version 1\n'],
+						text=True, stdout=subprocess.PIPE)
+
+		with tempfile.TemporaryDirectory('') as build_dir:
+			tree = kunit_kernel.LinuxSourceTree(build_dir,
+					kunitconfig_paths=[os.devnull])
+			with mock.patch.object(tree._ops, 'start', side_effect=fake_start), \
+			     mock.patch.object(kunit_kernel.subprocess, 'call'):
+				kernel_args = ['mem=1G']
+				for _ in tree.run_kernel(args=kernel_args, build_dir=build_dir,
+							 filter_glob='suite.test1'):
+					pass
+				for _ in tree.run_kernel(args=kernel_args, build_dir=build_dir,
+							 filter_glob='suite.test2'):
+					pass
+				self.assertEqual(kernel_args, ['mem=1G'],
+					'run_kernel() should not modify caller args')
+				self.assertIn('kunit.filter_glob=suite.test1', start_calls[0])
+				self.assertIn('kunit.filter_glob=suite.test2', start_calls[1])
+
 	def test_build_reconfig_no_config(self):
 		with tempfile.TemporaryDirectory('') as build_dir:
 			with open(kunit_kernel.get_kunitconfig_path(build_dir), 'w') as f:
-- 
2.51.0



