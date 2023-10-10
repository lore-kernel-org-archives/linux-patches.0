Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24E532192;
	Tue, 10 Oct 2023 19:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HQ9gb11R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F7EC433C8;
	Tue, 10 Oct 2023 19:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696967569;
	bh=u6XkChwgLKXRpmaMTPiMR4qyFXezaXl3BACHiWQ3Xfo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HQ9gb11RxEYh8c8r4b+PxPv5ICATgjDdOAsQ9qOGP77ezjd0PX8ETklOYqrrpycRB
	 lDok5EdQOFnpCdImOAqX6DzcGJFBNvgJBfku3c+Mqcd3JiWesL6NxNlUEfjhzVZ21s
	 2m8c2fbdzpYVvRYOyRYuMpqGzXPOvBtsJ8LaOtz5uzYNigPIIczQ9A6IrovSnbLzZO
	 7u6FzBKQx2a0VsGGQ0BrOkuhXuUTt0bA1O0sIVYaEQyVskXZTMvd0R6HYWnQL/Pz9s
	 YZ/eQL96wTPljzXW76kv4bk5eb4/Jix2EXkl4KS5Oo5vWEBhir+9lJLR6fu147R40e
	 dRZYK+xUVJ8Ow==
Date: Tue, 10 Oct 2023 12:52:47 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	conor@kernel.org, trix@redhat.com, samitolvanen@google.com,
	twd2.me@gmail.com, linux-riscv@lists.infradead.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH v3] RISC-V: build: Allow LTO to be selected
Message-ID: <20231010195247.GA2233717@dev-arch.thelio-3990X>
References: <20231003-riscv-lto-v3-1-8aca61a4ecb4@kernel.org>
 <CAKwvOdnMeM4YArw=hyVkev11cLfks5gaXWXNK+Wo0bcbeuMZHg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKwvOdnMeM4YArw=hyVkev11cLfks5gaXWXNK+Wo0bcbeuMZHg@mail.gmail.com>

On Tue, Oct 10, 2023 at 10:03:15AM -0700, Nick Desaulniers wrote:
> On Tue, Oct 3, 2023 at 12:17 PM Nathan Chancellor <nathan@kernel.org> wrote:
> >
> > From: Wende Tan <twd2.me@gmail.com>
> >
> > Allow LTO to be selected for RISC-V, only when LLD >= 14, since there is an
> > issue [1] in prior LLD versions that prevents LLD to generate proper
> > machine code for RISC-V when writing `nop`s.
> >
> > I have tested enabling LTO for `defconfig`. The LLD took ~2m21s and ~3GiB
> > on our Intel Xeon Gold 6140 server and produced an 18MiB Image. The image
> > can boot to shell using an archriscv rootfs on QEMU.
> >
> > I have also tested it for `allyesconfig` without COMPILE_TEST, FTRACE,
> > KASAN, and GCOV. The LLD took ~7h03m and ~335GiB on the server,
> > successfully producing a 1.7GiB Image. Unfortunately, we cannot boot this
> > image because the `create_kernel_page_table()` -> `alloc_pmd_early()` ->
> > `BUG_ON()` logic limits the image to be < 1GiB. Maybe we can fix it in a
> > separate patch further.
> >
> > Disable LTO for arch/riscv/kernel/pi, as llvm-objcopy expects an ELF
> > object file when manipulating the files in that subfolder, rather than
> > LLVM bitcode.
> >
> > [1] https://github.com/llvm/llvm-project/issues/50505, resolved by LLVM
> >     commit e63455d5e0e5 ("[MC] Use local MCSubtargetInfo in writeNops")
> >
> > Tested-by: Wende Tan <twd2.me@gmail.com>
> > Signed-off-by: Wende Tan <twd2.me@gmail.com>
> > Co-developed-by: Nathan Chancellor <nathan@kernel.org>
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> 
> Perhaps worth a v4 due to linker relaxation resulting in boot failures
> you observed:
> https://github.com/ClangBuiltLinux/linux/issues/1942 ?

Yes, agreed. RISC-V patchwork folks, consider marking this as "Changes
Requested" or whatever other status there is that indicates that I need
to send a v4 working around that issue, at least until we better
understand the issue.

Cheers,
Natha
