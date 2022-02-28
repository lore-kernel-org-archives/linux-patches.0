Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D0B7C
	for <patches@lists.linux.dev>; Mon, 28 Feb 2022 23:48:55 +0000 (UTC)
Received: by mail-pg1-f180.google.com with SMTP id bc27so4032662pgb.4
        for <patches@lists.linux.dev>; Mon, 28 Feb 2022 15:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DOfnUjf5SHgujNAsrHnGqVklHv5zKhZ0N45BxsxhIUA=;
        b=dQ9xQTXfywCuB5hU2YoYvf1abO6mqawOrQDIuWF1+R+blXk6gC8cvW3MRwUF0FBvMZ
         smpm2Fi9VdOh5fqV7kSjCbjaYI2WxvOLP6plYfqzjkE8UB7nYwKY4VsH/WJ8Bh2VJcY5
         /VXt/rSsBWjpEAR0GlNMj5Zd36o+mstQ3kbHLHub5CBufUMHKWzPzcTonSIHmLGrXEie
         H2TeWsdn3J8MMT37raXizMziE6ITT+3WIFjLfzprOxO0ETuIrnLZvtGQ9Nk4tR8DFZaC
         Tt+px4ytihcYeXhsiJOaZdmW5VyFJeNsYRmLHKpfV1OAyK3aVXj5O0zKQ5jVEqapscaP
         T99w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DOfnUjf5SHgujNAsrHnGqVklHv5zKhZ0N45BxsxhIUA=;
        b=htdfnunhYFlFJ86uTpj60d1P9HjEpbZqNASfnRAc+OcyZ4ueTKTSlnxbW6ZGSQJsyI
         v66UDavYZCD9Y3aLPyVjZ5hOGx/HmHd51gDDeEDlOYPDxdTjInxiXpaev9Hbucl3qegF
         hlkgPGLF0ezuzUrRiLsPV531RUZWaB4o7np4Hv9Bh8SqUgJtSh0D3PKJVhT1rgAkH3JJ
         iwEwHwljeFiwSlzlrqv2eVh6BurdSQGYGlC+aMASRk3brnPQXUNnbvPzh/tf04/yJq7n
         sZSMXKDoogM9q7g6XEbOuqCQPh7q6+odFEcbz7rHm6U3Ln4kj8zcYK+RPcIb6AepZ3gL
         jGMA==
X-Gm-Message-State: AOAM533FsjB3THl9a3JP0zOjsOWmcBi3ixrAW85T/zf6rbC43zT9MA0Z
	2ikR8imyGIDwGqFkCmbYOsY3IwBuYFiJzHfjdloPAg==
X-Google-Smtp-Source: ABdhPJzyIw7zfTj3UTXoJenJvnLd2Oa6CNOXbQ7vTCOpFnEoaNECPudqAu81k8Olg2E+UOTTHYzeVcv7KfVts4wem/4=
X-Received: by 2002:a05:6a02:283:b0:342:703e:1434 with SMTP id
 bk3-20020a056a02028300b00342703e1434mr19646669pgb.74.1646092134768; Mon, 28
 Feb 2022 15:48:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220225060038.1511562-1-ben.widawsky@intel.com> <20220225060038.1511562-2-ben.widawsky@intel.com>
In-Reply-To: <20220225060038.1511562-2-ben.widawsky@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 28 Feb 2022 15:48:43 -0800
Message-ID: <CAPcyv4iqNEtbvL35tPFD_jDLB8t-1zetGfsRMXT_oNU8si6fAg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] cxl/region: Add region creation ABI
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, patches@lists.linux.dev, 
	Alison Schofield <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Vishal Verma <vishal.l.verma@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 24, 2022 at 10:01 PM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> Regions are created as a child of the decoder that encompasses an
> address space with constraints. Regions have a number of attributes that
> must be configured before the region can be activated.
>
> The ABI is not meant to be secure,

What does that mean? It's "secure" by virtue of only being root
writable and if root userspace process race themselves the kernel will
coherently handle the conflict and pick a winner.

> but is meant to avoid accidental
> races.

It also solves purposeful race.

>  As a result, a buggy process may create a region by name that was
> allocated by a different process.

That's not a bug, one process atomically claims the next region, the
other loops.

> However, multiple processes which are
> trying not to race with each other shouldn't need special
> synchronization to do so.
>
> // Allocate a new region name
> region=$(cat /sys/bus/cxl/devices/decoder0.0/create_region)
>
> // Create a new region by name
> while
> region=$(cat /sys/bus/cxl/devices/decoder0.0/create_region)
> ! echo $region > /sys/bus/cxl/devices/decoder0.0/create_region
> do true; done
>
> // Region now exists in sysfs
> stat -t /sys/bus/cxl/devices/decoder0.0/$region
>
> // Delete the region, and name
> echo $region > /sys/bus/cxl/devices/decoder0.0/delete_region
>
> Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
>
> ---
> Changes since v5 (all Dan):
> - Fix erroneous return on create
> - Fix ida leak on error
> - forward declare to_cxl_region instead of cxl_region_release
> - Use REGION_DEAD in the right place
> - Allocate next id in region_alloc
> ---
>  Documentation/ABI/testing/sysfs-bus-cxl       |  23 ++
>  .../driver-api/cxl/memory-devices.rst         |  11 +
>  drivers/cxl/core/Makefile                     |   1 +
>  drivers/cxl/core/core.h                       |   3 +
>  drivers/cxl/core/port.c                       |  18 ++
>  drivers/cxl/core/region.c                     | 223 ++++++++++++++++++
>  drivers/cxl/cxl.h                             |   5 +
>  drivers/cxl/region.h                          |  28 +++
>  tools/testing/cxl/Kbuild                      |   1 +
>  9 files changed, 313 insertions(+)
>  create mode 100644 drivers/cxl/core/region.c
>  create mode 100644 drivers/cxl/region.h
>
> diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
> index 7c2b846521f3..e5db45ea70ad 100644
> --- a/Documentation/ABI/testing/sysfs-bus-cxl
> +++ b/Documentation/ABI/testing/sysfs-bus-cxl
> @@ -163,3 +163,26 @@ Description:
>                 memory (type-3). The 'target_type' attribute indicates the
>                 current setting which may dynamically change based on what
>                 memory regions are activated in this decode hierarchy.
> +
> +What:          /sys/bus/cxl/devices/decoderX.Y/create_region
> +Date:          January, 2022
> +KernelVersion: v5.18
> +Contact:       linux-cxl@vger.kernel.org
> +Description:
> +               Write a value of the form 'regionX.Y:Z' to instantiate a new

Per internal conversation this will move to "write a value of the form
"%u", right?

> +               region within the decode range bounded by decoderX.Y. The value
> +               written must match the current value returned from reading this
> +               attribute. This behavior lets the kernel arbitrate racing
> +               attempts to create a region. The thread that fails to write
> +               loops and tries the next value. Regions must be created for root
> +               decoders,

Does this need to be stated? It's already implicit by the fact that
'create_region' does not appear on anything but root decoders.


>  and must subsequently configured and bound to a region
> +               driver before they can be used.
> +
> +What:          /sys/bus/cxl/devices/decoderX.Y/delete_region
> +Date:          January, 2022
> +KernelVersion: v5.18
> +Contact:       linux-cxl@vger.kernel.org
> +Description:
> +               Deletes the named region.  The attribute expects a region in the
> +               form "regionX.Y:Z". The region's name, allocated by reading
> +               create_region, will also be released.
> diff --git a/Documentation/driver-api/cxl/memory-devices.rst b/Documentation/driver-api/cxl/memory-devices.rst
> index db476bb170b6..66ddc58a21b1 100644
> --- a/Documentation/driver-api/cxl/memory-devices.rst
> +++ b/Documentation/driver-api/cxl/memory-devices.rst
> @@ -362,6 +362,17 @@ CXL Core
>  .. kernel-doc:: drivers/cxl/core/mbox.c
>     :doc: cxl mbox
>
> +CXL Regions
> +-----------
> +.. kernel-doc:: drivers/cxl/region.h
> +   :identifiers:
> +
> +.. kernel-doc:: drivers/cxl/core/region.c
> +   :doc: cxl core region
> +
> +.. kernel-doc:: drivers/cxl/core/region.c
> +   :identifiers:
> +
>  External Interfaces
>  ===================
>
> diff --git a/drivers/cxl/core/Makefile b/drivers/cxl/core/Makefile
> index 6d37cd78b151..39ce8f2f2373 100644
> --- a/drivers/cxl/core/Makefile
> +++ b/drivers/cxl/core/Makefile
> @@ -4,6 +4,7 @@ obj-$(CONFIG_CXL_BUS) += cxl_core.o
>  ccflags-y += -I$(srctree)/drivers/cxl
>  cxl_core-y := port.o
>  cxl_core-y += pmem.o
> +cxl_core-y += region.o
>  cxl_core-y += regs.o
>  cxl_core-y += memdev.o
>  cxl_core-y += mbox.o
> diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> index 1a50c0fc399c..adfd42370b28 100644
> --- a/drivers/cxl/core/core.h
> +++ b/drivers/cxl/core/core.h
> @@ -9,6 +9,9 @@ extern const struct device_type cxl_nvdimm_type;
>
>  extern struct attribute_group cxl_base_attribute_group;
>
> +extern struct device_attribute dev_attr_create_region;
> +extern struct device_attribute dev_attr_delete_region;
> +
>  struct cxl_send_command;
>  struct cxl_mem_query_commands;
>  int cxl_query_cmd(struct cxl_memdev *cxlmd,
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index 1e785a3affaa..f3e1313217a8 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -9,6 +9,7 @@
>  #include <linux/idr.h>
>  #include <cxlmem.h>
>  #include <cxlpci.h>
> +#include <region.h>
>  #include <cxl.h>
>  #include "core.h"
>
> @@ -213,6 +214,8 @@ static struct attribute_group cxl_decoder_base_attribute_group = {
>  };
>
>  static struct attribute *cxl_decoder_root_attrs[] = {
> +       &dev_attr_create_region.attr,
> +       &dev_attr_delete_region.attr,
>         &dev_attr_cap_pmem.attr,
>         &dev_attr_cap_ram.attr,
>         &dev_attr_cap_type2.attr,
> @@ -270,6 +273,8 @@ static void cxl_decoder_release(struct device *dev)
>         struct cxl_decoder *cxld = to_cxl_decoder(dev);
>         struct cxl_port *port = to_cxl_port(dev->parent);
>
> +       ida_free(&cxld->region_ida, cxld->next_region_id);
> +       ida_destroy(&cxld->region_ida);
>         ida_free(&port->decoder_ida, cxld->id);
>         kfree(cxld);
>  }
> @@ -1244,6 +1249,13 @@ static struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port,
>         cxld->target_type = CXL_DECODER_EXPANDER;
>         cxld->platform_res = (struct resource)DEFINE_RES_MEM(0, 0);
>
> +       mutex_init(&cxld->id_lock);
> +       ida_init(&cxld->region_ida);
> +       rc = ida_alloc(&cxld->region_ida, GFP_KERNEL);
> +       if (rc < 0)
> +               goto err;
> +
> +       cxld->next_region_id = rc;
>         return cxld;
>  err:
>         kfree(cxld);
> @@ -1502,6 +1514,12 @@ bool schedule_cxl_memdev_detach(struct cxl_memdev *cxlmd)
>  }
>  EXPORT_SYMBOL_NS_GPL(schedule_cxl_memdev_detach, CXL);
>
> +bool schedule_cxl_region_unregister(struct cxl_region *cxlr)
> +{
> +       return queue_work(cxl_bus_wq, &cxlr->unregister_work);
> +}
> +EXPORT_SYMBOL_NS_GPL(schedule_cxl_region_unregister, CXL);
> +
>  /* for user tooling to ensure port disable work has completed */
>  static ssize_t flush_store(struct bus_type *bus, const char *buf, size_t count)
>  {
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> new file mode 100644
> index 000000000000..a934938f8630
> --- /dev/null
> +++ b/drivers/cxl/core/region.c
> @@ -0,0 +1,223 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright(c) 2022 Intel Corporation. All rights reserved. */
> +#include <linux/device.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/idr.h>
> +#include <region.h>
> +#include <cxl.h>
> +#include "core.h"
> +
> +/**
> + * DOC: cxl core region
> + *
> + * CXL Regions represent mapped memory capacity in system physical address
> + * space. Whereas the CXL Root Decoders identify the bounds of potential CXL
> + * Memory ranges, Regions represent the active mapped capacity by the HDM
> + * Decoder Capability structures throughout the Host Bridges, Switches, and
> + * Endpoints in the topology.
> + */
> +
> +
> +static struct cxl_region *to_cxl_region(struct device *dev);

cxl_lock_class() will want to know the lock_class for the cxl_region
device lock, so this can go straight to be an extern declaration
alongside is_cxl_decoder().

> +
> +static void cxl_region_release(struct device *dev)
> +{
> +       struct cxl_decoder *cxld = to_cxl_decoder(dev->parent);
> +       struct cxl_region *cxlr = to_cxl_region(dev);
> +
> +       dev_dbg(&cxld->dev, "Releasing %s\n", dev_name(dev));
> +       ida_free(&cxld->region_ida, cxlr->id);
> +       kfree(cxlr);
> +       put_device(&cxld->dev);
> +}
> +
> +static const struct device_type cxl_region_type = {
> +       .name = "cxl_region",
> +       .release = cxl_region_release,
> +};
> +
> +static struct cxl_region *to_cxl_region(struct device *dev)
> +{
> +       if (dev_WARN_ONCE(dev, dev->type != &cxl_region_type,
> +                         "not a cxl_region device\n"))
> +               return NULL;
> +
> +       return container_of(dev, struct cxl_region, dev);
> +}
> +
> +static void unregister_region(struct work_struct *work)
> +{
> +       struct cxl_region *cxlr;
> +
> +       cxlr = container_of(work, typeof(*cxlr), unregister_work);
> +       device_unregister(&cxlr->dev);
> +}
> +
> +static void schedule_unregister(void *cxlr)
> +{
> +       schedule_cxl_region_unregister(cxlr);
> +}
> +
> +static struct cxl_region *cxl_region_alloc(struct cxl_decoder *cxld)
> +{
> +       struct cxl_region *cxlr;
> +       struct device *dev;
> +       int rc;
> +
> +       lockdep_assert_held(&cxld->id_lock);
> +
> +       rc = ida_alloc(&cxld->region_ida, GFP_KERNEL);
> +       if (rc < 0) {
> +               dev_dbg(dev, "Failed to get next cached id (%d)\n", rc);
> +               return ERR_PTR(rc);
> +       }
> +
> +       cxlr = kzalloc(sizeof(*cxlr), GFP_KERNEL);
> +       if (!cxlr) {
> +               ida_free(&cxld->region_ida, rc);
> +               return ERR_PTR(-ENOMEM);
> +       }
> +
> +       cxld->next_region_id = rc;
> +
> +       dev = &cxlr->dev;
> +       device_initialize(dev);
> +       dev->parent = &cxld->dev;
> +       device_set_pm_not_required(dev);
> +       dev->bus = &cxl_bus_type;
> +       dev->type = &cxl_region_type;
> +       INIT_WORK(&cxlr->unregister_work, unregister_region);

Perhaps name it "detach_work" to match the same for memdevs, or second
choice, go rename the memdev one to "unregister_work". Keep the naming
consistent for data structures that fill the same role.

> +
> +       return cxlr;
> +}
> +
> +/**
> + * devm_cxl_add_region - Adds a region to a decoder
> + * @cxld: Parent decoder.
> + * @cxlr: Region to be added to the decoder.
> + *
> + * This is the second step of region initialization. Regions exist within an
> + * address space which is mapped by a @cxld. That @cxld must be a root decoder,
> + * and it enforces constraints upon the region as it is configured.
> + *
> + * Return: 0 if the region was added to the @cxld, else returns negative error
> + * code. The region will be named "regionX.Y.Z" where X is the port, Y is the
> + * decoder id, and Z is the region number.
> + */
> +static struct cxl_region *devm_cxl_add_region(struct cxl_decoder *cxld)
> +{
> +       struct cxl_port *port = to_cxl_port(cxld->dev.parent);
> +       struct cxl_region *cxlr;
> +       struct device *dev;
> +       int rc;
> +
> +       cxlr = cxl_region_alloc(cxld);
> +       if (IS_ERR(cxlr))
> +               return cxlr;
> +
> +       dev = &cxlr->dev;
> +
> +       cxlr->id = cxld->next_region_id;
> +       rc = dev_set_name(dev, "region%d.%d:%d", port->id, cxld->id, cxlr->id);
> +       if (rc)
> +               goto err_out;
> +
> +       /* affirm that release will have access to the decoder's region ida  */

s/affirm that release will/arrange for cxl_region_release to/

> +       get_device(&cxld->dev);
> +
> +       rc = device_add(dev);
> +       if (rc)
> +               goto err_put;
> +
> +       rc = devm_add_action_or_reset(port->uport, schedule_unregister, cxlr);
> +       if (rc)
> +               goto err_put;
> +
> +       return cxlr;
> +
> +err_put:
> +       put_device(&cxld->dev);
> +
> +err_out:
> +       put_device(dev);
> +       return ERR_PTR(rc);
> +}
> +
> +static ssize_t create_region_show(struct device *dev,
> +                                 struct device_attribute *attr, char *buf)
> +{
> +       struct cxl_port *port = to_cxl_port(dev->parent);
> +       struct cxl_decoder *cxld = to_cxl_decoder(dev);
> +
> +       return sysfs_emit(buf, "region%d.%d:%d\n", port->id, cxld->id,
> +                         cxld->next_region_id);

To cut down on userspace racing itself this should acquire the id_lock
to synchronize against the store side. i.e. no point in returning
known bad answers when the lock is held on the store side, even though
the answer given here may be immediately invalidated as soon as the
lock is dropped it's still useful to throttle readers in the presence
of writers.

> +}
> +
> +static ssize_t create_region_store(struct device *dev,
> +                                  struct device_attribute *attr,
> +                                  const char *buf, size_t len)
> +{
> +       struct cxl_port *port = to_cxl_port(dev->parent);
> +       struct cxl_decoder *cxld = to_cxl_decoder(dev);
> +       struct cxl_region *cxlr;
> +       int d, p, r, rc = 0;
> +
> +       if (sscanf(buf, "region%d.%d:%d", &p, &d, &r) != 3)
> +               return -EINVAL;
> +
> +       if (port->id != p || cxld->id != d)
> +               return -EINVAL;
> +
> +       rc = mutex_lock_interruptible(&cxld->id_lock);
> +       if (rc)
> +               return rc;
> +
> +       if (cxld->next_region_id != r) {
> +               rc = -EINVAL;
> +               goto out;
> +       }
> +
> +       cxlr = devm_cxl_add_region(cxld);
> +       rc = 0;
> +       dev_dbg(dev, "Created %s\n", dev_name(&cxlr->dev));
> +
> +out:
> +       mutex_unlock(&cxld->id_lock);
> +       if (rc)
> +               return rc;
> +       return len;
> +}
> +DEVICE_ATTR_RW(create_region);
> +
> +static struct cxl_region *cxl_find_region_by_name(struct cxl_decoder *cxld,
> +                                                 const char *name)
> +{
> +       struct device *region_dev;
> +
> +       region_dev = device_find_child_by_name(&cxld->dev, name);
> +       if (!region_dev)
> +               return ERR_PTR(-ENOENT);
> +
> +       return to_cxl_region(region_dev);
> +}
> +
> +static ssize_t delete_region_store(struct device *dev,
> +                                  struct device_attribute *attr,
> +                                  const char *buf, size_t len)
> +{
> +       struct cxl_port *port = to_cxl_port(dev->parent);
> +       struct cxl_decoder *cxld = to_cxl_decoder(dev);
> +       struct cxl_region *cxlr;
> +
> +       cxlr = cxl_find_region_by_name(cxld, buf);
> +       if (IS_ERR(cxlr))
> +               return PTR_ERR(cxlr);
> +
> +       if (!test_and_set_bit(REGION_DEAD, &cxlr->flags))
> +               devm_release_action(port->uport, schedule_unregister, cxlr);

Where is the synchronization against port ->remove()? That could have
started before this sysfs file was deleted and trigger double
device_unregister(). Also while any workqueue thread may want to
access the region a reference needs to be held otherwise you can get a
use after free. I expect that this should unconditionally schedule the
unregister work, then in the workqueue check that only one invocation
actually performs the unregistration.

Given that the work is only related to unregistration this can fail
requests to delete something that has already been deleted. If
userspace sees that error and wants to synchronize it can use the
bus/flush attribute for that. I.e.

if (work_pending(&cxlr->detach_work))
   return -EBUSY;

> +       put_device(&cxlr->dev);
> +
> +       return len;
> +}
> +DEVICE_ATTR_WO(delete_region);
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index b4047a310340..d5397f7dfcf4 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -221,6 +221,8 @@ enum cxl_decoder_type {
>   * @target_type: accelerator vs expander (type2 vs type3) selector
>   * @flags: memory type capabilities and locking
>   * @target_lock: coordinate coherent reads of the target list
> + * @region_ida: allocator for region ids.
> + * @next_region_id: Cached region id for next region.
>   * @nr_targets: number of elements in @target
>   * @target: active ordered target list in current decoder configuration
>   */
> @@ -236,6 +238,9 @@ struct cxl_decoder {
>         enum cxl_decoder_type target_type;
>         unsigned long flags;
>         seqlock_t target_lock;
> +       struct mutex id_lock;
> +       struct ida region_ida;
> +       int next_region_id;
>         int nr_targets;
>         struct cxl_dport *target[];
>  };
> diff --git a/drivers/cxl/region.h b/drivers/cxl/region.h
> new file mode 100644
> index 000000000000..7025f6785f83
> --- /dev/null
> +++ b/drivers/cxl/region.h
> @@ -0,0 +1,28 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/* Copyright(c) 2021 Intel Corporation. */
> +#ifndef __CXL_REGION_H__
> +#define __CXL_REGION_H__
> +
> +#include <linux/uuid.h>
> +
> +#include "cxl.h"
> +
> +/**
> + * struct cxl_region - CXL region
> + * @dev: This region's device.
> + * @id: This region's id. Id is globally unique across all regions.
> + * @flags: Flags representing the current state of the region.
> + * @unregister_work: Async unregister to allow attrs to take device_lock.
> + */
> +struct cxl_region {
> +       struct device dev;
> +       int id;
> +       unsigned long flags;
> +#define REGION_DEAD 0
> +       struct work_struct unregister_work;
> +
> +};
> +
> +bool schedule_cxl_region_unregister(struct cxl_region *cxlr);
> +
> +#endif
> diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
> index 82e49ab0937d..3fe6d34e6d59 100644
> --- a/tools/testing/cxl/Kbuild
> +++ b/tools/testing/cxl/Kbuild
> @@ -46,6 +46,7 @@ cxl_core-y += $(CXL_CORE_SRC)/memdev.o
>  cxl_core-y += $(CXL_CORE_SRC)/mbox.o
>  cxl_core-y += $(CXL_CORE_SRC)/pci.o
>  cxl_core-y += $(CXL_CORE_SRC)/hdm.o
> +cxl_core-y += $(CXL_CORE_SRC)/region.o
>  cxl_core-y += config_check.o
>
>  obj-m += test/
> --
> 2.35.1
>
