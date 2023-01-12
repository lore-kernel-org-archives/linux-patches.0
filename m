Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C098A79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:32:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E57C433B4;
	Thu, 12 Jan 2023 14:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533935;
	bh=h2Pp/l72dZXAnncxhJl1f/VbIBHtrczaMe6MyajUMsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ct5cy3OHXUM/fHPH9aP2tlZ0PAmq54GiS4KuyFflp+RXz78A+LjU9G5bXu9FRxyPF
	 aMRzXM6vcMR4rehW3UQt4zO0fJLUx1ffSF6FNe302WFoGEaNHAU/xwqoEpzvDP5A3G
	 tUfR/jZqT0x6eqBBcwvK08IwFURgR8pW9+KjYwbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Yang Jihong <yangjihong1@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 641/783] tracing: Fix infinite loop in tracing_read_pipe on overflowed print_trace_line
Date: Thu, 12 Jan 2023 14:55:57 +0100
Message-Id: <20230112135554.028178210@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Jihong <yangjihong1@huawei.com>

commit c1ac03af6ed45d05786c219d102f37eb44880f28 upstream.

print_trace_line may overflow seq_file buffer. If the event is not
consumed, the while loop keeps peeking this event, causing a infinite loop.

Link: https://lkml.kernel.org/r/20221129113009.182425-1-yangjihong1@huawei.com

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 088b1e427dbba ("ftrace: pipe fixes")
Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6371,7 +6371,20 @@ waitagain:
 
 		ret = print_trace_line(iter);
 		if (ret == TRACE_TYPE_PARTIAL_LINE) {
-			/* don't print partial lines */
+			/*
+			 * If one print_trace_line() fills entire trace_seq in one shot,
+			 * trace_seq_to_user() will returns -EBUSY because save_len == 0,
+			 * In this case, we need to consume it, otherwise, loop will peek
+			 * this event next time, resulting in an infinite loop.
+			 */
+			if (save_len == 0) {
+				iter->seq.full = 0;
+				trace_seq_puts(&iter->seq, "[LINE TOO BIG]\n");
+				trace_consume(iter);
+				break;
+			}
+
+			/* In other cases, don't print partial lines */
 			iter->seq.seq.len = save_len;
 			break;
 		}


