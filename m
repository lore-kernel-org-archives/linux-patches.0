Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C877E15A5;
	Thu, 17 Nov 2022 02:05:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B916CC433D6;
	Thu, 17 Nov 2022 02:05:21 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="oBVYY4GH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1668650720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dEJat997gDB284IQJDfbqi4/5IXvytYbwgZCPi3gI8M=;
	b=oBVYY4GH+szvpy7v+MDpWl7rIbq1Ag0+XjaiW9ivB+W/ypTPzWGRKmZ5grHtl0NRu+tdAw
	OceXtZlFIdzaNyPTBIDx5ZFzB/5YparpWLHfLRzfitegfl7G9s7sam3TuLTYL+fICnJhuN
	DFCVAmQjhuCf5Jl3bBUK1aEXDFPWY+A=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ca8ad650 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 17 Nov 2022 02:05:19 +0000 (UTC)
Date: Thu, 17 Nov 2022 03:05:14 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Heiko Carstens <hca@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Christoph =?utf-8?Q?B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	"Darrick J . Wong" <djwong@kernel.org>,
	SeongJae Park <sj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michael Ellerman <mpe@ellerman.id.au>, Helge Deller <deller@gmx.de>,
	netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-mmc@vger.kernel.org,
	linux-parisc@vger.kernel.org, ydroneaud@opteya.com
Subject: Re: [PATCH v2 3/3] treewide: use get_random_u32_between() when
 possible
Message-ID: <Y3WW2lOgoYLKQeve@zx2c4.com>
References: <20221114164558.1180362-1-Jason@zx2c4.com>
 <20221114164558.1180362-4-Jason@zx2c4.com>
 <202211161436.A45AD719A@keescook>
 <Y3V4g8eorwiU++Y3@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y3V4g8eorwiU++Y3@zx2c4.com>

On Thu, Nov 17, 2022 at 12:55:47AM +0100, Jason A. Donenfeld wrote:
> 1) How/whether to make f(0, UR2_MAX) safe,
>    - without additional 64-bit arithmetic,
>    - minimizing the number of branches.
>    I have a few ideas I'll code golf for a bit.
> I think I can make progress with (1) alone by fiddling around with
> godbolt enough, like usual.

The code gen is definitely worse.

Original half-open interval:

    return floor + get_random_u32_below(ceil - floor);

Suggested fully closed interval:
	
    ceil = ceil - floor + 1;
    return likely(ceil) ? floor + get_random_u32_below(ceil) : get_random_u32();

Is the worse code gen actually worth it? Options:

 a) Decide worse codegen is worth it.
 b) Declare f(0, U32_MAX) undefined and just not handle it.
 c) Stick with original half-open interval that doesn't have this problem.

Jason
