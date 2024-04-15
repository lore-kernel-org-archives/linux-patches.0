Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0591553A2;
	Mon, 15 Apr 2024 18:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713205953; cv=none; b=CrNsQVLM5if+VEy35yfmydXdWauQD2G8s7MVeHhMkNysz3W+l9USV9dOf9mHsB6S6SgqBAQD/ws6u3rVUzPzT4VnmRyEaRI9n7wpH189iB8CDj3nHRcB8Dq/kvG9wRgbdoc8WIZnJuAnjmcTXSo6A2ajhDPKAtUNbglo4Iy26VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713205953; c=relaxed/simple;
	bh=CG7UrxiclCzOT3p6JpR2Gw4yfNeQuA+CZtiI3k6cX/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GQ978oRxpaaL76xGCB8ZGf52YGZH/WrM7Fgn0KRZ7ZfRVw/BtCVZ6i+MnNDsMhLTZitkE8yfnobeun2GoguGWTK770PNdnUe7Q7m4jskIthZGk0FMt7iCZSUXKgrsWGuAOmmL32iJaY+AflJgM4TyUP3+B6kTn3gaF4gHJjcpA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kweOLtnr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kweOLtnr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BEAAC113CC;
	Mon, 15 Apr 2024 18:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713205952;
	bh=CG7UrxiclCzOT3p6JpR2Gw4yfNeQuA+CZtiI3k6cX/I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kweOLtnrZS6ULiNjjAANs5MyE9uTN5M0jQptaSd//PDOWqmlDXJnXgNx4MO+zwuD9
	 XC+cIi8gqj17tpAuiHjiPQF3TLM74nHgWY4Tgm8IusYk1801wQc3M0kA3Z8/m6nSkm
	 UuXob0JKWkylhbqgeE9qgODJOXkLStCfPDEz6ihHyhHBen/EA+qtpDxOeF2+yzWNn9
	 DyLjNSNa1VRC+oOXhPM4hSf4vhoqU/jwAZkmMCutnkdPt4xE9H8C+RN7TPrBOw9GO2
	 elpLxDWmER/GtUYjmuqFX0vX2H8TcXUd6s4uKScsfbv6XMljTVbwjYVplj9NiHzWp+
	 bbq03jdmkqMMw==
Date: Mon, 15 Apr 2024 11:32:30 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: gustavoars@kernel.org, justinstitt@google.com,
	linux-hardening@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 0/2] configs/hardening: Some fixes for UBSAN
Message-ID: <20240415183230.GA1011455@dev-arch.thelio-3990X>
References: <20240411-fix-ubsan-in-hardening-config-v1-0-e0177c80ffaa@kernel.org>
 <202404151110.8D4AD8E@keescook>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202404151110.8D4AD8E@keescook>

On Mon, Apr 15, 2024 at 11:15:05AM -0700, Kees Cook wrote:
> On Thu, Apr 11, 2024 at 11:11:05AM -0700, Nathan Chancellor wrote:
> >   [    0.189542] Internal error: UBSAN: unrecognized failure code: 00000000f2005515 [#1] PREEMPT SMP
> 
> Oops! Yes, I didn't update the (arm64) trap handler to notice integer
> overflows. I think I need something like:
> 
> diff --git a/lib/ubsan.c b/lib/ubsan.c
> index 5fc107f61934..a2fb19f75825 100644
> --- a/lib/ubsan.c
> +++ b/lib/ubsan.c
> @@ -77,6 +77,14 @@ const char *report_ubsan_failure(struct pt_regs *regs, u32 check_type)
>  		return "UBSAN: alignment assumption";
>  	case ubsan_type_mismatch:
>  		return "UBSAN: type mismatch";
> +#endif
> +#ifdef CONFIG_UBSAN_SIGNED_INTEGER_WRAP

This should be CONFIG_UBSAN_SIGNED_WRAP

> +	case ubsan_add_overflow:
> +		return "UBSAN: integer addition overflow";
> +	case ubsan_sub_overflow:
> +		return "UBSAN: integer subtraction overflow";
> +	case ubsan_mul_overflow:
> +		return "UBSAN: integer multiplication overflow";
>  #endif
>  	default:
>  		return "UBSAN: unrecognized failure code";

but with that fixed, it becomes

  [    0.208004] Internal error: UBSAN: integer subtraction overflow: 00000000f2005515 [#1] PREEMPT SMP

so LGTM.

> >   [    0.198326] Call trace:
> >   [    0.198544]  cancel_delayed_work+0x54/0x94
> >   [    0.198810]  deferred_probe_extend_timeout+0x20/0x6c
> >   [    0.198988]  driver_register+0xa8/0x10c
> >   [    0.199122]  __platform_driver_register+0x28/0x38
> >   [    0.199258]  tegra194_cbb_init+0x24/0x34
> 
> Justin, does this trace match anything you found running syzkaller
> against SIO? (I assume not -- this seems to be a tegra code path...)

FWIW, it is also visible with x86_64 in some other driver, so it is
likely not a driver specific issue (at least not to one driver).

[    0.219560] Oops: invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
[    0.220441] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.9.0-rc4-next-20240415-dirty #1
[    0.220441] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
[    0.220441] RIP: 0010:cancel_delayed_work+0x23/0x40
[    0.220441] Code: 90 90 90 90 90 90 90 f3 0f 1e fa 53 50 48 89 fb 48 c7 04 24 00 00 00 00 48 89 e2 be 01 00 00 00 e8 02 eb ff ff f6 03 04 75 05 <67> 0f b9 40 15 90 0f 0b 90 67 0f b9 40 15 66 66 66 66 66 66 2e 0f
[    0.220441] RSP: 0018:ffffa51600017b30 EFLAGS: 00010046
[    0.220441] RAX: 0000000000000000 RBX: ffffffff997db830 RCX: 6da351d27a629a00
[    0.220441] RDX: ffffa51600017b01 RSI: 0000000000000000 RDI: ffffffff997db850
[    0.220441] RBP: ffffa51600017ea8 R08: 0000000000000001 R09: 000000000000000a
[    0.220441] R10: 0000410110000001 R11: 0000000000000000 R12: 0000000000000000
[    0.220441] R13: 0000000000000000 R14: ffffffff99f2e474 R15: 0000000000000000
[    0.220441] FS:  0000000000000000(0000) GS:ffff8c485d200000(0000) knlGS:0000000000000000
[    0.220441] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.220441] CR2: ffff8c4854401000 CR3: 000000001382a000 CR4: 0000000000350ef0
[    0.220441] Call Trace:
[    0.220441]  <TASK>
[    0.220441]  ? __die_body+0x65/0xb0
[    0.220441]  ? die+0xa5/0xd0
[    0.220441]  ? do_trap+0xa1/0x170
[    0.220441]  ? cancel_delayed_work+0x23/0x40
[    0.220441]  ? cancel_delayed_work+0x23/0x40
[    0.220441]  ? handle_invalid_op+0x65/0x80
[    0.220441]  ? cancel_delayed_work+0x23/0x40
[    0.220441]  ? exc_invalid_op+0x39/0x50
[    0.220441]  ? asm_exc_invalid_op+0x1a/0x20
[    0.220441]  ? cancel_delayed_work+0x23/0x40
[    0.220441]  deferred_probe_extend_timeout+0x10/0x50
[    0.220441]  driver_register+0xa9/0x110
[    0.220441]  i2c_register_driver+0x40/0xa0
[    0.220441]  i2c_init+0x8b/0xe0
[    0.220441]  ? __pfx_i2c_init+0x10/0x10
[    0.220441]  do_one_initcall+0x110/0x350
[    0.220441]  ? kernfs_xattr_get+0x34/0x70
[    0.220441]  ? srso_return_thunk+0x5/0x5f
[    0.220441]  ? __alloc_pages_noprof+0x186/0x320
[    0.220441]  ? srso_return_thunk+0x5/0x5f
[    0.220441]  ? __get_random_u32_below+0xe/0x60
[    0.220441]  ? srso_return_thunk+0x5/0x5f
[    0.220441]  ? new_slab+0x1d6/0x710
[    0.220441]  ? new_slab+0x1d6/0x710
[    0.220441]  ? srso_return_thunk+0x5/0x5f
[    0.220441]  ? number+0x166/0x530
[    0.220441]  ? srso_return_thunk+0x5/0x5f
[    0.220441]  ? ida_alloc_range+0x459/0x4a0
[    0.220441]  ? srso_return_thunk+0x5/0x5f
[    0.220441]  ? parameq+0x12/0x90
[    0.220441]  ? srso_return_thunk+0x5/0x5f
[    0.220441]  ? srso_return_thunk+0x5/0x5f
[    0.220441]  ? parse_args+0x137/0x340
[    0.220441]  do_initcall_level+0x85/0x100
[    0.220441]  do_initcalls+0x54/0x90
[    0.220441]  kernel_init_freeable+0xf2/0x160
[    0.220441]  ? __pfx_kernel_init+0x10/0x10
[    0.220441]  kernel_init+0x15/0x1b0
[    0.220441]  ret_from_fork+0x35/0x40
[    0.220441]  ? __pfx_kernel_init+0x10/0x10
[    0.220441]  ret_from_fork_asm+0x1a/0x30
[    0.220441]  </TASK>
[    0.220441] Modules linked in:
[    0.220441] ---[ end trace 0000000000000000 ]---
[    0.220441] RIP: 0010:cancel_delayed_work+0x23/0x40
[    0.220441] Code: 90 90 90 90 90 90 90 f3 0f 1e fa 53 50 48 89 fb 48 c7 04 24 00 00 00 00 48 89 e2 be 01 00 00 00 e8 02 eb ff ff f6 03 04 75 05 <67> 0f b9 40 15 90 0f 0b 90 67 0f b9 40 15 66 66 66 66 66 66 2e 0f
[    0.220441] RSP: 0018:ffffa51600017b30 EFLAGS: 00010046
[    0.220441] RAX: 0000000000000000 RBX: ffffffff997db830 RCX: 6da351d27a629a00
[    0.220441] RDX: ffffa51600017b01 RSI: 0000000000000000 RDI: ffffffff997db850
[    0.220441] RBP: ffffa51600017ea8 R08: 0000000000000001 R09: 000000000000000a
[    0.220441] R10: 0000410110000001 R11: 0000000000000000 R12: 0000000000000000
[    0.220441] R13: 0000000000000000 R14: ffffffff99f2e474 R15: 0000000000000000
[    0.220441] FS:  0000000000000000(0000) GS:ffff8c485d200000(0000) knlGS:0000000000000000
[    0.220441] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.220441] CR2: ffff8c4854401000 CR3: 000000001382a000 CR4: 0000000000350ef0

Cheers,
Nathan
