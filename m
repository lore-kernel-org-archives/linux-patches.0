Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286A722B8A2;
	Wed, 12 Mar 2025 07:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741765737; cv=none; b=Z3NxZtCojNwXRSYM41bfbr7fzOfbxdDW3lQVMXe58/LmXa6eB4XT4MfQ9wReCT1rFea+oevlGM7pWT+V29PWU66NlKsKemx4JR/MlREu4dalP51qRVqr5SJ667iaEus8YjZQDH0mUyqggf9u2o15bgkcKXAn7cDmz3w3UQsiHtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741765737; c=relaxed/simple;
	bh=vfRs/MSe/Y1KQFvWBI7tlOGui5LoD1Fb/qm8JwY7gGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D4AMfuGduRQ5Ng2/T2I+wAmrsnUXRLzgHP8pW1tVavGHI0LTwwnsO7HFRl7gFWx5cVksBtQncS01ppk2FaShLfbsBGM+OHx4E2SNNrVITXuiiBQi+b5fGwMeUABjduOsXFlaNgCVSeL5GgsWtp5KNmsiHZTlyMkirnPD8V+1O3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ul/QbDgg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ul/QbDgg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45733C4CEE3;
	Wed, 12 Mar 2025 07:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741765736;
	bh=vfRs/MSe/Y1KQFvWBI7tlOGui5LoD1Fb/qm8JwY7gGs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ul/QbDgg8zcjtl4h5IHyKr+V8a9VU1Ffeaqo83jGvOD+uobs63RIkiPIk27aV8eQv
	 I0ll78Uj+z+IvsEE3+EcDXGdOHZ1Wo+0C7ydX3/OBVNxjp4saTAAAvBZn0QFDV3C5T
	 RryaLAVbn1IWU9QgWrZlO3TGZTyO/1UL0AmNZTyA=
Date: Wed, 12 Mar 2025 08:48:53 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Michael Kelley <mhkelley@outlook.com>
Subject: Re: [EXTERNAL] [PATCH 5.10 304/462] x86/i8253: Disable PIT timer 0
 when not in use
Message-ID: <2025031233-winnings-stopper-fb3d@gregkh>
References: <20250311145758.343076290@linuxfoundation.org>
 <20250311145810.371054352@linuxfoundation.org>
 <c7fd4e4b9e9f5a217b9ccbf14eed0cdad49772be.camel@infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c7fd4e4b9e9f5a217b9ccbf14eed0cdad49772be.camel@infradead.org>

On Tue, Mar 11, 2025 at 04:39:56PM +0100, David Woodhouse wrote:
> On Tue, 2025-03-11 at 15:59 +0100, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: David Woodhouse <dwmw@amazon.co.uk>
> > 
> > commit 70e6b7d9ae3c63df90a7bba7700e8d5c300c3c60 upstream.
> > 
> > Leaving the PIT interrupt running can cause noticeable steal time for
> > virtual guests. The VMM generally has a timer which toggles the IRQ input
> > to the PIC and I/O APIC, which takes CPU time away from the guest. Even
> > on real hardware, running the counter may use power needlessly (albeit
> > not much).
> > 
> > Make sure it's turned off if it isn't going to be used.
> > 
> > Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Tested-by: Michael Kelley <mhkelley@outlook.com>
> > Link: https://lore.kernel.org/all/20240802135555.564941-1-dwmw2@infradead.org
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> You probably want commit 531b2ca0a940ac ("clockevents/drivers/i8253:
> Fix stop sequence for timer 0") too, to make sure it *does* actually
> stop the PIT correctly.

As well as for all of the other stable branches that this showed up in.
I'll queue that up for the next round of stable releases.

thanks,

greg k-h
