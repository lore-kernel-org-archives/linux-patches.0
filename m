Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FAB1F95A;
	Fri, 26 Jul 2024 16:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722009917; cv=none; b=BKou5SzDbo6H5CT4gUM7nbtVcrDi3UAw9YKuzSuis/Q93QVlH7g4jONnOpvbxnDYipd7R5hV4Z54mSA4KmGHbwCWpZ7j+RvFyuIFopJWEmBhuD6Jdj9IiHFkDJluOwQHQ3xhLcSD+qic2ZMjNs2GZge6O8xIZpkod3BEwTdyStk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722009917; c=relaxed/simple;
	bh=80qH2fK6o+0BhmVLaRnz4mmCIpsJTSBPktVx+ABuJZ4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V9lo/JxqyQQyin3IlepCHHaBms926rvrpDC94PDgDlj0sRTy2uAkOYAcH2uv7nsJa0zGHHV2LosrLg4Q/fxBQ1/v9GvlUB7OCll9XzqWBbRiaChQMKE9I34qWZFRcp5k8gD6IcZLi9hmc67/8unhUO99lWP2THO/I/2XpmGik4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rJculWPG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rJculWPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E8FC32782;
	Fri, 26 Jul 2024 16:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722009917;
	bh=80qH2fK6o+0BhmVLaRnz4mmCIpsJTSBPktVx+ABuJZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rJculWPGpDEDyDt1DHD9k2mJQhIK/juZec/iz2IxDUW60aAdjrdg14TJ7LuMKi1jY
	 XZ448GcHPp9Mnw2S27TMzHEeKVezYuk3+9ajqubr8kjY5+L5O1br7KYqjnFKZiq8gJ
	 dE67l0epRawIWCPFwGlgb9FFsbAaStvgWoQXNF4Yk1ULgy2jVQz8T7s0fPsrjYQn3c
	 oEgJmHEHpjt1ok8a+JYemSr/KDOAZCMVQMP/VSRnrZsOli9oPK1wnBNInPd37wjk4F
	 pTrpUvMtEkSiZ6QX4kb/r+/LfrwY9RsZT8+jEwXqmcSlQcebca4KD2Hf/R2Yzatlwa
	 neQKQK5zDAM2A==
From: SeongJae Park <sj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	David Laight <david.laight@aculab.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Christoph Hellwig <hch@infradead.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 5.15 70/87] minmax: relax check to allow comparison between unsigned arguments and signed constants
Date: Fri, 26 Jul 2024 09:05:13 -0700
Message-Id: <20240726160513.52282-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <2024072659-edging-sloped-1a51@gregkh>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 26 Jul 2024 07:21:30 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Thu, Jul 25, 2024 at 09:58:51AM -0700, Linus Torvalds wrote:
> > On Thu, 25 Jul 2024 at 07:55, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > 5.15-stable review patch.  If anyone has any objections, please let me know.
> > 
> > I assume the min/max patches had some reason to be backported that is
> > probably mentioned somewhere in the forest of patches, but I missed
> > it.
> 
> It wasn't specifically called out here, but yes, they were needed for
> the DAEMON fix.  And they will be needed in the future probably as well
> because we have run into this problem many times when backporting
> patches (i.e. the backport throws tons of warnings because the min/max
> changes are not there.)

For others' information, the original backporting request including the detail
is available at https://lore.kernel.org/20240716183333.138498-1-sj@kernel.org

Also, s/DAEMON/DAMON/ ;)

> 
> Same for 6.1.y, which is why they are there too.
> 
> > It's ok, but people are literally talking about this set of patches
> > causing a big slowdown in building the kernel, with some files going
> > from less than a second to build to being 15+ seconds because of the
> > preprocessor expansion they can cause.
> 
> I saw that hopefully if that gets resolved in your tree we can backport
> the needed changes here tool.

I agree.


Thanks,
SJ

> 
> thanks,
> 
> greg k-h
