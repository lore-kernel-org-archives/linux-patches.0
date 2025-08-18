Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30012343D92;
	Mon, 18 Aug 2025 14:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526497; cv=none; b=RWVqjZ/bXby7tq2KnRbTVz5ihHychZ5vwq2xemooEjSWfpjd1YaTHw6JPyykCseoFXVzm1vtCGm/491fKn/xdwH2d8ra5fDqHmjqLt3Rbn3tN5F0OiUy3+xFvKM0em1ffr2o9Unn+78ZwsHpNdYYlIdQrk9mXoQRyCwScFWda2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526497; c=relaxed/simple;
	bh=KdFw95re/iHGoSPD0dCuy5WtG974kTCDSNERfS/dDNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EchzoNKzmib0Q1l9abeqyg8peXxTPGrXcUiNKSV1rLtMOo6nmwwr1wkxg3uiZHr53kankuCgIdUyK59d0cdBvp1uia7AjQkfCu/Z2iZh5nZDWGyrBdqLr6HB9shzukdIHVHa5QwgV0QKfvkrY5rtVQTXGVzYUHAlnhjwxV6cifQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E7bQwaO2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E7bQwaO2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95221C4CEEB;
	Mon, 18 Aug 2025 14:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526497;
	bh=KdFw95re/iHGoSPD0dCuy5WtG974kTCDSNERfS/dDNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E7bQwaO2YX9GOgASuGkRd1VMY1nrE9OeW4lK0sF4AeG1mNLLqhTpHeUjjm6Q1MjCy
	 oUxBu1pkKXTcPRrqYFI5M/Go0/zCg1dGfkHwF8NWMcPV7+X+e74yLRYLk9va74mpIH
	 QzP+wVbFirtXhQZLsd54wy7Oxe49d+nYg5l6kBTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.16 554/570] tracing: fprobe: Fix infinite recursion using preempt_*_notrace()
Date: Mon, 18 Aug 2025 14:49:01 +0200
Message-ID: <20250818124527.213710336@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
 kernel/trace/fprobe.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -352,7 +352,7 @@ static void fprobe_return(struct ftrace_
 	size_words = SIZE_IN_LONG(size);
 	ret_ip = ftrace_regs_get_instruction_pointer(fregs);
 
-	preempt_disable();
+	preempt_disable_notrace();
 
 	curr = 0;
 	while (size_words > curr) {
@@ -368,7 +368,7 @@ static void fprobe_return(struct ftrace_
 		}
 		curr += size;
 	}
-	preempt_enable();
+	preempt_enable_notrace();
 }
 NOKPROBE_SYMBOL(fprobe_return);
 


