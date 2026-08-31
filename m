Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF374A384A;
	Mon, 31 Aug 2026 13:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183751; cv=none; b=E4boi0er03gZMSMUbm0U3SKDkXvIg1XitshkHVjBeNL483uDnlSOuQYRWmvl+rXUFBU++JFgDWvsb0FxoI8HjCifhClNrfr+0V5ymVjNfVxGiSuJ4RCkd/Ft1KevXaOVFr7UIFKZeuljCQ5kOPVQ9IXosmCK5qO/seANYSqdjHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183751; c=relaxed/simple;
	bh=BPkIIthGZH10fUqVhA+uB2qms8AjsjUnPJecHs9JEos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rgZGmFvULs6PO/E3tjtI3xdSlI7CF0R4xbBqYn4qd27+S2NW6UiFGb6qHDn//zzlxqjmMoyFFYZmNpINcaqPWiiLQPUAnr7i19Bn0tXMEgr1F7YjIPSxbLYmpqGNi3c1UXv17G9pY3fIXjUg4l31LfoItA+2YVCCm9AinkFQtVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g5oMoQve; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g5oMoQve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69A11F00A3D;
	Mon, 31 Aug 2026 13:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183749;
	bh=RtGRI0QI45VYFlCaKshhJ6rkQO+8GKISdqKmt+NcK94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g5oMoQve7G+06Mb5HzsCBeNcRLWVbgw/PrF4YcDtGa0NetDGVCn6Yr8C0X5k23/Js
	 GJBjqMhJ1hmDdbt9UxpiXzQfUz6t5nr5JzfTNJzbKG17AuPv7CNAO8FILr7cmuniRi
	 OtGGrlVOTpDHHxc8VuNAl7w/RppA31qnOY9l2UQki5ACSYHiOu/prLIlPd8pG33T1V
	 iRWLK8jTRpVDUF6kI6EzHnAmAP7wxjfwikBV6ZT1Dni9SzhLI9FvIiUSjQdVKC4jN1
	 CGK7SXwqiBdEtZd0lzYAx6AkMVvj3yTTfuFux5M99gG0TPZs6gXK9+WxT7jpBvxr69
	 XUlgqh+/DZAAg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rik van Riel <riel@surriel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>,
	mhiramat@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] perf/ftrace: Fix WARNING in __unregister_ftrace_function
Date: Mon, 31 Aug 2026 09:25:09 -0400
Message-ID: <20260831133314.4125787-281-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rik van Riel <riel@surriel.com>

[ Upstream commit 9581123304b23049437324038698af9fb56ee663 ]

perf_ftrace_function_unregister() unconditionally calls
unregister_ftrace_function() without checking whether the ftrace_ops
was ever successfully registered. This triggers a WARN_ON in
__unregister_ftrace_function() when the ops doesn't have
FTRACE_OPS_FL_ENABLED set.

This can happen during perf_event_alloc() error cleanup when
perf_trace_destroy() is called via __free_event() on an event whose
ftrace_ops registration failed or was already torn down by
perf_try_init_event()'s err_destroy path.

The call path is:
  perf_event_alloc() error cleanup
    -> __free_event()
      -> event->destroy() [tp_perf_event_destroy]
        -> perf_trace_destroy()
          -> perf_trace_event_close()
            -> TRACE_REG_PERF_CLOSE
              -> perf_ftrace_function_unregister()
                -> unregister_ftrace_function()
                  -> __unregister_ftrace_function()
                    -> WARN_ON(!(ops->flags & FTRACE_OPS_FL_ENABLED))

Fix this by checking FTRACE_OPS_FL_ENABLED before attempting to
unregister. If the ops is not enabled, just free the filter and
return success.

Link: https://patch.msgid.link/20260527111301.2d0d8256@fangorn
Signed-off-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The follow-up check confirms the fix (`9581123304b23`) is on `master` —
it's the only commit adding the `FTRACE_OPS_FL_ENABLED` guard in
`perf_ftrace_function_unregister()`. It's not in **6.18.44**, so the
backport recommendation remains **YES**.

 kernel/trace/trace_event_perf.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index a6bb7577e8c59..5b272856e5ab1 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -497,7 +497,17 @@ static int perf_ftrace_function_register(struct perf_event *event)
 static int perf_ftrace_function_unregister(struct perf_event *event)
 {
 	struct ftrace_ops *ops = &event->ftrace_ops;
-	int ret = unregister_ftrace_function(ops);
+	int ret = 0;
+
+	/*
+	 * Perf will call this unconditionally even if the ops is not
+	 * enabled. The unregister_ftrace_function() will warn if called
+	 * when not enabled. Just bypass the unregistering if ops isn't
+	 * enabled here.
+	 */
+	if (ops->flags & FTRACE_OPS_FL_ENABLED)
+		ret = unregister_ftrace_function(ops);
+
 	ftrace_free_filter(ops);
 	return ret;
 }
-- 
2.53.0

