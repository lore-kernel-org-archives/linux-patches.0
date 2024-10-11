Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545A41C6F45;
	Fri, 11 Oct 2024 03:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728616811; cv=none; b=YrS2FGIuI09DZXXi0JTJP7oEmIdI8DweZXjRbZqTcWFfUmQIF+nS7hULEYPgvWGyriaXAmONHA9XwxX/v5c9LnC8sNLncBIn2pl48o6wWA66inhDzASfYgus1jGudXexX/CpxJfjqYcKwsai16UlIal+ruwTADUtQVow+bSHg38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728616811; c=relaxed/simple;
	bh=lEctRmfjjcNQmqS5QoKjxTuZy2C8mA9FeD0H6fQ9f3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NELqZxhSc4xMc9DXOHVpHInecAaRAvmyILKvoypiN6YsmUp8H+p6UNz49PewTihW1q6kYBqOXPpPRb9sECHBnlyJ5IYT/BSGmz/39Bp7NoV/7yGyZSWcUomzSQE5uZtg1g7jLDqgzojFdHAYFgPJsMr/ViaJ88b29eswp0haS7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HDk9Scza; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HDk9Scza"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D93C4CEC3;
	Fri, 11 Oct 2024 03:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728616810;
	bh=lEctRmfjjcNQmqS5QoKjxTuZy2C8mA9FeD0H6fQ9f3Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HDk9Sczapv3qhXj+fUbk0t5Qg2aNLXTefGAGW4QCSgV/FXie7VoNwk498Ks1jDqsP
	 AOkox7R2gDpcjD5TNKDFT9k4Rra1pFvuS9bMsclpQZzj4OSnP6EiNkaxJ7ujn2/7ac
	 0Lvbs+/bUM2T8mlcMuW4Tmkrj6fuFky7ONC7p03M=
Date: Fri, 11 Oct 2024 05:20:07 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Wei Fang <wei.fang@nxp.com>
Cc: =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Paolo Abeni <pabeni@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 028/386] net: fec: Restart PPS after link state change
Message-ID: <2024101158-amid-unselfish-8bd7@gregkh>
References: <20241008115629.309157387@linuxfoundation.org>
 <20241008115630.584472371@linuxfoundation.org>
 <1af647ce-69e4-4f86-b0a5-6ac76ec25d12@prolan.hu>
 <2024101033-primate-hacking-6d3c@gregkh>
 <PAXPR04MB8510F6DD068CE335D6D7202188792@PAXPR04MB8510.eurprd04.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <PAXPR04MB8510F6DD068CE335D6D7202188792@PAXPR04MB8510.eurprd04.prod.outlook.com>

On Fri, Oct 11, 2024 at 01:50:58AM +0000, Wei Fang wrote:
> > -----Original Message-----
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Sent: 2024年10月10日 17:58
> > To: Csókás Bence <csokas.bence@prolan.hu>
> > Cc: stable@vger.kernel.org; patches@lists.linux.dev; Paolo Abeni
> > <pabeni@redhat.com>; Sasha Levin <sashal@kernel.org>; Wei Fang
> > <wei.fang@nxp.com>
> > Subject: Re: [PATCH 6.6 028/386] net: fec: Restart PPS after link state change
> > 
> > On Tue, Oct 08, 2024 at 03:30:51PM +0200, Csókás Bence wrote:
> > > Hi!
> > >
> > > On 2024. 10. 08. 14:04, Greg Kroah-Hartman wrote:
> > > > 6.6-stable review patch.  If anyone has any objections, please let me know.
> > > >
> > > > ------------------
> > > >
> > > > From: Csókás, Bence <csokas.bence@prolan.hu>
> > > >
> > > > [ Upstream commit a1477dc87dc4996dcf65a4893d4e2c3a6b593002 ]
> > > >
> > > > On link state change, the controller gets reset, causing PPS to drop
> > > > out. Re-enable PPS if it was enabled before the controller reset.
> > > >
> > > > Fixes: 6605b730c061 ("FEC: Add time stamping code and a PTP hardware
> > > > clock")
> > > > Signed-off-by: Csókás, Bence <csokas.bence@prolan.hu>
> > > > Link:
> > > > https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fpa
> > > >
> > tch.msgid.link%2F20240924093705.2897329-1-csokas.bence%40prolan.hu&d
> > > >
> > ata=05%7C02%7Cwei.fang%40nxp.com%7C80acbc9bb01544f3e84808dce912
> > 01e0%
> > > >
> > 7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C6386415107715770
> > 46%7CUn
> > > >
> > known%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik
> > 1h
> > > >
> > aWwiLCJXVCI6Mn0%3D%7C0%7C%7C%7C&sdata=sQygTTDEvCmMBFcgolXp13
> > 8w4XkG3J
> > > > e0d5rPLnDrhwM%3D&reserved=0
> > > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > >
> > > There is a patch waiting to be merged that Fixes: this commit.
> > >
> > > Link:
> > > https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore
> > > .kernel.org%2Fnetdev%2F20241008061153.1977930-1-wei.fang%40nxp.co
> > m%2F&
> > >
> > data=05%7C02%7Cwei.fang%40nxp.com%7C80acbc9bb01544f3e84808dce91
> > 201e0%7
> > >
> > C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C63864151077160040
> > 3%7CUnkno
> > >
> > wn%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1ha
> > WwiL
> > >
> > CJXVCI6Mn0%3D%7C0%7C%7C%7C&sdata=7IXriaU8I%2BO%2F2rxZueqJtf%2B
> > VyF4ZQIR
> > > PNZvnKMpuctk%3D&reserved=0
> > 
> > Great, we can pick it up once it hits Linus's tree, please let us know when that
> > happens.
> > 
> 
> Hi Greg,
> 
> The patch has been applied to Linus's tree, thanks.

What is the git id of the commit?
