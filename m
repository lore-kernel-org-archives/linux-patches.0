Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFBC5137
	for <patches@lists.linux.dev>; Fri, 18 Mar 2022 21:03:52 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id q1-20020a17090a4f8100b001c6575ae105so6273696pjh.0
        for <patches@lists.linux.dev>; Fri, 18 Mar 2022 14:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qI+MlfKZnMCSIrbMYwmxL2S2VV1TiV3bDd9ZNL5WXRA=;
        b=OpviT3aOb2O+XaxOurSAGyCIVdo5aiAlyJCkG8IobaMeCg3RpV6IbRyyZqmF85E/zU
         2V+ACiFgZp5BPEtPUuXbuEeTv+NZ/c4nZ3txf1n4KjRbeoVhYTrHEY3Zg6xc3gnEgnHu
         2rGvGGJ0Cht1VpWVfAeHcMzb2lmBULpzYTWuuinOsXVBZP4Woo4xgsEV82LGtbYmtNkw
         eNhn4lKlgc1/WoWW5Fvdf6dGpTn3/gPxtoS4faUE6AjgpvSD8BxZ0LlMpMYLmf1YZ3b3
         nF1A7uRNBjKEuygoYzUl2z+IDF03K2GfH/6QTj46qDe9noZLLCXmeM6rGvVLeUxltlkL
         vbTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qI+MlfKZnMCSIrbMYwmxL2S2VV1TiV3bDd9ZNL5WXRA=;
        b=zdfvf7hbtE+p9O2WJPTUWejaczAeQVmoUB3+WUj5aNGYp7ZuaXbbPh14sEOB5si1J5
         tl2FvxFkf2bP6vQ7ceFLUskrSHl9B1kei4fhyP3pi+9FBkulK0j3U1EC4wIByWlPCotP
         FQjExHHG4xtueSEsuokKuyIE6XC3H57yM+G/uDK4WrZFLHGhbGYP0Q9dX3WP0VBdcI3o
         +xAKMkPs9b8pjon1j5ZRHhXVW3e/J5A2dme5NSapPCKe1Hhpy+pZJwBcZ/RlH0XuixBd
         nHLDxxHwWP4QVNJzxkLDRD72BXXG/JYoKpZCSl8bOF2BRmnwAGgpvfX4q6X8S8SjvBLH
         un8w==
X-Gm-Message-State: AOAM531OLVhNOFkcM1a2RKtqZ6GKrH8gcyICcZEzmqfDB08Zk+hm5Yj+
	8vXuTVa+L9Xn5cSr7XFTLE6zgMO4ffShKzfjIPJ/WA==
X-Google-Smtp-Source: ABdhPJzceRJrWmDfk1h2UJ7w8g298eOPsGMNTOhYsoD63Uz2lKFSoJ5p2Hqx+g5y+nGhsWpD+zP1z8Vh/gOFhyPjL+g=
X-Received: by 2002:a17:902:d504:b0:154:172:3677 with SMTP id
 b4-20020a170902d50400b0015401723677mr1367319plg.147.1647637432087; Fri, 18
 Mar 2022 14:03:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220316230303.1813397-1-ben.widawsky@intel.com> <20220316230303.1813397-3-ben.widawsky@intel.com>
In-Reply-To: <20220316230303.1813397-3-ben.widawsky@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 18 Mar 2022 14:03:41 -0700
Message-ID: <CAPcyv4j60_puoCe6q2KqWo8f-HzfwumRtgXqyj1Jr9ht+SBhKg@mail.gmail.com>
Subject: Re: [RFC PATCH 2/7] cxl/core: Distinguish cxl_decoder into types
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, patches@lists.linux.dev, 
	Alison Schofield <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Vishal Verma <vishal.l.verma@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Mar 16, 2022 at 4:03 PM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> CXL HDM decoders have distinct properties at each level in the
> hierarchy. Root decoders manage host physical address space. Switch
> decoders manage demultiplexing of data to downstream targets. Endpoint
> decoders must be aware of physical media size constraints. To properly
> support these unique needs, create these unique structures. As endpoint
> decoders don't handle media size accounting, that is saved for a later
> patch.
>
> CXL HDM decoders do have similar architectural properties at all levels:
> interleave properties, flags and types. Those are retained and when
> possible, still utilized.

This looks slightly more invasive than I was expecting for example, I
don't think the targets array needs to move and the direct assignment
of resources and ranges didn't seem to need fixing. An outline of my
thinking below if you want to consider it:

>
> Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> ---
>  drivers/cxl/acpi.c           |   9 ++-
>  drivers/cxl/core/hdm.c       |   8 +--
>  drivers/cxl/core/port.c      |  99 ++++++++++++++++++++---------
>  drivers/cxl/cxl.h            | 118 +++++++++++++++++++++++++++++++----
>  tools/testing/cxl/test/cxl.c |   7 +--
>  5 files changed, 186 insertions(+), 55 deletions(-)
>
> diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> index 09d6811736f2..822b615a25f4 100644
> --- a/drivers/cxl/acpi.c
> +++ b/drivers/cxl/acpi.c
> @@ -108,8 +108,7 @@ static int cxl_parse_cfmws(union acpi_subtable_headers *header, void *arg,
>
>         cxld->flags = cfmws_to_decoder_flags(cfmws->restrictions);
>         cxld->target_type = CXL_DECODER_EXPANDER;
> -       cxld->platform_res = (struct resource)DEFINE_RES_MEM(cfmws->base_hpa,
> -                                                            cfmws->window_size);
> +       cxl_set_decoder_extent(cxld, cfmws->base_hpa, cfmws->window_size);
>         cxld->interleave_ways = CFMWS_INTERLEAVE_WAYS(cfmws);
>         cxld->interleave_granularity = CFMWS_INTERLEAVE_GRANULARITY(cfmws);
>
> @@ -120,12 +119,12 @@ static int cxl_parse_cfmws(union acpi_subtable_headers *header, void *arg,
>                 rc = cxl_decoder_autoremove(dev, cxld);
>         if (rc) {
>                 dev_err(dev, "Failed to add decoder for %pr\n",
> -                       &cxld->platform_res);
> +                       &to_cxl_root_decoder(cxld)->res);
>                 return 0;
>         }
>         dev_dbg(dev, "add: %s node: %d range %pr\n", dev_name(&cxld->dev),
> -               phys_to_target_node(cxld->platform_res.start),
> -               &cxld->platform_res);
> +               phys_to_target_node(to_cxl_root_decoder(cxld)->res.start),
> +               &to_cxl_root_decoder(cxld)->res);
>
>         return 0;
>  }
> diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> index 808b19215425..83404cdb846b 100644
> --- a/drivers/cxl/core/hdm.c
> +++ b/drivers/cxl/core/hdm.c
> @@ -6,6 +6,7 @@
>
>  #include "cxlmem.h"
>  #include "core.h"
> +#include "cxl.h"
>
>  /**
>   * DOC: cxl core hdm
> @@ -165,10 +166,7 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
>                 return -ENXIO;
>         }
>
> -       cxld->decoder_range = (struct range) {
> -               .start = base,
> -               .end = base + size - 1,
> -       };
> +       cxl_set_decoder_extent(cxld, base, size);
>
>         /* switch decoders are always enabled if committed */
>         if (ctrl & CXL_HDM_DECODER0_CTRL_COMMITTED) {
> @@ -235,7 +233,7 @@ int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm)
>                 struct cxl_decoder *cxld;
>
>                 if (is_cxl_endpoint(port))
> -                       cxld = cxl_endpoint_decoder_alloc(port);
> +                       cxld = &cxl_endpoint_decoder_alloc(port)->base;
>                 else
>                         cxld = cxl_switch_decoder_alloc(port, target_count);
>                 if (IS_ERR(cxld)) {
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index bda40e91af2b..c46f0b01ce3c 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -73,14 +73,8 @@ static ssize_t start_show(struct device *dev, struct device_attribute *attr,
>                           char *buf)
>  {
>         struct cxl_decoder *cxld = to_cxl_decoder(dev);
> -       u64 start;
>
> -       if (is_root_decoder(dev))
> -               start = cxld->platform_res.start;
> -       else
> -               start = cxld->decoder_range.start;
> -
> -       return sysfs_emit(buf, "%#llx\n", start);
> +       return sysfs_emit(buf, "%#llx\n", cxl_get_decoder_extent(cxld).start);
>  }
>  static DEVICE_ATTR_ADMIN_RO(start);
>
> @@ -88,14 +82,9 @@ static ssize_t size_show(struct device *dev, struct device_attribute *attr,
>                         char *buf)
>  {
>         struct cxl_decoder *cxld = to_cxl_decoder(dev);
> -       u64 size;
> +       struct range r = cxl_get_decoder_extent(cxld);
>
> -       if (is_root_decoder(dev))
> -               size = resource_size(&cxld->platform_res);
> -       else
> -               size = range_len(&cxld->decoder_range);
> -
> -       return sysfs_emit(buf, "%#llx\n", size);
> +       return sysfs_emit(buf, "%#llx\n", range_len(&r));
>  }
>  static DEVICE_ATTR_RO(size);
>
> @@ -152,18 +141,19 @@ static DEVICE_ATTR_RO(target_type);
>
>  static ssize_t emit_target_list(struct cxl_decoder *cxld, char *buf)
>  {
> +       struct cxl_decoder_targets *t = cxl_get_decoder_targets(cxld);
>         ssize_t offset = 0;
>         int i, rc = 0;
>
>         for (i = 0; i < cxld->interleave_ways; i++) {
> -               struct cxl_dport *dport = cxld->target[i];
> +               struct cxl_dport *dport = t->target[i];
>                 struct cxl_dport *next = NULL;
>
>                 if (!dport)
>                         break;
>
>                 if (i + 1 < cxld->interleave_ways)
> -                       next = cxld->target[i + 1];
> +                       next = t->target[i + 1];
>                 rc = sysfs_emit_at(buf, offset, "%d%s", dport->port_id,
>                                    next ? "," : "");
>                 if (rc < 0)
> @@ -178,14 +168,15 @@ static ssize_t target_list_show(struct device *dev,
>                                 struct device_attribute *attr, char *buf)
>  {
>         struct cxl_decoder *cxld = to_cxl_decoder(dev);
> +       struct cxl_decoder_targets *t = cxl_get_decoder_targets(cxld);
>         ssize_t offset;
>         unsigned int seq;
>         int rc;
>
>         do {
> -               seq = read_seqbegin(&cxld->target_lock);
> +               seq = read_seqbegin(&t->target_lock);
>                 rc = emit_target_list(cxld, buf);
> -       } while (read_seqretry(&cxld->target_lock, seq));
> +       } while (read_seqretry(&t->target_lock, seq));
>
>         if (rc < 0)
>                 return rc;
> @@ -297,6 +288,7 @@ bool is_endpoint_decoder(struct device *dev)
>  {
>         return dev->type == &cxl_decoder_endpoint_type;
>  }
> +EXPORT_SYMBOL_NS_GPL(is_endpoint_decoder, CXL);
>
>  bool is_root_decoder(struct device *dev)
>  {
> @@ -1167,6 +1159,7 @@ EXPORT_SYMBOL_NS_GPL(cxl_find_dport_by_dev, CXL);
>  static int decoder_populate_targets(struct cxl_decoder *cxld,
>                                     struct cxl_port *port, int *target_map)
>  {
> +       struct cxl_decoder_targets *t = cxl_get_decoder_targets(cxld);
>         int i, rc = 0;
>
>         if (!target_map)
> @@ -1177,21 +1170,70 @@ static int decoder_populate_targets(struct cxl_decoder *cxld,
>         if (list_empty(&port->dports))
>                 return -EINVAL;
>
> -       write_seqlock(&cxld->target_lock);
> -       for (i = 0; i < cxld->nr_targets; i++) {
> +       write_seqlock(&t->target_lock);
> +       for (i = 0; i < t->nr_targets; i++) {
>                 struct cxl_dport *dport = find_dport(port, target_map[i]);
>
>                 if (!dport) {
>                         rc = -ENXIO;
>                         break;
>                 }
> -               cxld->target[i] = dport;
> +               t->target[i] = dport;
>         }
> -       write_sequnlock(&cxld->target_lock);
> +       write_sequnlock(&t->target_lock);
>
>         return rc;
>  }
>
> +static struct cxl_decoder *__cxl_decoder_alloc(struct cxl_port *port,
> +                                              unsigned int nr_targets)
> +{
> +       struct cxl_decoder *cxld;
> +
> +       if (is_cxl_endpoint(port)) {
> +               struct cxl_endpoint_decoder *cxled;
> +
> +               cxled = kzalloc(sizeof(*cxled), GFP_KERNEL);
> +               if (!cxled)
> +                       return NULL;
> +               cxld = &cxled->base;
> +       } else if (is_cxl_root(port)) {
> +               struct cxl_root_decoder *cxlrd;
> +
> +               cxlrd = kzalloc(sizeof(*cxlrd), GFP_KERNEL);
> +               if (!cxlrd)
> +                       return NULL;
> +
> +               cxlrd->targets =
> +                       kzalloc(struct_size(cxlrd->targets, target, nr_targets), GFP_KERNEL);
> +               if (!cxlrd->targets) {
> +                       kfree(cxlrd);
> +                       return NULL;
> +               }
> +               cxlrd->targets->nr_targets = nr_targets;
> +               seqlock_init(&cxlrd->targets->target_lock);
> +               cxld = &cxlrd->base;
> +       } else {
> +               struct cxl_switch_decoder *cxlsd;
> +
> +               cxlsd = kzalloc(sizeof(*cxlsd), GFP_KERNEL);
> +               if (!cxlsd)
> +                       return NULL;
> +
> +               cxlsd->targets =
> +                       kzalloc(struct_size(cxlsd->targets, target, nr_targets), GFP_KERNEL);
> +               if (!cxlsd->targets) {
> +                       kfree(cxlsd);
> +                       return NULL;
> +               }
> +               cxlsd->targets->nr_targets = nr_targets;
> +               seqlock_init(&cxlsd->targets->target_lock);
> +               cxld = &cxlsd->base;
> +       }
> +
> +       return cxld;
> +}
> +
>  /**
>   * cxl_decoder_alloc - Allocate a new CXL decoder
>   * @port: owning port of this decoder
> @@ -1217,9 +1259,10 @@ static struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port,
>         if (nr_targets > CXL_DECODER_MAX_INTERLEAVE)
>                 return ERR_PTR(-EINVAL);
>
> -       cxld = kzalloc(struct_size(cxld, target, nr_targets), GFP_KERNEL);
> +       cxld = __cxl_decoder_alloc(port, nr_targets);
>         if (!cxld)
>                 return ERR_PTR(-ENOMEM);
> +       ;
>
>         rc = ida_alloc(&port->decoder_ida, GFP_KERNEL);
>         if (rc < 0)
> @@ -1229,8 +1272,6 @@ static struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port,
>         get_device(&port->dev);
>         cxld->id = rc;
>
> -       cxld->nr_targets = nr_targets;
> -       seqlock_init(&cxld->target_lock);
>         dev = &cxld->dev;
>         device_initialize(dev);
>         device_set_pm_not_required(dev);
> @@ -1247,7 +1288,7 @@ static struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port,
>         cxld->interleave_ways = 1;
>         cxld->interleave_granularity = PAGE_SIZE;
>         cxld->target_type = CXL_DECODER_EXPANDER;
> -       cxld->platform_res = (struct resource)DEFINE_RES_MEM(0, 0);
> +       cxl_set_decoder_extent(cxld, 0, 0);
>
>         return cxld;
>  err:
> @@ -1302,12 +1343,12 @@ EXPORT_SYMBOL_NS_GPL(cxl_switch_decoder_alloc, CXL);
>   *
>   * Return: A new cxl decoder to be registered by cxl_decoder_add()
>   */
> -struct cxl_decoder *cxl_endpoint_decoder_alloc(struct cxl_port *port)
> +struct cxl_endpoint_decoder *cxl_endpoint_decoder_alloc(struct cxl_port *port)
>  {
>         if (!is_cxl_endpoint(port))
>                 return ERR_PTR(-EINVAL);
>
> -       return cxl_decoder_alloc(port, 0);
> +       return to_cxl_endpoint_decoder(cxl_decoder_alloc(port, 0));
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_endpoint_decoder_alloc, CXL);
>
> @@ -1366,7 +1407,7 @@ int cxl_decoder_add_locked(struct cxl_decoder *cxld, int *target_map)
>          * other resources are just sub ranges within the main decoder resource.
>          */
>         if (is_root_decoder(dev))
> -               cxld->platform_res.name = dev_name(dev);
> +               to_cxl_root_decoder(cxld)->res.name = dev_name(dev);
>
>         cxl_set_lock_class(dev);
>         return device_add(dev);
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 4a93d409328f..f523268060fd 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -210,6 +210,18 @@ enum cxl_decoder_type {
>   */
>  #define CXL_DECODER_MAX_INTERLEAVE 16
>
> +/**
> + * struct cxl_decoder_targets - Target information for root and switch decoders.
> + * @target_lock: coordinate coherent reads of the target list
> + * @nr_targets: number of elements in @target
> + * @target: active ordered target list in current decoder configuration
> + */
> +struct cxl_decoder_targets {
> +       seqlock_t target_lock;
> +       int nr_targets;
> +       struct cxl_dport *target[];
> +};
> +
>  /**
>   * struct cxl_decoder - CXL address range decode configuration
>   * @dev: this decoder's device
> @@ -220,26 +232,60 @@ enum cxl_decoder_type {
>   * @interleave_granularity: data stride per dport
>   * @target_type: accelerator vs expander (type2 vs type3) selector
>   * @flags: memory type capabilities and locking
> - * @target_lock: coordinate coherent reads of the target list
> - * @nr_targets: number of elements in @target
> - * @target: active ordered target list in current decoder configuration
>   */
>  struct cxl_decoder {
>         struct device dev;
>         int id;
> -       union {
> -               struct resource platform_res;
> -               struct range decoder_range;
> -       };
>         int interleave_ways;
>         int interleave_granularity;
>         enum cxl_decoder_type target_type;
>         unsigned long flags;
> -       seqlock_t target_lock;
> -       int nr_targets;
> -       struct cxl_dport *target[];
>  };
>
> +/**
> + * struct cxl_endpoint_decoder - An decoder residing in a CXL endpoint.
> + * @base: Base class decoder
> + * @range: Host physical address space consumed by this decoder.
> + */
> +struct cxl_endpoint_decoder {
> +       struct cxl_decoder base;
> +       struct range range;
> +};
> +
> +/**
> + * struct cxl_switch_decoder - A decoder in a switch or hostbridge.
> + * @base: Base class decoder
> + * @range: Host physical address space consumed by this decoder.
> + * @targets: Downstream targets for this switch.
> + */
> +struct cxl_switch_decoder {
> +       struct cxl_decoder base;
> +       struct range range;
> +       struct cxl_decoder_targets *targets;
> +};
> +
> +/**
> + * struct cxl_root_decoder - A toplevel/platform decoder
> + * @base: Base class decoder
> + * @res: host address space owned by this decoder
> + * @targets: Downstream targets (ie. hostbridges).
> + */
> +struct cxl_root_decoder {
> +       struct cxl_decoder base;
> +       struct resource res;
> +       struct cxl_decoder_targets *targets;
> +};

This is what I had started to mock up, I think the only differences
are no out of line allocations, and the concept that endpoint decoders
need to track hpa, dpa, and skip. What do you think?

struct cxl_root_decoder {
       struct resource hpa;
       struct cxl_decoder decoder;
};

struct cxl_switch_decoder {
       struct range hpa_range;
       struct cxl_decoder decoder;
};

struct cxl_endpoint_decoder {
       struct resource *hpa_res;
       struct range dpa_range;
       struct range dpa_skip;
       struct cxl_decoder decoder;
};

Then at allocation it would be something like:

        if (is_cxl_root(port)) {
                struct cxl_root_decoder *cxlrd;

                cxlrd = kzalloc(struct_size(cxlrd, decoder.target, nr_targets),
                                GFP_KERNEL);
                if (!cxlrd)
                        return ERR_PTR(-ENOMEM);

                cxlrd->hpa = (struct resource)DEFINE_RES_MEM(0, 0);
                cxld = &cxlrd->decoder;
                cxld->dev.type = &cxl_decoder_root_type;
        } else if (is_cxl_endpoint(port)) {
                struct cxl_endpoint_decoder *cxled;

                cxled = kzalloc(struct_size(cxled, decoder.target, nr_targets),
                                GFP_KERNEL);
                if (!cxled)
                        return ERR_PTR(-ENOMEM);

                cxled->dpa_range = (struct range) {
                        .start = 0,
                        .end = -1,
                };
                cxled->dpa_skip = (struct range) {
                        .start = 0,
                        .end = -1,
                };

                cxld = &cxled->decoder;
                cxld->dev.type = &cxl_decoder_endpoint_type;
        } else {
                struct cxl_switch_decoder *cxlsd;

                cxlsd = kzalloc(struct_size(cxlsd, decoder.target, nr_targets),
                                GFP_KERNEL);
                if (!cxlsd)
                        return ERR_PTR(-ENOMEM);

                cxled->hpa_range = (struct range) {
                        .start = 0,
                        .end = -1,
                };

                cxld->dev.type = &cxl_decoder_switch_type;
                if (!cxld)
                        return ERR_PTR(-ENOMEM);
        }


> +
> +#define _to_cxl_decoder(x)                                                     \
> +       static inline struct cxl_##x##_decoder *to_cxl_##x##_decoder(          \
> +               struct cxl_decoder *cxld)                                      \
> +       {                                                                      \
> +               return container_of(cxld, struct cxl_##x##_decoder, base);     \
> +       }
> +
> +_to_cxl_decoder(root)
> +_to_cxl_decoder(switch)
> +_to_cxl_decoder(endpoint)

I notice no is_{root,switch,endpoint}_decoder() sanity checking like
our other to_$object() helpers, deliberate?

>
>  /**
>   * enum cxl_nvdimm_brige_state - state machine for managing bus rescans
> @@ -364,11 +410,61 @@ struct cxl_decoder *cxl_root_decoder_alloc(struct cxl_port *port,
>  struct cxl_decoder *cxl_switch_decoder_alloc(struct cxl_port *port,
>                                              unsigned int nr_targets);
>  int cxl_decoder_add(struct cxl_decoder *cxld, int *target_map);
> -struct cxl_decoder *cxl_endpoint_decoder_alloc(struct cxl_port *port);
> +struct cxl_endpoint_decoder *cxl_endpoint_decoder_alloc(struct cxl_port *port);
>  int cxl_decoder_add_locked(struct cxl_decoder *cxld, int *target_map);
>  int cxl_decoder_autoremove(struct device *host, struct cxl_decoder *cxld);
>  int cxl_endpoint_autoremove(struct cxl_memdev *cxlmd, struct cxl_port *endpoint);
>
> +static inline struct cxl_decoder_targets *
> +cxl_get_decoder_targets(struct cxl_decoder *cxld)
> +{
> +       if (is_root_decoder(&cxld->dev))
> +               return to_cxl_root_decoder(cxld)->targets;
> +       else if (is_endpoint_decoder(&cxld->dev))
> +               return NULL;
> +       else
> +               return to_cxl_switch_decoder(cxld)->targets;
> +}
> +
> +static inline void cxl_set_decoder_extent(struct cxl_decoder *cxld,
> +                                         resource_size_t base,
> +                                         resource_size_t size)
> +{
> +       if (is_root_decoder(&cxld->dev))
> +               to_cxl_root_decoder(cxld)->res =
> +                       (struct resource)DEFINE_RES_MEM(base, size);
> +       else if (is_endpoint_decoder(&cxld->dev))
> +               to_cxl_endpoint_decoder(cxld)->range = (struct range){
> +                       .start = base,
> +                       .end = base + size - 1
> +               };
> +       else
> +               to_cxl_switch_decoder(cxld)->range = (struct range){
> +                       .start = base,
> +                       .end = base + size - 1
> +               };
> +}
> +
> +static inline struct range cxl_get_decoder_extent(struct cxl_decoder *cxld)
> +{
> +       struct range ret;
> +
> +       if (is_root_decoder(&cxld->dev)) {
> +               struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(cxld);
> +
> +               ret = (struct range) {
> +                       .start = cxlrd->res.start,
> +                       .end = cxlrd->res.end
> +               };
> +       } else if (is_endpoint_decoder(&cxld->dev)) {
> +               ret = to_cxl_endpoint_decoder(cxld)->range;
> +       } else {
> +               ret = to_cxl_switch_decoder(cxld)->range;
> +       }
> +
> +       return ret;
> +}

The caller context will know what decoder type it is operating on, so
the conversion to a generic type only to convert back into the
specific type somewhat defeats the purpose of having distinct types in
the first place.
