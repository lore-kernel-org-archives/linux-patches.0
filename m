Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851AB23644D;
	Thu,  6 Feb 2025 14:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738852179; cv=none; b=nOgqfhXVhbxIPmn2qP6euSJMvCQtgU40yAUfxNpDfk0FBWGvPzdT7+yqQMQNd3meToq50mWAV7UoM+U4/iNtc6cRX+VhLI2ABVmf2k+m9HhsYiFOS39KxIkjUFG2usPfbRR1e7VdBG3Qrugs+4Tl0sSUwyXeJumol9OGmKuCpqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738852179; c=relaxed/simple;
	bh=HhqB0518dEx31a0sXSOA5rP7kRMteOVX6/f4/YgMIQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g594JEv1o0/DaXjGf9T2ZXEDvbPbZ6liAGgaafjuSv83RBN9ZDZOjFgmpRrqIsmjGD6/+GinBuz3JkPwiscDARDlblbgW50rHS08KZ1TfZqxC9mcGMYIC4PoUQnTzXURAAFwdq4z6DXxP5PNTgx9MjMGkWaBUtDOYRokbm+lo8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZ12E7DI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZ12E7DI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D863C4CEDD;
	Thu,  6 Feb 2025 14:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738852179;
	bh=HhqB0518dEx31a0sXSOA5rP7kRMteOVX6/f4/YgMIQg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pZ12E7DIAjfGcfoHDZU7FBE8rBHenU4xx9j2skzQ6kzNnmZLUFUw/u7SGA0gk+a3A
	 un/qNL+oU/uS3jMeidt4QXqEuAanC3SjBk6pBOISaT5AsCBWS4ifUXC+ZGdTLe1anZ
	 /hFPfTYnevV9ojEyxck5dsFocgpViS2R3PH08qpY=
Date: Thu, 6 Feb 2025 15:29:35 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Jian-Hong Pan <jhp@endlessos.org>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 6.13 445/623] PCI/ASPM: Save parent L1SS config in
 pci_save_aspm_l1ss_state()
Message-ID: <2025020621-remindful-occultist-b433@gregkh>
References: <20250205134456.221272033@linuxfoundation.org>
 <20250205134513.241757556@linuxfoundation.org>
 <7a41907d-14d0-a1a4-47d6-90ff572d5af9@linux.intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7a41907d-14d0-a1a4-47d6-90ff572d5af9@linux.intel.com>

On Thu, Feb 06, 2025 at 11:00:18AM +0200, Ilpo Järvinen wrote:
> On Wed, 5 Feb 2025, Greg Kroah-Hartman wrote:
> 
> > 6.13-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Jian-Hong Pan <jhp@endlessos.org>
> > 
> > [ Upstream commit 1db806ec06b7c6e08e8af57088da067963ddf117 ]
> > 
> > After 17423360a27a ("PCI/ASPM: Save L1 PM Substates Capability for
> > suspend/resume"), pci_save_aspm_l1ss_state(dev) saves the L1SS state for
> > "dev", and pci_restore_aspm_l1ss_state(dev) restores the state for both
> > "dev" and its parent.
> > 
> > The problem is that unless pci_save_state() has been used in some other
> > path and has already saved the parent L1SS state, we will restore junk to
> > the parent, which means the L1 Substates likely won't work correctly.
> > 
> > Save the L1SS config for both the device and its parent in
> > pci_save_aspm_l1ss_state().  When restoring, we need both because L1SS must
> > be enabled at the parent (the Downstream Port) before being enabled at the
> > child (the Upstream Port).
> > 
> > Link: https://lore.kernel.org/r/20241115072200.37509-3-jhp@endlessos.org
> > Fixes: 17423360a27a ("PCI/ASPM: Save L1 PM Substates Capability for suspend/resume")
> > Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218394
> > Suggested-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> > Signed-off-by: Jian-Hong Pan <jhp@endlessos.org>
> > [bhelgaas: parallel save/restore structure, simplify commit log, patch at
> > https://lore.kernel.org/r/20241212230340.GA3267194@bhelgaas]
> > Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> > Tested-by: Jian-Hong Pan <jhp@endlessos.org> # Asus B1400CEAE
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Hi stable maintainers,
> 
> Please withhold this commit from stable until its fix ("PCI/ASPM: Fix L1SS 
> saving") can be pushed at the same as having this commit alone can causes 
> PCIe devices to becomes unavailable and hang the system during PM 
> transitions.
> 
> The fix is currently in pci/for-linus as the commit c312f005dedc, but 
> Bjorn might add more reported-by/tested-by tags if more people hit it 
> before the commit makes into Linus' tree so don't expect that commit id to 
> be stable just yet.

Ok, now dropped from all stable queues, thanks for letting us know.

greg k-h
