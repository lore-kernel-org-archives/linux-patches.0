Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09B43A961E;
	Fri,  4 Sep 2026 05:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499119; cv=none; b=RM42Zgy8quHBJgcPliDbwgSWPxtumBc3yAon6qHv+6J4koe9H4TZaSTUdmzJUuGIot4ePd3WSw0dutmhMGgtgCGxvBh7LflMZqutriG2YPemlIKvCgLK8zePSh+zQWoxN+me7ZhSegjwKGcJyE25pYe8dzCOwD4cWELDWCR+d2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499119; c=relaxed/simple;
	bh=apLCPrRENTYGd9+dSraCAoyfp5tSVTmnX4jkB7IiQtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJ6U2e2dL2jHk6RpGFy+U7aJ3tpE6I17PeheJX265u/HzcLoz/gbqeNHjF0gWrHsRGNOziUcSPky8p9/xwzb4zhmssHhucspBSWymDo9pCH/W+qmEBtFJNog/2v3FMaQbbXgJJ88DW8NSof+bTxO3Dt8GAvp2ogfUxiZELZLLN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vkgB71ZU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vkgB71ZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A991F00A3D;
	Fri,  4 Sep 2026 05:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499117;
	bh=FP4FG6oTgoWx+HCjRCAzycFAZGw+MLnWp1nZ2Be8Yqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vkgB71ZU6t8IcU7cq630way4OxlVACMXLRBawK1vE+lzaMGLr2nsygK/gYJbTOg/S
	 ETo/fstGiJGeQyOCMR4CS1K+TW5pKGVZ4mfsczrbKdOm5GGbIUrzXns+me+7+pTv/g
	 rdf1RtXeZpBaw1yl0ODWGR7ONQo39X8UQ9C4CIDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julien <julien82453@gmail.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 7.2 302/713] ACPI: scan: Avoid registering platform devices with resource overlaps
Date: Fri,  4 Sep 2026 06:54:30 +0200
Message-ID: <20260904045810.610512373@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit f234fdaae1cad8c39265e7ca0a14633076ec7154 upstream.

If acpi_dev_get_resources() returns overlapping I/O or memory resources,
the subsequent registration of a platform device will fail with -EBUSY
due to a resource conflict.  This is reported to happen on Acer Aspire
ES1-572 [1].

Avoid that by adjusting resources returned by acpi_dev_get_resources()
to eliminate partial overlaps between them.

This has not been regarded as necessary before because putting
overlapping resources into the _CRS of one device is really pointless,
but now that the issue has been reported to actually happen in the
field, it needs to be done.

Fixes: ab06eb920401 ("ACPI: scan: Register platform devices for fixed event buttons")
Fixes: 48fe2cddc85c ("tpm_crb: Convert ACPI driver to a platform one")
Reported-by: Julien <julien82453@gmail.com>
Tested-by: Julien <julien82453@gmail.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Closes: https://lore.kernel.org/linux-integrity/CAJOGg3z6LJPDsdPNBxajgy8_wQxfhYBRxe4EiurZf3kPU5A5Bw@mail.gmail.com/ [1]
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ rjw: Tweaked the new message ]
Link: https://patch.msgid.link/12955541.O9o76ZdvQC@rafael.j.wysocki
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpi_platform.c | 39 ++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/acpi_platform.c b/drivers/acpi/acpi_platform.c
index a09636a4168e..373c94de7590 100644
--- a/drivers/acpi/acpi_platform.c
+++ b/drivers/acpi/acpi_platform.c
@@ -12,6 +12,7 @@
 #include <linux/bits.h>
 #include <linux/device.h>
 #include <linux/err.h>
+#include <linux/ioport.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
@@ -71,6 +72,36 @@ static struct notifier_block acpi_platform_notifier = {
 	.notifier_call = acpi_platform_device_remove_notify,
 };
 
+static unsigned int acpi_platform_adjust_resources(struct acpi_device *adev,
+						   struct resource *new_res,
+						   struct resource *resources,
+						   unsigned int count)
+{
+	unsigned int i;
+
+	if (!(new_res->flags & (IORESOURCE_IO | IORESOURCE_MEM)))
+		return count;
+
+	for (i = 0; i < count; ) {
+		struct resource *res = &resources[i];
+
+		if (resource_type(new_res) != resource_type(res) ||
+		    !resource_union(new_res, res, new_res)) {
+			i++;
+			continue;
+		}
+
+		dev_info(&adev->dev, "%pR expanded due to overlap\n", new_res);
+		/*
+		 * Eliminate the previously processed resource that overlapped
+		 * with the new one because it is not necessary any more.
+		 */
+		memmove(res, res + 1, (--count - i) * sizeof(*res));
+	}
+
+	return count;
+}
+
 static void acpi_platform_fill_resource(struct acpi_device *adev,
 	const struct resource *src, struct resource *dest)
 {
@@ -151,10 +182,14 @@ struct platform_device *acpi_create_platform_device(struct acpi_device *adev,
 				return ERR_PTR(-ENOMEM);
 			}
 			count = 0;
-			list_for_each_entry(rentry, &resource_list, node)
+			list_for_each_entry(rentry, &resource_list, node) {
+				count = acpi_platform_adjust_resources(adev,
+								       rentry->res,
+								       resources,
+								       count);
 				acpi_platform_fill_resource(adev, rentry->res,
 							    &resources[count++]);
-
+			}
 			acpi_dev_free_resource_list(&resource_list);
 		}
 	}
-- 
2.55.0



