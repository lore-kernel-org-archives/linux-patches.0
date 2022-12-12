Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549CD2F58
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 21:01:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B883C433EF;
	Mon, 12 Dec 2022 21:01:37 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ROzf0OEV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1670878895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+33heWZqPNvN/OOyLci+aYXHO8pTl7ySUh12yfzj1hI=;
	b=ROzf0OEVcwV9kZSenrrYUtosBdsEhtxY7C5PILTab3NuW9wgoBfEK7sg5PUW//W6yifT10
	ENmm15ZqndAQutSnhGJelFw/OERj0DcstMOjf1WGns0U/WRd3zssrruw/4aQoaNXtR6aB3
	zGr3RiiFUgrPUH0iNcctwVACAJvXiS4=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b60ecb78 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Mon, 12 Dec 2022 21:01:35 +0000 (UTC)
Date: Mon, 12 Dec 2022 14:01:33 -0700
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	tglx@linutronix.de
Cc: linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
	Carlos O'Donell <carlos@redhat.com>,
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Jann Horn <jannh@google.com>,
	Christian Brauner <brauner@kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH RFC v12 2/6] x86: mm: Skip faulting instruction for
 VM_DROPPABLE faults
Message-ID: <Y5eWrYSCmKBG3MVS@zx2c4.com>
References: <20221212185347.1286824-1-Jason@zx2c4.com>
 <20221212185347.1286824-3-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221212185347.1286824-3-Jason@zx2c4.com>

On Mon, Dec 12, 2022 at 11:53:43AM -0700, Jason A. Donenfeld wrote:
> +	if (fault & VM_FAULT_SKIP_INSN) {
> +		u8 insn_buf[MAX_INSN_SIZE];
> +		struct insn insn;
> +		size_t len;
> +
> +		len = sizeof(insn_buf) - copy_from_user(insn_buf, (void *)regs->ip, sizeof(insn_buf));
> +		if (!len)
> +			return;
> +
> +		if (insn_decode(&insn, insn_buf, len, in_32bit_syscall() ? INSN_MODE_32 : INSN_MODE_64) < 0)
> +			return;
> +
> +		regs->ip += insn.length;
> +		return;
> +	}

I just found umip.c, which does basically the same thing, but does it
correctly. For v+1, the above snippet will instead do this:

	if (fault & VM_FAULT_SKIP_INSN) {
		u8 buf[MAX_INSN_SIZE];
		struct insn insn;
		int nr_copied;

		nr_copied = insn_fetch_from_user(regs, buf);
		if (nr_copied <= 0)
			return;

		if (!insn_decode_from_regs(&insn, regs, buf, nr_copied))
			return;

		regs->ip += insn.length;
		return;
	}

Same thing, but those helpers do correct inspection of the environment
and registers.

Also, seeing this already being done in umip.c is heartening that the
approach here isn't overly insane.

Jason
