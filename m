Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7792E5B39;
	Tue,  8 Jul 2025 17:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994232; cv=none; b=E8x9lyWZcF/1ynXkcccym5Yu+k+wKK+WTNEp9LE8rLYx4Epdfi1blTY4SaRY/HzjsUx5zL2LGws9NcWcaTS87EPZk6jTFFGC3brBpsf+T0VC8IMoJuk4BSTsN0wNGkBNs/tbybK9AtF/SSC3Mh6k89cwI3Iny/QEmWsti9CJiRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994232; c=relaxed/simple;
	bh=m6WVq/hD+2DOCoVG6MdmVi28DhU/sSmneozj4ab4Vdo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=deRXRHs30zzgK5oFzk+bV7DzwymaoBGxTrHoTQyeG50JC8LTUaIhIAb9Zu+JxPub6e0u9zStRRgmsTep4U+lF1S9kgvTNxB42agf7yP9iN3QAvAblVwiQf695p5uIibPqAwUzcJtKDl3+2Nh44kqitafYPUiRC12zFhmX5UaaC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zJJAEqwT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zJJAEqwT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63722C4CEED;
	Tue,  8 Jul 2025 17:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994231;
	bh=m6WVq/hD+2DOCoVG6MdmVi28DhU/sSmneozj4ab4Vdo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zJJAEqwTYURYDW8jm7Lb9iLW7tF6MNo8NXnT+l70izpMP0eInT1xeBY09P2U+HZea
	 Ngdj4iHQEk9RtzWGMT2QEbFVRi7aMl2yG93xTuBPnFu/EgrLWdfIF/vL+mui7cqVC9
	 dvCguMEunL8/4KLJqWWffNo/uEdava6++lTRTDx0=
Date: Tue, 8 Jul 2025 18:48:09 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: Re: [PATCH 6.1 81/81] x86/process: Move the buffer clearing before
 MONITOR
Message-ID: <2025070838-constrain-bath-afbd@gregkh>
References: <20250708162224.795155912@linuxfoundation.org>
 <20250708162227.496631045@linuxfoundation.org>
 <46161d11-2560-4044-8ed5-bb50206f9da2@citrix.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46161d11-2560-4044-8ed5-bb50206f9da2@citrix.com>

On Tue, Jul 08, 2025 at 05:35:04PM +0100, Andrew Cooper wrote:
> On 08/07/2025 5:24 pm, Greg Kroah-Hartman wrote:
> > @@ -895,13 +900,17 @@ static __cpuidle void mwait_idle(void)
> >  		}
> >  
> >  		__monitor((void *)&current_thread_info()->flags, 0, 0);
> > -		if (!need_resched())
> > -			__sti_mwait(0, 0);
> > -		else
> > +		if (need_resched()) {
> >  			raw_local_irq_enable();
> > +			goto out;
> > +		}
> > +
> > +		__sti_mwait(0, 0);
> 
> Erm, this doesn't look correct.

Did I get this merge wrong?  I didn't get a conflict here, but I did in
6.15.y

> The raw_local_irq_enable() needs to remain after __sti_mwait().

Is this correct in Linus's tree?

thanks,

greg k-h
