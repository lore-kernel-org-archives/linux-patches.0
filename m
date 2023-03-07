Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3D0BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:59:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D42C4339B;
	Tue,  7 Mar 2023 18:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215589;
	bh=zFcTd643dyZEnOb+zT4R+fpPWmEFGBOWQY3ICI73bZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YPi/KC9VKYTDsJeGYYUC+RsxTiYu1fBHHeIHNUFzS4BWhROMoVgRpA5op5oBSdNSp
	 9RcFdsQKYaD3OafJDIC9l7KDz72AmRNXvrs9WC3TBXJGb/aYC4DCOaFTb4/cFVAAsL
	 8H3uL08gIf0/1evF7RFt5lohn4tvSOzdIbnYuJ3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 293/567] ACPI: resource: Add helper function acpi_dev_get_memory_resources()
Date: Tue,  7 Mar 2023 18:00:29 +0100
Message-Id: <20230307165918.588528477@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

[ Upstream commit 6bb057bfd9d509755349cd2a6ca5e5e6e6071304 ]

Wrapper function that finds all memory type resources by
using acpi_dev_get_resources(). It removes the need for the
drivers to check the resource data type separately.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: c3194949ae8f ("usb: typec: intel_pmc_mux: Don't leak the ACPI device reference count")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 17 +++++++++++++++++
 include/linux/acpi.h    |  1 +
 2 files changed, 18 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index f6317bc417ab1..3b9f894873365 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -788,6 +788,23 @@ int acpi_dev_get_dma_resources(struct acpi_device *adev, struct list_head *list)
 }
 EXPORT_SYMBOL_GPL(acpi_dev_get_dma_resources);
 
+/**
+ * acpi_dev_get_memory_resources - Get current memory resources of a device.
+ * @adev: ACPI device node to get the resources for.
+ * @list: Head of the resultant list of resources (must be empty).
+ *
+ * This is a helper function that locates all memory type resources of @adev
+ * with acpi_dev_get_resources().
+ *
+ * The number of resources in the output list is returned on success, an error
+ * code reflecting the error condition is returned otherwise.
+ */
+int acpi_dev_get_memory_resources(struct acpi_device *adev, struct list_head *list)
+{
+	return acpi_dev_get_resources(adev, list, is_memory, NULL);
+}
+EXPORT_SYMBOL_GPL(acpi_dev_get_memory_resources);
+
 /**
  * acpi_dev_filter_resource_type - Filter ACPI resource according to resource
  *				   types
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 2d7df5cea2494..a23a5aea9c817 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -484,6 +484,7 @@ int acpi_dev_get_resources(struct acpi_device *adev, struct list_head *list,
 			   void *preproc_data);
 int acpi_dev_get_dma_resources(struct acpi_device *adev,
 			       struct list_head *list);
+int acpi_dev_get_memory_resources(struct acpi_device *adev, struct list_head *list);
 int acpi_dev_filter_resource_type(struct acpi_resource *ares,
 				  unsigned long types);
 
-- 
2.39.2



