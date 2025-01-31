Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09ADD1386C9;
	Fri, 31 Jan 2025 18:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738347682; cv=none; b=iRaVkCfQLNn6YFLce7ub4JPDflj+ZYw+lg4DtNhil5qyf5mOq6V9SljJFuKJ4C/h158aeryyq9f/eDsMpAm12aHautofycRmzhut5ULFGUUMLH9k/LoDQ/rZ90Cy5E0HIjU0Sf2qwkRkNeu17gSq823eWzqr2u57n4ZaNdJ0Ch0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738347682; c=relaxed/simple;
	bh=++eLT7i6lhz3W55ckpmPOQ2S1UI2KmtDi/OQQKxhcPo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fa8dPfsEpbyv5XPwzKw7WpPQai6zE01l+1cpWl9LAaYV9qcztWevqnmCjL4da7DwN0teJSV6Q5R7DXIPm1XrIos8BUixrUP0orQqGT/9mRnQJfLqtus32hrqcrd3ifMIJKXu3eZ9PNSn/Ftk0riI6TmcWlwE/IGPUSdhbKbOwJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bsMsRjTh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bsMsRjTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108BAC4CED1;
	Fri, 31 Jan 2025 18:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738347681;
	bh=++eLT7i6lhz3W55ckpmPOQ2S1UI2KmtDi/OQQKxhcPo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bsMsRjThA0LaGECgNMKafWzFB0+vPGBwkoVJjm2E4JxGleI891Oo0o3SSDulXrhmi
	 NBFHz/pCl2mpauFFbXaHdnLFDich8mXYSoRpFrpiDC7Q+PTHmTKVAnF57yT905G4Ev
	 ktoUQL/mkh7THBivLJ3iaJBcNsag7nXToxbWZ7gQLFR53gqUU/oY1xVBisWHRlkzR9
	 bUdfven6DZA7eqGh4lp3f8YR1D+EJF+oUWnT13k/MR/5oTJCgUHy+36U+8/bhbEzT5
	 dZ5lGHDrbKHj3a+yZTOZskcAVagt1MNy9nZdGQlH3N3RckDCYoxx7yzZJo40EqTQiF
	 NXqopK47OEjgg==
Date: Fri, 31 Jan 2025 11:21:17 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: John Johansen <john.johansen@canonical.com>
Cc: apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] apparmor: Fix checking address of an array in
 accum_label_info()
Message-ID: <20250131182117.GA2398605@ax162>
References: <20250120-apparmor-pointer-bool-conversion-label-v1-1-5957d28ffde6@kernel.org>
 <15e13942-965b-49f9-bf69-36579237a4cb@canonical.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15e13942-965b-49f9-bf69-36579237a4cb@canonical.com>

On Fri, Jan 24, 2025 at 01:59:36PM -0800, John Johansen wrote:
> On 1/20/25 05:12, Nathan Chancellor wrote:
> > clang warns:
> > 
> >    security/apparmor/label.c:206:15: error: address of array 'new->vec' will always evaluate to 'true' [-Werror,-Wpointer-bool-conversion]
> >      206 |         AA_BUG(!new->vec);
> >          |                ~~~~~~^~~
> > 
> > The address of this array can never be NULL because it is not at the
> > beginning of a structure. Convert the assertion to check that the new
> > pointer is not NULL.
> > 
> > Fixes: de4754c801f4 ("apparmor: carry mediation check on label")
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes: https://lore.kernel.org/oe-kbuild-all/202501191802.bDp2voTJ-lkp@intel.com/
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> 
> Acked-by: John Johansen <john.johansen@canonical.com>
> 
> I have pulled this into my tree

Thanks! Is this going to be pushed to -next soon? I am still seeing this
on next-20240131.

> > ---
> >   security/apparmor/label.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/security/apparmor/label.c b/security/apparmor/label.c
> > index afded9996f61..79be2d3d604b 100644
> > --- a/security/apparmor/label.c
> > +++ b/security/apparmor/label.c
> > @@ -203,7 +203,7 @@ static void accum_label_info(struct aa_label *new)
> >   	long u = FLAG_UNCONFINED;
> >   	int i;
> > -	AA_BUG(!new->vec);
> > +	AA_BUG(!new);
> >   	/* size == 1 is a profile and flags must be set as part of creation */
> >   	if (new->size == 1)
> > 
> > ---
> > base-commit: e6b087676954e36a7b1ed51249362bb499f8c1c2
> > change-id: 20250120-apparmor-pointer-bool-conversion-label-7c1027964c7f
> > 
> > Best regards,
> 
> 
