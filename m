Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CA9469D;
	Sat, 27 Jul 2024 05:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722056898; cv=none; b=U2e2NoyziKr5cwidi5cMy9myrVJzKsVbC+DhzKw8nVhQoxvIMZDxIqsNKFbppo1Css/HTv5gyabamutlRwM8/MPJ1bWM0XOS8aMJo2DbjQB4sczik51ZmEePH+Oya3DaFDRNwyOEABN7wUVqw/Bh9c3oeQ4e7w2KiYeqHblA4Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722056898; c=relaxed/simple;
	bh=cYEQjfMS9TKWHaK0IUBF4BGLTapY91GGZeGMQ+Df4MA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SicFo5AexMHBSq/3Y57tKsPEbD+v6Gko/VlOuC0vXFvS7L/JyeMOStXj6svYYEjDMbpK8p6MDsjMgnlmql2zamHmmuMhWdRzOB+Wx5K6lroPstBqmIuZn/ca1PnJFUttmkvo1njvBT4kYKqzV3QpuBIln7/AfmRaFBFzra5rgUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DLAK8r4p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DLAK8r4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F104C32781;
	Sat, 27 Jul 2024 05:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722056898;
	bh=cYEQjfMS9TKWHaK0IUBF4BGLTapY91GGZeGMQ+Df4MA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DLAK8r4pj+vq0hkzgB7JkfRB0AzsoiMMrdu10PLkaNgVqV2Kf5zfTzaiUdYzaUZpJ
	 DLiCl4JElWtBNd43CNo7I3pXsunaM9Zg7aFxDNnNEhqY070ltHmLIK23l/250rJ2XZ
	 aDsKvjFvTDgTF7OvpiZG+aGWO1SqGYq9cbzWqO8M=
Date: Sat, 27 Jul 2024 07:08:14 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, David Laight <david.laight@aculab.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Christoph Hellwig <hch@infradead.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 5.15 70/87] minmax: relax check to allow comparison
 between unsigned arguments and signed constants
Message-ID: <2024072710-proven-routing-7e63@gregkh>
References: <2024072659-edging-sloped-1a51@gregkh>
 <20240726160513.52282-1-sj@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240726160513.52282-1-sj@kernel.org>

On Fri, Jul 26, 2024 at 09:05:13AM -0700, SeongJae Park wrote:
> On Fri, 26 Jul 2024 07:21:30 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > On Thu, Jul 25, 2024 at 09:58:51AM -0700, Linus Torvalds wrote:
> > > On Thu, 25 Jul 2024 at 07:55, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > 5.15-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > I assume the min/max patches had some reason to be backported that is
> > > probably mentioned somewhere in the forest of patches, but I missed
> > > it.
> > 
> > It wasn't specifically called out here, but yes, they were needed for
> > the DAEMON fix.  And they will be needed in the future probably as well
> > because we have run into this problem many times when backporting
> > patches (i.e. the backport throws tons of warnings because the min/max
> > changes are not there.)
> 
> For others' information, the original backporting request including the detail
> is available at https://lore.kernel.org/20240716183333.138498-1-sj@kernel.org
> 
> Also, s/DAEMON/DAMON/ ;)

Sorry about that, correct names are important :)

I see Linus just committed 2 min/max "fixes" for this type of "the
preprocessor went mad!" issues to his tree so I'll look at backporting
them if people have build issues with the stable trees as well.

thanks,

greg k-h
