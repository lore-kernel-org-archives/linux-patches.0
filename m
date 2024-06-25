Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FBE1465A8;
	Tue, 25 Jun 2024 09:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308810; cv=none; b=ri422IdrgNZlWN6y7fzNm1WVJnftnzgf2M8AbLGexaGhQtg1KeokeOEcGlEsLKGtxUJO6nYaTiqpowJnIwGYgg/oUYz72dorH8ckbduqysxWYlDWI2xnnZzId6WihylVYxUg1gU1Z42xQ3AakcL8KR/eYEMLL6gN5s4djsdeHvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308810; c=relaxed/simple;
	bh=EBmS3TE58GE2EZSJOVSvE8xPkwLm2xUSSlKK3rAW6kI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kaNrD0XXHCES2UwRSRgAZS3TC876LUxU7zRih3ZhCH8iohjBiLsnArB6YR18Be/S0t/Kc6HUtVySl+kgCU/cZstxJhYiLJ2JaPPf7f4DGqLkIvC/DH2BUXrli7QNbk4CMqwmP8oBPQVJnMaMCB0Kim+MXHZ9FH6gcPHFlOhNYi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nG/Q0CH3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nG/Q0CH3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722D5C32786;
	Tue, 25 Jun 2024 09:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308809;
	bh=EBmS3TE58GE2EZSJOVSvE8xPkwLm2xUSSlKK3rAW6kI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nG/Q0CH3J+nngslJKQuyWvHJMOGTMh8qsYfuUlPt2Jz2DJHC6qm4b+AOxVnDlFJg7
	 1NTCtq0hBe3BraSIpaQxSehY4haeFHfXM7B086futdJO7/UWrgDVgtNHrvABDawATM
	 yflD3Nat/txrkoADGlKZp0s2nYfiM46DzqEk7Mog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Brennan <stephen.s.brennan@oracle.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Guo Ren <guoren@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.9 248/250] kprobe/ftrace: fix build error due to bad function definition
Date: Tue, 25 Jun 2024 11:33:26 +0200
Message-ID: <20240625085557.569728691@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 4b377b4868ef17b040065bd468668c707d2477a5 upstream.

Commit 1a7d0890dd4a ("kprobe/ftrace: bail out if ftrace was killed")
introduced a bad K&R function definition, which we haven't accepted in a
long long time.

Gcc seems to let it slide, but clang notices with the appropriate error:

  kernel/kprobes.c:1140:24: error: a function declaration without a prototype is deprecated in all >
   1140 | void kprobe_ftrace_kill()
        |                        ^
        |                         void

but this commit was apparently never in linux-next before it was sent
upstream, so it didn't get the appropriate build test coverage.

Fixes: 1a7d0890dd4a kprobe/ftrace: bail out if ftrace was killed
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1138,7 +1138,7 @@ static int disarm_kprobe_ftrace(struct k
 		ipmodify ? &kprobe_ipmodify_enabled : &kprobe_ftrace_enabled);
 }
 
-void kprobe_ftrace_kill()
+void kprobe_ftrace_kill(void)
 {
 	kprobe_ftrace_disabled = true;
 }


