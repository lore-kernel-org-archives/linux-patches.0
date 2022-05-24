Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7F22569
	for <patches@lists.linux.dev>; Tue, 24 May 2022 17:30:54 +0000 (UTC)
Received: from zn.tnic (p200300ea974657c6329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9746:57c6:329c:23ff:fea6:a903])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EF15F1EC0575;
	Tue, 24 May 2022 19:30:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1653413448;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=pFQzpaguKn2mw/j/BFZbpHvd9rTOTeSw8JSaYmA89ps=;
	b=k3eaDOkk+lic2WnoLwZaWoGj6rQtfhwSKTGcZ9TvhdBkaO5O55kpjEuHJR6GdGm4kQglVt
	fEmIr2e4MEXpdy3ahh7/hslFaq/p5xjYhZlvbN7El0nJt4a3L7MWCD9kLndPSjTqPQD4kB
	c4RNXu2WHC3LuUKTMLfDFuFaoCWDohQ=
Date: Tue, 24 May 2022 19:30:43 +0200
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
Subject: Re: [PATCH] x86/clear_user: Make it faster
Message-ID: <Yo0WQ0JNElGswnrq@zn.tnic>
References: <YnLfl6lupN2nq7+t@zn.tnic>
 <CAHk-=wiGbrJMim6EWncZUQBzguqy-vtNd+grfNizm5L8Vcmu+w@mail.gmail.com>
 <YnLplKy0Y66SsvQw@zn.tnic>
 <CAHk-=wjUX5DGNSiBYvPC8fQJGRe5_RWR8NW=gYF4=UpPiwCE8A@mail.gmail.com>
 <Ynow8F3G8Kl6V3gu@zn.tnic>
 <CAHk-=whCmmipbBDips0OJ=UiBUjZfgBGYruoOsqcq2TVd5kBSA@mail.gmail.com>
 <YnqqhmYv75p+xl73@zn.tnic>
 <Ynq1nVpu1xCpjnXm@zn.tnic>
 <YozQZMyQ0NDdD8cH@zn.tnic>
 <CAHk-=wiJ9xqFrdDJtUD3oc1kCxYcVjLi5BjBY-3NVHgYxYb_HA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wiJ9xqFrdDJtUD3oc1kCxYcVjLi5BjBY-3NVHgYxYb_HA@mail.gmail.com>

On Tue, May 24, 2022 at 09:51:56AM -0700, Linus Torvalds wrote:
> I can't find anything wrong with this, but who knows what
> patch-blindness I have from looking at a few different versions of it.
> Maybe my eyes just skim over it now.

Same here - I can't look at that code anymore. I'll try to gain some
distance and look at it again later, and do some more extensive testing
too.

> I do note that the clearing of %rax here:
> 
> > +.Lerms_exit:
> > +       xorl %eax,%eax
> > +       RET
> 
> seems to be unnecessary, since %rax is never modified in the path
> leading to this. But maybe just as well just for consistency with the
> cases where it *is* used as a temporary.

Yeah.

> And I still suspect that "copy_to_user()" is *much* more interesting
> than "clear_user()", but I guess we can't inline it anyway due to all
> the other overhead (ie access_ok() and stac/clac).
> 
> And for a plain "call memcpy/memset", we'd need compiler help to do
> this (at a minimum, we'd have to have the compiler use the 'rep
> movs/stos' register logic, and then we could patch things in place
> afterwards, with objtool creating the alternatives section or
> something).

Yeah, I have this on my todo to research them properly. Will report when
I have something.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
