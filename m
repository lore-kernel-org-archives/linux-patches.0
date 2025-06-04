Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926EF746E;
	Wed,  4 Jun 2025 01:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748999673; cv=none; b=jurrOkpOK56Ks7B7bRJ9awlU5xEIZ0bUsejpFOHbWIkU3Qup04IrfD+Pz+RAjLGFI1R87f40F145g3fs0sBmNx8GPxXjYYuH4xFVXi1/ev04v5duGrO5FAgHexlyU3fx5Q7hVktLkI3bqmvj0uA7zZk9PdDjcNCfwBKbekmUD5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748999673; c=relaxed/simple;
	bh=52I+rIIkcGx0tQWOqBUyrsOzqLA+368eas7GzximvAE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D80+4HoOjAut5Pg753n3LpZPGJ2F6P/QBzC7vxBqk3LS7VQm4c4jXYqiuN58NdGB9K54uIt3+KzF4OCsd8pofGeGhaAmqIahvK2R9WtqmJUDM3GGl7Jywb4mGeqfloVLnfdKthUfRUa5Ggb3lGg3kxA4JTvKyfQ3g99j7FBzhoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC36C4CEED;
	Wed,  4 Jun 2025 01:14:32 +0000 (UTC)
Date: Tue, 3 Jun 2025 21:15:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.15 070/118] tracing: Only return an adjusted
 address if it matches the kernel address
Message-ID: <20250603211547.32aed8e9@gandalf.local.home>
In-Reply-To: <20250604005049.4147522-70-sashal@kernel.org>
References: <20250604005049.4147522-1-sashal@kernel.org>
	<20250604005049.4147522-70-sashal@kernel.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue,  3 Jun 2025 20:50:01 -0400
Sasha Levin <sashal@kernel.org> wrote:

> From: Steven Rostedt <rostedt@goodmis.org>
>=20
> [ Upstream commit 00d872dd541cdf22230510201a1baf58f0147db9 ]
>=20
> The trace_adjust_address() will take a given address and examine the
> persistent ring buffer to see if the address matches a module that is
> listed there. If it does not, it will just adjust the value to the core
> kernel delta. But if the address was for something that was not part of
> the core kernel text or data it should not be adjusted.
>=20
> Check the result of the adjustment and only return the adjustment if it
> lands in the current kernel text or data. If not, return the original
> address.
>=20
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Link: https://lore.kernel.org/20250506102300.0ba2f9e0@gandalf.local.home
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>=20

I guess the following blurb is new.

> **YES** This commit should be backported to stable kernel trees based on

Hmm, I'm not so sure the analysis is correct.

> the following comprehensive analysis: ## Security Analysis ### 1.
> **Critical Security Fix** The commit addresses a significant security
> vulnerability in the `trace_adjust_address()` function. The change on
> lines 6148-6149 adds crucial validation: ```c raddr =3D addr +
> tr->text_delta; return __is_kernel(raddr) || is_kernel_core_data(raddr)
> || is_kernel_rodata(raddr) ? raddr : addr; ``` **Before the fix**: The
> function would blindly return `addr + tr->text_delta` without validating
> whether the resulting address falls within legitimate kernel memory

If you look at the code, it will return the address regardless if it is
within the kernel memory or not.

This is called when reading addresses that are in the persistent ring
buffer from a previous boot.

Before the "fix":

  It would always add the text_delta to the address.

The issue without that is that it could be adjusting a pointer that was to
allocated memory. It makes no sense to do this. The reason for doing this
adjustment is because a lot of reads of addresses use "%pS", and we care
only about getting a proper kallsyms of the address.

Thus what is done is:

		raddr =3D addr + tr->text_delta;
		return __is_kernel(raddr) || is_kernel_core_data(raddr) ||
			is_kernel_rodata(raddr) ? raddr : addr;

Which does the adjustment, and if it falls into kernel memory or data
return that adjustment, otherwise return the original address. The reason
is that by returning the adjusted memory, it may fall into a module that we
do not want to print kallsyms for.

> regions. **After the fix**: The function validates that adjusted
> addresses only point to valid kernel sections (text, core data, or read-
> only data). If the adjusted address doesn't fall within these legitimate
> regions, it returns the original address unchanged. ### 2. **KASLR
> Protection** This fix is particularly important for KASLR (Kernel
> Address Space Layout Randomization) security: - **Information Disclosure

It doesn't risk any KASLR information. All addresses used by
trace_adjust_address() is from a pointer that existed in a previous boot.
The adjustment is pretty meaningless if it's not in kernel text or data.

> Risk**: Without validation, the function could return addresses pointing
> to arbitrary memory locations, potentially leaking kernel address layout
> information - **KASLR Bypass**: Invalid address adjustments could reveal
> the kernel's memory layout, defeating KASLR protections - **Cross-boot
> attacks**: The persistent ring buffer functionality could be exploited
> to extract address information from previous boot sessions ### 3.
> **Memory Safety** The validation prevents potential memory corruption
> scenarios: - **Out-of-bounds access**: Ensures addresses used for symbol
> resolution and string dereferencing are within valid kernel regions -
> **Kernel crashes**: Prevents dereferencing of invalid addresses that
> could cause kernel panics - **Information leakage**: Stops potential
> disclosure of arbitrary kernel memory contents ### 4. **Limited Risk of
> Regression** This is a defensive fix that only affects the tracing
> subsystem: - **Minimal impact**: Only changes behavior when addresses
> would be invalid anyway - **Backwards compatible**: Legitimate addresses
> continue to work as before - **Contained scope**: Limited to persistent
> ring buffer functionality ### 5. **Alignment with Stable Tree Criteria**
> The commit meets all the criteria for stable tree backporting: - =E2=9C=85
> **Important bug fix**: Addresses a security vulnerability - =E2=9C=85 **S=
mall
> and contained**: Only adds validation logic, doesn't change architecture
> - =E2=9C=85 **Minimal regression risk**: Defensive change that only affec=
ts
> invalid cases - =E2=9C=85 **Clear benefit**: Improves kernel security wit=
hout
> breaking functionality - =E2=9C=85 **Non-feature**: Pure security fix, not
> adding new functionality ### 6. **Real-world Impact** This vulnerability
> could be exploited in environments where: - Persistent tracing is
> enabled across reboots - Attackers have access to trace output - Systems

Yes persistent tracing is enabled across reboots and the address is from a
previous boot. It does return the actual address of the current boot to use
with %pS when it was on the kernel text or data address. When it isn't
(likely a module address) the adjustment is meaningless and may give bad
trace output at most.

If an attacker has access to trace output KASLR is already lost, as
function tracing records raw addresses and exposes everything KASLR, which
is why reading these files is a privilege operation.

I won't argue against backporting, but I just wanted to state this analysis
may not be correct.

-- Steve


> rely on KASLR for security The fix ensures that the tracing subsystem
> cannot be used as a vector for kernel address space information
> disclosure or memory corruption attacks. **Conclusion**: This is a clear
> security fix that should be backported to maintain the security
> integrity of stable kernel releases.
>=20
>  kernel/trace/trace.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 5b8db27fb6ef3..01572ef79802f 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -6032,6 +6032,7 @@ unsigned long trace_adjust_address(struct trace_arr=
ay *tr, unsigned long addr)
>  	struct trace_module_delta *module_delta;
>  	struct trace_scratch *tscratch;
>  	struct trace_mod_entry *entry;
> +	unsigned long raddr;
>  	int idx =3D 0, nr_entries;
> =20
>  	/* If we don't have last boot delta, return the address */
> @@ -6045,7 +6046,9 @@ unsigned long trace_adjust_address(struct trace_arr=
ay *tr, unsigned long addr)
>  	module_delta =3D READ_ONCE(tr->module_delta);
>  	if (!module_delta || !tscratch->nr_entries ||
>  	    tscratch->entries[0].mod_addr > addr) {
> -		return addr + tr->text_delta;
> +		raddr =3D addr + tr->text_delta;
> +		return __is_kernel(raddr) || is_kernel_core_data(raddr) ||
> +			is_kernel_rodata(raddr) ? raddr : addr;
>  	}
> =20
>  	/* Note that entries must be sorted. */

