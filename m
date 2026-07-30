Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915982D7393;
	Thu, 30 Jul 2026 14:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423109; cv=none; b=Si3nObRCW0qwKCMbUJuct0L/U72P8C6VoWWvvikxJPtzY1KkL3WAwyYpl+ItraNMBVQ/rVNklk4YVK5qGrls6YoF6m/lZ3usPAgNQc3Oa3gFQiTXj/+d9A/LxAnpc9/LaxzuRvk8ZFy5jrrgLvrLJjP4Q9r/erj7b0chMKwwaG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423109; c=relaxed/simple;
	bh=FYOKKsqn0Qoa75EbW/4KumyR4yQLH1wjkQ/snn5dFFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iUNLsRxgC+5JbEKErad/5QFgRmhgohYJRB0hFjNezRL9hSRw1+r0VSYwtZEsiMvpFLkxXff5CVBoSqx3fHD+YLFHRfG+L06OKwH5LDeCIJ8mg2vaZxgV0Rdn1l1XlGBDpzTIkwi9lZssHr80k0IekpT/ki9JkwaKsPrQSjYRJo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yUsDYWj6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yUsDYWj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28821F000E9;
	Thu, 30 Jul 2026 14:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423108;
	bh=XpvhL/XUiPqCnVDQhE9mhunJ9QB6x0XMPnw3dZl7O6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yUsDYWj6HSfrqsI6NiS8kBvS2vpslMJykLyxGsI7OLVybrbET0HwuZle1unnt2fYI
	 IgOjsZmrzcelPsloSS5L+/D7dqLOfT+D1jffdVoL3Rbu/oA9t0InCWdumepBaUih8+
	 fr0/AFYlN49PnDOOc5lE/oJalxApJAwhg2LGeN/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.1 669/744] selftests/ftrace: Reset triggers at top level before instance loop
Date: Thu, 30 Jul 2026 16:15:42 +0200
Message-ID: <20260730141458.484028078@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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
@@ -503,6 +503,7 @@ for t in $TEST_CASES; do
 done
 
 # Test on instance loop
+(cd $TRACING_DIR; initialize_system)
 INSTANCE=" (instance) "
 for t in $TEST_CASES; do
   test_on_instance $t || continue


