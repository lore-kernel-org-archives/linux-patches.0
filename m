Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109DC57884;
	Wed, 14 Feb 2024 14:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707920631; cv=none; b=Epcjs+Fto7x7RgtbW/kqwjC/8Tyb/bAw0J7vTI9sgE2BgpDHo43VgYyfYLVJ/EmS97hdCZANHny4sN3sTWhg2im9yxIa0UnLjBWX18Bmm9UcOpeeYRI4OadyW7Hp/NCiJ2nh742dqhPAQETR+TkQtRCwg9l7dztuotKm54tuaqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707920631; c=relaxed/simple;
	bh=Y0DEqoKoiJNmnLXHIlNiOeBFv27RaLviCDR7jKHAn14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WhbQuqx3jmqnC20TOuCOxx+m2W6NI8Mt7E+hRQMafcdh3XohXY05i72xoaFqeJSfCWsru5Gxo0BQQ1TrHOPPTnhZy/Lg7xZj4MEtEYjEUdMqTz3GkbSvN9ncfqHpad8oUjkwTTyS0cE0gWpMtWD2lbwuxcipe1xO0AmU0jyFqLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QCAkV9Mj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QCAkV9Mj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113E4C433F1;
	Wed, 14 Feb 2024 14:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707920630;
	bh=Y0DEqoKoiJNmnLXHIlNiOeBFv27RaLviCDR7jKHAn14=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QCAkV9MjcTfGyGPNnHxfstxDQyy/S4HtJYeB9GL2FyPKXt1cb4gqlI3VFB6WoP9y7
	 IHCZ0y78kxqFRVJt1LCkSBgA+Xlfndxdzkyl6EsCMLN3jAF1QcVXVJ5yK2dLVJi5qe
	 cy0lPl4j26b+Jcj4q7rxZoQZYqgn6HW/ivGYujSU=
Date: Wed, 14 Feb 2024 15:23:47 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?utf-8?Q?Micha=C5=82?= Pecio <michal.pecio@gmail.com>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>, stable@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH 6.1 53/64] xhci: process isoc TD properly when there was
 a transaction error mid TD.
Message-ID: <2024021426-utter-startup-d4a1@gregkh>
References: <20240213171844.702064831@linuxfoundation.org>
 <20240213171846.401480216@linuxfoundation.org>
 <20240213194726.7262e240@foxbook>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240213194726.7262e240@foxbook>

On Tue, Feb 13, 2024 at 07:47:26PM +0100, Michał Pecio wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me
> > know.
> 
> I'm afraid this patch needs a little backporting for 6.1.x and earlier,
> because it frees entries in the transfer ring and this seems to involve
> updating a free space counter (num_trbs_free) on those kernel versions.
> 
> There may be other incompatibilities, particularly in earlier versions,
> I'm not clamining that this is a complete review.
> 
> 
> Related patch "handle isoc Babble and Buffer Overrun events properly"
> depends on this one and needs to wait until issues are resolved.
> 
> 
> This is the problematic part which calls xhci_td_cleanup() and bypasses
> finish_td() where the counting is normally done:
> > +				if (ep_seg) {
> > +					/* give back previous TD, start handling new */
> > +					xhci_dbg(xhci, "Missing TD completion event after mid TD error\n");
> > +					ep_ring->dequeue = td->last_trb;
> > +					ep_ring->deq_seg = td->last_trb_seg;
> > +					inc_deq(xhci, ep_ring);
> > +					xhci_td_cleanup(xhci, td, ep_ring, td->status);
> > +					td = td_next;
> >  				}

Ok, I will drop this for 6.1.x and older, please submit a working commit
for these kernels if you wish to see it in them.

thanks,

greg k-h
