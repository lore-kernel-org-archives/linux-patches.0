Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271FC23CD
	for <patches@lists.linux.dev>; Wed, 16 Feb 2022 10:28:04 +0000 (UTC)
Received: from zn.tnic (dslb-088-067-221-104.088.067.pools.vodafone-ip.de [88.67.221.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D85CA1EC054C;
	Wed, 16 Feb 2022 11:27:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1645007278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=1iASlCBOHtED7Z2DvFclCOCtXnoNRBqSBjzPZUr+6E0=;
	b=OSo5jxyYxijPlRROdYxeqJ0U+fS9j9OW7//QfVD9JnWM34azp4YBysQBmRHEk9JPGLfUXj
	+DgWSbhZpyKQmG+6GZiKy6q0avRK3tsQ0Gkm/drnuEXjaEvDElzPekpmezagYPTREwqPMA
	1veONq9EZ+4IkqiN6xDeOByUfER0YOI=
Date: Wed, 16 Feb 2022 11:28:01 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Jue Wang <juew@google.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] x86/mce: Add workaround for SKX/CLX/CPX spurious machine
 checks
Message-ID: <YgzRsfWOmqkNiNI7@zn.tnic>
References: <CAPcxDJ7nriZEJHF6dMPR7tQ+dGuueyRjw1NC+4CbjxiAT_S+ZA@mail.gmail.com>
 <20220208150945.266978-1-juew@google.com>
 <Ygwka++3eipjQzB2@zn.tnic>
 <YgwnqTc8FGG3orcE@agluck-desk3.sc.intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YgwnqTc8FGG3orcE@agluck-desk3.sc.intel.com>

On Tue, Feb 15, 2022 at 02:22:33PM -0800, Luck, Tony wrote:
> This early in do_machine check we don't know whether this was from
> a over enthusistic REP;MOVS fetch, or a "normal" machine check.
> I don't think there is an easy way to tell the difference.

That's what I am wondering: whether we can compare the buffers REP;
MOVS was accessing and determine whether the access was out of bounds.
Something ala _ASM_EXTABLE_ as it is done in arch/x86/lib/copy_mc_64.S,
for example, which will land us in fixup_exception().

Now there we'd need to know the range the thing was copying which should
be in pt_regs and the address the MCE reported. If latter is not in the
former range, we say ignore.

There's even some blurb about "recovering from fast-string exceptions"
over copy_mc_enhanced_fast_string...

Hmmm?

> The first check:
> 
> 	if ((mcgstatus & MCG_STATUS_LMCES) 
> 
> is for "is this a local machine check"? So no broadcast sync
> needed. But that needs a comment.

Yap.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
