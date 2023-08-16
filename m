Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1AA3DF60;
	Wed, 16 Aug 2023 14:01:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5197C433C8;
	Wed, 16 Aug 2023 14:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692194474;
	bh=nkuNJD8/UhNnfzOiQfXb1n2ZySormYlxsckz1notOVU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j/jdHixKRtiJEdVAw3WGGDLItBfxL8Q5pSZCCQC/5zMtToRi+/YPYr5dXWDDfsl00
	 P/I+ssx6H7ylfZytajye1OlAemCDBiRwVxGdZgtfQsXJifLp9+Vn4nKQDxfJLY+cEC
	 Dde/x+0WMyaBggFuNjqBurUlPoatXEf9UKZ3xv5hxYzDHBx6S5gUJxM7k0KSaYnKb9
	 k6rlH5Z6J4ZMx1KHJoV1yjEV58vD2gT9mS0sbGaAgyFaNe1HqECrz0tfkurqOetI3b
	 tPtfmCAXicOFEi+YaZIz9acAt7r6DuGmTpNgLO9rm63idrZX5SgVhR1VKZ5WTxmVVg
	 87Ecspxmhsh3A==
Date: Wed, 16 Aug 2023 07:01:12 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Petr Mladek <pmladek@suse.com>
Cc: rostedt@goodmis.org, senozhatsky@chromium.org,
	andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk,
	ndesaulniers@google.com, trix@redhat.com,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH v2] lib: test_scanf: Add explicit type cast to result
 initialization in test_number_prefix()
Message-ID: <20230816140112.GA2109327@dev-arch.thelio-3990X>
References: <20230807-test_scanf-wconstant-conversion-v2-1-839ca39083e1@kernel.org>
 <ZNysmicYHHQ3f1Ck@alley>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZNysmicYHHQ3f1Ck@alley>

Hi Petr,

On Wed, Aug 16, 2023 at 01:01:46PM +0200, Petr Mladek wrote:
> On Mon 2023-08-07 08:36:28, Nathan Chancellor wrote:
> > A recent change in clang allows it to consider more expressions as
> > compile time constants, which causes it to point out an implicit
> > conversion in the scanf tests:
> > 
> >   lib/test_scanf.c:661:2: warning: implicit conversion from 'int' to 'unsigned char' changes value from -168 to 88 [-Wconstant-conversion]
> >     661 |         test_number_prefix(unsigned char,       "0xA7", "%2hhx%hhx", 0, 0xa7, 2, check_uchar);
> >         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >   lib/test_scanf.c:609:29: note: expanded from macro 'test_number_prefix'
> >     609 |         T result[2] = {~expect[0], ~expect[1]};                                 \
> >         |                       ~            ^~~~~~~~~~
> >   1 warning generated.
> > 
> > The result of the bitwise negation is the type of the operand after
> > going through the integer promotion rules, so this truncation is
> > expected but harmless, as the initial values in the result array get
> > overwritten by _test() anyways. Add an explicit cast to the expected
> > type in test_number_prefix() to silence the warning. There is no
> > functional change, as all the tests still pass with GCC 13.1.0 and clang
> > 18.0.0.
> > 
> > Cc: stable@vger.kernel.org
> > Closes: https://github.com/ClangBuiltLinux/linux/issues/1899
> 
> "Closes:" is not a valid tag. It was proposed and rejected in the end.
> I replaced it with "Link:" as suggested by ./scripts/checkpatch.pl/

I don't really care about "Closes:" vs. "Link:", either is fine with me,
but checkpatch.pl did not warn me about it and I still see commit
44c31888098a ("checkpatch: allow Closes tags with links") in mainline
and -next that explicitly allows this (and even requires Closes: instead
of Link: when following Reported-by:).

> > Link: https://github.com/llvm/llvm-project/commit/610ec954e1f81c0e8fcadedcd25afe643f5a094e
> > Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> 
> Reviewed-by: Petr Mladek <pmladek@suse.com>
> 
> The patch has been pushed into printk/linux.git, branch for-6.6.

Thanks a lot for the review and acceptance!

Cheers,
Nathan
