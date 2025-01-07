Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4EC1F3D43;
	Tue,  7 Jan 2025 16:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736266405; cv=none; b=ZR8kJLOwDSaerif4HysONcTkmK5a/TTXVhcV5W4Dvlmd/fSu9iGnMJFpBkiB1QN/sn8fB8YfkkhOgEAplyFLGYfrSFE6Z1ku7U56Il1pH5HtzjKzSu7xVE+/O6dpJujSXmefRM2u7kPb0juLId5j8W2bbncjXx8tgaMoDoqoyW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736266405; c=relaxed/simple;
	bh=n7ayQdfsJwptn30pRC4jp91zbfN+mXLjDFUwsuzxGbk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aBvru5/DwngxNPCI7JXrIiNmOxykuCPjAqwgPXzLJW2TnVUyWHjfe2EqmQADrxDrLk81oHhhpNeHPiWzMkszRKkBKJJy1/5xXbCbCxW9QfGLFoxZMLoQUqoNCWbqvM8E3XNPSiiTfpZjKP+7CJd42mRKv54wzcXT892qERBCtY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85190C4CEDD;
	Tue,  7 Jan 2025 16:13:23 +0000 (UTC)
Date: Tue, 7 Jan 2025 11:14:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Koichiro Den <koichiro.den@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, mhiramat@kernel.org, mark.rutland@arm.com,
 mathieu.desnoyers@efficios.com, Zheng Yejian <zhengyejian1@huawei.com>,
 Hagar Hemdan <hagarhem@amazon.com>
Subject: Re: [PATCH 5.4 50/66] ftrace: Fix possible use-after-free issue in
 ftrace_location()
Message-ID: <20250107111451.70c905d0@gandalf.local.home>
In-Reply-To: <74gjhwxupvozwop7ndhrh7t5qeckomt7yqvkkbm5j2tlx6dkfk@rgv7sijvry2k>
References: <20241115063722.834793938@linuxfoundation.org>
	<20241115063724.648039829@linuxfoundation.org>
	<74gjhwxupvozwop7ndhrh7t5qeckomt7yqvkkbm5j2tlx6dkfk@rgv7sijvry2k>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 7 Jan 2025 17:51:36 +0900
Koichiro Den <koichiro.den@canonical.com> wrote:

> I observed that since this backport, on linux-5.4.y x86-64, a simple 'echo
> function > current_tracer' without any filter can easily result in double
> fault (int3) and system becomes unresponsible. linux-5.4.y x86 code has not
> yet been converted to use text_poke(), so IIUC the issue appears to be that
> the old ftrace_int3_handler()->ftrace_location() path now includes
> rcu_read_lock() with this backport patch, which has mcount location inside,
> that leads to the double fault.

Yep, I can easily reproduce this. Hmm, this should have been caught by
running the ftrace selftests. I guess nobody is doing that on stable releases :-/

> 
> I verified on an x86-64 qemu env that applying the following 11 additional
> backports resolves the issue. The main purpose is to backport #7. All the
> commits can be cleanly applied to the latest linux-5.4.y (v5.4.288).
> 
>   #11. fd3dc56253ac ftrace/x86: Add back ftrace_expected for ftrace bug reports
>   #10. ac6c1b2ca77e ftrace/x86: Add back ftrace_expected assignment
>    #9. 59566b0b622e x86/ftrace: Have ftrace trampolines turn read-only at the end of system boot up
>    #8. 38ebd8d11924 x86/ftrace: Mark ftrace_modify_code_direct() __ref
>    #7. 768ae4406a5c x86/ftrace: Use text_poke()
>    #6. 63f62addb88e x86/alternatives: Add and use text_gen_insn() helper
>    #5. 18cbc8bed0c7 x86/alternatives, jump_label: Provide better text_poke() batching interface
>    #4. 8f4a4160c618 x86/alternatives: Update int3_emulate_push() comment
>    #3. 72ebb5ff806f x86/alternative: Update text_poke_bp() kernel-doc comment
>    #2. 3a1255396b5a x86/alternatives: add missing insn.h include
>    #1. c3d6324f841b x86/alternatives: Teach text_poke_bp() to emulate instructions
> 
>   Note: #8-11 are follow-up fixes for #7
>         #2-3 are follow-up fixes for #1

That's a lot to backport. Perhaps there's a simpler solution?

> 
> According to [1], no regressions were observed on x86_64, which included
> running kselftest-ftrace. So I'm a bit confused.

Yeah, that's a big failure!

Maybe they only tested a min config with no ftrace enabled?

> 
> Could someone take a look and shed light on this? (ftrace on linux-5.4.y x86)

I would like to know too!

> 
> Thanks.
> 
> [1] https://lore.kernel.org/stable/CA+G9fYtdzDCDP_RxjPKS5wvQH=NsjT+bDRbukFqoX6cN+EHa7Q@mail.gmail.com/

Anyway, this appears to fix it (for 5.4 and earlier):

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 380032a27f98..2eb1a8ec5755 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1554,7 +1554,7 @@ unsigned long ftrace_location_range(unsigned long start, unsigned long end)
 	struct dyn_ftrace key;
 	unsigned long ip = 0;
 
-	rcu_read_lock();
+	preempt_disable_notrace();
 	key.ip = start;
 	key.flags = end;	/* overload flags, as it is unsigned long */
 
@@ -1572,7 +1572,7 @@ unsigned long ftrace_location_range(unsigned long start, unsigned long end)
 			break;
 		}
 	}
-	rcu_read_unlock();
+	preempt_enable_notrace();
 	return ip;
 }
 

If someone would like to apply that, feel free. As preempt_disable() will
give RCU protection as well.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve
