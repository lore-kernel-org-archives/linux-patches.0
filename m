Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F922D73AC;
	Wed, 13 Aug 2025 07:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755071263; cv=none; b=HlVdJQn19yNzL3/YMoTmwnAd1obDWegYnOGoYQbz66B70wKA5LRL6FWX+2mm4VDS2v9sp6xWGkVRgBoJFKHYln/pubmJQZRXi+PP+ca1t1pSAcEkS62+fCBXb40tXhqHOgRLj3wNJRyM2LE3F6O5tWMhyVNve6wmQeMK9+je2RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755071263; c=relaxed/simple;
	bh=Fideh62UEur0QpQrCZhQsftnWfsDUJRBsNG1byrcATA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rmk7oO4EzWJDcSp+MdNlgld3es+/XplBGl+TcdJaqBkp4n10IJU4MmEnTYeuNSc77QugmUmAQa9TNz5PigeW7OGnN8BPsrbGPhxXBhbcLIBOuYWzJivFqRr5hekyCqXryriU2l8crEcr1jNdMXr5mJY81NGALjdR7bnDZsPqt3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D5Lke5+j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D5Lke5+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1A0C4CEEB;
	Wed, 13 Aug 2025 07:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755071261;
	bh=Fideh62UEur0QpQrCZhQsftnWfsDUJRBsNG1byrcATA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D5Lke5+jHbVSft5lYT1/COXTjQLjf/OzwFQh0X0FU0XZ1Fgg41CAQQ1BY41YuYTt3
	 hzf3P/tkpMS3699fAR4A3SIR4BspyNbL8Y3+tc9kLG4wtmBcFeSRmXgDT1znvh9qFx
	 AN/wk57vmWSk27vaXVE7v53kdSWhnxnrcON2qys4=
Date: Wed, 13 Aug 2025 09:47:38 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Csaba Buday <buday.csaba@prolan.hu>, Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.16 519/627] net: mdio_bus: Use devm for getting reset
 GPIO
Message-ID: <2025081305-surround-manliness-8871@gregkh>
References: <20250812173419.303046420@linuxfoundation.org>
 <20250812173450.953470487@linuxfoundation.org>
 <73f6a64b-89b5-412a-94d7-07cdfa07cfb5@prolan.hu>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <73f6a64b-89b5-412a-94d7-07cdfa07cfb5@prolan.hu>

On Tue, Aug 12, 2025 at 10:22:59PM +0200, Csókás Bence wrote:
> Hi,
> 
> On 2025. 08. 12. 19:33, Greg Kroah-Hartman wrote:
> > 6.16-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Bence Csókás <csokas.bence@prolan.hu>
> > 
> > [ Upstream commit 3b98c9352511db627b606477fc7944b2fa53a165 ]
> > 
> > Commit bafbdd527d56 ("phylib: Add device reset GPIO support") removed
> > devm_gpiod_get_optional() in favor of the non-devres managed
> > fwnode_get_named_gpiod(). When it was kind-of reverted by commit
> > 40ba6a12a548 ("net: mdio: switch to using gpiod_get_optional()"), the devm
> > functionality was not reinstated. Nor was the GPIO unclaimed on device
> > remove. This leads to the GPIO being claimed indefinitely, even when the
> > device and/or the driver gets removed.
> > 
> > Fixes: bafbdd527d56 ("phylib: Add device reset GPIO support")
> > Fixes: 40ba6a12a548 ("net: mdio: switch to using gpiod_get_optional()")
> > Cc: Csaba Buday <buday.csaba@prolan.hu>
> > Signed-off-by: Bence Csókás <csokas.bence@prolan.hu>
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > Link: https://patch.msgid.link/20250728153455.47190-2-csokas.bence@prolan.hu
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> This was reverted and replaced by:
> https://git.kernel.org/netdev/net/c/8ea25274ebaf

That's not in Linus's tree yet, so I can't take it :(

So I'll just drop this commit for now, thanks.

greg k-h
