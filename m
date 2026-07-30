Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CB530C143;
	Thu, 30 Jul 2026 15:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426443; cv=none; b=WkIQICdlO1IVFsJL81+YUoKVvsKAZFiSvz1vuEW6rh7n2EyG3t6vlMr4W3Xxvg6UYm1GRejBxq6unYEwPrDqOMzFOMaPlqrFfKnYgl8eztp5i+fKkaNsq96bWLhY1YPTxdYNNMhR2ZZjVdSZPl4wMIuvUb4HaDEKpUeAeZYjlFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426443; c=relaxed/simple;
	bh=LClypfI5RENwUMn96GoWBc2tt1d4fV6zcbZ7IM7Wxpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n1vEEKSqaKnomnFNAyPyD0v2ROk+YWoiZqiqnsptU1jcfuVwCr6KeCXx57WS4rCG7l5BGYM6RBSTKfwK4pFrCnSk1xTYlbQBJjXwWNEDMESywBnkc6bg/Kjp03zjkRcWZBqLM1vO1Tkej7LDrQGc+3PLyRaw2Iv/xgZPja6DoDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kf0hhgqn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kf0hhgqn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D7A51F000E9;
	Thu, 30 Jul 2026 15:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426442;
	bh=jGWJY1EC2U1QR8qA8XBsGCEVEbhPBxrNV96SStz8exo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kf0hhgqnp3ZVNg59v4ZAcDHX/j2DojMpPh42yGiXPn8PuZBpp5qLNoQr3fZ9sBJ6f
	 9rU/knF6zQ2OaL54HSJeN+pkwu9LtdwtCZ2j3fUluh9e3ZpLPV4qWFYKhtjCfqytQ0
	 V1K3DLpo9lr38q6Vr+71WTahXCX1q9iklShyLfB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.12 419/602] selftests/ftrace: Reset triggers at top level before instance loop
Date: Thu, 30 Jul 2026 16:13:31 +0200
Message-ID: <20260730141444.770360697@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
@@ -483,6 +483,7 @@ for t in $TEST_CASES; do
 done
 
 # Test on instance loop
+(cd $TRACING_DIR; initialize_system)
 INSTANCE=" (instance) "
 for t in $TEST_CASES; do
   test_on_instance $t || continue


