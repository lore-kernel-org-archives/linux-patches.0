Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA91119E965;
	Thu,  9 Jan 2025 10:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736417345; cv=none; b=jFsiKkLRvkCz4BsqPRXHC2v4JNOWVfDg0tTy11brH1B2Rb0biILIHswWeRIPtRV83CN+mq78Z0HFwMgAPkyVjtuJtH5Lk3StNVBFKBT8iBScjv7DfH8KayR3CafezIO818uq20n7o9ggzPopCMaUkemCIwO/+3wyxON1p/jqPxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736417345; c=relaxed/simple;
	bh=veP0HqwfPhRjMBkQKLSbZSZebCfsTPfc8I//DwPoiA0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u17MbrlkA/JuYkHYV9CcZbAYIJgbQAwyQCzIy6Ei8vKoHBQkLVIRfCfgcl6rRE2MZt9ZD2tpNIZVqYiLJyn7m39/oms6Q3pHB8kmAxkvFh2ONZKW8lhPSMLk+ACivtSKw3qpq0CAXVbFc1ioz22DOOQ2xZK6ZT9F3t9S+r89suQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JxvU9z0f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JxvU9z0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE225C4CEDF;
	Thu,  9 Jan 2025 10:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736417345;
	bh=veP0HqwfPhRjMBkQKLSbZSZebCfsTPfc8I//DwPoiA0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JxvU9z0fOke928lTICbor0RygKW8QO8aEdP782reO9xMa7bs36DoRhb0bmd0M43wX
	 jd6MflUI+lNj3VLksv2Vi1rrf1lfJ3m4evKB9htYAyLh1+PfkIMCnMtMIoUCKBZM0x
	 RR3cVXnoHg8BGzJRATFelyd1XlgEW38fgkWjyhIc=
Date: Thu, 9 Jan 2025 11:09:02 +0100
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
Message-ID: <2025010929-nutmeg-lustiness-f433@gregkh>
References: <Z3ytcILx4S1v_ueJ@codewreck.org>
 <20250107071604.190497-1-dominique.martinet@atmark-techno.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250107071604.190497-1-dominique.martinet@atmark-techno.com>

On Tue, Jan 07, 2025 at 04:16:04PM +0900, Dominique Martinet wrote:
> This is a pre-requisite for the backport of commit 74363ec674cb ("zram:
> fix uninitialized ZRAM not releasing backing device"), which has been
> implemented differently in commit 7ac07a26dea7 ("zram: preparation for
> multi-zcomp support") upstream.
> 
> We only need to ensure that zcomp_destroy is not called with a NULL
> comp, so add this check as the other commit cannot be backported easily.
> 
> Stable-dep-of: 74363ec674cb ("zram: fix uninitialized ZRAM not releasing backing device")
> Link: https://lore.kernel.org/Z3ytcILx4S1v_ueJ@codewreck.org
> Suggested-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
> ---
> This is the fix suggested by kasong in reply to my report (his mail
> didn't make it to lkml because of client sending html)
> 
> This applies cleanly on all 3 branches, and I've tested it works
> properly on 5.10 (e.g. I can allocate and free zram devices fine)
> 
> I have no preference on which way forward is taken, the problematic
> patch can be dropped for a cycle while this is sorted out...
> 
> 
> Also, Kasong pointed to another issue he sent a patch for just now:
> https://lore.kernel.org/all/20250107065446.86928-1-ryncsn@gmail.com/
> 
> Before 74363ec674cb ("zram: fix uninitialized ZRAM not releasing backing
> device") that was indeed not a problem so I confirm this is a
> regression, even if it is unlikely.
> It doesn't look exploitable by unprivileged users anyway so I don't have
> any opinion on whether the patches should be held until upstream picks
> this latest fix up as well either.

Looks like Sasha just dropped the offending commit from the 5.10 and
5.15 queues (but forgot to drop some dep-of patches, I'll go fix that
up), so I'll also drop the patch from the 6.1.y queue as well to keep
things in sync.

If you all want this change to be in 6.1.y (or any other tree), can you
provide a working backport, with this patch merged into it?

thanks,

greg k-h
