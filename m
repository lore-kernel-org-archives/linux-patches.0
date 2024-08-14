Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2601B32D1;
	Wed, 14 Aug 2024 11:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723635578; cv=none; b=TYpG8Zz5b6y+qa21y6EYM3NPeTbTs7Rw8mBIlpenMlCCnc+EOc3sZ2nMhXLj2wz6qUOMNAeDdIKFVoF9TTb/xYwptbGjl+naKukqJ93jI4ym3u5H5rk+rhQ7JNf+vooZ8EtiEdCUuTSvEWLUsBUnyARVMwDWrQ7pn1rTN7rS0xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723635578; c=relaxed/simple;
	bh=vtH2DCyrfUoe5tu/jyFyQOHn6xoBWrlDJdmP2Jh98gA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vCGdLrZeq5yzENfkBsa6N++A9vFzY2PNAho00V8IPCVnRZi1ej58sYgSsPzh+tjUk9hy2uvhqCzQaAC4rmJ3Q3mycV6oi1ouQVo5i70/CmCXfZ6u7L/jX0Dn1W633pJhYEeBYeFt/IGuZR00ZQTB7J2l/zkEp3R855femPGeG7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L5MM9oBg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5MM9oBg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675EEC4AF10;
	Wed, 14 Aug 2024 11:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723635577;
	bh=vtH2DCyrfUoe5tu/jyFyQOHn6xoBWrlDJdmP2Jh98gA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L5MM9oBg45QC4y6WD4cx5+bOLIi68w4G5yClg1V2kGsRmdetZqHOgH+CuziNINyg1
	 CGGI08h13wb4uNtotuXDJ2n80LQhMIarFXwwc4FaJ+/X7IGTB70Jh9DA2oQmHYOfV4
	 GW5B3rlHllvxSsTwGPo9T7vCmDragJ/Td5hibjVw=
Date: Wed, 14 Aug 2024 13:39:35 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kevin Holm <kevin@holm.dev>
Cc: "Lin, Wayne" <Wayne.Lin@amd.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Limonciello, Mario" <Mario.Limonciello@amd.com>,
	"Deucher, Alexander" <Alexander.Deucher@amd.com>,
	"Wu, Hersen" <hersenxs.wu@amd.com>,
	"Wheeler, Daniel" <Daniel.Wheeler@amd.com>
Subject: Re: [PATCH 6.10 257/263] drm/amd/display: Defer handling mst up
 request in resume
Message-ID: <2024081409-outsell-delay-5031@gregkh>
References: <20240812160146.517184156@linuxfoundation.org>
 <20240812160156.489958533@linuxfoundation.org>
 <235aa62e-271e-4e2b-b308-e29b561d6419@holm.dev>
 <2024081345-eggnog-unease-7b3c@gregkh>
 <CO6PR12MB5489A767C7E0B1CFAEB069A0FC862@CO6PR12MB5489.namprd12.prod.outlook.com>
 <2024081317-penniless-gondola-2c07@gregkh>
 <12516acf-bee6-4371-a745-8f9e221bc657@holm.dev>
 <2d48c3c0-286d-4ed7-a3b6-5b4742b0e9d1@holm.dev>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d48c3c0-286d-4ed7-a3b6-5b4742b0e9d1@holm.dev>

On Wed, Aug 14, 2024 at 09:43:23AM +0200, Kevin Holm wrote:
> On 8/13/24 21:54, Kevin Holm wrote:
> > On 13.08.24 17:26, Greg Kroah-Hartman wrote:
> >  > On Tue, Aug 13, 2024 at 02:41:34PM +0000, Lin, Wayne wrote:
> >  >> [AMD Official Use Only - AMD Internal Distribution Only]
> >  >>
> >  >> Hi Greg and Kevin,
> >  >>
> >  >> Sorry for inconvenience, but this one should be reverted by another
> > backport patch:
> >  >> "drm/amd/display: Solve mst monitors blank out problem after resume"
> >  >
> >  > What commit id in Linus's tree is that?
> > 
> >  From what I can tell it's:
> > e33697141bac18 ("drm/amd/display: Solve mst monitors blank out problem
> > after resume")
> > 
> > You've send out a message that it failed to apply to a few of the stable trees:
> > - 6.10: https://lore.kernel.org/stable/2024081212-vitally-baked-7f93@gregkh/
> > - 6.6 : https://lore.kernel.org/stable/2024081213-roast-humorless-fd20@gregkh/
> > - 6.1 : https://lore.kernel.org/stable/2024081213-sweep-hungry-2d10@gregkh/
> > 
> > To apply it on top of 6.10.5-rc1 these two patches need to be applied first:
> > f63f86b5affcc2 ("drm/amd/display: Separate setting and programming of cursor")
> > 1ff6631baeb1f5 ("drm/amd/display: Prevent IPX From Link Detect and Set Mode")
> > 
> > I don't know if that solves the problem I initially described as I'm currently
> > on a different setup. What I can say is that it applying those three patches on
> 
> Applying the three patches I listed above, fixes the problem for my setup. My
> external 4k monitors now get a signal both on boot and when resuming from sleep.

Thanks for the report, I'll drop this commit for now from the trees and
then add back all of them for the next round of -rc releases for people
to test.

greg k-h
