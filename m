Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A0122097;
	Sat, 15 Jun 2024 10:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718449091; cv=none; b=uenE51rbf33KJ0dbOm2CwVQj9WKKJqKshxUtk6xl8UibCVmuGdx6OVQL7Uj0FMfx9DOshVa/bLSYEmMOzkP2X4sfiqG3kisUEl02rJ0I17wyUIWsSSg4hFdPE8DMOp1YQegJJL17oK9t1TdgTOlE+k7+NKLrcU8nAvTSl0Ogklo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718449091; c=relaxed/simple;
	bh=g7IPgHNS1h3LS5lVbaExUnTikfLbPytBrEMmU/FTdko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lHQgKKupMW5ENP1vEHjCih21o66xFfdte2g8iTgZ2cccekFAMm5yOoKjGkQjY9YNjTcCDt1nZ/gqoM7Tm2dAfjj3lhEwsxKlVgyc0/sbOZhebLeTyFNpUKnY9ZXhcNObviN+h98VmE78J0GoNhJlo9wc2M62WQNDwtqoS+gWwBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G0T+MsEs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G0T+MsEs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48DF7C116B1;
	Sat, 15 Jun 2024 10:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718449090;
	bh=g7IPgHNS1h3LS5lVbaExUnTikfLbPytBrEMmU/FTdko=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G0T+MsEsv5z0vFZmtWxcCOi3Qg5SytEtbNE0gjMEFHYU7tGne8hPP4/zo2PeVhSzD
	 erZFg3oFWdGNvVbuquJ07YR5MPpbMuhA0bzKlRIiMFzX3wB+Ituw5Ok+5Jq9zVvGBV
	 BebxSS+M1Jk0eBDO0TA8BrDC+jDshmQumpHJLgOI=
Date: Sat, 15 Jun 2024 12:58:07 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ken Milmore <ken.milmore@gmail.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, stable@vger.kernel.org,
	patches@lists.linux.dev, Heiner Kallweit <hkallweit1@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: Re: [PATCH 5.10 004/317] r8169: Fix possible ring buffer corruption
 on fragmented Tx packets.
Message-ID: <2024061559-skirmish-cassette-fb84@gregkh>
References: <20240613113247.525431100@linuxfoundation.org>
 <20240613113247.702462647@linuxfoundation.org>
 <9592add5-b9e3-d14d-dd1b-2ef3d1057dd1@ispras.ru>
 <ae35864a-9a76-4e9e-8a33-2d141f475d4d@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae35864a-9a76-4e9e-8a33-2d141f475d4d@gmail.com>

On Thu, Jun 13, 2024 at 09:27:18PM +0100, Ken Milmore wrote:
> On 13/06/2024 18:21, Alexey Khoroshilov wrote:
> > On 13.06.2024 14:30, Greg Kroah-Hartman wrote:
> >> 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > The patch is cleanly applied to 5.10, but it leads to uninit value
> > access in rtl_tx_slots_avail().
> > 
> > 
> > 	unsigned int frags;
> > 	u32 opts[2];
> > 
> > 	txd_first = tp->TxDescArray + entry;
> > 
> > 	if (unlikely(!rtl_tx_slots_avail(tp, frags))) {
> >                                              ^^^^^ - USE OF UNINIT VALUE
> > 		if (net_ratelimit())
> > 			netdev_err(dev, "BUG! Tx Ring full when queue awake!\n");
> > 		goto err_stop_0;
> > 	}
> > 
> > 	opts[1] = rtl8169_tx_vlan_tag(skb);
> > 	opts[0] = 0;
> > 
> > 	if (!rtl_chip_supports_csum_v2(tp))
> > 		rtl8169_tso_csum_v1(skb, opts);
> > 	else if (!rtl8169_tso_csum_v2(tp, skb, opts))
> > 		goto err_dma_0;
> > 
> > 	if (unlikely(rtl8169_tx_map(tp, opts, skb_headlen(skb), skb->data,
> > 				    entry, false)))
> > 		goto err_dma_0;
> > 
> > 	txd_first = tp->TxDescArray + entry;
> > 
> > 	frags = skb_shinfo(skb)->nr_frags;
> >         ^^^^^^   - INITIALIZATION IS HERE AFTER THE PATCH
> > 
> > There is no such problem in upstream because rtl_tx_slots_avail() has no
> > nr_frags argument there.
> > 
> > 
> > Found by Linux Verification Center (linuxtesting.org) with SVACE.
> > 
> > --
> > Alexey Khoroshilov
> > Linux Verification Center, ISPRAS
> 
> Looks like the frags argument was removed in commit 83c317d7b36bb (r8169: remove nr_frags argument from rtl_tx_slots_avail), which first appears in linux-5.11.
> 
> I dare say it would be safe to replace
>  	if (unlikely(!rtl_tx_slots_avail(tp, frags))) {
> with
>  	if (unlikely(!rtl_tx_slots_avail(tp, MAX_SKB_FRAGS))) {
> 
> Best wait for Heiner to confirm though.

I'll just drop this commit for now, thanks.

greg k-h
