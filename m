Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8B425B1E2;
	Thu,  1 May 2025 08:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746086451; cv=none; b=ENtAREaFv9C33demhpupB+tezil8zsOURtp2hg52djEv0G3L/hMNI5vTLnfvuI7RG+zlFPdoMncnx9JB2bk0+pIONdr931KA50Jt9WxF53lPMopFZmh8GUGL35YdpfTT9T7ExrANJDm1mqIMLf2A0KaWmyObRUCTgGBEABnX5L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746086451; c=relaxed/simple;
	bh=pTNtLy9iWiiWule0FiNE66wyiC9Hlc5hYY4+vRE+U18=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VzCYhWr53hu9gpEpi5u/zzuVOHVNkCj3SEewf4FVOAHkpXZDjRFrMYyslqygP/nYO/B9w8qq+gwIFbj1/seFRfQJMbRJ4UlzEjl0a4NLL/7mP65dQhR5KKQ37sznacleSu77QatHQyWe1wiJReYiXsC451WpfSQzo1fdVtqZQBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lo2/oL26; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lo2/oL26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CD4C4CEE3;
	Thu,  1 May 2025 08:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746086450;
	bh=pTNtLy9iWiiWule0FiNE66wyiC9Hlc5hYY4+vRE+U18=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lo2/oL26tK27Yn0OqdG2IrwmYZMzfsxhnwD/FZA4G13wKzDlkH1uvyXmChfUzMgpG
	 pvMewQKiqpOqq9kQkoNG1HKLdOgcn0QrSrlTnTw3Km4uxLGNcr7t3oPmJSZnxnNBgx
	 8ubHiYieQqw27xrNxVvYU/BedzYFIi/VOhp2ts8g=
Date: Thu, 1 May 2025 10:00:47 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel Golle <daniel@makrotopia.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	"Chester A. Unal" <chester.a.unal@arinc9.com>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 294/373] net: dsa: mt7530: sync driver-specific
 behavior of MT7531 variants
Message-ID: <2025050134-freestyle-delirious-fffe@gregkh>
References: <20250429161123.119104857@linuxfoundation.org>
 <20250429161135.207985097@linuxfoundation.org>
 <aBEbqsJhVNaLh82G@makrotopia.org>
 <aBGN0w1Wp1PRfPWn@makrotopia.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBGN0w1Wp1PRfPWn@makrotopia.org>

On Wed, Apr 30, 2025 at 03:41:23AM +0100, Daniel Golle wrote:
> Hi again,
> 
> On Tue, Apr 29, 2025 at 07:34:21PM +0100, Daniel Golle wrote:
> > On Tue, Apr 29, 2025 at 06:42:51PM +0200, Greg Kroah-Hartman wrote:
> > > 5.15-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Daniel Golle <daniel@makrotopia.org>
> > > 
> > > [ Upstream commit 497041d763016c2e8314d2f6a329a9b77c3797ca ]
> > > 
> > > MT7531 standalone and MMIO variants found in MT7988 and EN7581 share
> > > most basic properties. Despite that, assisted_learning_on_cpu_port and
> > > mtu_enforcement_ingress were only applied for MT7531 but not for MT7988
> > > or EN7581, causing the expected issues on MMIO devices.
> > > 
> > > Apply both settings equally also for MT7988 and EN7581 by moving both
> > > assignments form mt7531_setup() to mt7531_setup_common().
> > > 
> > > This fixes unwanted flooding of packets due to unknown unicast
> > > during DA lookup, as well as issues with heterogenous MTU settings.
> > > 
> > > Fixes: 7f54cc9772ce ("net: dsa: mt7530: split-off common parts from mt7531_setup")
> > 
> > The commit 7f54cc9772ce ("net: dsa: mt7530: split-off common parts from
> > mt7531_setup") is only present since v6.4 so backport to 5.15 and 6.1
> > doesn't make sense
> 
> I should have actually checked and only now noticed that 7f54cc9772ce
> ("net: dsa: mt7530: split-off common parts from mt7531_setup") has been
> picked to stable kernels down to Linux 5.15.
> 
> However, the bug only affects MMIO variants of the switch which are
> supported since commit 110c18bfed414 ("net: dsa: mt7530: introduce
> driver for MT7988 built-in switch"), and that is present only since
> Linux 6.6.
> 
> Sorry about the confusion, I should have probably chosen that commit in
> the Fixes: tag despite the original mistake was introduced in commit
> 7f54cc9772ce ("net: dsa: mt7530: split-off common parts from
> mt7531_setup").
> 

Thanks for the info, I've dropped this from the 5.15.y and 6.1.y queues
now.

greg k-h
