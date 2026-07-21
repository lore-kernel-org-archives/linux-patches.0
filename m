Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148CB248F57;
	Tue, 21 Jul 2026 15:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649330; cv=none; b=H0fOeDOnc/QVQmsLmAXEmndEeScgONPy56cD8OJpJnhUucMt6VJDJWZbPBz9rnny0Azzf9Koo4P3BkNsQMizcG3QtmwzHGNcJyQlZEfWgNvy9qqVvBlOv1RwuVeHKsiIhwl6SKnrCNKVOgBHik/w7LQZFCDLtjCBPu7EE85OwtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649330; c=relaxed/simple;
	bh=F9lOGQYHNylnsZswjAi+j2RtMueGPUgrxVn++SyaOuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pfmnImOBCKQJQOxIsXpSkzp/BC7kOBS/C+HdjGGk9ISCm9K69zieT1PLR8xuxZa1eDQlktr0TIZ5xATRktPSnBYe/RSmZDmJIEqF5tC7FIUcv9bzmCIuQjqFC8D5Uy3HDLUm9BD+8rVwtju03+Pw63FrEt5oA3eZ0Qd7g7EwdGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mImQcIYZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mImQcIYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5DF1F000E9;
	Tue, 21 Jul 2026 15:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649329;
	bh=iAiDosREtwpOJBbLWKnlllr0lgoz09bgUmAFJNzUqYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mImQcIYZ0wb1onnuuktLNsuu0gJgPo6yxo9OQNS6bHCVo1ei6wvs6aVSisC79RuWx
	 bJP1df5euDQYdJTbTssYPgkZylkG5DI2wcyi8ZFhadWx2MR/JEDlf5WTsLMAbFfwAm
	 a6XeDgZuiZ8eaFxGOrgNRGk+58gy2X/GHq+xIlKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <david@davidgow.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0536/2077] kunit:tool: Dont write to stdout when it should be disabled
Date: Tue, 21 Jul 2026 17:03:29 +0200
Message-ID: <20260721152605.450326018@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Gow <david@davidgow.net>

[ Upstream commit 29afed142d64e181749214072315c976f8510bd7 ]

The kunit_parser module accepts a 'printer' object which is used as a
destination for all output. This is typically set to stdout, so that the
parsed results are visible, but can be set to a special 'null_printer' to
implement options where not all results are always printed.

However, there are a few places where use of stdout is hardcoded, notably
in handling crashed tests and in outputting the colour escape sequences.

Properly use the specified printer for all output. This is okay for the
colour handling (as this is already gated behind isatty() anyway), and also
for the crash handling, as cases where printer != stdout are separately
printed afterwards.

Link: https://lore.kernel.org/r/20260606020317.264178-1-david@davidgow.net
Fixes: 062a9dd9bad7 ("kunit: tool: Only print the summary")
Signed-off-by: David Gow <david@davidgow.net>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/kunit/kunit_parser.py | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/kunit/kunit_parser.py b/tools/testing/kunit/kunit_parser.py
index 1c61a0ed740d4b..266c9dd953512e 100644
--- a/tools/testing/kunit/kunit_parser.py
+++ b/tools/testing/kunit/kunit_parser.py
@@ -17,7 +17,7 @@ import textwrap
 from enum import Enum, auto
 from typing import Iterable, Iterator, List, Optional, Tuple
 
-from kunit_printer import Printer, stdout
+from kunit_printer import Printer
 
 class Test:
 	"""
@@ -57,7 +57,7 @@ class Test:
 	def add_error(self, printer: Printer, error_message: str) -> None:
 		"""Records an error that occurred while parsing this test."""
 		self.counts.errors += 1
-		printer.print_with_timestamp(stdout.red('[ERROR]') + f' Test: {self.name}: {error_message}')
+		printer.print_with_timestamp(printer.red('[ERROR]') + f' Test: {self.name}: {error_message}')
 
 	def ok_status(self) -> bool:
 		"""Returns true if the status was ok, i.e. passed or skipped."""
@@ -544,7 +544,7 @@ def format_test_result(test: Test, printer: Printer) -> str:
 		return printer.yellow('[NO TESTS RUN] ') + test.name
 	if test.status == TestStatus.TEST_CRASHED:
 		print_log(test.log, printer)
-		return stdout.red('[CRASHED] ') + test.name
+		return printer.red('[CRASHED] ') + test.name
 	print_log(test.log, printer)
 	return printer.red('[FAILED] ') + test.name
 
@@ -651,11 +651,11 @@ def print_summary_line(test: Test, printer: Printer) -> None:
 	printer - Printer object to output results
 	"""
 	if test.status == TestStatus.SUCCESS:
-		color = stdout.green
+		color = printer.green
 	elif test.status in (TestStatus.SKIPPED, TestStatus.NO_TESTS):
-		color = stdout.yellow
+		color = printer.yellow
 	else:
-		color = stdout.red
+		color = printer.red
 	printer.print_with_timestamp(color(f'Testing complete. {test.counts}'))
 
 	# Summarize failures that might have gone off-screen since we had a lot
-- 
2.53.0



