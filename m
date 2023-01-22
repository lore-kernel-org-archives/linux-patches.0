Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6652590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:25:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67E7C43442;
	Sun, 22 Jan 2023 15:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401107;
	bh=y4jJji662PE8zmGj937GBvQ7RrN/fKIOqDq476udJ7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ii6BHh+lBY3Tkw82F8A3EZ6x2GrlxN7TVf38rlx1dQP06bO9lrBywQaXrBwIZ4lVT
	 PoTBhulhuRhQGsQ34dHzGK6M3SbJSGeSl022i0JrwRd5n3lDDM/dh3B9LQBR2xpYJR
	 iox61kdttUNiKE8grQX5TWG1zrgooRsK5oDB9Xhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Chanh Nguyen <chanh@os.amperecomputing.com>,
	Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Frank Li <frank.li@nxp.com>
Subject: [PATCH 6.1 113/193] USB: gadget: Add ID numbers to configfs-gadget driver names
Date: Sun, 22 Jan 2023 16:04:02 +0100
Message-Id: <20230122150251.490579974@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chanh Nguyen <chanh@os.amperecomputing.com>

commit 7c07553807c5125c89de242d35c10c206fd8e6bb upstream.

It is unable to use configfs to attach more than one gadget. When
attaching the second gadget, it always fails and the kernel message
prints out:

Error: Driver 'configfs-gadget' is already registered, aborting...
UDC core: g1: driver registration failed: -16

This commit fixes the problem by using the gadget name as a suffix
to each configfs_gadget's driver name, thus making the names
distinct.

Fixes: fc274c1e9973 ("USB: gadget: Add a new bus for gadgets")
Cc: stable <stable@kernel.org>
Signed-off-by: Chanh Nguyen <chanh@os.amperecomputing.com>
Reviewed-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Tested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Frank Li <frank.li@nxp.com>
Link: https://lore.kernel.org/r/20230111065105.29205-1-chanh@os.amperecomputing.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/configfs.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -392,6 +392,7 @@ static void gadget_info_attr_release(str
 	WARN_ON(!list_empty(&gi->string_list));
 	WARN_ON(!list_empty(&gi->available_func));
 	kfree(gi->composite.gadget_driver.function);
+	kfree(gi->composite.gadget_driver.driver.name);
 	kfree(gi);
 }
 
@@ -1571,7 +1572,6 @@ static const struct usb_gadget_driver co
 	.max_speed	= USB_SPEED_SUPER_PLUS,
 	.driver = {
 		.owner          = THIS_MODULE,
-		.name		= "configfs-gadget",
 	},
 	.match_existing_only = 1,
 };
@@ -1622,13 +1622,21 @@ static struct config_group *gadgets_make
 
 	gi->composite.gadget_driver = configfs_driver_template;
 
+	gi->composite.gadget_driver.driver.name = kasprintf(GFP_KERNEL,
+							    "configfs-gadget.%s", name);
+	if (!gi->composite.gadget_driver.driver.name)
+		goto err;
+
 	gi->composite.gadget_driver.function = kstrdup(name, GFP_KERNEL);
 	gi->composite.name = gi->composite.gadget_driver.function;
 
 	if (!gi->composite.gadget_driver.function)
-		goto err;
+		goto out_free_driver_name;
 
 	return &gi->group;
+
+out_free_driver_name:
+	kfree(gi->composite.gadget_driver.driver.name);
 err:
 	kfree(gi);
 	return ERR_PTR(-ENOMEM);


