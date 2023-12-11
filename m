Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060B34F212;
	Mon, 11 Dec 2023 18:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YeRWLgHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81473C433C7;
	Mon, 11 Dec 2023 18:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702318942;
	bh=3qKG0YZvalzyRWT2QXJvqIAFtLkPoO5ZeF5J222PCTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YeRWLgHdgi1st7KReVWb1S6V7YtSTzNuzv0BrrjLd1JelsepTQXy/6riqAa5Lf6GA
	 DfH7S8auH0QCWDsUc4bn8O9YltnMEt0OVKtIlKSkHwCKsGAWHWJe0YzAReJwWQlhbp
	 Yzn/VGnnjgjy6ongirMEJnXxj0YY+Nk86fBxwG4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4.14 12/25] tracing: Always update snapshot buffer size
Date: Mon, 11 Dec 2023 19:21:03 +0100
Message-ID: <20231211182009.143793983@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182008.665944227@linuxfoundation.org>
References: <20231211182008.665944227@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 7be76461f302ec05cbd62b90b2a05c64299ca01f upstream.

It use to be that only the top level instance had a snapshot buffer (for
latency tracers like wakeup and irqsoff). The update of the ring buffer
size would check if the instance was the top level and if so, it would
also update the snapshot buffer as it needs to be the same as the main
buffer.

Now that lower level instances also has a snapshot buffer, they too need
to update their snapshot buffer sizes when the main buffer is changed,
otherwise the following can be triggered:

 # cd /sys/kernel/tracing
 # echo 1500 > buffer_size_kb
 # mkdir instances/foo
 # echo irqsoff > instances/foo/current_tracer
 # echo 1000 > instances/foo/buffer_size_kb

Produces:

 WARNING: CPU: 2 PID: 856 at kernel/trace/trace.c:1938 update_max_tr_single.part.0+0x27d/0x320

Which is:

	ret = ring_buffer_swap_cpu(tr->max_buffer.buffer, tr->array_buffer.buffer, cpu);

	if (ret == -EBUSY) {
		[..]
	}

	WARN_ON_ONCE(ret && ret != -EAGAIN && ret != -EBUSY);  <== here

That's because ring_buffer_swap_cpu() has:

	int ret = -EINVAL;

	[..]

	/* At least make sure the two buffers are somewhat the same */
	if (cpu_buffer_a->nr_pages != cpu_buffer_b->nr_pages)
		goto out;

	[..]
 out:
	return ret;
 }

Instead, update all instances' snapshot buffer sizes when their main
buffer size is updated.

Link: https://lkml.kernel.org/r/20231205220010.454662151@goodmis.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Fixes: 6d9b3fa5e7f6 ("tracing: Move tracing_max_latency into trace_array")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5253,8 +5253,7 @@ static int __tracing_resize_ring_buffer(
 		return ret;
 
 #ifdef CONFIG_TRACER_MAX_TRACE
-	if (!(tr->flags & TRACE_ARRAY_FL_GLOBAL) ||
-	    !tr->current_trace->use_max_tr)
+	if (!tr->current_trace->use_max_tr)
 		goto out;
 
 	ret = ring_buffer_resize(tr->max_buffer.buffer, size, cpu);


