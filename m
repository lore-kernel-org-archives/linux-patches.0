Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B5A2C9D
	for <patches@lists.linux.dev>; Fri, 17 Mar 2023 23:31:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316C3C433D2;
	Fri, 17 Mar 2023 23:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1679095884;
	bh=BKv2lCgkapt88k5JeE6qHL3HDvWVl7vxGoYxVYQNE6g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AZS77oFPc8vjt+NncTCzc4g5EY3J3gWnYeRoc2YSm+RS4YyFYLI8uZALE3Il4OSIU
	 COeo5BuUNlxyKdh0no6EKsx2h4/O0mGmXcBvUmxaUZLvoOtD8eaFEg4e+xcWb+9gfm
	 +EHeTbpFPV0M4xhcfEJZnAmfSMySgJcJaleWErkL5z3WfJPk6ZOBss195aDbL4PWB/
	 F3vCgvtdSe1u3WQyzINZxVvaRYchT7RtdfGlFn0+Dfcfwad73hANwBkKmsMv82e7AE
	 pFpqMhEjKrwMzkKdx72bZ1aUri4xedhOHvtzxG3wpo775n2w2TN/jF27Hz0+lbLEY4
	 oHKObMRWSyJ1Q==
Date: Fri, 17 Mar 2023 16:31:22 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Petr Mladek <pmladek@suse.com>,
	Song Liu <song@kernel.org>, patches@lists.linux.dev,
	linux-modules@vger.kernel.org, live-patching@vger.kernel.org,
	linux-kbuild@vger.kernel.org
Subject: Re: mod->klp set on copy ok ?
Message-ID: <20230317233122.4vsewgrb3nq574fs@treble>
References: <CAB=NE6Vo4AXVrn1GPEoZWVF3NkXRoPwWOuUEJqJ35S9VMGTM2Q@mail.gmail.com>
 <ZA8NBuXbVP+PRPp0@alley>
 <ZBOPP4YWWhJRk2yn@bombadil.infradead.org>
 <20230317161639.3de7yeek6ia4y7ul@treble>
 <ZBS42Lid+CX0h0fk@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZBS42Lid+CX0h0fk@bombadil.infradead.org>

On Fri, Mar 17, 2023 at 12:00:40PM -0700, Luis Chamberlain wrote:
> > I dug into that code years ago, and the above sounds right.
> > 
> > The .ko file has a .gnu.linkonce.this_module section whose data is just
> > the original "struct module __this_module" which is created by the
> > module build (from foo.mod.c).
> > 
> > At the beginning of the finit_module() syscall, the .ko file's ELF
> > sections get copied (and optionally decompressed) into kernel memory.
> > Then 'mod' just points to the copied __this_module struct.
> > 
> > Then mod->klp (and possibly mod->taint) get set.
> > 
> > Then in layout_and_allocate(), that 'mod' gets memcpy'd into the second
> > (and final) in-kernel copy of 'struct module':
> > 
> >  		if (shdr->sh_type != SHT_NOBITS)
> >  			memcpy(dest, (void *)shdr->sh_addr, shdr->sh_size);
> >  		/* Update sh_addr to point to copy in image. */
> >  		shdr->sh_addr = (unsigned long)dest;
> > 
> > I suspect you don't see the size changing when you add to 'struct
> > module' because it's ____cacheline_aligned.
> > 
> > It's all rather obtuse, but working as designed as far as I can tell.
> 
> Ah, well it is beyond a ____cacheline_aligned issue! It would seem our build
> system does not incur a full re-build of $foo.mod.c if the size of struct module
> changes. Doing a full rebuild does get the right drift size change in
> struct module:

Ah, ok.  It sounds like build dependencies are broken for *.mod.c.

The added validations in the patch look reasonable, though the broken
build dependencies should also get fixed.

-- 
Josh
