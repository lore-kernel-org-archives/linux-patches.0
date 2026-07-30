Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFF044C670;
	Thu, 30 Jul 2026 16:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427983; cv=none; b=qNKBtklY461GJLAx9x2swB/L70IIxnsrFn7rJ8g0uaLWU04meptnU7TdXVB4elCV9UhMiDI+qmXWLB3kKo51G7Yc5H0Oy5MqCqrC+oYEBMmcwH/0OQ52MSLB3ij/Rzjb2lfrzKyNPU1vgmQnNCUk7W7Sx6GtP6pDX6VQBz7toiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427983; c=relaxed/simple;
	bh=lNDsmEDcsQ/t6RklVY7Sm8aP663GJUi6/+OCOeCuG94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oza5qXeL6VAJdl4Gz98NivIlEcQMsP8GMz9n70+0KVjBhZFqiZdbp6PDtwFiGb7WfHs+WlIJkJUJyi7HbmObRNJpn4gB5eMuP/lHXNXHhSjvAxG4/8h7ZLxaHZ5P4HowbzCDCXdpWbCQ8aef/5Oo/IFRZ6HWxdJ3Q4IaW97QgZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k7p/frfC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k7p/frfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33571F000E9;
	Thu, 30 Jul 2026 16:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427982;
	bh=XSxLhZGVCLrMe2EpyHoXtnMUgeecLsUaaxOAZ0Kbo7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k7p/frfCu/PnHxuqfFjo2JKdwBHdDzSHaKqcpyocd98iFNTLjrN7oCBPBilEpQEOq
	 3+xipp2uYZTDir0Kf0aGVMNTBgWC4Yh5q5MiZ6JL9pcVZKm9wZTyqO8IpFFLhbHOYM
	 L00eMNfKXJQK1vIHsFS33EeeCRedq35594jA+1Zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.6 325/484] selftests/ftrace: Reset triggers at top level before instance loop
Date: Thu, 30 Jul 2026 16:13:42 +0200
Message-ID: <20260730141430.548620209@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 1a087033a6bad73b4140020b40e819b0933aafc3 upstream.

When running instance tests, 'ftracetest' creates a new ftrace instance
and runs the tests inside it. Before starting each test, it executes
'initialize_system()' to reset the ftrace state to initial-state.

However, since 'initialize_system()' is executed in the context of the
instance directory, it only cleans up triggers and filters of that
instance.
Any triggers or dynamic events left behind in the top-level instance by
previous failed top-level tests, are left completely untouched. These
top-level leftovers can cause subsequent instance-based tests to fail
or even crash the kernel.

Fix this by executing 'initialize_system()' in the top-level tracing
directory once before entering the instance loop.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/178425671889.84440.9477850701738666404.stgit@devnote2
Fixes: b5b77be812de ("selftests: ftrace: Allow some tests to be run in a tracing instance")
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/ftrace/ftracetest |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/ftrace/ftracetest
+++ b/tools/testing/selftests/ftrace/ftracetest
@@ -477,6 +477,7 @@ for t in $TEST_CASES; do
 done
 
 # Test on instance loop
+(cd $TRACING_DIR; initialize_system)
 INSTANCE=" (instance) "
 for t in $TEST_CASES; do
   test_on_instance $t || continue


