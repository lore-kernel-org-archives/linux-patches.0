Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A822E9EAF;
	Wed, 13 Aug 2025 07:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755071816; cv=none; b=E+gAWO3eoSohWMLHOBnHiBa3QQXIUbMV2j4c1N8624OcPfhYBHPCBEF4cfnctjELFeeAObrgMN3io3wNVs4XnDg2/KbZ+e4XOKZAEkK3S+XYrqb2VWBoZpzG5vZUcqyiXI1bttlZJ/M2lXD0Ix4ISJQTaku5GNI+wcACrBWdGco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755071816; c=relaxed/simple;
	bh=0fQGcw+pVvQoeZLk69q9ZaepCx40Bh0Ala0NYP0ZEWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LXyGfs9XoVsyEcq1CW0hz7XiXifVzYHBS7o9onKQCX3qWSyZ4pT3PCjSYjOl+gx2BzxdJYmcJ7J8XGSz54YIYJNqOOo3Hj86jTLBTU6Q/aUo58ynsJVQGEFRAa6ffSXmzLWtMKPRmOJJR2iu7QrCeeGKrSylsoLQeZK38BRaAo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dUSruBPe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dUSruBPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2CA2C4CEF8;
	Wed, 13 Aug 2025 07:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755071815;
	bh=0fQGcw+pVvQoeZLk69q9ZaepCx40Bh0Ala0NYP0ZEWo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dUSruBPe7l1+9ZY87+JZ18MGB7jjn/fVudnBn6/HcMRZZXwOLrJLZ36sYqTmJYMCV
	 gl7pnqEU5FFJqN0AeRxZJwrZl1eFfLEM+sHAQgbRNKmbTRdjGGI9BSi869DxX1GmvP
	 3ZYzzRYhcKUiyDT+Y0hrAkxPX/WpIUrGrK4huZbQ=
Date: Wed, 13 Aug 2025 09:56:52 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Csaba Buday <buday.csaba@prolan.hu>, Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.16 519/627] net: mdio_bus: Use devm for getting reset
 GPIO
Message-ID: <2025081337-reprise-angling-7cb8@gregkh>
References: <20250812173419.303046420@linuxfoundation.org>
 <20250812173450.953470487@linuxfoundation.org>
 <73f6a64b-89b5-412a-94d7-07cdfa07cfb5@prolan.hu>
 <2025081305-surround-manliness-8871@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2025081305-surround-manliness-8871@gregkh>

On Wed, Aug 13, 2025 at 09:47:38AM +0200, Greg Kroah-Hartman wrote:
> On Tue, Aug 12, 2025 at 10:22:59PM +0200, Csókás Bence wrote:
> > Hi,
> > 
> > On 2025. 08. 12. 19:33, Greg Kroah-Hartman wrote:
> > > 6.16-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Bence Csókás <csokas.bence@prolan.hu>
> > > 
> > > [ Upstream commit 3b98c9352511db627b606477fc7944b2fa53a165 ]
> > > 
> > > Commit bafbdd527d56 ("phylib: Add device reset GPIO support") removed
> > > devm_gpiod_get_optional() in favor of the non-devres managed
> > > fwnode_get_named_gpiod(). When it was kind-of reverted by commit
> > > 40ba6a12a548 ("net: mdio: switch to using gpiod_get_optional()"), the devm
> > > functionality was not reinstated. Nor was the GPIO unclaimed on device
> > > remove. This leads to the GPIO being claimed indefinitely, even when the
> > > device and/or the driver gets removed.
> > > 
> > > Fixes: bafbdd527d56 ("phylib: Add device reset GPIO support")
> > > Fixes: 40ba6a12a548 ("net: mdio: switch to using gpiod_get_optional()")
> > > Cc: Csaba Buday <buday.csaba@prolan.hu>
> > > Signed-off-by: Bence Csókás <csokas.bence@prolan.hu>
> > > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > > Link: https://patch.msgid.link/20250728153455.47190-2-csokas.bence@prolan.hu
> > > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > 
> > This was reverted and replaced by:
> > https://git.kernel.org/netdev/net/c/8ea25274ebaf
> 
> That's not in Linus's tree yet, so I can't take it :(
> 
> So I'll just drop this commit for now, thanks.

Oops, nope, we took the revert also, so all is good, I'll leave this one
in.
