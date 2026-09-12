Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFE8400DF6;
	Sat, 12 Sep 2026 09:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203957; cv=none; b=l72VQyypz83sFdY3YNlvGsGNPuGOwNvIgsboOkx6L7fAJg5GCa/OY0uy1ffuyHmSKp2Qs7yUWymt1MfUj3Y40IjRZNAuOmFgkbIQYHEi+G+hrhtSMP5lTZeF+Go4/91jSTG6fUdNd10XA1t776NRUmpN35Elmx1zw6FDE2ttpjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203957; c=relaxed/simple;
	bh=hbv8OHTrk7ukVS1zpRkvMfFcHiOWYLrTf3g49gD421s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjeLHjM3CHEuhAhMJNd0v1eBx0BKqm1WT2V3WSBlHQ0sxW4rokPGOe6jiFH7ag2pvSWECm5dSNC9fVjXVLZQe+Ey11O9zi7z9hly+IM737upeTSOVtnFS4ootr/DKOK6wZsxkMkR86U9bL0LqDPyeIEJKPOP+/HIizHKgn502Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uA8KYO66; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uA8KYO66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 195EA1F000FF;
	Sat, 12 Sep 2026 09:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203956;
	bh=Tp0u0QSJrHu9MF5XBCGAluBBHBG6VaKexpTdynPHe1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uA8KYO663rSXa0ijQyaesentvASmatUkzJ6IzhfTksEJ/nOhsLLnrcrtuvHc7DlDC
	 m3rib2C75igFvgyAWm9DiCCZUXo1yzB4fHFduje4DEy+IYXWmTBGbgV8nCRflM2xYL
	 n4ONXZJB9fPhc/X4aZHDmAnmDiLdI74Fat9yPbog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1461/1815] ACPI: platform: Use acpi_bus_get_primary_device()
Date: Sat, 12 Sep 2026 08:53:31 +0200
Message-ID: <20260912065723.310957516@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

[ Upstream commit a9ba4dd2f18bf3f439d9ef0d8f375f90360ba1bd ]

The acpi_get_first_physical_node() usage in acpi_platform_fill_resource()
and acpi_create_platform_device() is generally unsafe because in theory
the device returned by it may be freed at any time [1].

It is also inefficient because acpi_get_first_physical_node() is called
multiple times for the same argument which can be avoided.

Address these issues by using acpi_bus_get_primary_device() instead of
acpi_get_first_physical_node() and adjusting the code to call it just
once at the beginning of and acpi_create_platform_device() and drop
the device reference acquired by it upon the return from that function.

Fixes: 3b95bd160547 ("ACPI: introduce a function to find the first physical device")
Fixes: a252d881c558 ("ACPI / platform: Pay attention to parent device's resources")
Link: https://sashiko.dev/#/patchset/12955541.O9o76ZdvQC%40rafael.j.wysocki [1]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/3436112.aeNJFYEL58@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_platform.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/acpi_platform.c b/drivers/acpi/acpi_platform.c
index e3c77a65f61c8..80ea7121744d0 100644
--- a/drivers/acpi/acpi_platform.c
+++ b/drivers/acpi/acpi_platform.c
@@ -108,18 +108,15 @@ static unsigned int acpi_platform_adjust_resources(struct acpi_device *adev,
 	return count;
 }
 
-static void acpi_platform_fill_resource(struct acpi_device *adev,
-	const struct resource *src, struct resource *dest)
+static void acpi_platform_fill_resource(struct device *parent,
+					const struct resource *src,
+					struct resource *dest)
 {
-	struct device *parent;
-
 	*dest = *src;
-
 	/*
 	 * If the device has parent we need to take its resources into
 	 * account as well because this device might consume part of those.
 	 */
-	parent = acpi_get_first_physical_node(acpi_dev_parent(adev));
 	if (parent && dev_is_pci(parent))
 		dest->parent = pci_find_resource(to_pci_dev(parent), dest);
 }
@@ -147,7 +144,8 @@ static unsigned int acpi_platform_resource_count(struct acpi_resource *ares, voi
 struct platform_device *acpi_create_platform_device(struct acpi_device *adev,
 						    const struct property_entry *properties)
 {
-	struct acpi_device *parent = acpi_dev_parent(adev);
+	struct acpi_device *p = acpi_dev_parent(adev);
+	struct device *parent __free(put_device) = acpi_bus_get_primary_device(p);
 	struct platform_device *pdev = NULL;
 	struct platform_device_info pdevinfo;
 	const struct acpi_device_id *match;
@@ -193,7 +191,7 @@ struct platform_device *acpi_create_platform_device(struct acpi_device *adev,
 								       rentry->res,
 								       resources,
 								       count);
-				acpi_platform_fill_resource(adev, rentry->res,
+				acpi_platform_fill_resource(parent, rentry->res,
 							    &resources[count++]);
 			}
 			acpi_dev_free_resource_list(&resource_list);
@@ -206,7 +204,7 @@ struct platform_device *acpi_create_platform_device(struct acpi_device *adev,
 	 * attached to it, that physical device should be the parent of the
 	 * platform device we are about to create.
 	 */
-	pdevinfo.parent = parent ? acpi_get_first_physical_node(parent) : NULL;
+	pdevinfo.parent = parent;
 	pdevinfo.name = dev_name(&adev->dev);
 	pdevinfo.id = PLATFORM_DEVID_NONE;
 	pdevinfo.res = resources;
-- 
2.53.0



