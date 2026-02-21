Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B666F280324;
	Sat, 21 Feb 2026 22:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771711318; cv=none; b=SoGKcXFJSo67Q9lXEhWU2o5SmOV6asJKTjOVumDdnEDh3DUnLK3Gf5mEi6N7R3FzgHdxuqdmMW0Xb8O930gncy+zN3/j/vAGIKO8PMPNEaKr0n31cVL1s7jpxTDGiIzIQZZ0IJH62gnRyB99Btxk0e4SbiSJI8ArQoKCMErCFuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771711318; c=relaxed/simple;
	bh=20a+tYRkc9plljsBoBRBzCC27DmkDCn4o9q+kiWHgEU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tn4QRGbxZzBsE+MYPXeRBMv2Ty9eT0W3vdQWULMyIB0Mp4Ho1bg59nHRR7z26B+JuO3xK0+wSbYz4FNRN+K3uDduhoJa7s+rKK9krvl3NSvVLuXKJh9qhah10c9kUfr2jYNcdgWdM1tKPKnAo74YpBomkPZWN8eh1H2RMxNYKsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=a3ub2MXT; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="a3ub2MXT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wKbbsAV9GKA7qu43sPIgrm99UQtsv+1OBx9lmas+e9U=; b=a3ub2MXTZUYipWSqRs5JoR+qvb
	Lu4dte+QWAvzbcG88JjsIsAp0/gAVW0HgMLY3+6/eiWcR6fCQRWs3jhF+B+gkh4PDz+21hFilsnBg
	aUMlolNb83OP0YZq83CapQUruahsC4iPAzZfliaZZA+Sq39/C1Jj0Pa3hkb1+7ye8BZOCCD4YxpNv
	9Ohy6J4Znb97dDcNuInYPV947AiSOvd5VEUMk5lQ/mYYR61oOYKeEiqqQvYFkji3ywr6T+57UOlN6
	JytwOmGwf00zp2lRxplBfT+WqTtmLOBtpIi6Sl8CSXdVgemCXc+Tncs1tGlso+Sj8dznJTXSDTKud
	a1BvUNMQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vtunR-0000000BzyP-42kV;
	Sat, 21 Feb 2026 21:45:53 +0000
Date: Sat, 21 Feb 2026 21:45:53 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
	Arnd Bergmann <arnd@arndb.de>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH 5.10 02/41] ARM: 9468/1: fix memset64() on big-endian
Message-ID: <aZonkWMwpbFhzDJq@casper.infradead.org>
References: <20260209142256.797267956@linuxfoundation.org>
 <20260209142256.889650945@linuxfoundation.org>
 <1a11526ae3d8664f705b541b8d6ea57b847b49a8.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a11526ae3d8664f705b541b8d6ea57b847b49a8.camel@decadent.org.uk>

On Sat, Feb 21, 2026 at 09:21:42PM +0100, Ben Hutchings wrote:
> On Mon, 2026-02-09 at 15:24 +0100, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Thomas Weissschuh <thomas.weissschuh@linutronix.de>
> > 
> > commit 23ea2a4c72323feb6e3e025e8a6f18336513d5ad upstream.
> > 
> > On big-endian systems the 32-bit low and high halves need to be swapped
> > for the underlying assembly implementation to work correctly.
> 
> Now it's broken on little-endian, because CONFIG_CPU_LITTLE_ENDIAN was
> only introduced in 5.19.
> 
> For 5.10 and 5.15, please revert this or change the condition to
> !IS_ENABLED(CONFIG_CPU_BIG_ENDIAN).

Probably best to pull in the version Linus preferred:

https://lore.kernel.org/linux-arm-kernel/20260213-arm-memset64-cleanup-v1-1-644a9735eeec@linutronix.de/


