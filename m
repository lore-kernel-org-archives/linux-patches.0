Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63399268C72;
	Tue,  8 Apr 2025 12:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114148; cv=none; b=uBYhNvNOn/8vGrncUfLCiPa/m3yfSsmY1CxfNiu9Efa3hgu729pJ/onebSUYV+32fWaTd2uTf6v7ELV5TBNM7KKgfaumrq4Wdxwx7Ki094d5qDsslyHWnchclq+K3HrSqnoVOocKMj/fe75VbxoeQGCGQNY6dCQXbo+UxmJ0Y2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114148; c=relaxed/simple;
	bh=mVyLDxHqa5FdMwpSxn/RG7mzrRmiBfxkdUat2Oa0Co4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AMLnof6sH7UAWr6j/yZHWDxvyonXdL/jyWkYcj0LGjTJybVmXUT+MDo8xV9dGnGI9FDWzT0h5oIX9k2npPt4QaHcWP0UbceTxXfKyEfMA0JdcVaoByjXkgWXKsWdFIy7UHY/4BQvYzVAECZpO3PskBj5i4kCpHJXwedFA8rdKXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v0rYfh9W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0rYfh9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44DBC4CEE5;
	Tue,  8 Apr 2025 12:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114148;
	bh=mVyLDxHqa5FdMwpSxn/RG7mzrRmiBfxkdUat2Oa0Co4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v0rYfh9Wv4oypBOK7ZZDj1swDQBY/3P6ApFc15qF/j0CfhHIcF39Eo2nvvyOnpGPt
	 9jQB9mmovfxWYMLMIFYKaAyu5NHUwjjSY64220CQoOFCTBpMhFWCq0t2GVZevx+irY
	 9nUTAh8LftS+7WPjZy7ht3CZS8o3r7TNtIDKisT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Zheng Yejian <zhengyejian1@huawei.com>,
	Kairui Song <kasong@tencent.com>,
	Tengda Wu <wutengda@huaweicloud.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 152/154] tracing: Fix use-after-free in print_graph_function_flags during tracer switching
Date: Tue,  8 Apr 2025 12:51:33 +0200
Message-ID: <20250408104820.163263291@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tengda Wu <wutengda@huaweicloud.com>

commit 7f81f27b1093e4895e87b74143c59c055c3b1906 upstream.

Kairui reported a UAF issue in print_graph_function_flags() during
ftrace stress testing [1]. This issue can be reproduced if puting a
'mdelay(10)' after 'mutex_unlock(&trace_types_lock)' in s_start(),
and executing the following script:

  $ echo function_graph > current_tracer
  $ cat trace > /dev/null &
  $ sleep 5  # Ensure the 'cat' reaches the 'mdelay(10)' point
  $ echo timerlat > current_tracer

The root cause lies in the two calls to print_graph_function_flags
within print_trace_line during each s_show():

  * One through 'iter->trace->print_line()';
  * Another through 'event->funcs->trace()', which is hidden in
    print_trace_fmt() before print_trace_line returns.

Tracer switching only updates the former, while the latter continues
to use the print_line function of the old tracer, which in the script
above is print_graph_function_flags.

Moreover, when switching from the 'function_graph' tracer to the
'timerlat' tracer, s_start only calls graph_trace_close of the
'function_graph' tracer to free 'iter->private', but does not set
it to NULL. This provides an opportunity for 'event->funcs->trace()'
to use an invalid 'iter->private'.

To fix this issue, set 'iter->private' to NULL immediately after
freeing it in graph_trace_close(), ensuring that an invalid pointer
is not passed to other tracers. Additionally, clean up the unnecessary
'iter->private = NULL' during each 'cat trace' when using wakeup and
irqsoff tracers.

 [1] https://lore.kernel.org/all/20231112150030.84609-1-ryncsn@gmail.com/

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Zheng Yejian <zhengyejian1@huawei.com>
Link: https://lore.kernel.org/20250320122137.23635-1-wutengda@huaweicloud.com
Fixes: eecb91b9f98d ("tracing: Fix memleak due to race between current_tracer and trace")
Closes: https://lore.kernel.org/all/CAMgjq7BW79KDSCyp+tZHjShSzHsScSiJxn5ffskp-QzVM06fxw@mail.gmail.com/
Reported-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Tengda Wu <wutengda@huaweicloud.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_functions_graph.c |    1 +
 kernel/trace/trace_irqsoff.c         |    2 --
 kernel/trace/trace_sched_wakeup.c    |    2 --
 3 files changed, 1 insertion(+), 4 deletions(-)

--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -1246,6 +1246,7 @@ void graph_trace_close(struct trace_iter
 	if (data) {
 		free_percpu(data->cpu_data);
 		kfree(data);
+		iter->private = NULL;
 	}
 }
 
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -228,8 +228,6 @@ static void irqsoff_trace_open(struct tr
 {
 	if (is_graph(iter->tr))
 		graph_trace_open(iter);
-	else
-		iter->private = NULL;
 }
 
 static void irqsoff_trace_close(struct trace_iterator *iter)
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -171,8 +171,6 @@ static void wakeup_trace_open(struct tra
 {
 	if (is_graph(iter->tr))
 		graph_trace_open(iter);
-	else
-		iter->private = NULL;
 }
 
 static void wakeup_trace_close(struct trace_iterator *iter)


