Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFBB21A425;
	Thu, 27 Nov 2025 12:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764247935; cv=none; b=jzkar/0gsY+jMhhsKPF8/MYZEcsI2abicKpLEc6WzSySO+7Fe7hd7cwcmYu2WGA7z+Ab+TSLsme1e0k50uunkH7HWlioG9EIatKVfjg/I7SLBUwojlOeZMjxhYfJT4hbn6BvQilBRFVqfViYTK9fqB7RQD5kaGHxFUnwo1nFjOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764247935; c=relaxed/simple;
	bh=7mI+R1BGydSJzPjv/tZ3DYJPk36lOhgPS1Ewmy4H4g4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BLt2HrQDf3qZkOvOcPJ9PCdi8cFCpAw6U9SoqW8NPmmxp7OC7Ibj2mb7xJizbripQ3IoxFXnUcEJESceKZ4CF6nRxzpqzOuDfYGpwx+nz5nWbduQpHjtJW1/Uc07H4EgD6B3RlT9qMVyMrFLhyyYd8PDXeo6C+jV8V46C0fwWKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jdIXX3Fm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jdIXX3Fm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705DEC4CEF8;
	Thu, 27 Nov 2025 12:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764247934;
	bh=7mI+R1BGydSJzPjv/tZ3DYJPk36lOhgPS1Ewmy4H4g4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jdIXX3FmfgW9rrMSrt6YCBuAMDKmmxw/CGeVgZ44QF/LGIfLXjH7Mg/KrAh6iX508
	 5JHZd4jjHhTWoDHH3gcoJIKrSS2jPM+KoVkFNxTa52hnVjsJiwxKtudrbg5OQORp5G
	 4AaWI5xJs4XElSRhgb5lVAFfMTCoYo+2Sbfv1JuQ=
Date: Thu, 27 Nov 2025 13:52:12 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: Jiri Slaby <jirislaby@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Jay Shin <jaeshin@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH 6.17 817/849] smb: client: fix potential UAF in
 smb2_close_cached_fid()
Message-ID: <2025112701-renewed-mooing-f822@gregkh>
References: <20251111004536.460310036@linuxfoundation.org>
 <20251111004556.178148239@linuxfoundation.org>
 <ed7d962e-b350-4986-ae92-14509306ea65@kernel.org>
 <2f9985eb-e180-44f4-9185-b863826245f9@suse.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f9985eb-e180-44f4-9185-b863826245f9@suse.com>

On Wed, Nov 26, 2025 at 11:11:30AM -0300, Henrique Carvalho wrote:
> 
> 
> On 11/26/25 3:47 AM, Jiri Slaby wrote:
> > On 11. 11. 25, 1:46, Greg Kroah-Hartman wrote:
> >> 6.17-stable review patch.  If anyone has any objections, please let me
> >> know.
> >>
> >> ------------------
> >>
> >> From: Henrique Carvalho <henrique.carvalho@suse.com>
> >>
> >> commit 734e99623c5b65bf2c03e35978a0b980ebc3c2f8 upstream.
> ...
> > 
> > This _backport_ (of a 6.18-rc5 commit) omits to change
> > cfids_invalidation_worker() which was removed in 6.18-rc1 by:
> > 7ae6152b7831 smb: client: remove cfids_invalidation_worker
> > 
> > This likely causes:
> > https://bugzilla.suse.com/show_bug.cgi?id=1254096
> > BUG: workqueue leaked atomic, lock or RCU
> > 
> > Because cfids_invalidation_worker() still does:
> >                 kref_put(&cfid->refcount, smb2_close_cached_fid);
> > instead of now required kref_put_lock() aka:
> >                 close_cached_dir(cfid);
> > 
> > thanks,
> 
> Thanks, Jiri.
> 
> I'm sending the updated patch attached.
> 
> This new version should also replace the patch backported to stable
> versions:
> 
> - 6.12.y (065bd62412271a2d734810dd50336cae88c54427)
> - 6.6.y (cb52d9c86d70298de0ab7c7953653898cbc0efd6)
> 
> Alternatively, I'm sending just the fix ("smb: client: fix incomplete
> backport in cfids_invalidation_worker()").

Thanks, I've taken the "fixup" now.

greg k-h
