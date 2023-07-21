Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AE420F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162E0C433C7;
	Fri, 21 Jul 2023 19:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967101;
	bh=+ibLxRcIm1vHR6y+Idy+lbff2jeb9PDe1qpiGAU6Jok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+GUOnWxar7ZsyQqTwnX0ESB4qv/Y7+egNhcpjAOqVAaDlzZhw1jfQytsA+ksscU6
	 ervWsSuLH1dtl53ABPkabwVA6xNdhqaSk1Sh/Ph8k8mOIOz3BE0GLifrY8iBhtby79
	 KqRXKh5+IWxpB1ErbmJs+cUgMg2lEf0O6iqr5yZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/223] kernel/trace: Fix cleanup logic of enable_trace_eprobe
Date: Fri, 21 Jul 2023 18:04:57 +0200
Message-ID: <20230721160522.736972401@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>

[ Upstream commit cf0a624dc706c306294c14e6b3e7694702f25191 ]

The enable_trace_eprobe() function enables all event probes, attached
to given trace probe. If an error occurs in enabling one of the event
probes, all others should be roll backed. There is a bug in that roll
back logic - instead of all event probes, only the failed one is
disabled.

Link: https://lore.kernel.org/all/20230703042853.1427493-1-tz.stoyanov@gmail.com/

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: 7491e2c44278 ("tracing: Add a probe that attaches to trace events")
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_eprobe.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_eprobe.c b/kernel/trace/trace_eprobe.c
index 753fc536525d3..d2370cdb4c1d6 100644
--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -743,6 +743,7 @@ static int enable_trace_eprobe(struct trace_event_call *call,
 	struct trace_eprobe *ep;
 	bool enabled;
 	int ret = 0;
+	int cnt = 0;
 
 	tp = trace_probe_primary_from_call(call);
 	if (WARN_ON_ONCE(!tp))
@@ -766,12 +767,25 @@ static int enable_trace_eprobe(struct trace_event_call *call,
 		if (ret)
 			break;
 		enabled = true;
+		cnt++;
 	}
 
 	if (ret) {
 		/* Failed to enable one of them. Roll back all */
-		if (enabled)
-			disable_eprobe(ep, file->tr);
+		if (enabled) {
+			/*
+			 * It's a bug if one failed for something other than memory
+			 * not being available but another eprobe succeeded.
+			 */
+			WARN_ON_ONCE(ret != -ENOMEM);
+
+			list_for_each_entry(pos, trace_probe_probe_list(tp), list) {
+				ep = container_of(pos, struct trace_eprobe, tp);
+				disable_eprobe(ep, file->tr);
+				if (!--cnt)
+					break;
+			}
+		}
 		if (file)
 			trace_probe_remove_file(tp, file);
 		else
-- 
2.39.2



