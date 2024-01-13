Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435B66AA6;
	Sat, 13 Jan 2024 20:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="dG4iAKCM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wJ5yJxPmst3zsydgmnWltTiW8JB9HTVakNC0H/+BSHk=; b=dG4iAKCMZTYRmgJwym4ypONdVJ
	riachWilF8ABEQQModp6w9x/g53bBrceWe9+ifwyN5EZfTxE34T6oEJy5pjr/IIUWw5Bh22iHYexy
	0SyVV+r9oD+XPxgoU8u//DfvONgBkmrGPSjlm731vIhMBygoN3GGZKmmOJ+MX5pEcod0iFDnDk6r1
	L8k3XH8Nd8XaQzLMyNZaxOJQYzmVwwYXX449rv3zeTKytN+TOMvA657IdLuJUxUfm7llK8LmPn2h7
	wLV4xH8C/0/cJGmNqqFIOdllfX2xWGlQ285Ru4aQC58NmCDuR4H0lBdzywcm8V/yypC4WBEOkf21M
	qLpacWew==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <carnil@debian.org>)
	id 1rOkJH-008zUu-HA; Sat, 13 Jan 2024 20:08:51 +0000
Received: by eldamar.lan (Postfix, from userid 1000)
	id D5A74BE2DE0; Sat, 13 Jan 2024 21:08:50 +0100 (CET)
Date: Sat, 13 Jan 2024 21:08:50 +0100
From: Salvatore Bonaccorso <carnil@debian.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH 6.1 1/4] cifs: fix flushing folio regression for 6.1
 backport
Message-ID: <ZaLt0qdHACUjlyOv@eldamar.lan>
References: <20240113094204.017594027@linuxfoundation.org>
 <20240113094204.068608649@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240113094204.068608649@linuxfoundation.org>
X-Debian-User: carnil

Hi Greg,

On Sat, Jan 13, 2024 at 10:50:39AM +0100, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> filemap_get_folio works differenty in 6.1 vs. later kernels
> (returning NULL in 6.1 instead of an error).  Add
> this minor correction which addresses the regression in the patch:
>   cifs: Fix flushing, invalidation and file size with copy_file_range()
> 
> Suggested-by: David Howells <dhowells@redhat.com>
> Reported-by: Salvatore Bonaccorso <carnil@debian.org>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> Tested-by: Salvatore Bonaccorso <carnil@debian.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  fs/smb/client/cifsfs.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -1240,7 +1240,7 @@ static int cifs_flush_folio(struct inode
>  	int rc = 0;
>  
>  	folio = filemap_get_folio(inode->i_mapping, index);
> -	if (IS_ERR(folio))
> +	if ((!folio) || (IS_ERR(folio)))
>  		return 0;
>  
>  	size = folio_size(folio);

Note, this one needs to be revisited:

https://lore.kernel.org/stable/ZaLNlyo8cDCpATPm@casper.infradead.org/T/#md6a3f0beceaa886ca0d1e4a47ff5a575340d7e8f

Regards,
Salvatore
