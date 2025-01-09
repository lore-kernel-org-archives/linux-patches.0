Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945DA2153E0;
	Thu,  9 Jan 2025 10:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736417381; cv=none; b=ljKMgKRDPtiN7aFWT/mkUQuKd0T2LzDbEXU6rRvGuTCQ6kYi28oUDsrWEYla35NZhH5KnSkig9L1S+1S4oMJi3d2wLFbQuUo9UiyGayEC4QwsXPhOp1AzaQyeFsyoNi7/vcDvARgCO9e9fqYzWtQmwmxXaeZdk++TxDcPiWU8bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736417381; c=relaxed/simple;
	bh=GDudpOKTWDYk9EI/wbr+KTMhTD/vFHbU+AATX3DuoLI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AapYPyHCMURb+WGUf/gB20PlAjbJlDI68d+F5ZFbG2pAOtFG9/QBV7obYhcQPC+lmtYViKNbc+TjodvjNrGzee8TFWsCfJDQGhpfMbV5svhGaf8RXylmw8JJhxYKi4hNKTkJMqRSHht/sppTMQB5yJ/5EWIaasYrsFTH7MEHwq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C9D1fhD6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C9D1fhD6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F7AC4CED2;
	Thu,  9 Jan 2025 10:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736417381;
	bh=GDudpOKTWDYk9EI/wbr+KTMhTD/vFHbU+AATX3DuoLI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C9D1fhD6kx7F60PP1FepVQO6dRD5qmlQCulQWS8m5xctf5T+2YpOm75DtyFQGi+zF
	 0hpXgOZ/Dzmhlj2ZFazHmEb6vfy6ieG64vFn5QL3oMYGp8BplChXDWQhhHp81c+GT4
	 dzjcX4cACNmnvI2WiWvjZVGcIcsQHBL/PUPwnsvc=
Date: Thu, 9 Jan 2025 11:09:38 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dominique Martinet <dominique.martinet@atmark-techno.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Desheng Wu <deshengwu@tencent.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 5.15 6.1] zram: check comp is non-NULL before
 calling comp_destroy
Message-ID: <2025010916-janitor-matching-0136@gregkh>
References: <Z3ytcILx4S1v_ueJ@codewreck.org>
 <20250107071604.190497-1-dominique.martinet@atmark-techno.com>
 <2025010929-nutmeg-lustiness-f433@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025010929-nutmeg-lustiness-f433@gregkh>

On Thu, Jan 09, 2025 at 11:09:02AM +0100, Greg Kroah-Hartman wrote:
> On Tue, Jan 07, 2025 at 04:16:04PM +0900, Dominique Martinet wrote:
> > This is a pre-requisite for the backport of commit 74363ec674cb ("zram:
> > fix uninitialized ZRAM not releasing backing device"), which has been
> > implemented differently in commit 7ac07a26dea7 ("zram: preparation for
> > multi-zcomp support") upstream.
> > 
> > We only need to ensure that zcomp_destroy is not called with a NULL
> > comp, so add this check as the other commit cannot be backported easily.
> > 
> > Stable-dep-of: 74363ec674cb ("zram: fix uninitialized ZRAM not releasing backing device")
> > Link: https://lore.kernel.org/Z3ytcILx4S1v_ueJ@codewreck.org
> > Suggested-by: Kairui Song <kasong@tencent.com>
> > Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
> > ---
> > This is the fix suggested by kasong in reply to my report (his mail
> > didn't make it to lkml because of client sending html)
> > 
> > This applies cleanly on all 3 branches, and I've tested it works
> > properly on 5.10 (e.g. I can allocate and free zram devices fine)
> > 
> > I have no preference on which way forward is taken, the problematic
> > patch can be dropped for a cycle while this is sorted out...
> > 
> > 
> > Also, Kasong pointed to another issue he sent a patch for just now:
> > https://lore.kernel.org/all/20250107065446.86928-1-ryncsn@gmail.com/
> > 
> > Before 74363ec674cb ("zram: fix uninitialized ZRAM not releasing backing
> > device") that was indeed not a problem so I confirm this is a
> > regression, even if it is unlikely.
> > It doesn't look exploitable by unprivileged users anyway so I don't have
> > any opinion on whether the patches should be held until upstream picks
> > this latest fix up as well either.
> 
> Looks like Sasha just dropped the offending commit from the 5.10 and
> 5.15 queues (but forgot to drop some dep-of patches, I'll go fix that
> up), so I'll also drop the patch from the 6.1.y queue as well to keep
> things in sync.
> 
> If you all want this change to be in 6.1.y (or any other tree), can you
> provide a working backport, with this patch merged into it?

Oops, nope, this was already in a 6.1.y release, so I'll go apply this
patch there now.  Sorry for the noise...

greg k-h
