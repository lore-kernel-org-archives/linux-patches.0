Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278ED86269;
	Tue,  9 Apr 2024 11:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712662264; cv=none; b=paCMH/ICHq0pQDkFDvsMp3+0z2mqeedS8yEafbcrRY1PSLGXjZ/94YnYJuZyB3XpFLOzJvCa4IvDMMGffpbkjQkSfXLMTSjtMv8Tlc+KtKZND9KL+xoq7PbKYCrU0OmPoXZD0dZc0lSAmP9Dip5vkt1xKN8HHM3hQKx7ExYI2HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712662264; c=relaxed/simple;
	bh=o7n4wqg2Y9p0Uni/nKyeds+zg1zOiA+aNEQQSeIs3mM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fdEZcrfzm/txBCJS5hwkQZWf6I1PbY2nA0w7qOBp6K3hSMMdqNF8y5C2r45rGb9cXlfPkNzgV6w5kZbPePPtB08niUJyQe+29ZhCTDU4Eg9CLuUbEIOYDGBWn4du/RaXC/hQTkGaifmteUO0CIcXcGWWxw0UOlgBPwUMHLDc258=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qOeaC/Zb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qOeaC/Zb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A9CC433C7;
	Tue,  9 Apr 2024 11:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712662263;
	bh=o7n4wqg2Y9p0Uni/nKyeds+zg1zOiA+aNEQQSeIs3mM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qOeaC/ZbZHLthcE8m01gwyI0o3SlQzI4nxTsPx7HwIiDdoh6RMr079dnTlVOM1eOz
	 Pm7vlBT9tjrYfgI87EeyYydosi7o/nkh2FAGgXx2lfo2bz4KGuAbtFSDgjTxf7T2yj
	 CPX1K5sm1GdA+rQChvKBvhzW+pKJtAyMumVj0zbE=
Date: Tue, 9 Apr 2024 13:31:00 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Petr Vorel <pvorel@suse.cz>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [PATCH 5.15 463/690] nfsd: fix net-namespace logic in
 __nfsd_file_cache_purge
Message-ID: <2024040952-riches-railcar-40bd@gregkh>
References: <20240408125359.506372836@linuxfoundation.org>
 <20240408125416.405210374@linuxfoundation.org>
 <20240409064222.GA83048@pevik>
 <2024040933-patio-impotent-7a0a@gregkh>
 <20240409103621.GA110810@pevik>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240409103621.GA110810@pevik>

On Tue, Apr 09, 2024 at 12:36:21PM +0200, Petr Vorel wrote:
> > On Tue, Apr 09, 2024 at 08:42:22AM +0200, Petr Vorel wrote:
> > > Hi all,
> 
> > > > 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> > > > ------------------
> 
> > > > From: Jeff Layton <jlayton@kernel.org>
> 
> > > > [ Upstream commit d3aefd2b29ff5ffdeb5c06a7d3191a027a18cdb8 ]
> 
> > > > If the namespace doesn't match the one in "net", then we'll continue,
> > > > but that doesn't cause another rhashtable_walk_next call, so it will
> > > > loop infinitely.
> 
> > > > Fixes: ce502f81ba88 ("NFSD: Convert the filecache to use rhashtable")
> > > > Reported-by: Petr Vorel <pvorel@suse.cz>
> > > > Link: https://lore.kernel.org/ltp/Y1%2FP8gDAcWC%2F+VR3@pevik/
> > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> > > > ---
> > > >  fs/nfsd/filecache.c | 5 ++---
> > > >  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> > > > diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
> > > > index 0b19eb015c6c8..024adcbe67e95 100644
> > > > --- a/fs/nfsd/filecache.c
> > > > +++ b/fs/nfsd/filecache.c
> > > > @@ -892,9 +892,8 @@ __nfsd_file_cache_purge(struct net *net)
> 
> > > >  		nf = rhashtable_walk_next(&iter);
> > > >  		while (!IS_ERR_OR_NULL(nf)) {
> > > > -			if (net && nf->nf_net != net)
> > > > -				continue;
> > > > -			nfsd_file_unhash_and_dispose(nf, &dispose);
> > > I don't know the context (whether the fix is needed for 5.15 and older), but
> > > patch does not apply because nfsd_file_unhash_and_dispose() was introduced in
> > > ce502f81ba88 ("NFSD: Convert the filecache to use rhashtable") in v6.0-rc1.  It
> > > was actually renamed from nfsd_file_unhash_and_release_locked() in that commit.
> > > Also the context changed - nfsd_file_unhash_and_dispose() was introduced in the
> > > commit which is supposed to be fixed in this commit, one would say that this fix
> > > is not needed in older kernels (5.15, 5.10 and 5.4; 4.19 has completely
> > > different code). But that's a question for Jeff or Chuck.
> 
> > This is part of a very large backport of nfsd patches to 5.15 to resolve
> > a lot of reported issues, so that might be why it looks odd here.  It
> > does seem to compile and boot ok for me, so maybe it's not an issue here
> > as you aren't seeing the other patches in this series?
> 
> Hi Greg,
> 
> I'm sorry, I should realize that one of the 462 previous patches might have
> changed the context. If it compiles and boots as whole it should be ok. I'm
> sorry for the noise.

No noise at all, reviews are good!
