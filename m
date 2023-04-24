Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454E57C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17B0C433D2;
	Mon, 24 Apr 2023 13:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342880;
	bh=PPwxJBYzorSjWbwgdGjfpnxbSvSYCmt3OflGBLHn93g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gf/bovsGBFknGWzZminqpYfON4gopE1O7y063qGQdpH1bbGayS/mVbk9Z7eyt0QBn
	 AO8slvLs9oTwchaIJJc3zLHkyLHKomkxrokcjYdS3EtayeznfIZpfFxfO0B5tkN0vd
	 bARJrIkOfykCqVXbGgi+rOvG6zU7L2ku965JRgz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: [PATCH 6.1 93/98] fpga: bridge: properly initialize bridge device before populating children
Date: Mon, 24 Apr 2023 15:17:56 +0200
Message-Id: <20230424131137.504258603@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexis Lothoré <alexis.lothore@bootlin.com>

commit dc70eb868b9cd2ca01313e5a394e6ea001d513e9 upstream.

The current code path can lead to warnings because of uninitialized device,
which contains, as a consequence, uninitialized kobject. The uninitialized
device is passed to of_platform_populate, which will at some point, while
creating child device, try to get a reference on uninitialized parent,
resulting in the following warning:

kobject: '(null)' ((ptrval)): is not initialized, yet kobject_get() is
being called.

The warning is observed after migrating a kernel 5.10.x to 6.1.x.
Reverting commit 0d70af3c2530 ("fpga: bridge: Use standard dev_release for
class driver") seems to remove the warning.
This commit aggregates device_initialize() and device_add() into
device_register() but this new call is done AFTER of_platform_populate

Fixes: 0d70af3c2530 ("fpga: bridge: Use standard dev_release for class driver")
Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
Acked-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/20230404133102.2837535-2-alexis.lothore@bootlin.com
Signed-off-by: Xu Yilun <yilun.xu@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/fpga/fpga-bridge.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/fpga/fpga-bridge.c
+++ b/drivers/fpga/fpga-bridge.c
@@ -360,7 +360,6 @@ fpga_bridge_register(struct device *pare
 	bridge->dev.parent = parent;
 	bridge->dev.of_node = parent->of_node;
 	bridge->dev.id = id;
-	of_platform_populate(bridge->dev.of_node, NULL, NULL, &bridge->dev);
 
 	ret = dev_set_name(&bridge->dev, "br%d", id);
 	if (ret)
@@ -372,6 +371,8 @@ fpga_bridge_register(struct device *pare
 		return ERR_PTR(ret);
 	}
 
+	of_platform_populate(bridge->dev.of_node, NULL, NULL, &bridge->dev);
+
 	return bridge;
 
 error_device:


