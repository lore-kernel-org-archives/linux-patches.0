Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06ECF6FB0;
	Thu, 18 Apr 2024 14:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713451884; cv=none; b=PuFSepq1SbDIft6l5ir7aXDghCLsDT7EE79dRZ/R9ySBVzqryrWV9IOGOvcaNf1mnp21n+BOgft4JGOTT+Npcoqn1UWYd7rSsLQKVJQ2z4wpqfu82zAXNv2OK8UU20fPo9xx5FpFxi0wOPCBuyqjs+tq1mSkPvD6SHpiEfxRoD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713451884; c=relaxed/simple;
	bh=otmv7rhTIoDeXBnEHe3n9sVC/BWFho4XCMjhnjOJ0+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CMXekI/Nidq4t9ZPB/GeyLWDcGT42BBCe9oFSFT7EuXupFXjjUsbxWSv8pJYhlOcKsalCKrvYt13pbEDFocUIrI6P+rNBI/3jE2/VGOXnmQBhEEZssPZ/FBcBmGxwV+bfGuwkZBfsxBaCHwNd+lwy3Eg7M5h74vmNMji2HynzCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=avA3AfO6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="avA3AfO6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C484EC113CC;
	Thu, 18 Apr 2024 14:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713451883;
	bh=otmv7rhTIoDeXBnEHe3n9sVC/BWFho4XCMjhnjOJ0+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=avA3AfO64KbySRBK0fRSPMK17uPXHs9lfqpO90wMXiMWbY7s5mnV+P8rgY5k7ENAK
	 Xv60/ZO+V1h/qeOC4YUUtmXpB2J8uUO03pxEN8EwrwxW5a9No9NmCGGY8Rl0O79b6k
	 0esWC8IBeJLIhoruXD3DXC/cfCSGeebWzOX/5nAn46R2bSdn/HVbetRfZzsrgoraiV
	 wviU4W75cgzee/E4jb34DhKClrhLi9+atKpwcZb5XBwfRZe9d9Re+LSHuQ9uPQKaoG
	 CkhEHxddN+vfu1tqBtIJuhsGpkKgJhCOChKFQxBHE+6m2WMuO/GFoWgWmT7agaBFM7
	 eAMo+6+adpVgQ==
Date: Thu, 18 Apr 2024 07:51:21 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: akpm@linux-foundation.org, arnd@arndb.de, gor@linux.ibm.com,
	agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
	svens@linux.ibm.com, wintera@linux.ibm.com, twinkler@linux.ibm.com,
	linux-s390@vger.kernel.org, netdev@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH 1/3] s390/vmlogrdr: Remove function pointer cast
Message-ID: <20240418145121.GA1435416@dev-arch.thelio-3990X>
References: <20240417-s390-drivers-fix-cast-function-type-v1-0-fd048c9903b0@kernel.org>
 <20240417-s390-drivers-fix-cast-function-type-v1-1-fd048c9903b0@kernel.org>
 <20240418095438.6056-A-hca@linux.ibm.com>
 <20240418102549.6056-B-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240418102549.6056-B-hca@linux.ibm.com>

Hi Heiko,

On Thu, Apr 18, 2024 at 12:25:49PM +0200, Heiko Carstens wrote:
> On Thu, Apr 18, 2024 at 11:54:38AM +0200, Heiko Carstens wrote:
> > On Wed, Apr 17, 2024 at 11:24:35AM -0700, Nathan Chancellor wrote:
> > > Clang warns (or errors with CONFIG_WERROR) after enabling
> > > -Wcast-function-type-strict by default:
> > > 
> > >   drivers/s390/char/vmlogrdr.c:746:18: error: cast from 'void (*)(const void *)' to 'void (*)(struct device *)' converts to incompatible function type [-Werror,-Wcast-function-type-strict]
> > >     746 |                 dev->release = (void (*)(struct device *))kfree;
> > >         |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > >   1 error generated.
> > > 
> > > Add a standalone function to fix the warning properly, which addresses
> > > the root of the warning that these casts are not safe for kCFI. The
> > > comment is not really relevant after this change, so remove it.
> > > 
> > > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > > ---
> > >  drivers/s390/char/vmlogrdr.c | 13 +++++--------
> > >  1 file changed, 5 insertions(+), 8 deletions(-)
> > 
> > > @@ -736,14 +740,7 @@ static int vmlogrdr_register_device(struct vmlogrdr_priv_t *priv)
> > >  		dev->driver = &vmlogrdr_driver;
> > >  		dev->groups = vmlogrdr_attr_groups;
> > >  		dev_set_drvdata(dev, priv);
> > > -		/*
> > > -		 * The release function could be called after the
> > > -		 * module has been unloaded. It's _only_ task is to
> > > -		 * free the struct. Therefore, we specify kfree()
> > > -		 * directly here. (Probably a little bit obfuscating
> > > -		 * but legitime ...).
> > > -		 */
> > 
> > Why is the comment not relevant after this change? Or better: why is it not
> > valid before this change, which is why the code was introduced a very long
> > time ago? Any reference?
> > 
> > I've seen the warning since quite some time, but didn't change the code
> > before sure that this doesn't introduce the bug described in the comment.
> 
> From only 20 years ago:
> 
> https://lore.kernel.org/all/20040316170812.GA14971@kroah.com/
> 
> The particular code (zfcp) was changed, so it doesn't have this code
> (or never did?)  anymore, but for the rest this may or may not still
> be valid.

I guess relevant may not have been the correct word. Maybe obvious? I
can keep the comment but I do not really see what it adds, although
reading the above thread, I suppose it was added as justification for
calling kfree() as ->release() for a 'struct device'? Kind of seems like
that ship has sailed since I see this all over the place as a
->release() function. I do not see how this patch could have a function
change beyond that but I may be misreading or misinterpreting your full
comment.

Cheers,
Nathan
