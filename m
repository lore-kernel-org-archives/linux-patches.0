Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EFB7C
	for <patches@lists.linux.dev>; Wed, 14 Dec 2022 00:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670977542; x=1702513542;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+oFV1Wy9CftKO7nx/MXEO4skZVyVvCs49jK/ZpEDV2s=;
  b=KwYKEn6OrIz69ULDojAGAXyXsMIYeOlz7aMFGNNgyW3FzxsbBu4ICMZS
   lBI/pik8IXLuQib3nWwiQG2iRAtYX2lUgxg2hxefR3VcSNjQlsRb8ULzY
   UierFy55S67RRC1gnGWioYVGnuyxckqNQiQVSabB4OzoeFYdTQxMhwW+z
   uyDCG+Yk6PPavUuEnavkX2RfEjE78CiENtQDpo852LLDuuzM6YEPiLnpu
   an5uM3sSqRDp8O+85eAlaAQJDloF7k52BNjgtDdTySlhutvNxPeXZmPFa
   fgZPA0QikAQwGPr/4mH9jSzzIvIKhkGmIu17D4G0WOQnE6ItazyuBGv3B
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="404540178"
X-IronPort-AV: E=Sophos;i="5.96,242,1665471600"; 
   d="scan'208";a="404540178"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 16:25:42 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="823084756"
X-IronPort-AV: E=Sophos;i="5.96,242,1665471600"; 
   d="scan'208";a="823084756"
Received: from mesplin-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.37.170])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 16:25:38 -0800
Subject: [ndctl PATCH 3/5] cxl/lib: Add cxl_wait_probe()
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: vishal.l.verma@intel.com, vishal.l.verma@intel.com, patches@lists.linux.dev
Date: Tue, 13 Dec 2022 16:25:38 -0800
Message-ID: <167097753806.1189953.10374103420436168237.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <167097752151.1189953.3189708700022130101.stgit@dwillia2-xfh.jf.intel.com>
References: <167097752151.1189953.3189708700022130101.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In preparation for the kernel performing more bus actions asynchronously,
arrange for all topolgy parsing to quiesce the cxl_bus_wq and the udev
queue.

This also obviates the need for 'udevadm settle' sprinkled throughout the
test code.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 cxl/lib/libcxl.c          |   91 +++++++++++++++++++++++++++++++++++----------
 cxl/lib/meson.build       |    1 
 cxl/lib/private.h         |    1 
 test/cxl-create-region.sh |    2 -
 test/cxl-labels.sh        |    1 
 test/cxl-region-sysfs.sh  |    1 
 test/cxl-topology.sh      |    1 
 7 files changed, 73 insertions(+), 25 deletions(-)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index dd7161fee50e..abc73440e4a3 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -43,6 +43,9 @@ struct cxl_ctx {
 	void *userdata;
 	int memdevs_init;
 	int buses_init;
+	unsigned long timeout;
+	struct udev *udev;
+	struct udev_queue *udev_queue;
 	struct list_head memdevs;
 	struct list_head buses;
 	struct kmod_ctx *kmod_ctx;
@@ -229,7 +232,9 @@ CXL_EXPORT void *cxl_get_private_data(struct cxl_ctx *ctx)
  */
 CXL_EXPORT int cxl_new(struct cxl_ctx **ctx)
 {
+	struct udev_queue *udev_queue;
 	struct kmod_ctx *kmod_ctx;
+	struct udev *udev;
 	struct cxl_ctx *c;
 	int rc = 0;
 
@@ -240,7 +245,19 @@ CXL_EXPORT int cxl_new(struct cxl_ctx **ctx)
 	kmod_ctx = kmod_new(NULL, NULL);
 	if (check_kmod(kmod_ctx) != 0) {
 		rc = -ENXIO;
-		goto out;
+		goto err_kmod;
+	}
+
+	udev = udev_new();
+	if (!udev) {
+		rc = -ENOMEM;
+		goto err_udev;
+	}
+
+	udev_queue = udev_queue_new(udev);
+	if (!udev_queue) {
+		rc = -ENOMEM;
+		goto err_udev_queue;
 	}
 
 	c->refcount = 1;
@@ -251,9 +268,17 @@ CXL_EXPORT int cxl_new(struct cxl_ctx **ctx)
 	list_head_init(&c->memdevs);
 	list_head_init(&c->buses);
 	c->kmod_ctx = kmod_ctx;
+	c->udev = udev;
+	c->udev_queue = udev_queue;
+	c->timeout = 5000;
 
 	return 0;
-out:
+
+err_udev_queue:
+	udev_queue_unref(udev_queue);
+err_udev:
+	kmod_unref(kmod_ctx);
+err_kmod:
 	free(c);
 	return rc;
 }
@@ -294,16 +319,13 @@ CXL_EXPORT void cxl_unref(struct cxl_ctx *ctx)
 	list_for_each_safe(&ctx->buses, bus, _b, port.list)
 		free_bus(bus, &ctx->buses);
 
+	udev_queue_unref(ctx->udev_queue);
+	udev_unref(ctx->udev);
 	kmod_unref(ctx->kmod_ctx);
 	info(ctx, "context %p released\n", ctx);
 	free(ctx);
 }
 
-static int cxl_flush(struct cxl_ctx *ctx)
-{
-	return sysfs_write_attr(ctx, "/sys/bus/cxl/flush", "1\n");
-}
-
 /**
  * cxl_set_log_fn - override default log routine
  * @ctx: cxl library context
@@ -565,6 +587,40 @@ err_path:
 	return NULL;
 }
 
+static int cxl_flush(struct cxl_ctx *ctx)
+{
+	return sysfs_write_attr(ctx, "/sys/bus/cxl/flush", "1\n");
+}
+
+static int cxl_wait_probe(struct cxl_ctx *ctx)
+{
+	unsigned long tmo = ctx->timeout;
+	int rc, sleep = 0;
+
+	do {
+		rc = cxl_flush(ctx);
+		if (rc < 0)
+			break;
+		if (udev_queue_get_queue_is_empty(ctx->udev_queue))
+			break;
+		sleep++;
+		usleep(1000);
+	} while (ctx->timeout == 0 || tmo-- != 0);
+
+	if (sleep)
+		dbg(ctx, "waited %d millisecond%s...\n", sleep,
+		    sleep == 1 ? "" : "s");
+
+	return rc < 0 ? -ENXIO : 0;
+}
+
+static int device_parse(struct cxl_ctx *ctx, const char *base_path,
+			const char *dev_name, void *parent, add_dev_fn add_dev)
+{
+	cxl_wait_probe(ctx);
+	return sysfs_device_parse(ctx, base_path, dev_name, parent, add_dev);
+}
+
 static void cxl_regions_init(struct cxl_decoder *decoder)
 {
 	struct cxl_port *port = cxl_decoder_get_port(decoder);
@@ -579,8 +635,7 @@ static void cxl_regions_init(struct cxl_decoder *decoder)
 
 	decoder->regions_init = 1;
 
-	sysfs_device_parse(ctx, decoder->dev_path, "region", decoder,
-			   add_cxl_region);
+	device_parse(ctx, decoder->dev_path, "region", decoder, add_cxl_region);
 }
 
 CXL_EXPORT struct cxl_region *cxl_region_get_first(struct cxl_decoder *decoder)
@@ -1157,7 +1212,7 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 		goto err_read;
 	memdev->buf_len = strlen(cxlmem_base) + 50;
 
-	sysfs_device_parse(ctx, cxlmem_base, "pmem", memdev, add_cxl_pmem);
+	device_parse(ctx, cxlmem_base, "pmem", memdev, add_cxl_pmem);
 
 	cxl_memdev_foreach(ctx, memdev_dup)
 		if (memdev_dup->id == memdev->id) {
@@ -1188,8 +1243,7 @@ static void cxl_memdevs_init(struct cxl_ctx *ctx)
 
 	ctx->memdevs_init = 1;
 
-	sysfs_device_parse(ctx, "/sys/bus/cxl/devices", "mem", ctx,
-			   add_cxl_memdev);
+	device_parse(ctx, "/sys/bus/cxl/devices", "mem", ctx, add_cxl_memdev);
 }
 
 CXL_EXPORT struct cxl_ctx *cxl_memdev_get_ctx(struct cxl_memdev *memdev)
@@ -1559,8 +1613,7 @@ static void cxl_endpoints_init(struct cxl_port *port)
 
 	port->endpoints_init = 1;
 
-	sysfs_device_parse(ctx, port->dev_path, "endpoint", port,
-			   add_cxl_endpoint);
+	device_parse(ctx, port->dev_path, "endpoint", port, add_cxl_endpoint);
 }
 
 CXL_EXPORT struct cxl_ctx *cxl_endpoint_get_ctx(struct cxl_endpoint *endpoint)
@@ -1927,8 +1980,7 @@ static void cxl_decoders_init(struct cxl_port *port)
 
 	port->decoders_init = 1;
 
-	sysfs_device_parse(ctx, port->dev_path, decoder_fmt, port,
-			   add_cxl_decoder);
+	device_parse(ctx, port->dev_path, decoder_fmt, port, add_cxl_decoder);
 
 	free(decoder_fmt);
 }
@@ -2387,7 +2439,7 @@ static void cxl_ports_init(struct cxl_port *port)
 
 	port->ports_init = 1;
 
-	sysfs_device_parse(ctx, port->dev_path, "port", port, add_cxl_port);
+	device_parse(ctx, port->dev_path, "port", port, add_cxl_port);
 }
 
 CXL_EXPORT struct cxl_ctx *cxl_port_get_ctx(struct cxl_port *port)
@@ -2655,7 +2707,7 @@ static void cxl_dports_init(struct cxl_port *port)
 
 	port->dports_init = 1;
 
-	sysfs_device_parse(ctx, port->dev_path, "dport", port, add_cxl_dport);
+	device_parse(ctx, port->dev_path, "dport", port, add_cxl_dport);
 }
 
 CXL_EXPORT int cxl_port_get_nr_dports(struct cxl_port *port)
@@ -2771,8 +2823,7 @@ static void cxl_buses_init(struct cxl_ctx *ctx)
 
 	ctx->buses_init = 1;
 
-	sysfs_device_parse(ctx, "/sys/bus/cxl/devices", "root", ctx,
-			   add_cxl_bus);
+	device_parse(ctx, "/sys/bus/cxl/devices", "root", ctx, add_cxl_bus);
 }
 
 CXL_EXPORT struct cxl_bus *cxl_bus_get_first(struct cxl_ctx *ctx)
diff --git a/cxl/lib/meson.build b/cxl/lib/meson.build
index eba0ce7278e7..60b9de7e940d 100644
--- a/cxl/lib/meson.build
+++ b/cxl/lib/meson.build
@@ -15,6 +15,7 @@ cxl = library('cxl',
   dependencies : [
     uuid,
     kmod,
+    libudev,
   ],
   version : libcxl_version,
   install : true,
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index 2d89241cd18d..81d6face263a 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -4,6 +4,7 @@
 #define _LIBCXL_PRIVATE_H_
 
 #include <libkmod.h>
+#include <libudev.h>
 #include <cxl/cxl_mem.h>
 #include <ccan/endian/endian.h>
 #include <ccan/short_types/short_types.h>
diff --git a/test/cxl-create-region.sh b/test/cxl-create-region.sh
index 47aed44848ab..02161661b28f 100644
--- a/test/cxl-create-region.sh
+++ b/test/cxl-create-region.sh
@@ -15,7 +15,6 @@ check_prereq "jq"
 modprobe -r cxl_test
 modprobe cxl_test
 rc=1
-udevadm settle
 
 destroy_regions()
 {
@@ -97,7 +96,6 @@ create_subregions()
 			echo "create sub-region failed for $decoder / $mem"
 			err "$LINENO"
 		fi
-		udevadm settle
 	done
 
 	echo "created $num_regions subregions:"
diff --git a/test/cxl-labels.sh b/test/cxl-labels.sh
index 3bf1e6e995b6..b38ca2f4693f 100644
--- a/test/cxl-labels.sh
+++ b/test/cxl-labels.sh
@@ -15,7 +15,6 @@ check_prereq "jq"
 modprobe -r cxl_test
 modprobe cxl_test
 rc=1
-udevadm settle
 
 test_label_ops()
 {
diff --git a/test/cxl-region-sysfs.sh b/test/cxl-region-sysfs.sh
index e128406cd8c8..863639271afa 100644
--- a/test/cxl-region-sysfs.sh
+++ b/test/cxl-region-sysfs.sh
@@ -15,7 +15,6 @@ check_prereq "jq"
 modprobe -r cxl_test
 modprobe cxl_test
 rc=1
-udevadm settle
 
 # THEORY OF OPERATION: Create a x8 interleave across the pmem capacity
 # of the 8 endpoints defined by cxl_test, commit the decoders (which
diff --git a/test/cxl-topology.sh b/test/cxl-topology.sh
index 362fffa6d539..fc3bbbe6b84a 100644
--- a/test/cxl-topology.sh
+++ b/test/cxl-topology.sh
@@ -15,7 +15,6 @@ check_prereq "jq"
 modprobe -r cxl_test
 modprobe cxl_test
 rc=1
-udevadm settle
 
 # THEORY OF OPERATION: Validate the hard coded assumptions of the
 # cxl_test.ko module that defines its topology in

