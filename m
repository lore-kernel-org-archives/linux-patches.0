Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF092BF3E2;
	Tue, 10 Mar 2026 11:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141226; cv=none; b=QdUWJwQbbxD9oDByNM9Gsoxb8ko8cIMLdcxUdMWx5a5ranyQ34ImJ1x2euojZKkZo+HOgDM5IXl2apvUlE5SVym1rstuNkEeJ47ViRqX3pGcNFyNtGeFquUXNQLKy5X6U9w7wLP9gi91W6amPrEhqrwQ48V4wmpZV6ZVQJQWzCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141226; c=relaxed/simple;
	bh=GUSNiT8MSd3OGkCF/I80ZRL2IOjeAAQhiKpZ8NY23wE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S72A/KWypC/CfJQIYMgVbYa3MJBzFSX8xPb4odYOc3P7aZvwzVFOndw1Q7gXB0uQkKuUQJzLjZNn7QGCtoUNb3pEIRyfO0c05wDWfNUX1EypPjAZMSpew8dKkUA2avvUAh/P1VW3dipCwKXJBtX/vA4qIEJJiedHHsNhgj+mRq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sO5AQlTc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sO5AQlTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A806C19423;
	Tue, 10 Mar 2026 11:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141226;
	bh=GUSNiT8MSd3OGkCF/I80ZRL2IOjeAAQhiKpZ8NY23wE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sO5AQlTcsNF/k7JDCjqT3Uka/+975iwQhQwyASDqwslneibnipVebUzoGH5lfQit6
	 lCk2rZzHo+44ANts8RejHkR36msJZgVp1OANffsAl9Y4E0e++sMa/BFymJmPRvgBDD
	 SkB/VtM0HHLSOk7zHe1MwkH/X2kRt35iQUg+De3UpuQg4hpp1LOlSSWFOSUe7JCNH3
	 DuwQaT6rYtkhNOPntHSutLCH83m+SUg235VYwQ8hL7UwLa4oIc27bCf/YOhP3esUrl
	 0Zzx/C9p5Vltn25wvQ1VEhJL+nBFnWv1qi8pn97ZTqr89KaxgxGTU2coJGeaqJ6cGe
	 KiBruokGla/2A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shuvam Pandey <shuvampandey1@gmail.com>,
	David Gow <david@davidgow.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 228/311] kunit: tool: copy caller args in run_kernel to prevent mutation
Date: Tue, 10 Mar 2026 07:04:35 -0400
Message-ID: <f5c66764ac7d5ee71ff107398e3329ef1630d6bd.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 260d8d9aa1db4..2998e1bc088b2 100644
--- a/tools/testing/kunit/kunit_kernel.py
+++ b/tools/testing/kunit/kunit_kernel.py
@@ -346,8 +346,10 @@ class LinuxSourceTree:
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
index bbba921e0eacb..ed45bac1548d9 100755
--- a/tools/testing/kunit/kunit_tool_test.py
+++ b/tools/testing/kunit/kunit_tool_test.py
@@ -489,6 +489,32 @@ class LinuxSourceTreeTest(unittest.TestCase):
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

