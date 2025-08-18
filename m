Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92BE3203B7;
	Mon, 18 Aug 2025 13:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524552; cv=none; b=pX6TWuF3U4M2RnXXi/BJp2N7wVTHPziFptEhn1JpTM8rJnPkaf2nXKlEO5kX0qF3wKitOHod/ENZaRUzIJSw9qG9w5+d3RcRgv28GZIsuCbExmdKiJlDOSemyQQ9qqRSgy9spJY4qtlJ1+vLNL4ZmOpaHO+MqybHfK3UD/mzDGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524552; c=relaxed/simple;
	bh=rVG1KbRJmedReq+xKzlPL4JKsB3H63H3GicAjTg4EGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CEQntKB+3TqIa/OQucRdAXOVawQBNpVa9hLRGFtBcz6SOOin+Rn58MbmT0/x7RPKBdIr42D9y6XW6SpPB5kjUH0lgxpS3wc+5l5qYgprtiIV6uEn8LY+8nhTZmmiWlB/Db/M43oE49RfxKtyxOrPq9b5JB+QhGnqdzuBBqk9U8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CY08oyUM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CY08oyUM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0F0C4CEF1;
	Mon, 18 Aug 2025 13:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524552;
	bh=rVG1KbRJmedReq+xKzlPL4JKsB3H63H3GicAjTg4EGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CY08oyUM0BYgxKGDuSg7mVrpUBiiQV+TcrdHh7ovhcyAyUkojRVUGoVDTZ8tLFHmP
	 rz29PNJXkjXfSkQNLzoyBUYvsHTjEk2BQmDTOZy6+ObKUep2AXdSOjwMINN4RKZkUy
	 DOhvAHQUK1AVChSigCVJTcIz++WoeJGaPIu/wZ+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.15 500/515] tracing: fprobe: Fix infinite recursion using preempt_*_notrace()
Date: Mon, 18 Aug 2025 14:48:06 +0200
Message-ID: <20250818124517.697877472@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit a3e892ab0fc287389176eabdcd74234508f6e52d upstream.

Since preempt_count_add/del() are tracable functions, it is not allowed
to use preempt_disable/enable() in ftrace handlers. Without this fix,
probing on `preempt_count_add%return` will cause an infinite recursion
of fprobes.

To fix this problem, use preempt_disable/enable_notrace() in
fprobe_return().

Link: https://lore.kernel.org/all/175374642359.1471729.1054175011228386560.stgit@mhiramat.tok.corp.google.com/

Fixes: 4346ba160409 ("fprobe: Rewrite fprobe on function-graph tracer")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/fprobe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
index ba7ff14f5339..f9b3aa9afb17 100644
--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -352,7 +352,7 @@ static void fprobe_return(struct ftrace_graph_ret *trace,
 	size_words = SIZE_IN_LONG(size);
 	ret_ip = ftrace_regs_get_instruction_pointer(fregs);
 
-	preempt_disable();
+	preempt_disable_notrace();
 
 	curr = 0;
 	while (size_words > curr) {
@@ -368,7 +368,7 @@ static void fprobe_return(struct ftrace_graph_ret *trace,
 		}
 		curr += size;
 	}
-	preempt_enable();
+	preempt_enable_notrace();
 }
 NOKPROBE_SYMBOL(fprobe_return);
 
-- 
2.50.1



