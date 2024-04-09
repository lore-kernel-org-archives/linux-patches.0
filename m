Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454A97EEE2;
	Tue,  9 Apr 2024 08:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712651299; cv=none; b=NjQT73+At4wZUX+6yxJsf9ssJg98c8zg1JOyJhOw+omdTerYFBBkAcOjy4zEepsAfj1rjQPPJ2QqBIeR2vC+bRUOZLYZubPSHYDD6C+lJazlOlpVCx6nvsCh6aqVYvJIozmi1tqOtDnSbnt+1CLUg+aBUCNFXv7j8KpLvHmyS2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712651299; c=relaxed/simple;
	bh=ASLvvOePDleOf+pXb7ZVJAJfugVJzvD2suH9zumY0Yw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EtEUnxTMj7uvkuyhm+R8hZfKhxw/1kfa2+mDLIdUUPTnjnvFXYX3vl6O+CuSkU6nYpN1U9A1EtO4fvGTusmprNX4GmQ4791pdKd0g61+ftUrnxSm6r3JXZ5C6FOJ2uII9si4YJABbJe1+Bk8wrbyDY98NqBkYhotmKwoa7KRZT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k95b24Ij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k95b24Ij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B724C433F1;
	Tue,  9 Apr 2024 08:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712651298;
	bh=ASLvvOePDleOf+pXb7ZVJAJfugVJzvD2suH9zumY0Yw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k95b24IjitYBjwM+G6cdvNNkeOem6vVIpko8PCrmdo3bguUFWXE7YSRJEJ7GyTUo2
	 o898PolXumgKYmJJ2PbpHah4eeO3KqtDFZRTCwA4dYH0ggV/54EZfUPa2CwJ4+k65J
	 xd40PXfJzuFJQRCJ7/OhoHAXzEyvu7CgwWvLrNmc=
Date: Tue, 9 Apr 2024 08:53:33 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Petr Vorel <pvorel@suse.cz>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [PATCH 5.15 463/690] nfsd: fix net-namespace logic in
 __nfsd_file_cache_purge
Message-ID: <2024040933-patio-impotent-7a0a@gregkh>
References: <20240408125359.506372836@linuxfoundation.org>
 <20240408125416.405210374@linuxfoundation.org>
 <20240409064222.GA83048@pevik>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240409064222.GA83048@pevik>

On Tue, Apr 09, 2024 at 08:42:22AM +0200, Petr Vorel wrote:
> Hi all,
> 
> > 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> > ------------------
> 
> > From: Jeff Layton <jlayton@kernel.org>
> 
> > [ Upstream commit d3aefd2b29ff5ffdeb5c06a7d3191a027a18cdb8 ]
> 
> > If the namespace doesn't match the one in "net", then we'll continue,
> > but that doesn't cause another rhashtable_walk_next call, so it will
> > loop infinitely.
> 
> > Fixes: ce502f81ba88 ("NFSD: Convert the filecache to use rhashtable")
> > Reported-by: Petr Vorel <pvorel@suse.cz>
> > Link: https://lore.kernel.org/ltp/Y1%2FP8gDAcWC%2F+VR3@pevik/
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> > ---
> >  fs/nfsd/filecache.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> > diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
> > index 0b19eb015c6c8..024adcbe67e95 100644
> > --- a/fs/nfsd/filecache.c
> > +++ b/fs/nfsd/filecache.c
> > @@ -892,9 +892,8 @@ __nfsd_file_cache_purge(struct net *net)
> 
> >  		nf = rhashtable_walk_next(&iter);
> >  		while (!IS_ERR_OR_NULL(nf)) {
> > -			if (net && nf->nf_net != net)
> > -				continue;
> > -			nfsd_file_unhash_and_dispose(nf, &dispose);
> I don't know the context (whether the fix is needed for 5.15 and older), but
> patch does not apply because nfsd_file_unhash_and_dispose() was introduced in
> ce502f81ba88 ("NFSD: Convert the filecache to use rhashtable") in v6.0-rc1.  It
> was actually renamed from nfsd_file_unhash_and_release_locked() in that commit.
> Also the context changed - nfsd_file_unhash_and_dispose() was introduced in the
> commit which is supposed to be fixed in this commit, one would say that this fix
> is not needed in older kernels (5.15, 5.10 and 5.4; 4.19 has completely
> different code). But that's a question for Jeff or Chuck.

This is part of a very large backport of nfsd patches to 5.15 to resolve
a lot of reported issues, so that might be why it looks odd here.  It
does seem to compile and boot ok for me, so maybe it's not an issue here
as you aren't seeing the other patches in this series?

thanks,

greg k-h
