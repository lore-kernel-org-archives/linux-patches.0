Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFE135E940;
	Thu, 25 Jun 2026 14:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782396495; cv=none; b=GzT1LOrqkTn/DXAZwHVJ+R6KRBXurhiNnW8fgSFM/2az8Ikck3shCAd2k33i/o6AkO7ZD6iIhD+cpNqHQ6wiibkrk+KkgtW1jFTaTSfroZCr8OOKqZkF3SjJ77UWSkcz0PttO08lL4m/tc++BV9M6xQQCyLyATEdLrW5N+THE38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782396495; c=relaxed/simple;
	bh=VadflMrV5Y5GiavVRO4d679hafrETVACnjzeOE97MAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QDKAQgbftivDb8y9I3dy9TiBurrAbw9GpwosNS37hdO8MtRASLGOCwYkqGDjMGz0aU+4irKpCsfIbbmnvawEvO4ZFJkSnn9kuC9M45tHaIs3sVPZ5qPFpCW3eVcz4RSpa6aCclE8044H56Qeb54NJ9eo7+ajiXCOSuddvo/ZTAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XYbA13Tl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XYbA13Tl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8BC1F000E9;
	Thu, 25 Jun 2026 14:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782396493;
	bh=4EXQWfdtBSMC0qZpTbidaAuKZ+eg07thHjIW5SaTkgI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XYbA13TlUVzjdNRF9AXi8VlZ0vLfOTsCeRZ953JWJ+LMVWU13vJYpCrAaekMEgu2q
	 +YPS1muiT3nBuvDGV597M51b9Ejwq4Tekrfl0pLXt5uzRggBS9A8K3JM99vZZ9Q05f
	 yU0oKGNE7RkTqW1pBFUOeyuuTrv7RqEPPybKleDB3+pknZra0UQ3TgbPTVbmt+qxUa
	 br11zfn3XLybPSq3JpHdpDYll+wUAYzhSqzv3tzWqMkshcS/7FFUdrAMT2N4UHkvDc
	 W5rgwW+zgk/we44UpkL2ZkbfAT3slqG62QOT1uLAvCcbr6Pk1aiRztrR6rnYJZCNi/
	 pLycM2U6Bs2Jg==
Received: from johan by xi.lan with local (Exim 4.99.3)
	(envelope-from <johan@kernel.org>)
	id 1wckkV-00000002SAt-0rM1;
	Thu, 25 Jun 2026 16:08:11 +0200
Date: Thu, 25 Jun 2026 16:08:11 +0200
From: Johan Hovold <johan@kernel.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev,
	Masayuki Ohtake <masa-korg@dsn.okisemi.com>,
	Ramanan Govindarajan <ramanan.govindarajan@oracle.com>,
	Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH 5.15 323/411] spi: topcliff-pch: fix controller
 deregistration
Message-ID: <aj02Sx14nrwc--Uo@hovoldconsulting.com>
References: <20260616145100.376842714@linuxfoundation.org>
 <20260616145118.324999322@linuxfoundation.org>
 <d23a21f0-95dd-4e0c-845e-2a54c50f44eb@oracle.com>
 <ajpLCYZ3eQm5p64L@hovoldconsulting.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajpLCYZ3eQm5p64L@hovoldconsulting.com>

On Tue, Jun 23, 2026 at 10:59:53AM +0200, Johan Hovold wrote:
> On Fri, Jun 19, 2026 at 06:08:40PM +0530, Harshit Mogalapalli wrote:
> > On 16/06/26 20:29, Greg Kroah-Hartman wrote:
> > > 5.15-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Johan Hovold <johan@kernel.org>
> > > 
> > > [ Upstream commit 5d6f477d6fc0767c57c5e1e6f55a1662820eef87 ]
> > > 
> > > Make sure to deregister the controller before disabling and releasing
> > > underlying resources like interrupts and DMA during driver unbind.

> > I think for 5.15.y we should fix the backport by moving spi_master_get() 
> > and spi_unregister_master() before the local queue/resource/IRQ teardown 
> > in pch_spi_pd_remove(), thoughts?
> 
> I agree, this backport looks wrong.
> 
> This is probably an effect of
> 
> 	9d72732fe70c ("spi: topcliff-pch: fix use-after-free on unbind")
> 
> being backported before
> 
> 	9d72732fe70c ("spi: topcliff-pch: fix use-after-free on unbind")

This was supposed to say

	5d6f477d6fc0 ("spi: topcliff-pch: fix controller deregistration")

of course...
 
> due to the latter first failing to apply because of the SPI API rename.

Johan
