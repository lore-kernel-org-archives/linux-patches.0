Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E198F3C1D57;
	Sat, 12 Sep 2026 07:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197179; cv=none; b=TEWuSP1AN323Yg6ZjrBlqKQeiucZfhNyG8V0Zo3ZYdo6DaQZA24/gD3+ThFclSwQWKoQLpWJLe0Ry2MCYG+DvCfhJIcQ/0CKEFE3pOG/j/+VCxw0qEgldH+8sMh4eWTyw8Q2wy6GRTIXmTcp8x58BS+ZiAMP+7nvEXm69JvUhJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197179; c=relaxed/simple;
	bh=Qjqbxara1tXybGutLqJl/z3H6gfFDi+rmU2qQfaHU1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAr6eeGrI6wFp1FN0Zh97I0RwZJyv6jOPyFD8qDl9YOkSE8GAqmEBysdAUTLGXf2NrxiDjAbNiP9Yw6265907VUUg6l4gCj2xlxEAY3xkDhNeQ4HyzR9ZnqGjFcxRME0ChgBRN6+Rra5bGJld8I2JFtWR/eF9lNR+eTEKQ4X9nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bPrrsnBN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bPrrsnBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4780B1F000FF;
	Sat, 12 Sep 2026 07:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197177;
	bh=Z3Cdk1F/RkvbEyiHAQqBXrxT0j7rroXOJe4QPBCJ3Dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bPrrsnBN7uFY1neeHU/e7mPDuopLey282isn28rEp3NYzunzrA7xqWvWqIhD3SxLg
	 HSz4DYbiN6CMI9ZqE3kNk8KMw7F66mSOw86jLMmJGsqX2hOQBYkhPERGgFvzI6G5+A
	 4aDVfW4ScswVKGo16N1epHdJNauBnF7Ic4nJmiec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Ian Rogers <irogers@google.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0117/1815] perf test: Skip failing perf test aslr test case
Date: Sat, 12 Sep 2026 08:31:07 +0200
Message-ID: <20260912065651.755287464@linuxfoundation.org>
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

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit 5786fa53dc7a4ae027ee2dbf321ed2286c4c20b5 ]

The test case 'perf test aslr' fails on s390. The root cause of the
failure is subtest test_callchain_aslr. This test invokes command

 # ./perf record -g -e task-clock:u -o /tmp/perf-test-aslr \
	-- perf test -w noploop 3

to generate a call stack using event task-clock:u. On s390 this defaults
to '--call-graph dwarf' whereas on x86_64 this defaults to framepointer
(fp) format. The command

 # ./perf inject --aslr -i /tmp/perf-test-aslr

now scans all SAMPLE entries recorded in the perf.data file to convert
possible addresses. This is done in aslr_tool__process_sample() looking
at sample_type bits PERF_SAMPLE_IP, PERF_SAMPLE_TID,
PERF_SAMPLE_TIME, PERF_SAMPLE_PERIOD, PERF_SAMPLE_CALLCHAIN,
PERF_SAMPLE_REGS_USER and PERF_SAMPLE_STACK_USER.
On s390 the samples do not contain FP entries
of type PERF_SAMPLE_CALLCHAIN (the bit is set in sample_type, but the
number of FP entries is 0).
The processing enters the PERF_SAMPLE_STACK_USER portion where the
data is copied to the newly constructed sample and then aborted with
this warning:

 /* TODO: can this be less conservative? */
 pr_debug("Dropping stack user sample as possible ASLR leak\n");

With command line option '--call-graph dwarf' the new output file
does not contain any samples at all. This leads to a missing $new_addr
value in the shell script and a failure.

Fix this and skip this subtest. Emit a hint that this subtest is
currently unsupported on all platform when option --call-graph dwarf
is selected.
Since one subtest is skipped, the complete test is reported as
skipped.

Fixes: 190c45463844 ("perf test: Add inject ASLR test")
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Suggested-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/inject_aslr.sh | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/perf/tests/shell/inject_aslr.sh b/tools/perf/tests/shell/inject_aslr.sh
index c00461828ea79..d83c2591db8f6 100755
--- a/tools/perf/tests/shell/inject_aslr.sh
+++ b/tools/perf/tests/shell/inject_aslr.sh
@@ -135,8 +135,14 @@ test_callchain_aslr() {
     echo "Callchain ASLR test [Failed - no noploop samples in original file]"
     err=1
   elif [ -z "$new_addr" ]; then
-    echo "Callchain ASLR test [Failed - could not find remapped address]"
-    err=1
+    if perf evlist -v -i "${data}" | grep -q 'sample_type:.*STACK_USER'; then
+      echo "Dropping stack user sample as possible ASLR leak"
+      echo "Call-graph dwarf not supported with 'perf inject --aslr'"
+      echo "Callchain ASLR test [Skip]"
+    else
+      echo "Callchain ASLR test [Failed - could not find remapped address]"
+      err=1
+    fi
   elif [ "$orig_addr" = "$new_addr" ]; then
     echo "Callchain ASLR test [Failed - addresses are not remapped]"
     err=1
-- 
2.53.0



