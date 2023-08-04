Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2E61C20;
	Fri,  4 Aug 2023 04:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691123107; x=1722659107;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wIvtHfVAex1xKpqUP62l3sj89G+UGbbBqgFI8Dd8rGA=;
  b=aYCw91CGLpqWDS5wgKELW5guHFdvqmBbZbtBTOnyUO1Af55beS20qbOX
   fv+N4Z98+S+YBaYl4MnhC/HrewE/yx8VDtozQffj7kvZUh0Scqs0gu50d
   ffSyBWAmPu7PMYx+XkGaj510L4HIbskejPQW4I8JWS0x7DsqqOp/5ytku
   IExLaiZ9HXUD8SDRDxnx9o8952g9Q5sDo6/NPjcWvQ9oZRhiBGkK5WBDL
   hIow+J5bIUhLf1lPJYx9HgNLVkMHB6wOnug6rg4zJ3GkJsCvs33napfKJ
   WSsWwInN5Rqp+hEt757MMNnyrqE/tMNZ111EqibO/XHgQLEv1v4eX2HCF
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="456436072"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="456436072"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 21:25:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="706824930"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="706824930"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga006.jf.intel.com with ESMTP; 03 Aug 2023 21:25:02 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1qRmN2-009Qwx-2Q;
	Fri, 04 Aug 2023 07:25:00 +0300
Date: Fri, 4 Aug 2023 07:25:00 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: pmladek@suse.com, rostedt@goodmis.org, senozhatsky@chromium.org,
	linux@rasmusvillemoes.dk, ndesaulniers@google.com, trix@redhat.com,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] lib: test_scanf: Add explicit type cast to result
 initialization in test_number_prefix()
Message-ID: <ZMx9nDQVaoRwN5oK@smile.fi.intel.com>
References: <20230803-test_scanf-wconstant-conversion-v1-1-74da994dedbc@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230803-test_scanf-wconstant-conversion-v1-1-74da994dedbc@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Thu, Aug 03, 2023 at 11:14:42AM -0700, Nathan Chancellor wrote:
> A recent change in clang allows it to consider more expressions as
> compile time constants, which causes it to point out an implicit
> conversion in the scanf tests:
> 
>   lib/test_scanf.c:661:2: warning: implicit conversion from 'int' to 'unsigned char' changes value from -168 to 88 [-Wconstant-conversion]
>     661 |         test_number_prefix(unsigned char,       "0xA7", "%2hhx%hhx", 0, 0xa7, 2, check_uchar);
>         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   lib/test_scanf.c:609:29: note: expanded from macro 'test_number_prefix'
>     609 |         T result[2] = {~expect[0], ~expect[1]};                                 \
>         |                       ~            ^~~~~~~~~~
>   1 warning generated.
> 
> The result of the bitwise negation is the type of the operand after
> going through the integer promotion rules, so this truncation is
> expected but harmless, as the initial values in the result array get
> overwritten by _test() anyways. Add an explicit cast to the expected
> type in test_number_prefix() to silence the warning. There is no
> functional change, as all the tests still pass with GCC 13.1.0 and clang
> 18.0.0.

>  do {										\
>  	const T expect[2] = { expect0, expect1 };				\
> -	T result[2] = {~expect[0], ~expect[1]};					\
> +	T result[2] = {(T)~expect[0], (T)~expect[1]};				\

Can we add spaces as above, while at it?

	T result[2] = { (T)~expect[0], (T)~expect[1] };				\

>  	_test(fn, &expect, str, scan_fmt, n_args, &result[0], &result[1]);	\
>  } while (0)

-- 
With Best Regards,
Andy Shevchenko


