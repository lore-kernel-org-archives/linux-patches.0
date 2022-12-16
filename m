Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7677D20E3
	for <patches@lists.linux.dev>; Fri, 16 Dec 2022 14:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44912C433EF;
	Fri, 16 Dec 2022 14:15:35 +0000 (UTC)
Date: Fri, 16 Dec 2022 09:15:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Pratyush Yadav <ptyadav@amazon.de>
Cc: <stable@vger.kernel.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, <patches@lists.linux.dev>, Linux Trace Kernel
 <linux-trace-kernel@vger.kernel.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Primiano Tucci <primiano@google.com>
Subject: Re: [PATCH 5.4] tracing/ring-buffer: Only do full wait when cpu !=
 RING_BUFFER_ALL_CPUS
Message-ID: <20221216091533.6a74d5c5@gandalf.local.home>
In-Reply-To: <20221216134241.81381-1-ptyadav@amazon.de>
References: <20221216134241.81381-1-ptyadav@amazon.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 16 Dec 2022 14:42:41 +0100
Pratyush Yadav <ptyadav@amazon.de> wrote:

> full_hit() directly uses cpu as an array index. Since
> RING_BUFFER_ALL_CPUS == -1, calling full_hit() with cpu ==
> RING_BUFFER_ALL_CPUS will cause an invalid memory access.
> 
> The upstream commit 42fb0a1e84ff ("tracing/ring-buffer: Have polling
> block on watermark") already does this. This was missed when backporting
> to v5.4.y.
> 
> This bug was discovered and resolved using Coverity Static Analysis
> Security Testing (SAST) by Synopsys, Inc.

Nice.

> 
> Fixes: e65ac2bdda54 ("tracing/ring-buffer: Have polling block on watermark")
> Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
> ---
> 
> I am not familiar with this code. This was just pointed out by our
> static analysis tool and I wrote a quick patch fixing this. Only
> compile-tested.
> 
>  kernel/trace/ring_buffer.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 176d858903bd..11e8189dd8ae 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -727,6 +727,7 @@ __poll_t ring_buffer_poll_wait(struct ring_buffer *buffer, int cpu,
> 
>  	if (cpu == RING_BUFFER_ALL_CPUS) {
>  		work = &buffer->irq_work;
> +		full = 0;

Good catch. This was indeed missed in the backport. The backported patch
even added the comment:

 * @full: wait until the percentage of pages are available, if @cpu != RING_BUFFER_ALL_CPUS

Greg, please take this patch.

Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Thanks,

-- Steve

>  	} else {
>  		if (!cpumask_test_cpu(cpu, buffer->cpumask))
>  			return -EINVAL;
> --
> 2.38.1
> 
> 
> 
> 
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
> 
> 

