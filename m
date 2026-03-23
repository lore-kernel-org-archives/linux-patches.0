Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70ACF3B19AC;
	Mon, 23 Mar 2026 16:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282320; cv=none; b=peTOxrVeGmpTQXLb0HOwvPrRg1WolrrIVTpAqC4+NIhp7kw2RxA7+ISwYbnJTz7OFGKTExLCRsmzUAhXK8NKaldB1pEU8QYdOoGT7EFl2Gd+HvltIQSXOLiK6IdVJ/J3OKf/8BgEs3sMhHOr7o8kPjWgvYlHUAQy5TQ/9TdnrXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282320; c=relaxed/simple;
	bh=crQ0ukg+C4Qtjw44S7OUGVDvsqjI1hkruQVnct5y1zQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrCmE5c52sOFcx0q9J2VFwurIvqKmeRM169S5VgSjYD6T7uYoKvjybU33qqZFOxCFSwftxUEwgUo0awhay8OgrASHAYMKNyXn/+ncakGkgbXYA6EjOqbxkH6X7Qq+FfViQe+N9c9wyzU3AacviVXDVzKV8AwszMWU3Ax5JdEU2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Al6jiacH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Al6jiacH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DA4C2BC9E;
	Mon, 23 Mar 2026 16:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282320;
	bh=crQ0ukg+C4Qtjw44S7OUGVDvsqjI1hkruQVnct5y1zQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Al6jiacH2GIkGuMurmA15ALAe8sJVy9X+yh37deLjfhxbSaKEAZ+SRKKYKuvBD7Nw
	 U+v3JBkVbqdbD712Z01I5vq1NHuQ0htSydrd5dqjL4k58kAAs28o7h/83GytEQ3Cxl
	 JCatFtRQZgQtvyFBnolUgQgE0mD8LEzup364SqRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Pantyukhin <apantykhin@gmail.com>,
	David Gow <davidgow@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 113/481] kunit: kunit.py extract handlers
Date: Mon, 23 Mar 2026 14:41:35 +0100
Message-ID: <20260323134528.035773992@linuxfoundation.org>
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

From: Alexander Pantyukhin <apantykhin@gmail.com>

[ Upstream commit 2dc9d6ca52a47fd00822e818c2a5e48fc5fbbd53 ]

The main function contains a wide if-elif block that handles different
subcommands. It's possible to make code refactoring to extract
subcommands handlers.

Fixed commit summary line.
Shuah Khan <skhan@linuxfoundation.org>

Signed-off-by: Alexander Pantyukhin <apantykhin@gmail.com>
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Stable-dep-of: 40804c4974b8 ("kunit: tool: copy caller args in run_kernel to prevent mutation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/kunit/kunit.py | 167 ++++++++++++++++++++---------------
 1 file changed, 96 insertions(+), 71 deletions(-)

diff --git a/tools/testing/kunit/kunit.py b/tools/testing/kunit/kunit.py
index 43fbe96318fe1..8cd8188675047 100755
--- a/tools/testing/kunit/kunit.py
+++ b/tools/testing/kunit/kunit.py
@@ -395,6 +395,95 @@ def tree_from_args(cli_args: argparse.Namespace) -> kunit_kernel.LinuxSourceTree
 			extra_qemu_args=qemu_args)
 
 
+def run_handler(cli_args):
+	if not os.path.exists(cli_args.build_dir):
+		os.mkdir(cli_args.build_dir)
+
+	linux = tree_from_args(cli_args)
+	request = KunitRequest(build_dir=cli_args.build_dir,
+					make_options=cli_args.make_options,
+					jobs=cli_args.jobs,
+					raw_output=cli_args.raw_output,
+					json=cli_args.json,
+					timeout=cli_args.timeout,
+					filter_glob=cli_args.filter_glob,
+					kernel_args=cli_args.kernel_args,
+					run_isolated=cli_args.run_isolated)
+	result = run_tests(linux, request)
+	if result.status != KunitStatus.SUCCESS:
+		sys.exit(1)
+
+
+def config_handler(cli_args):
+	if cli_args.build_dir and (
+			not os.path.exists(cli_args.build_dir)):
+		os.mkdir(cli_args.build_dir)
+
+	linux = tree_from_args(cli_args)
+	request = KunitConfigRequest(build_dir=cli_args.build_dir,
+						make_options=cli_args.make_options)
+	result = config_tests(linux, request)
+	stdout.print_with_timestamp((
+		'Elapsed time: %.3fs\n') % (
+			result.elapsed_time))
+	if result.status != KunitStatus.SUCCESS:
+		sys.exit(1)
+
+
+def build_handler(cli_args):
+	linux = tree_from_args(cli_args)
+	request = KunitBuildRequest(build_dir=cli_args.build_dir,
+					make_options=cli_args.make_options,
+					jobs=cli_args.jobs)
+	result = config_and_build_tests(linux, request)
+	stdout.print_with_timestamp((
+		'Elapsed time: %.3fs\n') % (
+			result.elapsed_time))
+	if result.status != KunitStatus.SUCCESS:
+		sys.exit(1)
+
+
+def exec_handler(cli_args):
+	linux = tree_from_args(cli_args)
+	exec_request = KunitExecRequest(raw_output=cli_args.raw_output,
+					build_dir=cli_args.build_dir,
+					json=cli_args.json,
+					timeout=cli_args.timeout,
+					filter_glob=cli_args.filter_glob,
+					kernel_args=cli_args.kernel_args,
+					run_isolated=cli_args.run_isolated)
+	result = exec_tests(linux, exec_request)
+	stdout.print_with_timestamp((
+		'Elapsed time: %.3fs\n') % (result.elapsed_time))
+	if result.status != KunitStatus.SUCCESS:
+		sys.exit(1)
+
+
+def parse_handler(cli_args):
+	if cli_args.file is None:
+		sys.stdin.reconfigure(errors='backslashreplace')  # pytype: disable=attribute-error
+		kunit_output = sys.stdin
+	else:
+		with open(cli_args.file, 'r', errors='backslashreplace') as f:
+			kunit_output = f.read().splitlines()
+	# We know nothing about how the result was created!
+	metadata = kunit_json.Metadata()
+	request = KunitParseRequest(raw_output=cli_args.raw_output,
+					json=cli_args.json)
+	result, _ = parse_tests(request, metadata, kunit_output)
+	if result.status != KunitStatus.SUCCESS:
+		sys.exit(1)
+
+
+subcommand_handlers_map = {
+	'run': run_handler,
+	'config': config_handler,
+	'build': build_handler,
+	'exec': exec_handler,
+	'parse': parse_handler
+}
+
+
 def main(argv):
 	parser = argparse.ArgumentParser(
 			description='Helps writing and running KUnit tests.')
@@ -438,78 +527,14 @@ def main(argv):
 	if get_kernel_root_path():
 		os.chdir(get_kernel_root_path())
 
-	if cli_args.subcommand == 'run':
-		if not os.path.exists(cli_args.build_dir):
-			os.mkdir(cli_args.build_dir)
-
-		linux = tree_from_args(cli_args)
-		request = KunitRequest(build_dir=cli_args.build_dir,
-				       make_options=cli_args.make_options,
-				       jobs=cli_args.jobs,
-				       raw_output=cli_args.raw_output,
-				       json=cli_args.json,
-				       timeout=cli_args.timeout,
-				       filter_glob=cli_args.filter_glob,
-				       kernel_args=cli_args.kernel_args,
-				       run_isolated=cli_args.run_isolated)
-		result = run_tests(linux, request)
-		if result.status != KunitStatus.SUCCESS:
-			sys.exit(1)
-	elif cli_args.subcommand == 'config':
-		if cli_args.build_dir and (
-				not os.path.exists(cli_args.build_dir)):
-			os.mkdir(cli_args.build_dir)
-
-		linux = tree_from_args(cli_args)
-		request = KunitConfigRequest(build_dir=cli_args.build_dir,
-					     make_options=cli_args.make_options)
-		result = config_tests(linux, request)
-		stdout.print_with_timestamp((
-			'Elapsed time: %.3fs\n') % (
-				result.elapsed_time))
-		if result.status != KunitStatus.SUCCESS:
-			sys.exit(1)
-	elif cli_args.subcommand == 'build':
-		linux = tree_from_args(cli_args)
-		request = KunitBuildRequest(build_dir=cli_args.build_dir,
-					    make_options=cli_args.make_options,
-					    jobs=cli_args.jobs)
-		result = config_and_build_tests(linux, request)
-		stdout.print_with_timestamp((
-			'Elapsed time: %.3fs\n') % (
-				result.elapsed_time))
-		if result.status != KunitStatus.SUCCESS:
-			sys.exit(1)
-	elif cli_args.subcommand == 'exec':
-		linux = tree_from_args(cli_args)
-		exec_request = KunitExecRequest(raw_output=cli_args.raw_output,
-						build_dir=cli_args.build_dir,
-						json=cli_args.json,
-						timeout=cli_args.timeout,
-						filter_glob=cli_args.filter_glob,
-						kernel_args=cli_args.kernel_args,
-						run_isolated=cli_args.run_isolated)
-		result = exec_tests(linux, exec_request)
-		stdout.print_with_timestamp((
-			'Elapsed time: %.3fs\n') % (result.elapsed_time))
-		if result.status != KunitStatus.SUCCESS:
-			sys.exit(1)
-	elif cli_args.subcommand == 'parse':
-		if cli_args.file is None:
-			sys.stdin.reconfigure(errors='backslashreplace')  # pytype: disable=attribute-error
-			kunit_output = sys.stdin
-		else:
-			with open(cli_args.file, 'r', errors='backslashreplace') as f:
-				kunit_output = f.read().splitlines()
-		# We know nothing about how the result was created!
-		metadata = kunit_json.Metadata()
-		request = KunitParseRequest(raw_output=cli_args.raw_output,
-					    json=cli_args.json)
-		result, _ = parse_tests(request, metadata, kunit_output)
-		if result.status != KunitStatus.SUCCESS:
-			sys.exit(1)
-	else:
+	subcomand_handler = subcommand_handlers_map.get(cli_args.subcommand, None)
+
+	if subcomand_handler is None:
 		parser.print_help()
+		return
+
+	subcomand_handler(cli_args)
+
 
 if __name__ == '__main__':
 	main(sys.argv[1:])
-- 
2.51.0



