Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E9221CA07;
	Mon,  2 Jun 2025 14:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874929; cv=none; b=Xuwg7WYGzln8d7WYhrIsBoIMafA2YD+S9uWqBh1qh5zOnxlQ6hTwYK0ygEKQnQ63xMT2xQ8R58jUznesbOLF0HXOCEtnzqqKuKbMwhdt1jbyOlVP2lX7PaBvZRHz4lRi9JInXJGvpZPJbGgT85mQKTa2DAi8lSZkS59eyd9/QaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874929; c=relaxed/simple;
	bh=aM5s6ihCADPEh0DrupWzn1vABxJohH6ff7qhayz4gzg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IpXO1HKePXikSHWPd/Nll+0TZmLLaFF0YoyDPk2CJ5Vh98NX8titKrQvSAD/J/9XSzg8Rv+H733WtYk4YTJJzzQwJ5iUi0he+NceNg+4oJxVgwkbYFzUmlfl4aziderLqW35uPsduGGqlF/XhA+CZK7LFEeyhlF61wzmjn2DCmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B67C4CEEB;
	Mon,  2 Jun 2025 14:35:27 +0000 (UTC)
Date: Mon, 2 Jun 2025 10:36:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 syzbot+c8cd2d2c412b868263fb@syzkaller.appspotmail.com, Jeongjun Park
 <aha310510@gmail.com>
Subject: Re: [PATCH 5.4 009/204] tracing: Fix oob write in
 trace_seq_to_buffer()
Message-ID: <20250602103639.6d9776d5@gandalf.local.home>
In-Reply-To: <20250602134255.842400124@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
	<20250602134255.842400124@linuxfoundation.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  2 Jun 2025 15:45:42 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> 5.4-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Jeongjun Park <aha310510@gmail.com>
> 
> commit f5178c41bb43444a6008150fe6094497135d07cb upstream.
> 
> syzbot reported this bug:
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in trace_seq_to_buffer kernel/trace/trace.c:1830 [inline]
> BUG: KASAN: slab-out-of-bounds in tracing_splice_read_pipe+0x6be/0xdd0 kernel/trace/trace.c:6822
> Write of size 4507 at addr ffff888032b6b000 by task syz.2.320/7260
> 
> CPU: 1 UID: 0 PID: 7260 Comm: syz.2.320 Not tainted 6.15.0-rc1-syzkaller-00301-g3bde70a2c827 #0 PREEMPT(full)
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:408 [inline]
>  print_report+0xc3/0x670 mm/kasan/report.c:521
>  kasan_report+0xe0/0x110 mm/kasan/report.c:634
>  check_region_inline mm/kasan/generic.c:183 [inline]
>  kasan_check_range+0xef/0x1a0 mm/kasan/generic.c:189
>  __asan_memcpy+0x3c/0x60 mm/kasan/shadow.c:106
>  trace_seq_to_buffer kernel/trace/trace.c:1830 [inline]
>  tracing_splice_read_pipe+0x6be/0xdd0 kernel/trace/trace.c:6822
>  ....
> ==================================================================
> 
> It has been reported that trace_seq_to_buffer() tries to copy more data
> than PAGE_SIZE to buf. Therefore, to prevent this, we should use the
> smaller of trace_seq_used(&iter->seq) and PAGE_SIZE as an argument.
> 
> Link: https://lore.kernel.org/20250422113026.13308-1-aha310510@gmail.com
> Reported-by: syzbot+c8cd2d2c412b868263fb@syzkaller.appspotmail.com
> Fixes: 3c56819b14b0 ("tracing: splice support for tracing_pipe")
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Jeongjun Park <aha310510@gmail.com>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  kernel/trace/trace.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -6331,13 +6331,14 @@ static ssize_t tracing_splice_read_pipe(
>  		/* Copy the data into the page, so we can start over. */
>  		ret = trace_seq_to_buffer(&iter->seq,
>  					  page_address(spd.pages[i]),
> -					  trace_seq_used(&iter->seq));
> +					  min((size_t)trace_seq_used(&iter->seq),
> +						  PAGE_SIZE));

Note this will require this patch too:

   Link: https://lore.kernel.org/20250526013731.1198030-1-pantaixi@huaweicloud.com

commit 2fbdb6d8e03b ("tracing: Fix compilation warning on arm32")

-- Steve

>  		if (ret < 0) {
>  			__free_page(spd.pages[i]);
>  			break;
>  		}
>  		spd.partial[i].offset = 0;
> -		spd.partial[i].len = trace_seq_used(&iter->seq);
> +		spd.partial[i].len = ret;
>  
>  		trace_seq_init(&iter->seq);
>  	}
> 

