Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB8543F8A6;
	Thu, 30 Jul 2026 15:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424881; cv=none; b=RfLGBB2PqQxDNrDgJ/5iW7YkfpIA68BbM85y09DvrBC0P5WBJryLBQ8M+1+NfSxMMEPq3L/UaGIr2BTR/cuUL6Jh/vSz0ntHdgcpGHrMTo/JtAF1FxLsnMxdnXsM2C5+ldPVnEOFq/392dyj6HTC8/niToO0dAXQi27M2Yva640=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424881; c=relaxed/simple;
	bh=RDZND6fciwj6dOHwZzgiANpsF9RWgNenVW6+IOhmbR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JgjWg031MpPsBkU+dm8dUp8Hm1eDtXpCubZ+BFA9p0gOHFpY73DZ8O7QLCeMJ1rhW8bXHTqU3G1lYTwMd8jnJM9W8qwQp84h0N6WYA8kt+BeTF9cIfRy1WN4C+8j6+f3WxU+8ZZ1SKxX25vTV4RGO7F2vyQ1fFa+ebNi/LOkVb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aRhaFqHV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aRhaFqHV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A771F00A3F;
	Thu, 30 Jul 2026 15:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424880;
	bh=QA0ZFHX8KDtrlLkTFih4azRCNKY4ToraoKL5mySwvhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aRhaFqHVFX1FSqIkmYOFwqq8FZFhVHpSLSaYYWTF3bG6D+4vMjf85/VvaxNUKBbjC
	 cY/nWAqTtB9ElZf3HuMG6YGkW0RbPkQ+BFKN4nIUSAvYy3xGgJftuoAcZlmxswryfm
	 yAL2CQ/Vs20hsfnfy0rtmaUE/7CpBWNq5RnxP8P4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 547/675] selftests/ftrace: Reset triggers at top level before instance loop
Date: Thu, 30 Jul 2026 16:14:37 +0200
Message-ID: <20260730141456.769133871@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


