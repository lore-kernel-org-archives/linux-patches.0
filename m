Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D39B345753;
	Tue, 20 Jan 2026 18:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768932516; cv=none; b=LeRV7lBE7FB8effkozs2peFU6gNMB/mA2gHmZWBG4VUg91wwPRlcfbqM94ac9PsE0p5m9N//BBlExA+HuD0nil+p++rRHhJcotzHAvN0lxMwFuwGorIVJwtKEbNzzt+fWgp2sCRf8pyRnHqnZ8JKOMuG2m7Mr2FwF41zVGjTxq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768932516; c=relaxed/simple;
	bh=iPeLQUClZ+MDpbXM0eSkRUGIDQYyAShv0zDvLJ34TzA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pqQtESSASS1t1bP7NjT2/RUU9VSOrL33GlEYrWg/+qYYusExLQtsAl8WNl2MdpXxlQ9FrcuaYRjVZ1vrF7RkqGmOFex35UCm8xeq/90J0uw6nRI0Qs6Z56z4nKZa83hEXGyXWiSMPKkz4a57i2REAyeU4CTKilStdp1lyt/GqXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eaen7DRr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eaen7DRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16257C19421;
	Tue, 20 Jan 2026 18:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768932515;
	bh=iPeLQUClZ+MDpbXM0eSkRUGIDQYyAShv0zDvLJ34TzA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eaen7DRrJQ4BuE/5XfK+2pvuk1wxn8S7+PK/HopD8haSQ4wc6ROsSepDIcG0Ya/xl
	 WsiJN/in+saOwaV4vxNfkXDKX8vDNC7iJBXc5QpF91qbomrRhw4izBELY7HQtYGPmO
	 LbqLeZ4YRedpUqptV7WGi451y+rRBxFKXY/oZ5KfTCzTNGviHusZI2N7Y3+3MjDnXm
	 j19tGlM0nag5TpJsriaMYCclT6NwFryGO4GGrvzl2zKMJYSiDJ7ZvO7EUCnxCWjV8D
	 02q3IogQYGB2V5S/bKCI/BZgdKp8nztOpzXUayrFfB1x9Pjot3omS5D52bLND+9h5c
	 P3z5e387X7dzg==
Date: Tue, 20 Jan 2026 11:08:33 -0700
From: Keith Busch <kbusch@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Donald Dutile <ddutile@redhat.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH v3 10/11] PCI: Check ACS DSP/USP redirect bits in
 pci_enable_pasid()
Message-ID: <aW_EoTarUr6LEZgy@kbusch-mbp>
References: <0-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
 <10-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>

On Fri, Sep 05, 2025 at 03:06:25PM -0300, Jason Gunthorpe wrote:
> +static u16 pci_acs_ctrl_mask(struct pci_dev *pdev, u16 hw_cap)
> +{
> +	/*
> +	 * Egress Control enables use of the Egress Control Vector which is not
> +	 * present without the cap.
> +	 */
> +	u16 mask = PCI_ACS_EC;
> +
> +	mask = hw_cap & (PCI_ACS_SV | PCI_ACS_TB | PCI_ACS_RR |
> +				      PCI_ACS_CR | PCI_ACS_UF | PCI_ACS_DT);

I think you intended "mask |=", otherwise the initialization to
PCI_ACS_EC doesn't make sense.
