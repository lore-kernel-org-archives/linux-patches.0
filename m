Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83B94E4C49;
	Wed, 30 Sep 2026 15:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782571; cv=none; b=OJwlMD+dgCvrxb76axokgvRuSEqTondgsMD8DsJxXP1pqqZDfjhtR9N/tsiPaTfzNvubYdwE89/ySNXSto5pHH9Pur5u54x5tDy8i6bl05IJpv5lHfo5CccKrh3ykVbDy39EnT2/Qs0ygBvzn+uZad62wz1y/DCULlAHvgel29I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782571; c=relaxed/simple;
	bh=HngOw7jFhzi3uSeMB4aAc1gUVFoUmz3MkxOIykLNJNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AwYJKj3/zzId99/6xslnbuol0lbSft7S54UHolTJYtIaj1IvKaqINVjaZVtM2Mgumhn2wrZB9j5UYhZ+CnoFE/F5aEI4JdmGTuL5KMDxDtCy5qUD/bPYz+dvx+qtX6pY1YmTXfrfelZjnUni2KUXQdzHnmIyJCKYHpUElb5jQC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l/3U9st3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l/3U9st3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABC41F00893;
	Wed, 30 Sep 2026 15:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782553;
	bh=oH6SwxQYmxY22VaDQHnZZvSywHuF84IMNRWgiqyo+mM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l/3U9st3iBYmM4XdQ3MzJ261AqgE2wg2goKQ6L3m0njpd2yK7h81MKgCc+LINIttW
	 1HGj5mCBvuQtLKRfKAOcVprhL6JvjEMcocEjDgvSXxFsa+8dK00+PPen8K5xJYGLY7
	 y0yHAd40ThixVulf/AXk+NvcyH4oInOnbCieNyEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/595] perf/ftrace: Fix WARNING in __unregister_ftrace_function
Date: Wed, 30 Sep 2026 17:19:40 +0200
Message-ID: <20260930152349.609769712@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 kernel/trace/trace_event_perf.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index b3a863c10c0a7..cccb8540d3018 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -494,7 +494,17 @@ static int perf_ftrace_function_register(struct perf_event *event)
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



