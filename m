Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820A71A9F9B;
	Mon, 13 Oct 2025 21:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760390210; cv=none; b=HAb/2q2Jg7BTjkmvkgyU6miWkYHPHGbyf7yzrm72FB6t/zdlJUqRqmG3YsIOywfnMhDnnA/cthEPArj9KCCAiZInlRbeEtjW3Wb3NxIL53RkiV5TYbVptSJORmXr9jJSSo7mbXix71k6fDEFSLIMDl9jU1PoXkvYrW1DFewcYwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760390210; c=relaxed/simple;
	bh=YZTcR6Frhh1tL4uhDqTV7X9j8XQL569lYi9mClkyuJU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=H6ys/zE0A7OuSMQDvWD8cxkbYg9ACoQpyXEbPDpIKkSY5OTTFwZ0DlTuYldWVDd90pfTMKajw8ujT1VwP3cH1LTHmPU99fFFkhRg0wa8hkiknizTWN477ZEfA6GHs7a9GJlpOOI7hNpv9UcLjrWUkvEG6SLhGXcqQT1JSISynzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dJGpzaO/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dJGpzaO/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4098C4CEE7;
	Mon, 13 Oct 2025 21:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760390210;
	bh=YZTcR6Frhh1tL4uhDqTV7X9j8XQL569lYi9mClkyuJU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=dJGpzaO/brVvHWxo2sp9cjZZ2GIotA5Inp+D8bNi6575pld9Q7b3gtM/OkiKAs9nT
	 jukpxudYmCSV2AiyfTUsay4O5wtlzX7q15i9MCKN0AyKI+RcKB/OdNNVT/1kIVht55
	 SzVFBiXIn6pTB27Mx2ARt5rhXHv8fMyfqVcBkc6o98HlV3T5mO1S+c8hD0a19pmP/f
	 9XvMxO1GLMgMgthOTjzCDpg6CMWzcq7jDFS2kjXqbuszCx5yoofhtfMUfmTTSyhJ3k
	 mfhrS6Ye32WBhtVPtlSf9LMlun/zX8t8Lw0PQR6zXe/FNABTx9MgemhG11fqfjjIAv
	 LL9m5+5hGwcSQ==
Date: Mon, 13 Oct 2025 16:16:48 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Inochi Amaoto <inochiama@gmail.com>,
	Chen Wang <unicorn_wang@outlook.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>, Kenneth Crudup <kenny@panix.com>,
	Genes Lists <lists@sapience.com>, Jens Axboe <axboe@kernel.dk>,
	Todd Brandt <todd.e.brandt@intel.com>
Subject: Re: [PATCH 6.17 068/563] PCI/MSI: Add startup/shutdown for per
 device domains
Message-ID: <20251013211648.GA864848@bhelgaas>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013144413.753811471@linuxfoundation.org>

[+cc Kenny, Gene, Jens, Todd]

On Mon, Oct 13, 2025 at 04:38:49PM +0200, Greg Kroah-Hartman wrote:
> 6.17-stable review patch.  If anyone has any objections, please let me know.

We have open regression reports about this, so I don't think we
should backport it yet:

  https://lore.kernel.org/r/af5f1790-c3b3-4f43-97d5-759d43e09c7b@panix.com

> ------------------
> 
> From: Inochi Amaoto <inochiama@gmail.com>
> 
> [ Upstream commit 54f45a30c0d0153d2be091ba2d683ab6db6d1d5b ]
> 
> As the RISC-V PLIC cannot apply affinity settings without invoking
> irq_enable(), it will make the interrupt unavailble when used as an
> underlying interrupt chip for the MSI controller.
> 
> Implement the irq_startup() and irq_shutdown() callbacks for the PCI MSI
> and MSI-X templates.
> 
> For chips that specify MSI_FLAG_PCI_MSI_STARTUP_PARENT, the parent startup
> and shutdown functions are invoked. That allows the interrupt on the parent
> chip to be enabled if the interrupt has not been enabled during
> allocation. This is necessary for MSI controllers which use PLIC as
> underlying parent interrupt chip.
> 
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Inochi Amaoto <inochiama@gmail.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Tested-by: Chen Wang <unicorn_wang@outlook.com> # Pioneerbox
> Reviewed-by: Chen Wang <unicorn_wang@outlook.com>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> Link: https://lore.kernel.org/all/20250813232835.43458-3-inochiama@gmail.com
> Stable-dep-of: 9d8c41816bac ("irqchip/sg2042-msi: Fix broken affinity setting")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/pci/msi/irqdomain.c | 52 +++++++++++++++++++++++++++++++++++++
>  include/linux/msi.h         |  2 ++
>  2 files changed, 54 insertions(+)
> 
> diff --git a/drivers/pci/msi/irqdomain.c b/drivers/pci/msi/irqdomain.c
> index 0938ef7ebabf2..e0a800f918e81 100644
> --- a/drivers/pci/msi/irqdomain.c
> +++ b/drivers/pci/msi/irqdomain.c
> @@ -148,6 +148,23 @@ static void pci_device_domain_set_desc(msi_alloc_info_t *arg, struct msi_desc *d
>  	arg->hwirq = desc->msi_index;
>  }
>  
> +static void cond_shutdown_parent(struct irq_data *data)
> +{
> +	struct msi_domain_info *info = data->domain->host_data;
> +
> +	if (unlikely(info->flags & MSI_FLAG_PCI_MSI_STARTUP_PARENT))
> +		irq_chip_shutdown_parent(data);
> +}
> +
> +static unsigned int cond_startup_parent(struct irq_data *data)
> +{
> +	struct msi_domain_info *info = data->domain->host_data;
> +
> +	if (unlikely(info->flags & MSI_FLAG_PCI_MSI_STARTUP_PARENT))
> +		return irq_chip_startup_parent(data);
> +	return 0;
> +}
> +
>  static __always_inline void cond_mask_parent(struct irq_data *data)
>  {
>  	struct msi_domain_info *info = data->domain->host_data;
> @@ -164,6 +181,23 @@ static __always_inline void cond_unmask_parent(struct irq_data *data)
>  		irq_chip_unmask_parent(data);
>  }
>  
> +static void pci_irq_shutdown_msi(struct irq_data *data)
> +{
> +	struct msi_desc *desc = irq_data_get_msi_desc(data);
> +
> +	pci_msi_mask(desc, BIT(data->irq - desc->irq));
> +	cond_shutdown_parent(data);
> +}
> +
> +static unsigned int pci_irq_startup_msi(struct irq_data *data)
> +{
> +	struct msi_desc *desc = irq_data_get_msi_desc(data);
> +	unsigned int ret = cond_startup_parent(data);
> +
> +	pci_msi_unmask(desc, BIT(data->irq - desc->irq));
> +	return ret;
> +}
> +
>  static void pci_irq_mask_msi(struct irq_data *data)
>  {
>  	struct msi_desc *desc = irq_data_get_msi_desc(data);
> @@ -194,6 +228,8 @@ static void pci_irq_unmask_msi(struct irq_data *data)
>  static const struct msi_domain_template pci_msi_template = {
>  	.chip = {
>  		.name			= "PCI-MSI",
> +		.irq_startup		= pci_irq_startup_msi,
> +		.irq_shutdown		= pci_irq_shutdown_msi,
>  		.irq_mask		= pci_irq_mask_msi,
>  		.irq_unmask		= pci_irq_unmask_msi,
>  		.irq_write_msi_msg	= pci_msi_domain_write_msg,
> @@ -210,6 +246,20 @@ static const struct msi_domain_template pci_msi_template = {
>  	},
>  };
>  
> +static void pci_irq_shutdown_msix(struct irq_data *data)
> +{
> +	pci_msix_mask(irq_data_get_msi_desc(data));
> +	cond_shutdown_parent(data);
> +}
> +
> +static unsigned int pci_irq_startup_msix(struct irq_data *data)
> +{
> +	unsigned int ret = cond_startup_parent(data);
> +
> +	pci_msix_unmask(irq_data_get_msi_desc(data));
> +	return ret;
> +}
> +
>  static void pci_irq_mask_msix(struct irq_data *data)
>  {
>  	pci_msix_mask(irq_data_get_msi_desc(data));
> @@ -234,6 +284,8 @@ EXPORT_SYMBOL_GPL(pci_msix_prepare_desc);
>  static const struct msi_domain_template pci_msix_template = {
>  	.chip = {
>  		.name			= "PCI-MSIX",
> +		.irq_startup		= pci_irq_startup_msix,
> +		.irq_shutdown		= pci_irq_shutdown_msix,
>  		.irq_mask		= pci_irq_mask_msix,
>  		.irq_unmask		= pci_irq_unmask_msix,
>  		.irq_write_msi_msg	= pci_msi_domain_write_msg,
> diff --git a/include/linux/msi.h b/include/linux/msi.h
> index e5e86a8529fb6..3111ba95fbde4 100644
> --- a/include/linux/msi.h
> +++ b/include/linux/msi.h
> @@ -568,6 +568,8 @@ enum {
>  	MSI_FLAG_PARENT_PM_DEV		= (1 << 8),
>  	/* Support for parent mask/unmask */
>  	MSI_FLAG_PCI_MSI_MASK_PARENT	= (1 << 9),
> +	/* Support for parent startup/shutdown */
> +	MSI_FLAG_PCI_MSI_STARTUP_PARENT	= (1 << 10),
>  
>  	/* Mask for the generic functionality */
>  	MSI_GENERIC_FLAGS_MASK		= GENMASK(15, 0),
> -- 
> 2.51.0
> 
> 
> 
