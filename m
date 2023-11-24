Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F72239FE3;
	Fri, 24 Nov 2023 18:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjBkMjAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F3CC433C8;
	Fri, 24 Nov 2023 18:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850154;
	bh=X6JhS/p5f6ppIcf8O9L/tts2MV2ednrmZQ3S1veGYns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjBkMjAgPc1wVSp73WXmvIK4BbX++ArnItOINJEB6OU1XhXwxyvpOPedpPkGDn8vs
	 6f1UQUdMA0lezpvG5pDOtV77JShFBV75ljG6hyPYXzjRGJuS++gm6JKbhLFIG096WP
	 mAKxtfa/nlldbnCYixbdaF8Xt/3LmZuR++W3LvLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.6 467/530] tracing: fprobe-event: Fix to check tracepoint event and return
Date: Fri, 24 Nov 2023 17:50:33 +0000
Message-ID: <20231124172042.287962381@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit ce51e6153f7781bcde0f8bb4c81d6fd85ee422e6 upstream.

Fix to check the tracepoint event is not valid with $retval.
The commit 08c9306fc2e3 ("tracing/fprobe-event: Assume fprobe is
a return event by $retval") introduced automatic return probe
conversion with $retval. But since tracepoint event does not
support return probe, $retval is not acceptable.

Without this fix, ftracetest, tprobe_syntax_errors.tc fails;

[22] Tracepoint probe event parser error log check      [FAIL]
 ----
 # tail 22-tprobe_syntax_errors.tc-log.mRKroL
 + ftrace_errlog_check trace_fprobe t kfree ^$retval dynamic_events
 + printf %s t kfree
 + wc -c
 + pos=8
 + printf %s t kfree ^$retval
 + tr -d ^
 + command=t kfree $retval
 + echo Test command: t kfree $retval
 Test command: t kfree $retval
 + echo
 ----

So 't kfree $retval' should fail (tracepoint doesn't support
return probe) but passed it.

Link: https://lore.kernel.org/all/169944555933.45057.12831706585287704173.stgit@devnote2/

Fixes: 08c9306fc2e3 ("tracing/fprobe-event: Assume fprobe is a return event by $retval")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_fprobe.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_fprobe.c b/kernel/trace/trace_fprobe.c
index 8bfe23af9c73..7d2ddbcfa377 100644
--- a/kernel/trace/trace_fprobe.c
+++ b/kernel/trace/trace_fprobe.c
@@ -927,11 +927,12 @@ static int parse_symbol_and_return(int argc, const char *argv[],
 	for (i = 2; i < argc; i++) {
 		tmp = strstr(argv[i], "$retval");
 		if (tmp && !isalnum(tmp[7]) && tmp[7] != '_') {
+			if (is_tracepoint) {
+				trace_probe_log_set_index(i);
+				trace_probe_log_err(tmp - argv[i], RETVAL_ON_PROBE);
+				return -EINVAL;
+			}
 			*is_return = true;
-			/*
-			 * NOTE: Don't check is_tracepoint here, because it will
-			 * be checked when the argument is parsed.
-			 */
 			break;
 		}
 	}
-- 
2.43.0



