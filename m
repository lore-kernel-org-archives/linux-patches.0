Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2672C80
	for <patches@lists.linux.dev>; Wed, 12 Jan 2022 16:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642006510; x=1673542510;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IiK/bQTEziksw+6B3s+yYuky+PRebRKxOWRT1b7eiTk=;
  b=fzYqh8U0/PgaGF+z6z8pS295LP96ZJOOsha2b3yd5J4xHTIapt8CxtYi
   EOtMiKw6CJ0Mws2WbgpgUfUULupcOAjdBgWi4Bdc8cH87IlsRo5fgm8lQ
   qUawIlmoqMeTZ4w7xwmyC3iLeNzguAdq0/ZML+VAPHN/q3SPQEHAdUxXF
   nWnsVwaT/vEEy8Zd7eylAkPRiAPkWhrPFpYzC09SrPhh4rI+jU2yh609z
   OKzsXkaRPzD9gH9xassp47W5lUso6GTB1eAmQsOla//2daB2Howgnidfo
   0a7dhK9iyzMnJfGRxouarRaSQz6Ut3C6jaEhZNhyWZeK3FoDL2YUktzs7
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10225"; a="231123945"
X-IronPort-AV: E=Sophos;i="5.88,282,1635231600"; 
   d="scan'208";a="231123945"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 08:54:25 -0800
X-IronPort-AV: E=Sophos;i="5.88,282,1635231600"; 
   d="scan'208";a="576607479"
Received: from jmaclean-mobl1.amr.corp.intel.com (HELO intel.com) ([10.252.136.131])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 08:54:24 -0800
Date: Wed, 12 Jan 2022 08:54:22 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, linux-nvdimm@lists.01.org,
	linux-pci@vger.kernel.org, patches@lists.linux.dev,
	Bjorn Helgaas <helgaas@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH 13/13] cxl: Program decoders for regions
Message-ID: <20220112165422.uh6zbnkvzn2d7mom@intel.com>
References: <20220107003756.806582-1-ben.widawsky@intel.com>
 <20220107003756.806582-14-ben.widawsky@intel.com>
 <20220112145328.00000194@huawei.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220112145328.00000194@huawei.com>

On 22-01-12 14:53:28, Jonathan Cameron wrote:
> On Thu,  6 Jan 2022 16:37:56 -0800
> Ben Widawsky <ben.widawsky@intel.com> wrote:
> 
> > Do the HDM decoder programming for all endpoints and host bridges in a
> > region. Switches are currently unimplemented.
> > 
> > Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> > ---
> Hi Ben,
> 
> Minor bug in the maths below that I'd missed eyeballing the registers
> because it happened to give nearly the write value for my normal test config
> by complete coincidence...
> 
> You may well have already caught this one - I've not checked your latest
> tree.
> 
> > +/**
> > + * cxl_commit_decoder() - Program a configured cxl_decoder
> > + * @cxld: The preconfigured cxl decoder.
> > + *
> > + * A cxl decoder that is to be committed should have been earmarked as enabled.
> > + * This mechanism acts as a soft reservation on the decoder.
> > + *
> > + * Returns 0 if commit was successful, negative error code otherwise.
> > + */
> > +int cxl_commit_decoder(struct cxl_decoder *cxld)
> > +{
> > +	u32 ctrl, tl_lo, tl_hi, base_lo, base_hi, size_lo, size_hi;
> > +	struct cxl_port *port = to_cxl_port(cxld->dev.parent);
> > +	struct cxl_port_state *cxlps;
> > +	void __iomem *hdm_decoder;
> > +	int rc;
> > +
> > +	/*
> > +	 * Decoder flags are entirely software controlled and therefore this
> > +	 * case is purely a driver bug.
> > +	 */
> > +	if (dev_WARN_ONCE(&port->dev, (cxld->flags & CXL_DECODER_F_ENABLE) != 0,
> > +			  "Invalid %s enable state\n", dev_name(&cxld->dev)))
> > +		return -ENXIO;
> > +
> > +	cxlps = dev_get_drvdata(&port->dev);
> > +	hdm_decoder = cxlps->regs.hdm_decoder;
> > +	ctrl = readl(hdm_decoder + CXL_HDM_DECODER0_CTRL_OFFSET(cxld->id));
> > +
> > +	/*
> > +	 * A decoder that's currently active cannot be changed without the
> > +	 * system being quiesced. While the driver should prevent against this,
> > +	 * for a variety of reasons the hardware might not be in sync with the
> > +	 * hardware and so, do not splat on error.
> > +	 */
> > +	size_hi = readl(hdm_decoder +
> > +			CXL_HDM_DECODER0_SIZE_HIGH_OFFSET(cxld->id));
> > +	size_lo =
> > +		readl(hdm_decoder + CXL_HDM_DECODER0_SIZE_LOW_OFFSET(cxld->id));
> > +	if (FIELD_GET(CXL_HDM_DECODER0_CTRL_COMMITTED, ctrl) &&
> > +	    (size_lo + size_hi)) {
> > +		dev_err(&port->dev, "Tried to change an active decoder (%s)\n",
> > +			dev_name(&cxld->dev));
> > +		return -EBUSY;
> > +	}
> > +
> > +	u32p_replace_bits(&ctrl, 8 - ilog2(cxld->interleave_granularity),
> 
> This maths is wrong.   interleave_granularity is stored here as log2() anyway
> and should be cxld->interleave_granularity - 8;

Thanks. interleave_granularity was supposed to move to the absolute value and so
the math here should be correct (although in my current rev I have extracted the
math to a separate function).

I'll fix the meaning of granularity...

> 
> 
> 
> > +			  CXL_HDM_DECODER0_CTRL_IG_MASK);
> > +	u32p_replace_bits(&ctrl, ilog2(cxld->interleave_ways),
> > +			  CXL_HDM_DECODER0_CTRL_IW_MASK);
