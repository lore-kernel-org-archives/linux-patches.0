Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0A27466
	for <patches@lists.linux.dev>; Fri, 17 Mar 2023 16:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254F6C4339B;
	Fri, 17 Mar 2023 16:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1679069801;
	bh=73c1YHqM5bs0yeTOn+ydHweRhCIAl4DTHPV1qGN6k3E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eJO9APYzVwm1/pju51IShJ157Sq2967OU4rNmVQyxCKT88dwxYQpdLRouYUow2h2J
	 Weil0XKQ1VexbEH15v4Djo0ZAix2D6H3SP44Cl/WIV8f05eo3VEhyPieNUva/KH7p3
	 f9LG6hkvwwz0d3muk9wwdbElMhOEcZafhI1gWxWP1a5Vtn/ZYFglsP9vjm1utwoVQU
	 jxu4tSIgbUGUVkW8kaOLvN+MhW9rXGWAo+Cdq6gTme0CNqQ7DPBvfRT05kaz5wkPrh
	 NdHjRRI6r5ZYhLy87L0ApoYlG/rf4XrFp1P/QiKwueY3yXS7FMyFP9moQptY/npAtb
	 CSRDST6a7oRiw==
Date: Fri, 17 Mar 2023 09:16:39 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>, Song Liu <song@kernel.org>,
	patches@lists.linux.dev, linux-modules@vger.kernel.org,
	live-patching@vger.kernel.org
Subject: Re: mod->klp set on copy ok ?
Message-ID: <20230317161639.3de7yeek6ia4y7ul@treble>
References: <CAB=NE6Vo4AXVrn1GPEoZWVF3NkXRoPwWOuUEJqJ35S9VMGTM2Q@mail.gmail.com>
 <ZA8NBuXbVP+PRPp0@alley>
 <ZBOPP4YWWhJRk2yn@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZBOPP4YWWhJRk2yn@bombadil.infradead.org>

On Thu, Mar 16, 2023 at 02:50:55PM -0700, Luis Chamberlain wrote:
> The comment for "Update sh_addr to point to copy in image." seems pretty
> misleading to me, what we are doing there is actually ensuring that we update
> the copy's ELF section address to point to our newly allocated memory.
> Do folks agree?
> 
> And how about the size on the memcpy()? That's a shd->sh_size. No matter
> how much I increase my struct module in include/linux/module.h I see
> thes same sh_size. Do folks see same?
> 
> nm --print-size --size-sort fs/xfs/xfs.ko | grep __this_module
> 0000000000000000 0000000000000500 D __this_module
> 
> This is what is supposed to make the final part of layout_and_allocate() work:
> 
> 	mod = (void *)info->sechdrs[info->index.mod].sh_addr;
> 
> This works off of the copy of the module. Let's recall that
> setup_load_info() sets the copy mod to:
> 
> 	info->mod = (void *)info->hdr + info->sechdrs[info->index.mod].sh_offset;
> 
> The memcpy() in move_module() is what *should* be copying over the entire
> mod stuff properly over, that includes the mod->klp for live patching
> but also any new data we muck with in-kernel as the new mod->mem stuff
> in layout_sections(). In short, anything in struct module should be
> shoved into an ELF section. But I'm not quite sure this is all right.

I dug into that code years ago, and the above sounds right.

The .ko file has a .gnu.linkonce.this_module section whose data is just
the original "struct module __this_module" which is created by the
module build (from foo.mod.c).

At the beginning of the finit_module() syscall, the .ko file's ELF
sections get copied (and optionally decompressed) into kernel memory.
Then 'mod' just points to the copied __this_module struct.

Then mod->klp (and possibly mod->taint) get set.

Then in layout_and_allocate(), that 'mod' gets memcpy'd into the second
(and final) in-kernel copy of 'struct module':

 		if (shdr->sh_type != SHT_NOBITS)
 			memcpy(dest, (void *)shdr->sh_addr, shdr->sh_size);
 		/* Update sh_addr to point to copy in image. */
 		shdr->sh_addr = (unsigned long)dest;

I suspect you don't see the size changing when you add to 'struct
module' because it's ____cacheline_aligned.

It's all rather obtuse, but working as designed as far as I can tell.

-- 
Josh
