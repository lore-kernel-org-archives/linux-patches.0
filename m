Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01D62F3A
	for <patches@lists.linux.dev>; Wed,  4 May 2022 21:01:15 +0000 (UTC)
Received: from zn.tnic (p5de8eeb4.dip0.t-ipconnect.de [93.232.238.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9D53E1EC0354;
	Wed,  4 May 2022 23:01:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1651698069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=CVQhTFxBk4LR/y/BsUV+TEsrpPonN5g3FeS0pnSesIg=;
	b=PgdoSq+mYUSotajou9NuBD5oB9gB1N5TMOLRDCPzZaD4gNOLPYQD0kanV60FeW1IBxGQZm
	hpZsQi6FZJLf2tO6+mN4KInMJLLy3l316tMSK8JPZL6EyFLaQxbvz4P6gohtI2fBQNI3Xm
	SsgDtXan3Yu5yDmWJ0gjaUjVmD9wpnM=
Date: Wed, 4 May 2022 23:01:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Hemment <markhemm@googlemail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	the arch/x86 maintainers <x86@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, patrice.chotard@foss.st.com,
	Mikulas Patocka <mpatocka@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Hugh Dickins <hughd@google.com>, patches@lists.linux.dev,
	Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
	Mel Gorman <mgorman@suse.de>
Subject: Re: [patch 02/14] tmpfs: fix regressions from wider use of ZERO_PAGE
Message-ID: <YnLplKy0Y66SsvQw@zn.tnic>
References: <YmWm5AXdwgwu57KZ@zn.tnic>
 <CAHk-=wgFnTbbeR0NAsGGsoBBThXt9Zh5_acN47r4CF0PdgSNeA@mail.gmail.com>
 <YmiK7Bos+zLAvL0t@zn.tnic>
 <CAHk-=winO-QozwEEKeZJsT9Cux+JbihocPWhjm3m1RGTQwViDg@mail.gmail.com>
 <YmkdxaKdc2w/3I7o@zn.tnic>
 <CAHk-=wg=D9eaDHU5yHpqf_G7zTBcv6yU1kkNzV6KKb5jttNxvA@mail.gmail.com>
 <YnLMSWbz6BNfsBME@zn.tnic>
 <CAHk-=wh_62HBCz1g_6mKP71XOvJAs3JwBz0=jve2mg1DGWPq5g@mail.gmail.com>
 <YnLfl6lupN2nq7+t@zn.tnic>
 <CAHk-=wiGbrJMim6EWncZUQBzguqy-vtNd+grfNizm5L8Vcmu+w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wiGbrJMim6EWncZUQBzguqy-vtNd+grfNizm5L8Vcmu+w@mail.gmail.com>

On Wed, May 04, 2022 at 01:40:07PM -0700, Linus Torvalds wrote:
> Sadly, I'm on Zen2 with my 3970X, and the Zen 3 threadrippers seem to
> be basically impossible to get.

Yeah, what we did is get a gigabyte board:

[    0.000000] DMI: GIGABYTE MZ32-AR0-00/MZ32-AR0-00, BIOS M06 07/10/2021

and stick a server CPU in it:

[    2.352371] smpboot: CPU0: AMD EPYC 7313 16-Core Processor (family: 0x19, model: 0x1, stepping: 0x1)

so that we can have the memory encryption stuff. 32 threads is fairly
decent and kernel builds are fast enough, at least for me. If you need
to do a lot of allmodconfigs, you probably need something bigger though.

> Oh, the clear_user() in the ELF loader? I wouldn't have expected that
> to be noticeable.

Yah, that guy in load_elf_binary(). At least it did hit my breakpoint
fairly often so I thought, what is a benchmark that does create a lot of
processes...

> Now, clear_page() is *very* noticeable, but that has its own special
> magic and doesn't use clear_user().

Yeah, that's with the alternative CALL thing. Could be useful to try to
see how much the inlined rep; movsb would bring...

> Maybe there is some other clear_user() case I never thought of. My
> dim memories of profiles definitely had copy_to_user, clear_page and
> copy_page being some of the top copy loops.

I could try to do a perf probe or whatever fancy new thing we do now on
clear_user to get some numbers of how many times it gets called during
the benchmark run. Or do you wanna know the callers too?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
