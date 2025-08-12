Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46611531E8;
	Tue, 12 Aug 2025 13:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755004011; cv=none; b=AZH00qLsgxFTVFQdzBDd+OUEFfRFf02hxNeHiRaV8eqvJYs6F6RrmhXFvPID5fwRHbZV41Y1uSEqAjYOJ7B1QorjweDhhXwt7jCkL21v8OQmw2ohucg1hd3ENYYbxAwXW43C80XGCZG7YwIit37wP3bxMWI/SzMbtUOBiFK93EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755004011; c=relaxed/simple;
	bh=kgcdZRlgzMs6r2fHQPsEJ3bWbY/Y1L0QseyEFWl+2rE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JPh5IJ7j9BWr8lGJxrGdsAOZd4BzJTAvPH5yET/IK1Vej+tx1dthIsYaVjkJuPd7+5J5BzKSsLJ4Z1DWLQTQtM2Ebz9FDnpW1DfsR0Bc8mNLt40ZZo5nbmv94FDGwQzltpP9JWgyMPWFVkXsAwSw9akkIXLVwRma54lipkM644U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jnCiiRUn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jnCiiRUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C80C4CEF0;
	Tue, 12 Aug 2025 13:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755004010;
	bh=kgcdZRlgzMs6r2fHQPsEJ3bWbY/Y1L0QseyEFWl+2rE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jnCiiRUnryd0zHRPHwaoptE+p9429pB1BJ4W4ppiGk2pKejMyLYDBI8d/l7HxASiZ
	 rff4PlFYvZWMaWByz3tLj0ROSnJsf5dcwb1QmRO9bO8vFa3Kzu1oBeaPjebM8aNrH5
	 rAoTGLtuTI2Mf3Am/vBFwOtTZ68TQ0hKvZ0nfivI=
Date: Tue, 12 Aug 2025 15:06:47 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Jian-Hong Pan <jhp@endlessos.org>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 6.13 445/623] PCI/ASPM: Save parent L1SS config in
 pci_save_aspm_l1ss_state()
Message-ID: <2025081241-reverence-margarine-76dd@gregkh>
References: <20250205134456.221272033@linuxfoundation.org>
 <20250205134513.241757556@linuxfoundation.org>
 <7a41907d-14d0-a1a4-47d6-90ff572d5af9@linux.intel.com>
 <2025020621-remindful-occultist-b433@gregkh>
 <aIpPWZ5eS1gEeAwm@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aIpPWZ5eS1gEeAwm@google.com>

On Wed, Jul 30, 2025 at 09:59:05AM -0700, Brian Norris wrote:
> Hello,
> 
> On Thu, Feb 06, 2025 at 03:29:35PM +0100, Greg Kroah-Hartman wrote:
> > On Thu, Feb 06, 2025 at 11:00:18AM +0200, Ilpo Järvinen wrote:
> > > On Wed, 5 Feb 2025, Greg Kroah-Hartman wrote:
> > > 
> > > > 6.13-stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: Jian-Hong Pan <jhp@endlessos.org>
> > > > 
> > > > [ Upstream commit 1db806ec06b7c6e08e8af57088da067963ddf117 ]
> > > > 
> > > > After 17423360a27a ("PCI/ASPM: Save L1 PM Substates Capability for
> > > > suspend/resume"), pci_save_aspm_l1ss_state(dev) saves the L1SS state for
> > > > "dev", and pci_restore_aspm_l1ss_state(dev) restores the state for both
> > > > "dev" and its parent.
> [...]
> > > Please withhold this commit from stable until its fix ("PCI/ASPM: Fix L1SS 
> > > saving") can be pushed at the same as having this commit alone can causes 
> > > PCIe devices to becomes unavailable and hang the system during PM 
> > > transitions.
> > > 
> > > The fix is currently in pci/for-linus as the commit c312f005dedc, but 
> > > Bjorn might add more reported-by/tested-by tags if more people hit it 
> > > before the commit makes into Linus' tree so don't expect that commit id to 
> > > be stable just yet.
> > 
> > Ok, now dropped from all stable queues, thanks for letting us know.
> 
> Any chance these can be re-included? That's:
> 
> 1db806ec06b7 ("PCI/ASPM: Save parent L1SS config in pci_save_aspm_l1ss_state()")
> 7507eb3e7bfa ("PCI/ASPM: Fix L1SS saving")
> 
> We've independently backported them into kernels we're using, but it
> seems wise to get 6.12.y, etc., back up to date.

Now queued up, thanks.

greg k-h
