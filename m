Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9016AA6;
	Sat, 13 Jan 2024 20:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cX8Y1oI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF4CC433C7;
	Sat, 13 Jan 2024 20:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705177190;
	bh=L/pJvDQ52c7g8Uf+4aJJZC5MDQljv8CbSNtcFXli0oM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cX8Y1oI8Bm/FCkD2opP9AlzeHUBhi/meDWe9jjASzUJG6b2GaIpW0W87NwWH9eggy
	 7S0bzswDtQSe7QRUuTau8sfjK4bI0UQIjB3uw7fKxrECjmV0Gs9V/OX5MfFKrVnGDX
	 vVCh1O0GWutu3Tokh4uhq5XTt0e2XCKIcGrEeqZ4=
Date: Sat, 13 Jan 2024 21:19:46 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Salvatore Bonaccorso <carnil@debian.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH 6.1 1/4] cifs: fix flushing folio regression for 6.1
 backport
Message-ID: <2024011336-oppressor-ocean-17c2@gregkh>
References: <20240113094204.017594027@linuxfoundation.org>
 <20240113094204.068608649@linuxfoundation.org>
 <ZaLt0qdHACUjlyOv@eldamar.lan>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZaLt0qdHACUjlyOv@eldamar.lan>

On Sat, Jan 13, 2024 at 09:08:50PM +0100, Salvatore Bonaccorso wrote:
> Hi Greg,
> 
> On Sat, Jan 13, 2024 at 10:50:39AM +0100, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > filemap_get_folio works differenty in 6.1 vs. later kernels
> > (returning NULL in 6.1 instead of an error).  Add
> > this minor correction which addresses the regression in the patch:
> >   cifs: Fix flushing, invalidation and file size with copy_file_range()
> > 
> > Suggested-by: David Howells <dhowells@redhat.com>
> > Reported-by: Salvatore Bonaccorso <carnil@debian.org>
> > Signed-off-by: Steve French <stfrench@microsoft.com>
> > Tested-by: Salvatore Bonaccorso <carnil@debian.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  fs/smb/client/cifsfs.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- a/fs/smb/client/cifsfs.c
> > +++ b/fs/smb/client/cifsfs.c
> > @@ -1240,7 +1240,7 @@ static int cifs_flush_folio(struct inode
> >  	int rc = 0;
> >  
> >  	folio = filemap_get_folio(inode->i_mapping, index);
> > -	if (IS_ERR(folio))
> > +	if ((!folio) || (IS_ERR(folio)))
> >  		return 0;
> >  
> >  	size = folio_size(folio);
> 
> Note, this one needs to be revisited:
> 
> https://lore.kernel.org/stable/ZaLNlyo8cDCpATPm@casper.infradead.org/T/#md6a3f0beceaa886ca0d1e4a47ff5a575340d7e8f

I see that, thanks, I'll go fix this up.

greg k-h
