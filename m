Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2903C4F212;
	Mon, 11 Dec 2023 18:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FcvLCc/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F35C433C7;
	Mon, 11 Dec 2023 18:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319086;
	bh=KSddwmdkjwKWJq6rGwXz2hmrUnxDinyULUxkOYZ1kyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FcvLCc/NyJrPXG3GjY9aJ5xMeEHp9lAQ3E+iiBzMTE3U6DPeQFAd2RbFKIl+r5MEn
	 ZjpIb2woM7C3WNV6k9WQ5smZacu7tHi4lsBKFMcHwZ0n8BO5hz88a3vG6AvsM+idh+
	 uNqmO+IBJydsWyZ2HZMXsAgiLdH9kKhJvH2HtUHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 33/55] tracing: Always update snapshot buffer size
Date: Mon, 11 Dec 2023 19:21:43 +0100
Message-ID: <20231211182013.458334330@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182012.263036284@linuxfoundation.org>
References: <20231211182012.263036284@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5258,8 +5258,7 @@ static int __tracing_resize_ring_buffer(
 		return ret;
 
 #ifdef CONFIG_TRACER_MAX_TRACE
-	if (!(tr->flags & TRACE_ARRAY_FL_GLOBAL) ||
-	    !tr->current_trace->use_max_tr)
+	if (!tr->current_trace->use_max_tr)
 		goto out;
 
 	ret = ring_buffer_resize(tr->max_buffer.buffer, size, cpu);


