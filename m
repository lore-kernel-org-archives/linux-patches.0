Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01034A84
	for <patches@lists.linux.dev>; Thu, 17 Mar 2022 20:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647548639; x=1679084639;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BXVhiq2szAP9Zk+d+DqXnX4OgZhHnIKEKiPsS/lakBU=;
  b=Lp/soEeab5K/9OrVMNLKcqQI/+8FK3L8EnAHkyQhrYiGApMj9C1/9cJf
   zYh/T+h+slehcANtTSMBcbQXWTqTrQyyVMi9cw5g4VX49UfqhNq/WtUjd
   DYnhDIsUq8MJ18P+1kArumHq59xm8Xl7q36uEB331WekLjWof76PcNZVp
   mDiyXLc54NI0HVbeaTu5SItkufClsUWJ2G7nfKqFyqI9Cm1Q41OTN1Tef
   yDTBUjShnJc0Ibudg4Lzl1/zM8/jQHDFKJ7cRnrOMpVRYHpdM3E0C15P1
   qT4R68fDqs91nVmx9nCFaggXGxOKY/OEWXYnXTmT2zonanlcV2yIG7YCp
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10289"; a="317693500"
X-IronPort-AV: E=Sophos;i="5.90,190,1643702400"; 
   d="scan'208";a="317693500"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 13:23:59 -0700
X-IronPort-AV: E=Sophos;i="5.90,190,1643702400"; 
   d="scan'208";a="558093450"
Received: from dshkut-mobl.amr.corp.intel.com (HELO intel.com) ([10.252.132.229])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 13:23:59 -0700
Date: Thu, 17 Mar 2022 13:23:52 -0700
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org
Cc: patches@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [RFC PATCH 4/7] cxl/core/hdm: Allocate resources from the media
Message-ID: <20220317202352.7yc67wo7o5yy4pcn@intel.com>
References: <20220316230303.1813397-1-ben.widawsky@intel.com>
 <20220316230303.1813397-5-ben.widawsky@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316230303.1813397-5-ben.widawsky@intel.com>

On 22-03-16 16:03:00, Ben Widawsky wrote:
> Similar to how decoders consume address space for the root decoder, they
> also consume space on the device's physical media. For future
> allocations, it's important to mark those as used/busy.
> 
> Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> ---
>  drivers/cxl/core/core.h |  6 +++
>  drivers/cxl/core/hdm.c  | 44 +++++++++++++++++-
>  drivers/cxl/core/port.c | 99 +++++++++++++++++++++++++++++++++--------
>  drivers/cxl/cxl.h       | 16 +++++--
>  4 files changed, 142 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> index 1a50c0fc399c..1dea4dbb4f33 100644
> --- a/drivers/cxl/core/core.h
> +++ b/drivers/cxl/core/core.h
> @@ -9,6 +9,12 @@ extern const struct device_type cxl_nvdimm_type;
>  
>  extern struct attribute_group cxl_base_attribute_group;
>  
> +extern struct device_attribute dev_attr_create_pmem_region;
> +extern struct device_attribute dev_attr_delete_region;
> +
> +extern int *gen_pool_vcookie;
> +extern int *gen_pool_pcookie;
> +
>  struct cxl_send_command;
>  struct cxl_mem_query_commands;
>  int cxl_query_cmd(struct cxl_memdev *cxlmd,
> diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> index 83404cdb846b..4a4e07a010ec 100644
> --- a/drivers/cxl/core/hdm.c
> +++ b/drivers/cxl/core/hdm.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  /* Copyright(c) 2022 Intel Corporation. All rights reserved. */
>  #include <linux/io-64-nonatomic-hi-lo.h>
> +#include <linux/genalloc.h>
>  #include <linux/device.h>
>  #include <linux/delay.h>
>  
> @@ -188,8 +189,11 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
>  	else
>  		cxld->target_type = CXL_DECODER_ACCELERATOR;
>  
> -	if (is_endpoint_decoder(&cxld->dev))
> +	if (is_endpoint_decoder(&cxld->dev)) {
> +		to_cxl_endpoint_decoder(cxld)->skip =
> +			ioread64_hi_lo(hdm + CXL_HDM_DECODER0_TL_LOW(which));
>  		return 0;
> +	}
>  
>  	target_list.value =
>  		ioread64_hi_lo(hdm + CXL_HDM_DECODER0_TL_LOW(which));
> @@ -199,6 +203,35 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
>  	return 0;
>  }
>  
> +static void cxl_request_regions(struct cxl_endpoint_decoder *cxled,
> +				resource_size_t base)
> +{
> +	struct cxl_port *port = to_cxl_port(cxled->base.dev.parent);
> +	struct genpool_data_fixed gpdf;
> +	struct range r = cxled->hrange;
> +	unsigned long addr;
> +	void *type;
> +
> +	if (!(cxled->base.flags & CXL_DECODER_F_ENABLE))
> +		return;
> +
> +	gpdf.offset = base;
> +	addr = gen_pool_alloc_algo_owner(port->media, range_len(&r),
> +					 gen_pool_fixed_alloc, &gpdf, &type);
> +	if (addr != base || (base == 0 && !type)) {
> +		dev_warn(&port->dev, "Couldn't allocate media\n");
> +		return;
> +	} else if (type == &gen_pool_pcookie) {
> +		dev_warn(&port->dev, "Enumerated a persistent capacity\n");
> +		return;
> +	}
> +
> +	cxled->drange = (struct range) {
> +		.start = addr,
> +		.end = addr + range_len(&r) - 1,
> +	};
> +}
> +
>  /**
>   * devm_cxl_enumerate_decoders - add decoder objects per HDM register set
>   * @cxlhdm: Structure to populate with HDM capabilities
> @@ -208,6 +241,7 @@ int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm)
>  	void __iomem *hdm = cxlhdm->regs.hdm_decoder;
>  	struct cxl_port *port = cxlhdm->port;
>  	int i, committed, failed;
> +	u64 base = 0;
>  	u32 ctrl;
>  
>  	/*
> @@ -230,6 +264,7 @@ int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm)
>  	for (i = 0, failed = 0; i < cxlhdm->decoder_count; i++) {
>  		int target_map[CXL_DECODER_MAX_INTERLEAVE] = { 0 };
>  		int rc, target_count = cxlhdm->target_count;
> +		struct cxl_endpoint_decoder *cxled;
>  		struct cxl_decoder *cxld;
>  
>  		if (is_cxl_endpoint(port))
> @@ -255,6 +290,13 @@ int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm)
>  				 "Failed to add decoder to port\n");
>  			return rc;
>  		}
> +
> +		if (!is_cxl_endpoint(port))
> +			continue;
> +
> +		cxled = to_cxl_endpoint_decoder(cxld);
> +		cxl_request_regions(cxled, base + cxled->skip);
> +		base += cxled->skip + range_len(&cxled->hrange);

This is wrong. It assumes the decode is tightly packed. Working on a fix.

>  	}
>  
>  	if (failed == cxlhdm->decoder_count) {
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index 6653de4dfb43..fe50a42bed7b 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -452,16 +452,44 @@ static struct cxl_port *cxl_port_alloc(struct device *uport,
>  	return ERR_PTR(rc);
>  }
>  
> -/**
> - * devm_cxl_add_port - register a cxl_port in CXL memory decode hierarchy
> - * @host: host device for devm operations
> - * @uport: "physical" device implementing this upstream port
> - * @component_reg_phys: (optional) for configurable cxl_port instances
> - * @parent_port: next hop up in the CXL memory decode hierarchy
> - */
> -struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
> -				   resource_size_t component_reg_phys,
> -				   struct cxl_port *parent_port)
> +int *gen_pool_vcookie;
> +int *gen_pool_pcookie;
> +
> +static int create_gen_pools(struct cxl_port *ep, u64 capacity, u64 pmem_offset)
> +{
> +	int rc;
> +
> +	ep->media = gen_pool_create(ilog2(SZ_256M), NUMA_NO_NODE);
> +	if (IS_ERR(ep->media))
> +		return PTR_ERR(ep->media);
> +
> +	if (pmem_offset) {
> +		rc = gen_pool_add_owner(ep->media, 0, -1, pmem_offset,
> +					NUMA_NO_NODE, &gen_pool_vcookie);
> +		if (rc) {
> +			gen_pool_destroy(ep->media);
> +			return rc;
> +		}
> +	}
> +
> +	if (pmem_offset < capacity) {
> +		rc = gen_pool_add_owner(ep->media, pmem_offset, -1,
> +					capacity - pmem_offset, NUMA_NO_NODE,
> +					&gen_pool_pcookie);
> +		if (rc) {
> +			gen_pool_destroy(ep->media);
> +			return rc;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static struct cxl_port *__devm_cxl_add_port(struct device *host,
> +					    struct device *uport,
> +					    resource_size_t component_reg_phys,
> +					    u64 capacity, u64 pmem_offset,
> +					    struct cxl_port *parent_port)
>  {
>  	struct cxl_port *port;
>  	struct device *dev;
> @@ -474,12 +502,15 @@ struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
>  	if (parent_port)
>  		port->depth = parent_port->depth + 1;
>  	dev = &port->dev;
> -	if (is_cxl_memdev(uport))
> +	if (is_cxl_memdev(uport)) {
>  		rc = dev_set_name(dev, "endpoint%d", port->id);
> -	else if (parent_port)
> +		if (!rc)
> +			rc = create_gen_pools(port, capacity, pmem_offset);
> +	} else if (parent_port) {
>  		rc = dev_set_name(dev, "port%d", port->id);
> -	else
> +	} else {
>  		rc = dev_set_name(dev, "root%d", port->id);
> +	}
>  	if (rc)
>  		goto err;
>  
> @@ -502,10 +533,22 @@ struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
>  	put_device(dev);
>  	return ERR_PTR(rc);
>  }
> -EXPORT_SYMBOL_NS_GPL(devm_cxl_add_port, CXL);
>  
> -static int *gen_pool_vcookie;
> -static int *gen_pool_pcookie;
> +/**
> + * devm_cxl_add_port - register a cxl_port in CXL memory decode hierarchy
> + * @host: host device for devm operations
> + * @uport: "physical" device implementing this upstream port
> + * @component_reg_phys: (optional) for configurable cxl_port instances
> + * @parent_port: next hop up in the CXL memory decode hierarchy
> + */
> +struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
> +				   resource_size_t component_reg_phys,
> +				   struct cxl_port *parent_port)
> +{
> +	return __devm_cxl_add_port(host, uport, component_reg_phys, 0, 0,
> +				   parent_port);
> +}
> +EXPORT_SYMBOL_NS_GPL(devm_cxl_add_port, CXL);
>  
>  struct cxl_port *devm_cxl_add_endpoint_port(struct device *host,
>  					    struct device *uport,
> @@ -513,9 +556,9 @@ struct cxl_port *devm_cxl_add_endpoint_port(struct device *host,
>  					    u64 capacity, u64 pmem_offset,
>  					    struct cxl_port *parent_port)
>  {
> -	int rc;
>  	struct cxl_port *ep =
> -		devm_cxl_add_port(host, uport, component_reg_phys, parent_port);
> +		__devm_cxl_add_port(host, uport, component_reg_phys, capacity,
> +				    pmem_offset, parent_port);
>  	if (IS_ERR(ep) || !capacity)
>  		return ep;
>  
> @@ -526,6 +569,8 @@ struct cxl_port *devm_cxl_add_endpoint_port(struct device *host,
>  	}
>  
>  	if (pmem_offset) {
> +		int rc;
> +
>  		rc = gen_pool_add_owner(ep->media, 0, -1, pmem_offset,
>  					NUMA_NO_NODE, &gen_pool_vcookie);
>  		if (rc) {
> @@ -537,6 +582,8 @@ struct cxl_port *devm_cxl_add_endpoint_port(struct device *host,
>  	}
>  
>  	if (pmem_offset < capacity) {
> +		int rc;
> +
>  		rc = gen_pool_add_owner(ep->media, pmem_offset, -1,
>  					capacity - pmem_offset, NUMA_NO_NODE,
>  					&gen_pool_pcookie);
> @@ -1250,6 +1297,7 @@ static struct cxl_decoder *__cxl_decoder_alloc(struct cxl_port *port,
>  		cxled = kzalloc(sizeof(*cxled), GFP_KERNEL);
>  		if (!cxled)
>  			return NULL;
> +		cxled->drange = (struct range){ 0, -1 };
>  		cxld = &cxled->base;
>  	} else if (is_cxl_root(port)) {
>  		struct cxl_root_decoder *cxlrd;
> @@ -1504,6 +1552,21 @@ EXPORT_SYMBOL_NS_GPL(cxl_decoder_add, CXL);
>  
>  static void cxld_unregister(void *dev)
>  {
> +	struct cxl_decoder *cxld = to_cxl_decoder(dev);
> +
> +	if (is_endpoint_decoder(&cxld->dev)) {
> +		struct cxl_endpoint_decoder *cxled =
> +			to_cxl_endpoint_decoder(cxld);
> +		struct cxl_port *ep = to_cxl_port(cxld->dev.parent);
> +
> +		if (!range_len(&cxled->drange))
> +			goto out;
> +
> +		gen_pool_free(ep->media, cxled->drange.start,
> +			      range_len(&cxled->drange));
> +	}
> +
> +out:
>  	device_unregister(dev);
>  }
>  
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index d18e93e77f7e..e88b1efe54d3 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -245,11 +245,15 @@ struct cxl_decoder {
>  /**
>   * struct cxl_endpoint_decoder - An decoder residing in a CXL endpoint.
>   * @base: Base class decoder
> - * @range: Host physical address space consumed by this decoder.
> + * @hrange: Host physical address space consumed by this decoder.
> + * @drange: device space consumed by this decoder.
> + * @skip: The skip count as specified in the CXL specification.
>   */
>  struct cxl_endpoint_decoder {
>  	struct cxl_decoder base;
> -	struct range range;
> +	struct range hrange;
> +	struct range drange;
> +	u64 skip;
>  };
>  
>  /**
> @@ -269,11 +273,15 @@ struct cxl_switch_decoder {
>   * @base: Base class decoder
>   * @res: host address space owned by this decoder
>   * @targets: Downstream targets (ie. hostbridges).
> + * @next_region_id: The pre-cached next region id.
> + * @id_lock: Protects next_region_id
>   */
>  struct cxl_root_decoder {
>  	struct cxl_decoder base;
>  	struct resource res;
>  	struct cxl_decoder_targets *targets;
> +	int next_region_id;
> +	struct mutex id_lock; /* synchronizes access to next_region_id */
>  };
>  
>  #define _to_cxl_decoder(x)                                                     \
> @@ -441,7 +449,7 @@ static inline void cxl_set_decoder_extent(struct cxl_decoder *cxld,
>  		to_cxl_root_decoder(cxld)->res =
>  			(struct resource)DEFINE_RES_MEM(base, size);
>  	else if (is_endpoint_decoder(&cxld->dev))
> -		to_cxl_endpoint_decoder(cxld)->range = (struct range){
> +		to_cxl_endpoint_decoder(cxld)->drange = (struct range){
>  			.start = base,
>  			.end = base + size - 1
>  		};
> @@ -464,7 +472,7 @@ static inline struct range cxl_get_decoder_extent(struct cxl_decoder *cxld)
>  			.end = cxlrd->res.end
>  		};
>  	} else if (is_endpoint_decoder(&cxld->dev)) {
> -		ret = to_cxl_endpoint_decoder(cxld)->range;
> +		ret = to_cxl_endpoint_decoder(cxld)->drange;
>  	} else {
>  		ret = to_cxl_switch_decoder(cxld)->range;
>  	}
> -- 
> 2.35.1
> 
