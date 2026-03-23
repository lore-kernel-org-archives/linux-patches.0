Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D713B19AC;
	Mon, 23 Mar 2026 16:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282325; cv=none; b=Jyx4FHOoE45pKx940G984lT0xr3Y1eGiN+VDXwaWx95MSM9/ADs+lMHyyWHlrNTCUbtnWMDAt6Q3/7fnjVwPur2dFwsArC9bub6x25pk6T1PKF6jKVSioUJWxoZK5kq8hFfF7WTDjWHEM3RpDi3HStypiYaXeIa5wsf55XeUkgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282325; c=relaxed/simple;
	bh=qfiDyt8HMONYVqIUtEut9uobTe3rZYvTcKaCiy3rtlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DioCgDyRjjtaWSwL0Y7H9uhpHow9tzkVLYklSlRq0Dtw9hoVK6iWIy6/HiL1UHiIgjApujItcrLkHo4zhFKl7XdZQsGS7AysQa8ABHns8fiNHqR0GWNFJlGgfr+dWUACesONGI7rXI9kjovag0en5I+Og7fVFWJIwjutWhZRfME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KBQ7RdKy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KBQ7RdKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31CCAC4CEF7;
	Mon, 23 Mar 2026 16:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282325;
	bh=qfiDyt8HMONYVqIUtEut9uobTe3rZYvTcKaCiy3rtlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KBQ7RdKya8hPQKJn40nsmZnq+DnT/eeEB+XCGE93dhUmWRQUr80u1O7K9HfHj6rv2
	 uVqvwl39lrOhtPANJXTMPOrjTAra+xUzBYWdlddrqu1/aUU1a10+5QIchw5d8hcZvm
	 KyOAmYccz+XGaqe+c3V3WxL1iy6B+6Ju380BW4zU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Daniel Latypov <dlatypov@google.com>,
	David Gow <davidgow@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 115/481] kunit: tool: fix pre-existing `mypy --strict` errors and update run_checks.py
Date: Mon, 23 Mar 2026 14:41:37 +0100
Message-ID: <20260323134528.081879297@linuxfoundation.org>
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

[ Upstream commit 1da2e6220e1115930694c649605534baf6fa3dea ]

Basically, get this command to be happy and make run_checks.py happy
 $ mypy --strict --exclude '_test.py$' --exclude qemu_configs/ ./tools/testing/kunit/

Primarily the changes are
* add `-> None` return type annotations
* add all the missing argument type annotations

Previously, we had false positives from mypy in `main()`, see commit
09641f7c7d8f ("kunit: tool: surface and address more typing issues").
But after commit 2dc9d6ca52a4 ("kunit: kunit.py extract handlers")
refactored things, the variable name reuse mypy hated is gone.

Note: mypy complains we don't annotate the types the unused args in our
signal handler. That's silly.
But to make it happy, I've copy-pasted an appropriate annotation from
https://github.com/python/typing/discussions/1042#discussioncomment-2013595.

Reported-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/linux-kselftest/9a172b50457f4074af41fe1dc8e55dcaf4795d7e.camel@sipsolutions.net/
Signed-off-by: Daniel Latypov <dlatypov@google.com>
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Stable-dep-of: 40804c4974b8 ("kunit: tool: copy caller args in run_kernel to prevent mutation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/kunit/kunit.py        | 24 ++++++++++++------------
 tools/testing/kunit/kunit_config.py |  4 ++--
 tools/testing/kunit/kunit_kernel.py | 29 +++++++++++++++--------------
 tools/testing/kunit/run_checks.py   |  4 ++--
 4 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/tools/testing/kunit/kunit.py b/tools/testing/kunit/kunit.py
index 172db04b48f42..1ed7f0f86dee3 100755
--- a/tools/testing/kunit/kunit.py
+++ b/tools/testing/kunit/kunit.py
@@ -278,7 +278,7 @@ def massage_argv(argv: Sequence[str]) -> Sequence[str]:
 def get_default_jobs() -> int:
 	return len(os.sched_getaffinity(0))
 
-def add_common_opts(parser) -> None:
+def add_common_opts(parser: argparse.ArgumentParser) -> None:
 	parser.add_argument('--build_dir',
 			    help='As in the make command, it specifies the build '
 			    'directory.',
@@ -329,13 +329,13 @@ def add_common_opts(parser) -> None:
 			    help='Additional QEMU arguments, e.g. "-smp 8"',
 			    action='append', metavar='')
 
-def add_build_opts(parser) -> None:
+def add_build_opts(parser: argparse.ArgumentParser) -> None:
 	parser.add_argument('--jobs',
 			    help='As in the make command, "Specifies  the number of '
 			    'jobs (commands) to run simultaneously."',
 			    type=int, default=get_default_jobs(), metavar='N')
 
-def add_exec_opts(parser) -> None:
+def add_exec_opts(parser: argparse.ArgumentParser) -> None:
 	parser.add_argument('--timeout',
 			    help='maximum number of seconds to allow for all tests '
 			    'to run. This does not include time taken to build the '
@@ -360,7 +360,7 @@ def add_exec_opts(parser) -> None:
 			    type=str,
 			    choices=['suite', 'test'])
 
-def add_parse_opts(parser) -> None:
+def add_parse_opts(parser: argparse.ArgumentParser) -> None:
 	parser.add_argument('--raw_output', help='If set don\'t parse output from kernel. '
 			    'By default, filters to just KUnit output. Use '
 			    '--raw_output=all to show everything',
@@ -395,7 +395,7 @@ def tree_from_args(cli_args: argparse.Namespace) -> kunit_kernel.LinuxSourceTree
 			extra_qemu_args=qemu_args)
 
 
-def run_handler(cli_args):
+def run_handler(cli_args: argparse.Namespace) -> None:
 	if not os.path.exists(cli_args.build_dir):
 		os.mkdir(cli_args.build_dir)
 
@@ -414,7 +414,7 @@ def run_handler(cli_args):
 		sys.exit(1)
 
 
-def config_handler(cli_args):
+def config_handler(cli_args: argparse.Namespace) -> None:
 	if cli_args.build_dir and (
 			not os.path.exists(cli_args.build_dir)):
 		os.mkdir(cli_args.build_dir)
@@ -430,7 +430,7 @@ def config_handler(cli_args):
 		sys.exit(1)
 
 
-def build_handler(cli_args):
+def build_handler(cli_args: argparse.Namespace) -> None:
 	linux = tree_from_args(cli_args)
 	request = KunitBuildRequest(build_dir=cli_args.build_dir,
 					make_options=cli_args.make_options,
@@ -443,7 +443,7 @@ def build_handler(cli_args):
 		sys.exit(1)
 
 
-def exec_handler(cli_args):
+def exec_handler(cli_args: argparse.Namespace) -> None:
 	linux = tree_from_args(cli_args)
 	exec_request = KunitExecRequest(raw_output=cli_args.raw_output,
 					build_dir=cli_args.build_dir,
@@ -459,10 +459,10 @@ def exec_handler(cli_args):
 		sys.exit(1)
 
 
-def parse_handler(cli_args):
+def parse_handler(cli_args: argparse.Namespace) -> None:
 	if cli_args.file is None:
-		sys.stdin.reconfigure(errors='backslashreplace')  # pytype: disable=attribute-error
-		kunit_output = sys.stdin
+		sys.stdin.reconfigure(errors='backslashreplace')  # type: ignore
+		kunit_output = sys.stdin  # type: Iterable[str]
 	else:
 		with open(cli_args.file, 'r', errors='backslashreplace') as f:
 			kunit_output = f.read().splitlines()
@@ -484,7 +484,7 @@ subcommand_handlers_map = {
 }
 
 
-def main(argv):
+def main(argv: Sequence[str]) -> None:
 	parser = argparse.ArgumentParser(
 			description='Helps writing and running KUnit tests.')
 	subparser = parser.add_subparsers(dest='subcommand')
diff --git a/tools/testing/kunit/kunit_config.py b/tools/testing/kunit/kunit_config.py
index 9f76d7b896175..eb5dd01210b1b 100644
--- a/tools/testing/kunit/kunit_config.py
+++ b/tools/testing/kunit/kunit_config.py
@@ -8,7 +8,7 @@
 
 from dataclasses import dataclass
 import re
-from typing import Dict, Iterable, List, Tuple
+from typing import Any, Dict, Iterable, List, Tuple
 
 CONFIG_IS_NOT_SET_PATTERN = r'^# CONFIG_(\w+) is not set$'
 CONFIG_PATTERN = r'^CONFIG_(\w+)=(\S+|".*")$'
@@ -34,7 +34,7 @@ class Kconfig:
 	def __init__(self) -> None:
 		self._entries = {}  # type: Dict[str, str]
 
-	def __eq__(self, other) -> bool:
+	def __eq__(self, other: Any) -> bool:
 		if not isinstance(other, self.__class__):
 			return False
 		return self._entries == other._entries
diff --git a/tools/testing/kunit/kunit_kernel.py b/tools/testing/kunit/kunit_kernel.py
index cd73256c30c39..faf90dcfed32d 100644
--- a/tools/testing/kunit/kunit_kernel.py
+++ b/tools/testing/kunit/kunit_kernel.py
@@ -16,6 +16,7 @@ import shutil
 import signal
 import threading
 from typing import Iterator, List, Optional, Tuple
+from types import FrameType
 
 import kunit_config
 import qemu_config
@@ -56,7 +57,7 @@ class LinuxSourceTreeOperations:
 	def make_arch_config(self, base_kunitconfig: kunit_config.Kconfig) -> kunit_config.Kconfig:
 		return base_kunitconfig
 
-	def make_olddefconfig(self, build_dir: str, make_options) -> None:
+	def make_olddefconfig(self, build_dir: str, make_options: Optional[List[str]]) -> None:
 		command = ['make', 'ARCH=' + self._linux_arch, 'O=' + build_dir, 'olddefconfig']
 		if self._cross_compile:
 			command += ['CROSS_COMPILE=' + self._cross_compile]
@@ -70,7 +71,7 @@ class LinuxSourceTreeOperations:
 		except subprocess.CalledProcessError as e:
 			raise ConfigError(e.output.decode())
 
-	def make(self, jobs, build_dir: str, make_options) -> None:
+	def make(self, jobs: int, build_dir: str, make_options: Optional[List[str]]) -> None:
 		command = ['make', 'ARCH=' + self._linux_arch, 'O=' + build_dir, '--jobs=' + str(jobs)]
 		if make_options:
 			command.extend(make_options)
@@ -132,7 +133,7 @@ class LinuxSourceTreeOperationsQemu(LinuxSourceTreeOperations):
 class LinuxSourceTreeOperationsUml(LinuxSourceTreeOperations):
 	"""An abstraction over command line operations performed on a source tree."""
 
-	def __init__(self, cross_compile=None):
+	def __init__(self, cross_compile: Optional[str]=None):
 		super().__init__(linux_arch='um', cross_compile=cross_compile)
 
 	def make_arch_config(self, base_kunitconfig: kunit_config.Kconfig) -> kunit_config.Kconfig:
@@ -215,7 +216,7 @@ def _get_qemu_ops(config_path: str,
 
 	if not hasattr(config, 'QEMU_ARCH'):
 		raise ValueError('qemu_config module missing "QEMU_ARCH": ' + config_path)
-	params: qemu_config.QemuArchParams = config.QEMU_ARCH  # type: ignore
+	params: qemu_config.QemuArchParams = config.QEMU_ARCH
 	if extra_qemu_args:
 		params.extra_qemu_params.extend(extra_qemu_args)
 	return params.linux_arch, LinuxSourceTreeOperationsQemu(
@@ -229,10 +230,10 @@ class LinuxSourceTree:
 	      build_dir: str,
 	      kunitconfig_paths: Optional[List[str]]=None,
 	      kconfig_add: Optional[List[str]]=None,
-	      arch=None,
-	      cross_compile=None,
-	      qemu_config_path=None,
-	      extra_qemu_args=None) -> None:
+	      arch: Optional[str]=None,
+	      cross_compile: Optional[str]=None,
+	      qemu_config_path: Optional[str]=None,
+	      extra_qemu_args: Optional[List[str]]=None) -> None:
 		signal.signal(signal.SIGINT, self.signal_handler)
 		if qemu_config_path:
 			self._arch, self._ops = _get_qemu_ops(qemu_config_path, extra_qemu_args, cross_compile)
@@ -275,7 +276,7 @@ class LinuxSourceTree:
 		logging.error(message)
 		return False
 
-	def build_config(self, build_dir: str, make_options) -> bool:
+	def build_config(self, build_dir: str, make_options: Optional[List[str]]) -> bool:
 		kconfig_path = get_kconfig_path(build_dir)
 		if build_dir and not os.path.exists(build_dir):
 			os.mkdir(build_dir)
@@ -303,7 +304,7 @@ class LinuxSourceTree:
 		old_kconfig = kunit_config.parse_file(old_path)
 		return old_kconfig != self._kconfig
 
-	def build_reconfig(self, build_dir: str, make_options) -> bool:
+	def build_reconfig(self, build_dir: str, make_options: Optional[List[str]]) -> bool:
 		"""Creates a new .config if it is not a subset of the .kunitconfig."""
 		kconfig_path = get_kconfig_path(build_dir)
 		if not os.path.exists(kconfig_path):
@@ -319,7 +320,7 @@ class LinuxSourceTree:
 		os.remove(kconfig_path)
 		return self.build_config(build_dir, make_options)
 
-	def build_kernel(self, jobs, build_dir: str, make_options) -> bool:
+	def build_kernel(self, jobs: int, build_dir: str, make_options: Optional[List[str]]) -> bool:
 		try:
 			self._ops.make_olddefconfig(build_dir, make_options)
 			self._ops.make(jobs, build_dir, make_options)
@@ -328,7 +329,7 @@ class LinuxSourceTree:
 			return False
 		return self.validate_config(build_dir)
 
-	def run_kernel(self, args=None, build_dir='', filter_glob='', timeout=None) -> Iterator[str]:
+	def run_kernel(self, args: Optional[List[str]]=None, build_dir: str='', filter_glob: str='', timeout: Optional[int]=None) -> Iterator[str]:
 		if not args:
 			args = []
 		if filter_glob:
@@ -339,7 +340,7 @@ class LinuxSourceTree:
 		assert process.stdout is not None  # tell mypy it's set
 
 		# Enforce the timeout in a background thread.
-		def _wait_proc():
+		def _wait_proc() -> None:
 			try:
 				process.wait(timeout=timeout)
 			except Exception as e:
@@ -365,6 +366,6 @@ class LinuxSourceTree:
 			waiter.join()
 			subprocess.call(['stty', 'sane'])
 
-	def signal_handler(self, unused_sig, unused_frame) -> None:
+	def signal_handler(self, unused_sig: int, unused_frame: Optional[FrameType]) -> None:
 		logging.error('Build interruption occurred. Cleaning console.')
 		subprocess.call(['stty', 'sane'])
diff --git a/tools/testing/kunit/run_checks.py b/tools/testing/kunit/run_checks.py
index 066e6f938f6dc..d061cf1ca4a59 100755
--- a/tools/testing/kunit/run_checks.py
+++ b/tools/testing/kunit/run_checks.py
@@ -23,7 +23,7 @@ commands: Dict[str, Sequence[str]] = {
 	'kunit_tool_test.py': ['./kunit_tool_test.py'],
 	'kunit smoke test': ['./kunit.py', 'run', '--kunitconfig=lib/kunit', '--build_dir=kunit_run_checks'],
 	'pytype': ['/bin/sh', '-c', 'pytype *.py'],
-	'mypy': ['/bin/sh', '-c', 'mypy *.py'],
+	'mypy': ['mypy', '--strict', '--exclude', '_test.py$', '--exclude', 'qemu_configs/', '.'],
 }
 
 # The user might not have mypy or pytype installed, skip them if so.
@@ -73,7 +73,7 @@ def main(argv: Sequence[str]) -> None:
 		sys.exit(1)
 
 
-def run_cmd(argv: Sequence[str]):
+def run_cmd(argv: Sequence[str]) -> None:
 	subprocess.check_output(argv, stderr=subprocess.STDOUT, cwd=ABS_TOOL_PATH, timeout=TIMEOUT)
 
 
-- 
2.51.0



