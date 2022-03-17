Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C684A9F
	for <patches@lists.linux.dev>; Thu, 17 Mar 2022 21:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647553790; x=1679089790;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=U/ge9XDyQ7H80gJgVwgzFvy2BAEC7K+gjpG9ti5VJ4U=;
  b=A9lqSmM1Xjx/fBK6EKf1xUtHRUTCUS96eUQS5yBriGjBis03dXKIhyBM
   suJpFmdn3t4sjyEjyjwQKsQYHxHpeHDTaT4WQx5awde3u4XpxQXZjII2v
   O1HJGzOng3WZ0Ec6RqwlvemitOlZk0YKxNZKilhYtSAH+zgllchVsoAiV
   TVrvxp3LgIwsJNiRPcWhveLZnCdA76HvOgtsL2WRhGzMaNDznzGcUCEJC
   U0wLdfOo7WndvAtRioePOLhmwJsiXVPc8hIfljmN/vinFqA2sWMRplMpY
   f5lexBtHlQVQmAM6gnD3SaSvcv2Bul/nLv1dx/cthlWtAmeF50UvxfXxy
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10289"; a="236934982"
X-IronPort-AV: E=Sophos;i="5.90,190,1643702400"; 
   d="scan'208";a="236934982"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 14:49:50 -0700
X-IronPort-AV: E=Sophos;i="5.90,190,1643702400"; 
   d="scan'208";a="558122501"
Received: from dshkut-mobl.amr.corp.intel.com (HELO intel.com) ([10.252.132.229])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 14:49:49 -0700
Date: Thu, 17 Mar 2022 14:49:43 -0700
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org
Cc: patches@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [RFC PATCH 5/7] cxl/core/port: add decoder attrs for size and
 volatility
Message-ID: <20220317214943.gxbwayoletild3eq@intel.com>
References: <20220316230303.1813397-1-ben.widawsky@intel.com>
 <20220316230303.1813397-6-ben.widawsky@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220316230303.1813397-6-ben.widawsky@intel.com>

On 22-03-16 16:03:01, Ben Widawsky wrote:
> Endpoint decoders have the decoder-unique properties of having their
> range being constrained by the media they're a part of, and, having a
> concrete need to disambiguate between volatile and persistent capacity
> (due to partitioning). As part of region programming, these decoders
> will be required to be pre-configured, ie, have the size and volatility
> set.
> 
> Endpoint decoders must consider two different address space for address
> allocation. Sysram will need to be mapped for use of this memory if not
> set up in the EFI memory map. Additionally, the CXL device itself has
> it's own address space domain which requires allocation and management.
> To handle the device address space, a gen_pool is used per device. Host
> physical address space will get allocated as needed when the region is
> created.
> 
> The existing gen_pool API is an almost perfect fit for managing the
> device memory. There exists one impediment however. HDM decoders (as of
> the CXL 2.0 spec) must map incremental address. 8.2.5.12.20 states,
> "Decoder[m+1].Base >= (Decoder[m].Base+Decoder[m].Size)". To handle this
> case, a custom gen_pool algorithm is implemented which searches for the
> last enabled decoder and allocates at the next address after that. This
> is like a first fit + fixed algorithm.
> 
> /sys/bus/cxl/devices/decoder3.0
> ├── devtype
> ├── interleave_granularity
> ├── interleave_ways
> ├── locked
> ├── modalias
> ├── size
> ├── start
> ├── subsystem -> ../../../../../../../bus/cxl
> ├── target_type
> ├── uevent
> └── volatile
> 
> Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-cxl |  13 +-
>  drivers/cxl/Kconfig                     |   3 +-
>  drivers/cxl/core/port.c                 | 168 +++++++++++++++++++++++-
>  drivers/cxl/cxl.h                       |   6 +
>  4 files changed, 187 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
> index 7c2b846521f3..01fee09b8473 100644
> --- a/Documentation/ABI/testing/sysfs-bus-cxl
> +++ b/Documentation/ABI/testing/sysfs-bus-cxl
> @@ -117,7 +117,9 @@ Description:
>  		range is fixed. For decoders of devtype "cxl_decoder_switch" the
>  		address is bounded by the decode range of the cxl_port ancestor
>  		of the decoder's cxl_port, and dynamically updates based on the
> -		active memory regions in that address space.
> +		active memory regions in that address space. For decoders of
> +		devtype "cxl_decoder_endpoint", size is a mutable value which
> +		carves our space from the physical media.
>  
>  What:		/sys/bus/cxl/devices/decoderX.Y/locked
>  Date:		June, 2021
> @@ -163,3 +165,12 @@ Description:
>  		memory (type-3). The 'target_type' attribute indicates the
>  		current setting which may dynamically change based on what
>  		memory regions are activated in this decode hierarchy.
> +
> +What:		/sys/bus/cxl/devices/decoderX.Y/volatile
> +Date:		March, 2022
> +KernelVersion:	v5.19
> +Contact:	linux-cxl@vger.kernel.org
> +Description:
> +		Provide a knob to set/get whether the desired media is volatile
> +		or persistent. This applies only to decoders of devtype
> +		"cxl_decoder_endpoint",
> diff --git a/drivers/cxl/Kconfig b/drivers/cxl/Kconfig
> index b88ab956bb7c..8796fd4b22bc 100644
> --- a/drivers/cxl/Kconfig
> +++ b/drivers/cxl/Kconfig
> @@ -95,7 +95,8 @@ config CXL_MEM
>  	  If unsure say 'm'.
>  
>  config CXL_PORT
> -	default CXL_BUS
>  	tristate
> +	default CXL_BUS
> +	select DEVICE_PRIVATE
>  
>  endif
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index fe50a42bed7b..89505de0843a 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -4,6 +4,7 @@
>  #include <linux/workqueue.h>
>  #include <linux/genalloc.h>
>  #include <linux/device.h>
> +#include <linux/ioport.h>
>  #include <linux/module.h>
>  #include <linux/pci.h>
>  #include <linux/slab.h>
> @@ -86,8 +87,170 @@ static ssize_t size_show(struct device *dev, struct device_attribute *attr,
>  	struct range r = cxl_get_decoder_extent(cxld);
>  
>  	return sysfs_emit(buf, "%#llx\n", range_len(&r));
> +};
> +
> +struct genpool_data_cxl {
> +	struct cxl_port *port;
> +	struct cxl_endpoint_decoder *cxled;
> +};
> +
> +struct maximum_addr {
> +	int id;
> +	unsigned long addr;
> +};
> +
> +/* Find the first enabled decoder below the one we care about */
> +static int cxl_find_max_addr(struct device *dev, void *data)
> +{
> +	struct maximum_addr *ma = (struct maximum_addr *)data;
> +	struct cxl_decoder *cxld;
> +	struct cxl_endpoint_decoder *cxled;
> +
> +	if (!is_cxl_decoder(dev))
> +		return 0;
> +
> +	cxld = to_cxl_decoder(dev);
> +
> +	if (cxld->id >= ma->id)
> +		return 0;
> +
> +	if (!(cxld->flags & CXL_DECODER_F_ENABLE))
> +		return 0;
> +
> +	if (cxled->drange.end) {
> +		ma->addr = cxled->drange.end + 1;
> +		return 1;
> +	}
> +
> +	return 0;
>  }
> -static DEVICE_ATTR_RO(size);
> +
> +unsigned long gen_pool_cxl_alloc(unsigned long *map, unsigned long size,
> +				 unsigned long start, unsigned int nr,
> +				 void *data, struct gen_pool *pool,
> +				 unsigned long start_addr)
> +{
> +	struct genpool_data_cxl *port_dec = data;
> +	struct cxl_port *port = port_dec->port;
> +	struct cxl_endpoint_decoder *cxled = port_dec->cxled;
> +	unsigned long offset_bit;
> +	unsigned long start_bit;
> +	struct maximum_addr ma;
> +
> +	lockdep_assert_held(&port->media_lock);
> +
> +	ma.id = cxled->base.id;
> +	ma.addr = 0;
> +
> +	device_for_each_child(&port->dev, &ma, cxl_find_max_addr);
> +

This should be device_for_each_child_reverse()

> +	/* From here on, it's fixed offset algo */
> +	offset_bit = ma.addr >> pool->min_alloc_order;
> +
> +	start_bit = bitmap_find_next_zero_area(map, size, start + offset_bit,
> +					       nr, 0);
> +	if (start_bit != offset_bit)
> +		start_bit = size;
> +	return start_bit;
> +}
> +
> +static ssize_t size_store(struct device *dev, struct device_attribute *attr,
> +			  const char *buf, size_t len)
> +{
> +	struct cxl_decoder *cxld = to_cxl_decoder(dev);
> +	struct cxl_endpoint_decoder *cxled = to_cxl_endpoint_decoder(cxld);
> +	struct cxl_port *port = to_cxl_port(cxled->base.dev.parent);
> +	struct genpool_data_cxl gpdc = {
> +		.port = port,
> +		.cxled = cxled,
> +	};
> +	unsigned long addr;
> +	void *type;
> +	u64 size;
> +	int rc;
> +
> +	rc = kstrtou64(buf, 0, &size);
> +	if (rc)
> +		return rc;
> +
> +	if (size % SZ_256M)
> +		return -EINVAL;
> +
> +	rc = mutex_lock_interruptible(&cxled->res_lock);
> +	if (rc)
> +		return rc;
> +
> +	/* No change */
> +	if (range_len(&cxled->drange) == size)
> +		goto out;
> +
> +	/* Extent was previously set */
> +	if (range_len(&cxled->drange)) {
> +		dev_dbg(dev, "freeing previous reservation %#llx-%#llx\n",
> +				cxled->drange.start, cxled->drange.end);
> +		gen_pool_free(port->media, cxled->drange.start,
> +			      range_len(&cxled->drange));
> +		cxled->drange = (struct range){ 0, -1 };
> +		if (!size)
> +			goto out;
> +	}
> +
> +	rc = mutex_lock_interruptible(&port->media_lock);
> +	if (rc)
> +		goto out;
> +
> +	addr = gen_pool_alloc_algo_owner(port->media, size, gen_pool_cxl_alloc,
> +					 &gpdc, &type);
> +	mutex_unlock(&port->media_lock);
> +	if (!addr && !type) {
> +		dev_dbg(dev, "couldn't find %u bytes\n", size);
> +		cxl_set_decoder_extent(cxld, 0, 0);
> +		rc = -ENOSPC;
> +	} else {
> +		cxl_set_decoder_extent(cxld, addr, size);
> +	}
> +
> +out:
> +	mutex_unlock(&cxled->res_lock);
> +	return rc ? rc : len;
> +}
> +static DEVICE_ATTR_RW(size);
> +
> +static ssize_t volatile_show(struct device *dev, struct device_attribute *attr,
> +			     char *buf)
> +{
> +	struct cxl_decoder *cxld = to_cxl_decoder(dev);
> +	struct cxl_endpoint_decoder *cxled = to_cxl_endpoint_decoder(cxld);
> +
> +	return sysfs_emit(buf, "%u\n", cxled->volatil);
> +}
> +
> +static ssize_t volatile_store(struct device *dev, struct device_attribute *attr,
> +			      const char *buf, size_t len)
> +{
> +	struct cxl_decoder *cxld = to_cxl_decoder(dev);
> +	struct cxl_endpoint_decoder *cxled = to_cxl_endpoint_decoder(cxld);
> +	bool p;
> +	int rc;
> +
> +	rc = kstrtobool(buf, &p);
> +	if (rc)
> +		return rc;
> +
> +	rc = mutex_lock_interruptible(&cxled->res_lock);
> +	if (rc)
> +		return rc;
> +
> +	if (range_len(&cxled->drange) > 0)
> +		rc = -EBUSY;
> +	mutex_unlock(&cxled->res_lock);
> +	if (rc)
> +		return rc;
> +
> +	cxled->volatil = p;
> +	return len;
> +}
> +static DEVICE_ATTR_RW(volatile);
>  
>  static ssize_t interleave_ways_show(struct device *dev,
>  				    struct device_attribute *attr, char *buf)
> @@ -243,6 +406,7 @@ static const struct attribute_group *cxl_decoder_switch_attribute_groups[] = {
>  
>  static struct attribute *cxl_decoder_endpoint_attrs[] = {
>  	&dev_attr_target_type.attr,
> +	&dev_attr_volatile.attr,
>  	NULL,
>  };
>  
> @@ -439,6 +603,7 @@ static struct cxl_port *cxl_port_alloc(struct device *uport,
>  	ida_init(&port->decoder_ida);
>  	INIT_LIST_HEAD(&port->dports);
>  	INIT_LIST_HEAD(&port->endpoints);
> +	mutex_init(&port->media_lock);
>  
>  	device_initialize(dev);
>  	device_set_pm_not_required(dev);
> @@ -1298,6 +1463,7 @@ static struct cxl_decoder *__cxl_decoder_alloc(struct cxl_port *port,
>  		if (!cxled)
>  			return NULL;
>  		cxled->drange = (struct range){ 0, -1 };
> +		mutex_init(&cxled->res_lock);
>  		cxld = &cxled->base;
>  	} else if (is_cxl_root(port)) {
>  		struct cxl_root_decoder *cxlrd;
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index e88b1efe54d3..8944d0fdd58a 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -248,12 +248,16 @@ struct cxl_decoder {
>   * @hrange: Host physical address space consumed by this decoder.
>   * @drange: device space consumed by this decoder.
>   * @skip: The skip count as specified in the CXL specification.
> + * @res_lock: Synchronize device's resource usage
> + * @volatil: Configuration param. Decoder target is non-persistent mem
>   */
>  struct cxl_endpoint_decoder {
>  	struct cxl_decoder base;
>  	struct range hrange;
>  	struct range drange;
>  	u64 skip;
> +	struct mutex res_lock; /* sync access to decoder's resource */
> +	bool volatil;
>  };
>  
>  /**
> @@ -338,6 +342,7 @@ struct cxl_nvdimm {
>   * @component_reg_phys: component register capability base address (optional)
>   * @dead: last ep has been removed, force port re-creation
>   * @depth: How deep this port is relative to the root. depth 0 is the root.
> + * @media_lock: Protects the media gen_pool
>   * @media: Media's address space (endpoint only)
>   */
>  struct cxl_port {
> @@ -350,6 +355,7 @@ struct cxl_port {
>  	resource_size_t component_reg_phys;
>  	bool dead;
>  	unsigned int depth;
> +	struct mutex media_lock;
>  	struct gen_pool *media;
>  };
>  
> -- 
> 2.35.1
> 
