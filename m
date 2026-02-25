Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCE124677D;
	Wed, 25 Feb 2026 01:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983379; cv=none; b=bu5QikPqbnE9Bk0a8iZdM21fxmE/JSQv9uE1w5dlq4yyW3UW42sxaIWbH++1ccDGK5EIULrTzpI95/CrirP1RDDZn58FPTSHqevgznXdqPL0+QTZhHiDgs0WclZkUt5ps0JPfyAEWu3Lj8ZXFajVzirwoGiyAObLgRdXgmekaD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983379; c=relaxed/simple;
	bh=bsa/S6t+grjMd/ztDrE5BfPw/QnGXu0YFasHRIBBeHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Km/2Gg3gwQKtLZZhgAXZQnsNtihj+OoDjDfU4O2F75uNaTZLl4rf5Ezch7zcqNhm+DZS+7zP4toqNxuzIzJ9gWJNST6X/M6efcNkBH8K+3M1/waYwEj66aiF6O8j32WG14aVHVqFBzE56s0NKgluVtNb/MorrCg9okNvrVdyfDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ju7Oo8rL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ju7Oo8rL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B6CC116D0;
	Wed, 25 Feb 2026 01:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983379;
	bh=bsa/S6t+grjMd/ztDrE5BfPw/QnGXu0YFasHRIBBeHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ju7Oo8rLAS1Uc63ogwLN/lTHobbzAgD6zItUlUFMGgI4FZZBi1kbMdoWqBkhCwZHP
	 KxARms1V8ep0ZftqLwbiNJ1Yq32SgeXIsuU618m9GCSFPtYhQtbrolfPaA2Ak1p/W6
	 otezFH0MAroGC2TI+pnGo896iwAg7msy7+xn47xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Tom Zanussi <zanussi@kernel.org>,
	Miaoqian Lin <linmq006@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 503/781] tracing: Properly process error handling in event_hist_trigger_parse()
Date: Tue, 24 Feb 2026 17:20:12 -0800
Message-ID: <20260225012412.141475371@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 0550069cc25f513ce1f109c88f7c1f01d63297db ]

Memory allocated with trigger_data_alloc() requires trigger_data_free()
for proper cleanup.

Replace kfree() with trigger_data_free() to fix this.

Found via static analysis and code review.

This isn't a real bug due to the current code basically being an open
coded version of trigger_data_free() without the synchronization. The
synchronization isn't needed as this is the error path of creation and
there's nothing to synchronize against yet. Replace the kfree() to be
consistent with the allocation.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Link: https://patch.msgid.link/20251211100058.2381268-1-linmq006@gmail.com
Fixes: e1f187d09e11 ("tracing: Have existing event_command.parse() implementations use helpers")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index c97bb2fda5c02..7e50df8b800b1 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -6911,7 +6911,7 @@ static int event_hist_trigger_parse(struct event_command *cmd_ops,
 
 	remove_hist_vars(hist_data);
 
-	kfree(trigger_data);
+	trigger_data_free(trigger_data);
 
 	destroy_hist_data(hist_data);
 	goto out;
-- 
2.51.0



