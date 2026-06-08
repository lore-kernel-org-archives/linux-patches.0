Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD2C325494;
	Mon,  8 Jun 2026 16:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780934607; cv=none; b=A7spjVrUrrin33aU+qxF0EFxLGDYe68CJrNg2b9Syk5K7F9SzQJwhBUO1qgFsVPDQnKm4OLVJtnfb8GzuWmNKT6nuIsSE7ENs7IBGrTpTgozbHDin7GDUs2hI1cOfPOCv9yF4n3CZVAg2eyItoRd7LadZKdZwTUm5CtFrjpFw1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780934607; c=relaxed/simple;
	bh=8JLxiqgcD0YOvqhERnCcIUPOLSB3aFpHvIB2bHIUDJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sblwVnmJHu63T2wYyiXjbJwUI8xJNwkhm5Th/BHt/07dYpd+OrNhoamfIgL9JSBigH53kwMPQchZHmcper/S3zLxsE+fl7NTGyfg7wrISI7J84zl0iMgprm1le9C20bNKQG+2mSVCx1DI7NVnK79IokYos3nJSC0Z8an4HlQnZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pvrWezwv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pvrWezwv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB851F00893;
	Mon,  8 Jun 2026 16:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780934606;
	bh=Vr9jVMS80gOp2YTnFHoD1vcCtZ8qIuWVlrvbBgC3Ci8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=pvrWezwvYZ6hp0ECtEE5aeudgIuBWvTtR3DEjZ/exd6Ny/IYpkFUKUZNB8jB9Qcm1
	 K5KP4gCcHFAQjKTd6me/OpF6XyfASogHwAY6JQkNkRLAvviutcLcpfF4maGlVm+mXY
	 YJGQvZ98XbCPGqWZ3mgLUpwjPB3WUxVUNEXjG3fM=
Date: Mon, 8 Jun 2026 18:02:27 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thorsten Leemhuis <linux@leemhuis.info>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Hannes Reinecke <hare@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>, Justin Forbes <jforbes@redhat.com>
Subject: Re: [PATCH 7.0 089/332] net/handshake: Pass negative errno through
 handshake_complete()
Message-ID: <2026060807-egging-prune-a3ae@gregkh>
References: <20260607095728.031258202@linuxfoundation.org>
 <20260607095731.416875228@linuxfoundation.org>
 <3fe6ad12-30e4-4a57-8167-268ffdb4488a@leemhuis.info>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fe6ad12-30e4-4a57-8167-268ffdb4488a@leemhuis.info>

On Mon, Jun 08, 2026 at 04:37:09PM +0200, Thorsten Leemhuis wrote:
> On 6/7/26 11:57, Greg Kroah-Hartman wrote:
> > 7.0-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Chuck Lever <chuck.lever@oracle.com>
> > 
> > [ Upstream commit 6b22d433aa13f68e3cd9534ca9a5f4277bfa01c2 ]
> > 
> > handshake_complete() declares status as unsigned int and
> > tls_handshake_done() negates that value (-status) before handing
> > it to the TLS consumer. Consumers match on negative errno
> > constants -- xs_tls_handshake_done() has
> 
> This causes a error for me when building ynl. See below for the build
> log. The problem can be avoided by reverting this patch from the
> stable-rc queue or by cherry-picking fbf5df34a4dbcd ("tools: ynl: add
> scope qualifier for definitions") [v7.1-rc4].
> 
> I'd suggest doing the later, as I last week had a quite similar error
> when building ynl during the 7.0.11-rc1 phase:
> https://lore.kernel.org/all/d66f5c95-ebc0-4c53-9852-f73c790363f7@leemhuis.info/
> 
> Back then Sasha went for dropping the problematic change ("net: shaper:
> reject handle IDs exceeding internal bit-width") from the 6.18.y and
> 7.0.y queues. But given that this is the second time within a week the
> missing patch seems to cause trouble I suspect it might not be the last.

I've queued this up now, but it didn't apply to 6.12.y, can someone
provide a working backport for there?

thanks,

greg k-h
