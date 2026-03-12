Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D243242AC;
	Thu, 12 Mar 2026 20:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347082; cv=none; b=F8yTskd7YITZM3bw4WSCHTKRD6N6QECQttfJhiDEdH9uRqsQHQun0gVvKFvUUVS6TAQatoM3f0zQhbinORsU3LYBM9ikxjI8vcgsLh6FT5HqQ+ancPFSm5RO6FpQqbYucZs88ANZf+k3WEf46D/+gAl3ZrKqg3uwjkBrpfd0A8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347082; c=relaxed/simple;
	bh=4frWVZ/1M45gnL4J0Ml9e89+bvlrHSYVzm6iYpcAgSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JF7W4XI4dUiiQpogGs3Xi0p0eDzgxaeQwNsC1AQJS1tQ+t/ylM/RQa+/ftzQ6r9h0Xb89tNrv5iyj9sxilvFxCtbh367OU6LE0D2xHY6JAD6pyEXqAdzBEmAf/2wsUSOkzpmF03cqHWzthgM2yZQsVSz+CjTosTr9aFCPYBNiJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IcCn6I7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IcCn6I7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1ACAC4CEF7;
	Thu, 12 Mar 2026 20:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347082;
	bh=4frWVZ/1M45gnL4J0Ml9e89+bvlrHSYVzm6iYpcAgSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IcCn6I7spxwd+LefAp/h720C7qZk7ybrMrD95Wrwaodim/SUvsfYzTkaliNBSsO6I
	 HHyCDeujH2hTBFZa8XQ6t5X1MnZi44TwXR50aEYjCiB6X3807YxS3UxEdoU9PhjG50
	 dU4DMFVA69s5/oG3kFThcUUrthvhIodOGuneosDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	David Gow <david@davidgow.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 198/265] kunit: tool: copy caller args in run_kernel to prevent mutation
Date: Thu, 12 Mar 2026 21:09:45 +0100
Message-ID: <20260312201025.470261975@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 61931c4926fd6..12b0f2ee56656 100644
--- a/tools/testing/kunit/kunit_kernel.py
+++ b/tools/testing/kunit/kunit_kernel.py
@@ -333,8 +333,10 @@ class LinuxSourceTree:
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
index 2beb7327e53fc..70e5d0abe87f3 100755
--- a/tools/testing/kunit/kunit_tool_test.py
+++ b/tools/testing/kunit/kunit_tool_test.py
@@ -477,6 +477,32 @@ class LinuxSourceTreeTest(unittest.TestCase):
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



