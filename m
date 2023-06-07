Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1660F1D2A5
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EBE3C4339B;
	Wed,  7 Jun 2023 20:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170786;
	bh=oZnFZvVyq37kjsJAdZ3SjFKDGN4gfpEdfcVyXBHNGbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZWsWNAp3ILD4bxefhkCLpzV5eqTh3PMHrI4xpPSVxtBjRf7PLZWkpbaerDgHFpQos
	 ObVx3feqgo/xwNqgdY2wrOnZ/1w9pn8nCTJpX+IClGPp/tVqmFL16l6twEL5q+t+jq
	 9m/lxCn7o340jOdNTNai/oxJoWtXjAfrR6+plBxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pietro Borrello <borrello@diag.uniroma1.it>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Mukesh Ojha <quic_mojha@quicinc.com>
Subject: [PATCH 6.1 188/225] tracing/probe: trace_probe_primary_from_call(): checked list_first_entry
Date: Wed,  7 Jun 2023 22:16:21 +0200
Message-ID: <20230607200920.532644725@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pietro Borrello <borrello@diag.uniroma1.it>

commit 81d0fa4cb4fc0e1a49c2b22f92c43d9fe972ebcf upstream.

All callers of trace_probe_primary_from_call() check the return
value to be non NULL. However, the function returns
list_first_entry(&tpe->probes, ...) which can never be NULL.
Additionally, it does not check for the list being possibly empty,
possibly causing a type confusion on empty lists.
Use list_first_entry_or_null() which solves both problems.

Link: https://lore.kernel.org/linux-trace-kernel/20230128-list-entry-null-check-v1-1-8bde6a3da2ef@diag.uniroma1.it/

Fixes: 60d53e2c3b75 ("tracing/probe: Split trace_event related data from trace_probe")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-by: Mukesh Ojha <quic_mojha@quicinc.com>
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -302,7 +302,7 @@ trace_probe_primary_from_call(struct tra
 {
 	struct trace_probe_event *tpe = trace_probe_event_from_call(call);
 
-	return list_first_entry(&tpe->probes, struct trace_probe, list);
+	return list_first_entry_or_null(&tpe->probes, struct trace_probe, list);
 }
 
 static inline struct list_head *trace_probe_probe_list(struct trace_probe *tp)


