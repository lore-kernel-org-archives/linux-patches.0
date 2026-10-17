Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE94D3C8C68;
	Sat, 17 Oct 2026 16:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255524; cv=none; b=qHy8gUiesBhU+SVOqRt/2H/xsJyDdLYofMGvTmA8gNTpjZqH01bsEtc9XWIf/wsLmSB4SfL9mexWhaDYD4At95plnvpOqeEfFJAFVLESBMjHYoKGyllc3FUfRmkOHVZSRSeGYiaBDk+hcQvXyWQXwNEvsJn0vcVe/vYQbqAtISw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255524; c=relaxed/simple;
	bh=AwCIhM/d9wUkJEb2MEqLAfyCTeESuvNjuKqH4sfABaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKb+5/BadgnN0QAdGCNojTkoZSVhJrbrrl/+FvjfvhqGGoxFxiPHPdTf5+y3gAyFywBmIJSEGqyc19rd9YQupuNwqJLek6eq9mLLJwjhJvt0bBjf2qldQZmCtnMcx80l4qz3J01BUMybriDL2MA37A5bQBY3a/TJa0V85G5EsD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wdRNt+EI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wdRNt+EI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C14A1F000C4;
	Sat, 17 Oct 2026 16:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255521;
	bh=oV6XxPZ1S/zejOhMMxTx6j78SEabD2kvij6cIRwSFdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wdRNt+EIN2EsuZ77g/Rw3GycGftbXd1+4V8UlmciO0Vufy9rYzGpcb5jHZV5pBMYO
	 z58cQaZ8t1vyjHJN0exqYApB2ToyWhHtjCsf85cENxlwTyZvu1xHKLfysud10uc92x
	 QbgWzbZTr7CISumD9rmE7IS7Ja5GQ3nkmN8L/9pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 805/869] ACPI: platform: Use acpi_bus_get_primary_device()
Date: Sat, 17 Oct 2026 18:00:46 +0200
Message-ID: <20261017160057.537836238@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 48d15dd785f6e..affa076a211da 100644
--- a/drivers/acpi/acpi_platform.c
+++ b/drivers/acpi/acpi_platform.c
@@ -71,18 +71,15 @@ static struct notifier_block acpi_platform_notifier = {
 	.notifier_call = acpi_platform_device_remove_notify,
 };
 
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
@@ -110,7 +107,8 @@ static unsigned int acpi_platform_resource_count(struct acpi_resource *ares, voi
 struct platform_device *acpi_create_platform_device(struct acpi_device *adev,
 						    const struct property_entry *properties)
 {
-	struct acpi_device *parent = acpi_dev_parent(adev);
+	struct acpi_device *p = acpi_dev_parent(adev);
+	struct device *parent __free(put_device) = acpi_bus_get_primary_device(p);
 	struct platform_device *pdev = NULL;
 	struct platform_device_info pdevinfo;
 	const struct acpi_device_id *match;
@@ -149,7 +147,7 @@ struct platform_device *acpi_create_platform_device(struct acpi_device *adev,
 		}
 		count = 0;
 		list_for_each_entry(rentry, &resource_list, node)
-			acpi_platform_fill_resource(adev, rentry->res,
+			acpi_platform_fill_resource(parent, rentry->res,
 						    &resources[count++]);
 
 		acpi_dev_free_resource_list(&resource_list);
@@ -161,7 +159,7 @@ struct platform_device *acpi_create_platform_device(struct acpi_device *adev,
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



