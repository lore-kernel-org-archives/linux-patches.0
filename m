Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BBE525B;
	Tue, 23 Jan 2024 22:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706048436; cv=none; b=E1wlhhtsfiIAuJt/wfQrlt91iMaXWjK0oJ/63rhJ64nKUsF9dGBfeI82KL/4WlZSSGJngpsnYc2sj56j4h0PlyMm1dL8AEPgm81RYdoNyhJqfRoxAzxkm1r0yJVto598cqNFE5SKfaEfkyuhFVDtZOwqIqj6MmMZfDdHHzYOsyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706048436; c=relaxed/simple;
	bh=QKCxb0axNEVzTfzpxzzyg4pfr6WqDHOVtYtpncNdvjY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K+iPPb5MFwkNiotesiRd0GWVeuET5/UxcT/Ds4+3fvfjcVuauQ3XiTHtbOVlGlq0xFpmGXzmFB9dY23T+U08kVTVKq1G6jIMTPJrvy4RLT+dOHvqJVI14xbJiPMZE7uvJ75AuIr+hND1LTrZ7Je2kePSxUOCPMLeI+I5D9B8H6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f2yDW+g0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f2yDW+g0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F04CC433F1;
	Tue, 23 Jan 2024 22:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706048435;
	bh=QKCxb0axNEVzTfzpxzzyg4pfr6WqDHOVtYtpncNdvjY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f2yDW+g0ktQNn9brNx3h0uxnM8EO4VJCZCdrqU00/fOJ/7BE/wB/yOFtZFZtZNfQA
	 YXG9500gf+EM4CetK3qPaenda1CoZ7mAy86QBtpXBMgq6Q6EsHjNUKSNMOt14ovwn2
	 sM1M9Dsu+jXp++K6lP3WjFv/WT3mZbz64haaXbFg=
Date: Tue, 23 Jan 2024 14:20:35 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Moulding <dan@danm.net>
Cc: junxiao.bi@oracle.com, logang@deltatee.com, patches@lists.linux.dev,
	song@kernel.org, stable@vger.kernel.org, yukuai3@huawei.com
Subject: Re: [PATCH 6.7 438/641] md: bypass block throttle for superblock
 update
Message-ID: <2024012316-phonebook-shrewdly-31f2@gregkh>
References: <2024012320-coaster-ensnare-237c@gregkh>
 <20240123213515.7535-1-dan@danm.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240123213515.7535-1-dan@danm.net>

On Tue, Jan 23, 2024 at 02:35:15PM -0700, Dan Moulding wrote:
> > Or is the regression also in Linus's tree and both of these should be
> > reverted/dropped in order to keep systems ok until the bug is fixed in
> > Linus's tree?
> 
> The regression is in Linus' tree and appeared with commit
> bed9e27baf52. I was operating under the assumption that the two
> commits (bed9e27baf52 and d6e035aad6c0) are intended to exist as a
> pair that should go together (the commit messages led me to believe
> so).
> 
> The commit that caused the regression has already appeared in the
> 6.7.1 release (but without the second commit). Since I thought the two
> commits are a pair and the regression needs to be reverted, that the
> second commit should not be backported for 6.7.2 until the issue is
> properly resolved in Linus' tree.
> 
> But it sounds like Song Liu is saying that the second commit
> (d6e035aad6c0) should actually be fine to accept on its own even
> though the other one needs to be reverted, and is not really dependent
> on the one that caused the regression [1]. So maybe it's fine to pick
> it up for 6.7.2.
> 
> I can say that I have tested 6.7.1 plus just commit d6e035aad6c0 and I
> cannot reproduce the regression with it. But 6.7.1 plus both commits,
> I can still reproduce the regression. So bed9e27baf52 definitely needs
> to be reverted to eliminate the regression.
> 
> I hope that clears things up some.

Nope, not at all :)

For now, I'm going to keep both commits in the stable trees, as that
matches what is in Linus's tree as this seems to be hard to reproduce
and I haven't seen any other reports of issues.  Being in sync with what
is in Linus's tree is almost always good, that way if a fix happens
there, we can easily backport it to the stable trees too.

So unless the maintainer(s) say otherwise, I'll just let this be.

thanks,

greg k-h
