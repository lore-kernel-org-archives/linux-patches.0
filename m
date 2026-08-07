Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815E83AD50F;
	Fri,  7 Aug 2026 14:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113794; cv=none; b=UMveHMXIql74uoBSawuwKo7gUDxUt34nu/n+xQWekGLBoomyUWEeedK/sMeCJUdU611ovOcHyX6eZwCA6pFVdtVxWOw1uWNtlVlg8OU8wy2I6HO7Wym5HRkH6TiTiDiGIYCl/TBdB6WEDajGeWu0aoPLX4azU/9vERDCrh/eQ04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113794; c=relaxed/simple;
	bh=2b2xTvjFli4hDRonW3yal0hPMeBqF+hN3krDpXTj5Ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lx44JGN+h+Fn2HKujUwkjnlxU3TrPBU8PWpU1yh5rgp6RByOi4Cs98JJS5mW/3JDgENhNdpbqJmUAa/Lr6yJH6nakradZLHaOBJ38yLBiYYRZWfh4bAWpRhTCO7QAb8qBEe86W//XaFdbUmj43UfbZpdBwCaVRNTn/QHbsxww+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rTLUtQvc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rTLUtQvc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729AD1F00A3E;
	Fri,  7 Aug 2026 14:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113777;
	bh=DV4tO1aYZC+idfgt0v5B0v3LrmX4fiimFwznVNgwtYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rTLUtQvcOuAF81f8UqYDSFgdFzPZ+SVzjCg5jgA8N5eYJAWa2Fh/5WT8TEq+W2JFT
	 zJ9XBPImQ36XMs7SwylZadBybxRfuVw5av+NdCgXbDzNUdV7RyKZgddoTzmpOpSSmj
	 vnWdyz0whHodfKvVCd8BarTlg6i+AGrycY4oafZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	David Gow <david@davidgow.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 008/337] kunit: tool: Terminate kernel under test on SIGINT
Date: Fri,  7 Aug 2026 16:33:31 +0200
Message-ID: <20260807143418.702656184@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: David Gow <david@davidgow.net>

commit 8f260b02eeeffbf2263c2b82b6e3e32fd73cde2b upstream.

kunit.py will attempt to catch SIGINT / ^C in order to ensure the TTY isn't
messed up, but never actually attempts to terminate the running kernel (be
it UML or QEMU). This can lead to a bit of frustration if the kernel has
crashed or hung.

Terminate the kernel process in the signal handler, if it's running. This
requires plumbing through the process handle in a few more places (and
having some checks to see if the kernel is still running in places where it
may have already been killed).

Reported-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Closes: https://lore.kernel.org/all/aaFmiAmg9S18EANA@smile.fi.intel.com/
Signed-off-by: David Gow <david@davidgow.net>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Tested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
[florian: resolved conflict in signal_handler(): upstream references
_restore_terminal_if_tty() which is introduced by the following commit;
retained subprocess.call(['stty', 'sane']) until that helper is available]
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/kunit/kunit_kernel.py | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/tools/testing/kunit/kunit_kernel.py b/tools/testing/kunit/kunit_kernel.py
index 12b0f2ee5665..3f2979f2f6ea 100644
--- a/tools/testing/kunit/kunit_kernel.py
+++ b/tools/testing/kunit/kunit_kernel.py
@@ -15,7 +15,7 @@ import shlex
 import shutil
 import signal
 import threading
-from typing import Iterator, List, Optional, Tuple
+from typing import Iterator, List, Optional, Tuple, Any
 from types import FrameType
 
 import kunit_config
@@ -252,6 +252,7 @@ class LinuxSourceTree:
 		if kconfig_add:
 			kconfig = kunit_config.parse_from_string('\n'.join(kconfig_add))
 			self._kconfig.merge_in_entries(kconfig)
+		self._process : Optional[subprocess.Popen[Any]] = None
 
 	def arch(self) -> str:
 		return self._arch
@@ -345,36 +346,45 @@ class LinuxSourceTree:
 			args.append('kunit.filter_action=' + filter_action)
 		args.append('kunit.enable=1')
 
-		process = self._ops.start(args, build_dir)
-		assert process.stdout is not None  # tell mypy it's set
+		self._process = self._ops.start(args, build_dir)
+		assert self._process is not None # tell mypy it's set
+		assert self._process.stdout is not None  # tell mypy it's set
 
 		# Enforce the timeout in a background thread.
 		def _wait_proc() -> None:
 			try:
-				process.wait(timeout=timeout)
+				if self._process:
+					self._process.wait(timeout=timeout)
 			except Exception as e:
 				print(e)
-				process.terminate()
-				process.wait()
+				if self._process:
+					self._process.terminate()
+					self._process.wait()
 		waiter = threading.Thread(target=_wait_proc)
 		waiter.start()
 
 		output = open(get_outfile_path(build_dir), 'w')
 		try:
 			# Tee the output to the file and to our caller in real time.
-			for line in process.stdout:
+			for line in self._process.stdout:
 				output.write(line)
 				yield line
 		# This runs even if our caller doesn't consume every line.
 		finally:
 			# Flush any leftover output to the file
-			output.write(process.stdout.read())
+			if self._process:
+				if self._process.stdout:
+					output.write(self._process.stdout.read())
+					self._process.stdout.close()
+				self._process = None
 			output.close()
-			process.stdout.close()
 
 			waiter.join()
 			subprocess.call(['stty', 'sane'])
 
 	def signal_handler(self, unused_sig: int, unused_frame: Optional[FrameType]) -> None:
 		logging.error('Build interruption occurred. Cleaning console.')
+		if self._process:
+				self._process.terminate()
+				self._process.wait()
 		subprocess.call(['stty', 'sane'])
-- 
2.53.0



