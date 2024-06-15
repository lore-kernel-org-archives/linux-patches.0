Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1EA321A3;
	Sat, 15 Jun 2024 11:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718449333; cv=none; b=sym7fMbsOiI6/TZSBp3V6LWUIoLNPmH3e4cBlShjbkqHGaNTxRrF3LW5xzcMs9s63bOzZQiSUJNzLxcL4t9Zz9cSOZkSGKZfczd/8dFm6mLl92WBC3jLr8m9s/Xu5jCaOMjcRwhiqwateW66caZhI8N2TMrgAUeQ9a00NAb2KRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718449333; c=relaxed/simple;
	bh=xjYdJqAhETqkEBExjERIpsVqTpqngTtnlP6c2oNKbuw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sdaP4+cDpclJxRdLLkplwv8sMdYk5rEyB1aC5y4KKJBHVdAtzB4gyKK4zTDJnpbGQQu90d+6Da4KlKibLxOIynH2CmdhBPxBy0L7gsxjfZTBnBn3noG9lrxyW29tjY9qRrWsE9crq3dkLmBKKjjKqClJiC9qIiE62FPaR2VSF7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=te9o5tLT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="te9o5tLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33EAC116B1;
	Sat, 15 Jun 2024 11:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718449333;
	bh=xjYdJqAhETqkEBExjERIpsVqTpqngTtnlP6c2oNKbuw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=te9o5tLTe8KukA9PxTiWypevxhFo1kwhKTTfkNDlSuQ9VxzTZ62m8N7r+paYcrHN6
	 h8jSFp4sHuwOV28Nb1Tm/X8O4h6A7U8rlUxLtwIyoXpFcvVsIH7RkoPZFy8a0tFdMV
	 IlpCQuFYAv5J/ZaL6YueAA2dDA9Y13H7pRRKFI9E=
Date: Sat, 15 Jun 2024 13:02:10 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 260/317] powerpc/uaccess: Use asm goto for get_user
 when compiler supports it
Message-ID: <2024061503-putdown-gains-fb20@gregkh>
References: <20240613113247.525431100@linuxfoundation.org>
 <20240613113257.605251513@linuxfoundation.org>
 <87zfronfwb.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zfronfwb.fsf@mail.lhotse>

On Fri, Jun 14, 2024 at 05:27:00PM +1000, Michael Ellerman wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Christophe Leroy <christophe.leroy@csgroup.eu>
> >
> > [ Upstream commit 5cd29b1fd3e8f2b45fe6d011588d832417defe31 ]
> >
> > clang 11 and future GCC are supporting asm goto with outputs.
> >
> > Use it to implement get_user in order to get better generated code.
> >
> > Note that clang requires to set x in the default branch of
> > __get_user_size_goto() otherwise is compliant about x not being
> > initialised :puzzled:
> >
> > Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> > Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> > Link: https://lore.kernel.org/r/403745b5aaa1b315bb4e8e46c1ba949e77eecec0.1615398265.git.christophe.leroy@csgroup.eu
> > Stable-dep-of: 50934945d542 ("powerpc/uaccess: Use YZ asm constraint for ld")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  arch/powerpc/include/asm/uaccess.h | 55 ++++++++++++++++++++++++++++++
> >  1 file changed, 55 insertions(+)
> 
> This is causing a build break. Please drop it.
> 
> There have been a lot of changes to uaccess.h since v5.10. I think
> rather than trying to pull in enough of them to allow backporting the
> recent uaccess fixes it'd be better to do a custom backport. I'll send
> one once I've done some build tests.

Now dropped, thanks!

greg k-h
