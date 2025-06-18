Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62BF2E06FC;
	Wed, 18 Jun 2025 12:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750251233; cv=none; b=gxK5ujpW7pLEOApU3G2CDvm9OMG5rS+qkoctUVQcYF009tIFhOEK27+mBOPBUNWC5mAI4SIxVpWx0VYMdijKu9+RhD2mo7kr1PJx2dAN187ICvvLOxxb1M8saTocfkflcjr2DgP+AnMpv6kUJ8AARF8mHeyH6H/Pg4AT3/Y0B3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750251233; c=relaxed/simple;
	bh=r6TitXVaq9ZLwEsZ/TZ81Y/o6aCiNp3zHjUW84VyLaE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pB8gqsUjMgWsh0cknb7anOyRjBAeIKZdqpnvzUqBeMoMUtzjWGCuQ9VDKiC/3TWm+lvnvWGui9n2hUoBBvwO5Qe+IOCpEV6AyoZBO0O8ay4u4L8381UqRsMxFPxLJrDUoJ/56wrbfJ/KsnCDgLqxE1D+RamKmiAFAAbqlwMrzm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nq/jTbP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nq/jTbP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C89C4CEE7;
	Wed, 18 Jun 2025 12:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750251232;
	bh=r6TitXVaq9ZLwEsZ/TZ81Y/o6aCiNp3zHjUW84VyLaE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Nq/jTbP9vuab2XQf4r1u7zbl+WEoIcaT3zy/TcqZZn4rQi9VYoXSuIrl7KGCI4bG3
	 Qo5smXr92q5JcfcwstbLDFm6QkyoppCL5v8pzCevbfceDfDybrvmbTYNbTPKGAKlHe
	 pct7q9eagAWyOCJdxpqm9ddBfZTcEzRd2lEDwyH4=
Date: Wed, 18 Jun 2025 14:53:48 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Denis Benato <benato.denis96@gmail.com>,
	Yijun Shen <Yijun_Shen@dell.com>,
	"Perry, David" <David.Perry@amd.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 313/512] PCI: Explicitly put devices into D0 when
 initializing
Message-ID: <2025061839-browsing-frigidly-8505@gregkh>
References: <20250617152419.512865572@linuxfoundation.org>
 <20250617152432.297176178@linuxfoundation.org>
 <d031e9aa-583c-4152-9330-06dc02858e82@amd.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d031e9aa-583c-4152-9330-06dc02858e82@amd.com>

On Tue, Jun 17, 2025 at 04:53:23PM +0000, Limonciello, Mario wrote:
> On 6/17/25 10:24 AM, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Mario Limonciello <mario.limonciello@amd.com>
> > 
> > [ Upstream commit 4d4c10f763d7808fbade28d83d237411603bca05 ]
> > 
> > AMD BIOS team has root caused an issue that NVMe storage failed to come
> > back from suspend to a lack of a call to _REG when NVMe device was probed.
> > 
> > 112a7f9c8edbf ("PCI/ACPI: Call _REG when transitioning D-states") added
> > support for calling _REG when transitioning D-states, but this only works
> > if the device actually "transitions" D-states.
> > 
> > 967577b062417 ("PCI/PM: Keep runtime PM enabled for unbound PCI devices")
> > added support for runtime PM on PCI devices, but never actually
> > 'explicitly' sets the device to D0.
> > 
> > To make sure that devices are in D0 and that platform methods such as
> > _REG are called, explicitly set all devices into D0 during initialization.
> > 
> > Fixes: 967577b062417 ("PCI/PM: Keep runtime PM enabled for unbound PCI devices")
> > Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> > Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> > Tested-by: Denis Benato <benato.denis96@gmail.com>
> > Tested-By: Yijun Shen <Yijun_Shen@Dell.com>
> > Tested-By: David Perry <david.perry@amd.com>
> > Reviewed-by: Rafael J. Wysocki <rafael@kernel.org>
> > Link: https://patch.msgid.link/20250424043232.1848107-1-superm1@kernel.org
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> 
> Same comment as on 6.6:
> 
> I do think this should come back to stable, but I think we need to wait
> a stable cycle to pick it up so that it can come with this fix too.
> 
> https://lore.kernel.org/linux-pci/20250611233117.61810-1-superm1@kernel.org/

Now dropped from all queues, thanks!

greg k-h
