Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDD91DB127;
	Tue,  8 Jul 2025 16:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993789; cv=none; b=B0Cc1ZpYdxPKkEM56RDPzbeg1u8k3NACN1EyjZYdsOG8zXRZ85Rr0AuLtbkj9jyCF8a7aPZ8jV3Ou2lKeVHqV05VvCgbNnUs/KzQqgcimByw6Ve1x5Y7HIghpflHObb7Ha6U3Vw1WhGDtZtUNTfOAYpyY0fbC57OoRj6PhQ/nsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993789; c=relaxed/simple;
	bh=30tLtuxAjgQGAzN6ge92qXg9x24sW8lZuHEbD6AcSWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yoith+PaQZEdBCkcTNlEhKTrLV37e1RoCloBhPpgsViIWY+QeWVDKIPjnx5U+Uthjtl1gEtdgBCdfRr7hw6wkCJiE/c4Sgra5a5FPLWfZ/+0tND+Rz4moAqThNEfo1cQfxcbIBvVxM2LqUK47RvB1i+d9vCsXKVLXc6WFH7Ql0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ykv4kG3J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ykv4kG3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278A1C4CEF0;
	Tue,  8 Jul 2025 16:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993789;
	bh=30tLtuxAjgQGAzN6ge92qXg9x24sW8lZuHEbD6AcSWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ykv4kG3JUzErQS3mDBBTDpD5B0M7AFtKIgF5LPVOkPs9B/PiTmfGW1XDnQGTVNIMP
	 HHK3r30kONqvRQnfcTTP4G/pRq2om0CB4Yz6MDvEsOr5gPsMldrphdkkPqxCh4yMC/
	 Mz6MGll3G10pq0Y40mwMFA+441GyNc3srMqf6yEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/160] usb: Add checks for snprintf() calls in usb_alloc_dev()
Date: Tue,  8 Jul 2025 18:20:56 +0200
Message-ID: <20250708162232.039008474@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 82fe5107fa3d21d6c3fba091c9dbc50495588630 ]

When creating a device path in the driver the snprintf() takes
up to 16 characters long argument along with the additional up to
12 characters for the signed integer (as it can't see the actual limits)
and tries to pack this into 16 bytes array. GCC complains about that
when build with `make W=1`:

  drivers/usb/core/usb.c:705:25: note: ‘snprintf’ output between 3 and 28 bytes into a destination of size 16

Since everything works until now, let's just check for the potential
buffer overflow and bail out. It is most likely a never happen situation,
but at least it makes GCC happy.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20250321164949.423957-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/usb.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index ec8e003f59415..a16e7ebb7f953 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -750,15 +750,16 @@ struct usb_device *usb_alloc_dev(struct usb_device *parent,
 		dev_set_name(&dev->dev, "usb%d", bus->busnum);
 		root_hub = 1;
 	} else {
+		int n;
+
 		/* match any labeling on the hubs; it's one-based */
 		if (parent->devpath[0] == '0') {
-			snprintf(dev->devpath, sizeof dev->devpath,
-				"%d", port1);
+			n = snprintf(dev->devpath, sizeof(dev->devpath), "%d", port1);
 			/* Root ports are not counted in route string */
 			dev->route = 0;
 		} else {
-			snprintf(dev->devpath, sizeof dev->devpath,
-				"%s.%d", parent->devpath, port1);
+			n = snprintf(dev->devpath, sizeof(dev->devpath), "%s.%d",
+				     parent->devpath, port1);
 			/* Route string assumes hubs have less than 16 ports */
 			if (port1 < 15)
 				dev->route = parent->route +
@@ -767,6 +768,11 @@ struct usb_device *usb_alloc_dev(struct usb_device *parent,
 				dev->route = parent->route +
 					(15 << ((parent->level - 1)*4));
 		}
+		if (n >= sizeof(dev->devpath)) {
+			usb_put_hcd(bus_to_hcd(bus));
+			usb_put_dev(dev);
+			return NULL;
+		}
 
 		dev->dev.parent = &parent->dev;
 		dev_set_name(&dev->dev, "%d-%s", bus->busnum, dev->devpath);
-- 
2.39.5



