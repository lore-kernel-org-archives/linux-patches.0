Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71A5399351;
	Sat, 12 Sep 2026 20:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243312; cv=none; b=jVI443/+qHRWeKEFvzo49QC9zmn/E3U8bIqObF+8AgIkD49U3aOVamwijePMpAodoCUL+zgk7NZpqb+9SVvdh9jbQW75zuFvqA5BwxDupq+dDDnrZssQ+250s+NnQvn0rYB38MTUgA5CkjQwVmBJ3mJ+HjMIjXrw3nrBQ4FltmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243312; c=relaxed/simple;
	bh=QUWNTB80p/0wDSTncbSAUH1sRtodoNeMZEx0RKCKobA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qFffpcCL5ijA4FCkpCVYO8co0rCuRxOh4dVFa0Szv3aXegTmneT1q9LuklfiFtzDKi0tiBHD/PVDWjBHgOPJlQAedvzA7tUCPtrHk/QQwlYltNwPaJjZiSd//h/VA1nl4DyAF58FFnHypPPi2hDE5jnR62BLrLN+WWm/KcjZDdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S9oVVpQB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S9oVVpQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE6A1F000FF;
	Sat, 12 Sep 2026 20:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243310;
	bh=UGV4iNDGMpISCR0Gf+ydWCtEx/S2Gbt9k0imT9StlCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S9oVVpQBr7QyvLcJSKmuuTbcAHmhCH0g7g9RNtMWg2eDNFBHn0rYKmy0vg8O++RSj
	 v4qCbGkp3Hc8VrM3UdbSjKqIrNbOAfgKX02EOLRr6LlXoNTwUqRH//3pS+ba+u4pgz
	 szigINaA2CCbPUKMzplj+xGjagHDexwqlyQ2bimM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ritesh Harjani <riteshh@linux.ibm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 712/798] tracing: Have TRACE_DEFINE_ENUM affect trace event types as well
Date: Sat, 12 Sep 2026 09:05:40 +0200
Message-ID: <20260912065533.404747135@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit b3bc8547d3be60898818885f5bf22d0a62e2eb48 ]

The macro TRACE_DEFINE_ENUM is used to convert enums in the kernel to
their actual value when they are exported to user space via the trace
event format file.

Currently only the enums in the "print fmt" (TP_printk in the TRACE_EVENT
macro) have the enums converted. But the enums can be used to denote array
size:

        field:unsigned int fc_ineligible_rc[EXT4_FC_REASON_MAX]; offset:12;      size:36;        signed:0;

The EXT4_FC_REASON_MAX has no meaning to userspace but it needs to know
that information to know how to parse the array.

Have the array indexes also be parsed as well.

Link: https://lore.kernel.org/all/cover.1646922487.git.riteshh@linux.ibm.com/

Reported-by: Ritesh Harjani <riteshh@linux.ibm.com>
Tested-by: Ritesh Harjani <riteshh@linux.ibm.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: ae70b04ab9c7 ("tracing: Have trace_event_update_all() only handle module that is loading")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index ea63a3fa32a2e..889ec51171ce9 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2433,6 +2433,33 @@ static void update_event_printk(struct trace_event_call *call,
 	}
 }
 
+static void update_event_fields(struct trace_event_call *call,
+				struct trace_eval_map *map)
+{
+	struct ftrace_event_field *field;
+	struct list_head *head;
+	char *ptr;
+	int len = strlen(map->eval_string);
+
+	head = trace_get_fields(call);
+	list_for_each_entry(field, head, link) {
+		ptr = strchr(field->type, '[');
+		if (!ptr)
+			continue;
+		ptr++;
+
+		if (!isalpha(*ptr) && *ptr != '_')
+			continue;
+
+		if (strncmp(map->eval_string, ptr, len) != 0)
+			continue;
+
+		ptr = eval_replace(ptr, map, len);
+		/* enum/sizeof string smaller than value */
+		WARN_ON_ONCE(!ptr);
+	}
+}
+
 void trace_event_eval_update(struct trace_eval_map **map, int len)
 {
 	struct trace_event_call *call, *p;
@@ -2468,6 +2495,7 @@ void trace_event_eval_update(struct trace_eval_map **map, int len)
 					first = false;
 				}
 				update_event_printk(call, map[i]);
+				update_event_fields(call, map[i]);
 			}
 		}
 		cond_resched();
-- 
2.53.0



