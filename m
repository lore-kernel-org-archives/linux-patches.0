Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9867F1C07D4;
	Tue, 15 Oct 2024 13:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998362; cv=none; b=ZPvM2d5QMR3t98Bg5KFXC2eMadBlcCLR9WWOYVNJIz9sQz2rx6TPP3lfTjX2usMMq4Rhj4mJ2/h+aeSKv0plyHLiQL3YhLjanH2Ipb30ds9zaPSmUKECeNtm3whQZejcy6TcrZCowP7JKvz3mBiln/K9DmptmbLHNTKYEL8DE78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998362; c=relaxed/simple;
	bh=F1pmrIl09F4zOM0SuPagAvxHPsAuzZi40xJ9uyWnmF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npZt3pdgJEpT7XmDGT/PNZGsOLb+XifkakfiKeGFtzNC4RO9upCbnJoCvwbkXSqeBJWisadjeFaG5YeHpo0ALEdQ03AFldzcPpBYG739/Y5cUWyUOEQOz257gQPL9HBr6URGeOVIsj4Ew5FAoyj/WElTdBQzc03MELY6ciruoXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eeEyNaHL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eeEyNaHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FD7C4CEC6;
	Tue, 15 Oct 2024 13:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998362;
	bh=F1pmrIl09F4zOM0SuPagAvxHPsAuzZi40xJ9uyWnmF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eeEyNaHL70Dqi4/XDHK+iusGfjEDIUGEvMrlN6FLX/5bLeTJvqXbEFzsHL0reeHPk
	 lHH3tnhkZcM/nx/b5/xGyIZ4rGo/qDDs8XZfWCE+wYsmewq+9Z3AGA5YunemTGZIai
	 xwJCs610Z8dJjCeePS/w1yb4EchtQ9rqrP26OuRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sachin Sant <sachinp@linux.ibm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 438/518] tracing: Remove precision vsnprintf() check from print event
Date: Tue, 15 Oct 2024 14:45:42 +0200
Message-ID: <20241015123933.911484567@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit 5efd3e2aef91d2d812290dcb25b2058e6f3f532c ]

This reverts 60be76eeabb3d ("tracing: Add size check when printing
trace_marker output"). The only reason the precision check was added
was because of a bug that miscalculated the write size of the string into
the ring buffer and it truncated it removing the terminating nul byte. On
reading the trace it crashed the kernel. But this was due to the bug in
the code that happened during development and should never happen in
practice. If anything, the precision can hide bugs where the string in the
ring buffer isn't nul terminated and it will not be checked.

Link: https://lore.kernel.org/all/C7E7AF1A-D30F-4D18-B8E5-AF1EF58004F5@linux.ibm.com/
Link: https://lore.kernel.org/linux-trace-kernel/20240227125706.04279ac2@gandalf.local.home
Link: https://lore.kernel.org/all/20240302111244.3a1674be@gandalf.local.home/
Link: https://lore.kernel.org/linux-trace-kernel/20240304174341.2a561d9f@gandalf.local.home

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Fixes: 60be76eeabb3d ("tracing: Add size check when printing trace_marker output")
Reported-by: Sachin Sant <sachinp@linux.ibm.com>
Tested-by: Sachin Sant <sachinp@linux.ibm.com>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_output.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 753b84c50848a..94b0991717b6d 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -1313,12 +1313,11 @@ static enum print_line_t trace_print_print(struct trace_iterator *iter,
 {
 	struct print_entry *field;
 	struct trace_seq *s = &iter->seq;
-	int max = iter->ent_size - offsetof(struct print_entry, buf);
 
 	trace_assign_type(field, iter->ent);
 
 	seq_print_ip_sym(s, field->ip, flags);
-	trace_seq_printf(s, ": %.*s", max, field->buf);
+	trace_seq_printf(s, ": %s", field->buf);
 
 	return trace_handle_return(s);
 }
@@ -1327,11 +1326,10 @@ static enum print_line_t trace_print_raw(struct trace_iterator *iter, int flags,
 					 struct trace_event *event)
 {
 	struct print_entry *field;
-	int max = iter->ent_size - offsetof(struct print_entry, buf);
 
 	trace_assign_type(field, iter->ent);
 
-	trace_seq_printf(&iter->seq, "# %lx %.*s", field->ip, max, field->buf);
+	trace_seq_printf(&iter->seq, "# %lx %s", field->ip, field->buf);
 
 	return trace_handle_return(&iter->seq);
 }
-- 
2.43.0



