Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351687E
	for <patches@lists.linux.dev>; Sat, 16 Apr 2022 06:37:05 +0000 (UTC)
Received: from zn.tnic (p200300ea971b588b329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971b:588b:329c:23ff:fea6:a903])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B46231EC056D;
	Sat, 16 Apr 2022 08:36:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1650091019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=Hjvqo80T3gV6LPpmZSntv/dMWVJgtHp0mQopWFcjQOg=;
	b=kUcm4Mtj+MaZdWyhGr5ZxkEAq58Cm+2yGYINteqqDZKBgTFrJlmrTPMB8DRshXFH5t7YM2
	khWIhXD43mUF2svwaLhnxlBoalh8GeO8y1s5x5Nx8U7oepNQBpU0GP4YJOPQbEVdCrdodm
	cDRyirK6dLrK11I8uG3w4Oj1lkylGYU=
Date: Sat, 16 Apr 2022 08:36:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	the arch/x86 maintainers <x86@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, patrice.chotard@foss.st.com,
	Mikulas Patocka <mpatocka@redhat.com>, markhemm@googlemail.com,
	Lukas Czerner <lczerner@redhat.com>, Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Hugh Dickins <hughd@google.com>, patches@lists.linux.dev,
	Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [patch 02/14] tmpfs: fix regressions from wider use of ZERO_PAGE
Message-ID: <Ylpj9of+CP4ipDtm@zn.tnic>
References: <20220414191240.9f86d15a3e3afd848a9839a6@linux-foundation.org>
 <20220415021328.7D31EC385A1@smtp.kernel.org>
 <CAHk-=wh=Mu_EYhtOmPn6AxoQZyEh-4fo2Zx3G7rBv1g7vwoKiw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wh=Mu_EYhtOmPn6AxoQZyEh-4fo2Zx3G7rBv1g7vwoKiw@mail.gmail.com>

On Fri, Apr 15, 2022 at 03:10:51PM -0700, Linus Torvalds wrote:
> Adding PeterZ and Borislav (who seem to be the last ones to have
> worked on the copy and clear_page stuff respectively) and the x86
> maintainers in case somebody gets the urge to just fix this.

I guess if enough people ask and keep asking, some people at least try
to move...

> Because memory clearing should be faster than copying, and the thing
> that makes copying fast is that FSRM and ERMS logic (the whole
> "manually unrolled copy" is hopefully mostly a thing of the past and
> we can consider it legacy)

So I did give it a look and it seems to me, if we want to do the
alternatives thing here, it will have to look something like
arch/x86/lib/copy_user_64.S.

I.e., the current __clear_user() will have to become the "handle_tail"
thing there which deals with uncopied rest-bytes at the end and the new
fsrm/erms/rep_good variants will then be alternative_call_2 or _3.

The fsrm thing will have only the handle_tail thing at the end when size
!= 0.

The others - erms and rep_good - will have to check for sizes smaller
than, say a cacheline, and for those call the handle_tail thing directly
instead of going into a REP loop. The current __clear_user() is still a
lot better than that copy_user_generic_unrolled() abomination. And it's
not like old CPUs would get any perf penalty - they'll simply use the
same code.

And then you need the labels for _ASM_EXTABLE_UA() exception handling.

Anyway, something along those lines.

And then we'll need to benchmark this on a bunch of current machines to
make sure there's no funny surprises, perf-wise.

I can get cracking on this but I would advise people not to hold their
breaths. :)

Unless someone has a better idea or is itching to get hands dirty
her-/himself.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
