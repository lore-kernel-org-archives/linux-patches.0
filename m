Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5547B2C9C
	for <patches@lists.linux.dev>; Fri,  7 Jan 2022 16:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641573153; x=1673109153;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YXyhi7jWupoTDySA3DCVw1DwpBEsMEZGa9+qIrGsldw=;
  b=EE1oLZI1DRNLli7n5hkL+qwO68/sMJbGsUB+6O9PgGPRD6EGXw38S4y4
   08taBZQzpTs+3m81kEbvlD2ei5jvVuQb5gbQ8C6tkw6tIRFwA3KD6mdxE
   X9wxW/JOlO1crLIpRp4QOzlnWQ8nSUPLdASYqhwJt019kqBxt8Sj3JWJ3
   vGglXgfNv0B+Syt8/MRMxmK29RAEmS1NyfejO7THLxKjvdY9GBFoo9Kh+
   4WJmPHDgGZhHBSIb/g6rpQhNtfBJvnx/H58iyFKqsOxdj3ZaAjnYGm0WK
   A6xvnNIopsCmgxVPxIQA7Jz+yTesy6gkm+Ra8R8HlefrVOPWTrgADdnRv
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10219"; a="222883106"
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="222883106"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 08:32:28 -0800
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="621962441"
Received: from njclifto-mobl.amr.corp.intel.com (HELO intel.com) ([10.252.135.14])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 08:32:27 -0800
Date: Fri, 7 Jan 2022 08:32:26 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, linux-nvdimm@lists.01.org,
	linux-pci@vger.kernel.org, patches@lists.linux.dev,
	Bjorn Helgaas <helgaas@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH 09/13] cxl/region: Implement XHB verification
Message-ID: <20220107163226.cdqqylscu4qvcqly@intel.com>
References: <20220107003756.806582-1-ben.widawsky@intel.com>
 <20220107003756.806582-10-ben.widawsky@intel.com>
 <20220107103052.00006c4b@huawei.com>
 <20220107103827.00006e4c@huawei.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220107103827.00006e4c@huawei.com>

On 22-01-07 10:38:27, Jonathan Cameron wrote:
> On Fri, 7 Jan 2022 10:30:52 +0000
> Jonathan Cameron <Jonathan.Cameron@huawei.com> wrote:
> 
> > On Thu,  6 Jan 2022 16:37:52 -0800
> > Ben Widawsky <ben.widawsky@intel.com> wrote:
> > 
> > > Cross host bridge verification primarily determines if the requested
> > > interleave ordering can be achieved by the root decoder, which isn't as
> > > programmable as other decoders.
> > > 
> > > The algorithm implemented here is based on the CXL Type 3 Memory Device
> > > Software Guide, chapter 2.13.14
> > > 
> > > Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>  
> > 
> > Trivial thing inline.
> > 
> > > diff --git a/drivers/cxl/region.c b/drivers/cxl/region.c
> > > index c8e3c48dfbb9..ca559a4b5347 100644
> > > --- a/drivers/cxl/region.c
> > > +++ b/drivers/cxl/region.c
> > > @@ -28,6 +28,17 @@
> > >   */
> > >  
> > >  #define region_ways(region) ((region)->config.eniw)
> > > +#define region_ig(region) (ilog2((region)->config.ig))
> > > +
> > > +#define for_each_cxl_endpoint(ep, region, idx)                                 \
> > > +	for (idx = 0, ep = (region)->config.targets[idx];                      \
> > > +	     idx < region_ways(region);                                        \
> > > +	     idx++, ep = (region)->config.targets[idx])
> > > +
> > > +#define for_each_cxl_decoder_target(target, decoder, idx)                      \
> > > +	for (idx = 0, target = (decoder)->target[idx];                         \  
> > 
> > As target is used too often in here, you'll replace it in ->target[idx] as well.
> > It happens to work today because the parameter always happens to be target
> > 
> > > +	     idx < (decoder)->nr_targets;                                      \
> > > +	     idx++, target++)
> I should have read the next few lines :)
> 
> target++ doesn't get (decoder)->target[idx] which is what we want - it indexes
> off the end of a particular instance rather than through the array.
> 
> I'm guessing this was from my unclear comment yesterday. I should have spent
> a little more time being explicit there.
> 
> Jonathan

Yeah. I was working quickly because I ended up losing childcare for this week
and wanted to get this out ASAP. I'll fix it up on the next round.

> 
> > >    
> 
