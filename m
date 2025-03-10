Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5575917C225;
	Mon, 10 Mar 2025 17:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627055; cv=none; b=BWGD+c7PqTmXSHr+tnsCfmaJQPIdTg6kye96Fdg8tI2JpqWFWQL4k/RXPDyiny95wqHIqxkPpVBLpohl50ks7I3wV8lP5d7wUokcnYdZI0z/NJRullRgMb6RKJwIVwU7E5Db3KH5ectWJ7RhocNoec+4sIk3Q9OD5ev6UVHH1Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627055; c=relaxed/simple;
	bh=AFdWZAWyULLVf4IIckyhthgQll7HTLdDQKtif8gwIrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mnnqeyv//MBMyTYX2cP3Y8c19E639hjORvJrR/08RpnFv9O2e98Md3uZIlKO84JOGbl7FwhWscM/QkzpM0wjHjlWn6rdV2COgOA/DFkLE6y1JQ3mskkJhb9qmVB8Llvz3P9V8vp8sYdpo4cLO/lGqGmBkp35Nhe52xAdOvHnNHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y6mNnp40; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y6mNnp40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0722C4CEE5;
	Mon, 10 Mar 2025 17:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627055;
	bh=AFdWZAWyULLVf4IIckyhthgQll7HTLdDQKtif8gwIrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6mNnp40mJCKLKiK+NIoe71txhs/75VEh9bcpZCL+LN5crGsMob345IKeVWdCGM5E
	 cSG8hBVK5eek/EYiA9nRoR7PjbLh1TH7QYjQqVdZ+sTJclM5N8BPwQxoz+D8+F2B2l
	 j/vdTHdHSvsvKooS4VQC4gSS40vFRDQykq6Dh/oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.13 204/207] fprobe: Always unregister fgraph function from ops
Date: Mon, 10 Mar 2025 18:06:37 +0100
Message-ID: <20250310170455.887955629@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit ded9140622358a154efb3a777025fa7f7ae2c2d9 upstream.

When the last fprobe is removed, it calls unregister_ftrace_graph() to
remove the graph_ops from function graph. The issue is when it does so, it
calls return before removing the function from its graph ops via
ftrace_set_filter_ips(). This leaves the last function lingering in the
fprobe's fgraph ops and if a probe is added it also enables that last
function (even though the callback will just drop it, it does add unneeded
overhead to make that call).

  # echo "f:myevent1 kernel_clone" >> /sys/kernel/tracing/dynamic_events
  # cat /sys/kernel/tracing/enabled_functions
kernel_clone (1)           	tramp: 0xffffffffc02f3000 (ftrace_graph_func+0x0/0x60) ->ftrace_graph_func+0x0/0x60

  # echo "f:myevent2 schedule_timeout" >> /sys/kernel/tracing/dynamic_events
  # cat /sys/kernel/tracing/enabled_functions
kernel_clone (1)           	tramp: 0xffffffffc02f3000 (ftrace_graph_func+0x0/0x60) ->ftrace_graph_func+0x0/0x60
schedule_timeout (1)           	tramp: 0xffffffffc02f3000 (ftrace_graph_func+0x0/0x60) ->ftrace_graph_func+0x0/0x60

  # > /sys/kernel/tracing/dynamic_events
  # cat /sys/kernel/tracing/enabled_functions

  # echo "f:myevent3 kmem_cache_free" >> /sys/kernel/tracing/dynamic_events
  # cat /sys/kernel/tracing/enabled_functions
kmem_cache_free (1)           	tramp: 0xffffffffc0219000 (ftrace_graph_func+0x0/0x60) ->ftrace_graph_func+0x0/0x60
schedule_timeout (1)           	tramp: 0xffffffffc0219000 (ftrace_graph_func+0x0/0x60) ->ftrace_graph_func+0x0/0x60

The above enabled a fprobe on kernel_clone, and then on schedule_timeout.
The content of the enabled_functions shows the functions that have a
callback attached to them. The fprobe attached to those functions
properly. Then the fprobes were cleared, and enabled_functions was empty
after that. But after adding a fprobe on kmem_cache_free, the
enabled_functions shows that the schedule_timeout was attached again. This
is because it was still left in the fprobe ops that is used to tell
function graph what functions it wants callbacks from.

Cc: stable@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Link: https://lore.kernel.org/20250220202055.393254452@goodmis.org
Fixes: 4346ba1604093 ("fprobe: Rewrite fprobe on function-graph tracer")
Tested-by: Heiko Carstens <hca@linux.ibm.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/fprobe.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -374,11 +374,9 @@ static void fprobe_graph_remove_ips(unsi
 	lockdep_assert_held(&fprobe_mutex);
 
 	fprobe_graph_active--;
-	if (!fprobe_graph_active) {
-		/* Q: should we unregister it ? */
+	/* Q: should we unregister it ? */
+	if (!fprobe_graph_active)
 		unregister_ftrace_graph(&fprobe_graph_ops);
-		return;
-	}
 
 	ftrace_set_filter_ips(&fprobe_graph_ops.ops, addrs, num, 1, 0);
 }


