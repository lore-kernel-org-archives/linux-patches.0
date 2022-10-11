Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E378B3D7A
	for <patches@lists.linux.dev>; Tue, 11 Oct 2022 19:20:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72E9C433C1;
	Tue, 11 Oct 2022 19:20:45 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ffRvgHya"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1665516044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RA4bPutHAHohSF+PnCG8VU4xakANI3SkU4vfXfUd7Qo=;
	b=ffRvgHyamzXR450C+Ln4VDucOXWh/M5b9/1XUe5G0XeTtNmOAE5k39qXvAUaKlukieuHTM
	hWNJpmMFSLmW8Z+5JVR7Dtl8BZ6KFi+lVPIGL8LkVkjWU6q2ig8SBPiW0noiFKovm6Gb0s
	AnmJjOSlGkYYFhxX58Q713RjahYRZvU=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a3b741dd (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Tue, 11 Oct 2022 19:20:44 +0000 (UTC)
Date: Tue, 11 Oct 2022 13:20:41 -0600
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S . Miller" <davem@davemloft.net>,
	kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v6 5/7] treewide: use get_random_u32() when possible
Message-ID: <Y0XCCSpBVcfg/C/7@zx2c4.com>
References: <20221010230613.1076905-1-Jason@zx2c4.com>
 <20221010230613.1076905-6-Jason@zx2c4.com>
 <2659449.sfTDpz5f83@eto.sf-tec.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2659449.sfTDpz5f83@eto.sf-tec.de>

On Tue, Oct 11, 2022 at 11:14:44AM +0200, Rolf Eike Beer wrote:
> Am Dienstag, 11. Oktober 2022, 01:06:11 CEST schrieb Jason A. Donenfeld:
> > The prandom_u32() function has been a deprecated inline wrapper around
> > get_random_u32() for several releases now, and compiles down to the
> > exact same code. Replace the deprecated wrapper with a direct call to
> > the real function. The same also applies to get_random_int(), which is
> > just a wrapper around get_random_u32(). This was done as a basic find
> > and replace.
> 
> > diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
> > b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c index
> > d0a7465be586..3a7aded30e8e 100644
> > --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
> > +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
> > @@ -177,7 +177,7 @@ static int brcmf_pno_set_random(struct brcmf_if *ifp,
> > struct brcmf_pno_info *pi) memcpy(pfn_mac.mac, mac_addr, ETH_ALEN);
> >  	for (i = 0; i < ETH_ALEN; i++) {
> >  		pfn_mac.mac[i] &= mac_mask[i];
> > -		pfn_mac.mac[i] |= get_random_int() & ~(mac_mask[i]);
> > +		pfn_mac.mac[i] |= get_random_u32() & ~(mac_mask[i]);
> >  	}
> >  	/* Clear multi bit */
> >  	pfn_mac.mac[0] &= 0xFE;
> 
> mac is defined as u8 mac[ETH_ALEN]; in fwil_types.h.
> 
> Eike
> 
> P.S.: CC list trimmed because of an unrelated mailer bug

Nice catch, thanks. Will remove to the get_random_{u16,u8} commit.
