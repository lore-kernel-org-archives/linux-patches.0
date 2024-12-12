Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0975B215764;
	Thu, 12 Dec 2024 16:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020866; cv=none; b=cfS1kFEp21aTRQJ0nLSHycKoVS/rpnbCplwz2zkSGPUD7+XYWO0wTswGRuKK8Wt04P04d+bmRnFBpcFjDuSLOaF8O3LgA1KJLmwu4wujZrQ7/FuExDyMRNkBKNXcbRxi2gY00kwR23fkq7rfEv84xP4/6XrT2qzD1x4fIgQCKq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020866; c=relaxed/simple;
	bh=nFt+80rmsQjxPP74OBaZ8BXrzALvMpOYMgsGYBXIp7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XyXCCfbzLAS724mVohyIE/HRHNk9wDBpN4fP6DJ61Sy/7FuBydzpAwV6Ew8zrWNxDtEIFQ9RNtRNKdiopjayHZCTv2+4GCYubRM1XhdniyS+3nd4rHcHqs1MfIFB0UiH6jHVkLP6B9ToZ2rUILSoqBfpxBILSpxpMZZb90muPbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xDACpUdk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xDACpUdk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704AFC4CECE;
	Thu, 12 Dec 2024 16:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020865;
	bh=nFt+80rmsQjxPP74OBaZ8BXrzALvMpOYMgsGYBXIp7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xDACpUdkBrn/gSOZ3K3DncoWOiFyNylpyTiKU3ftOEQL4x2S69dY4TwtFGvmmDAkh
	 Wyh5JGwe45txFryw3LPCkWW/yqtBx0uZrRArCpyQDo+MSlitKZ0w0f2gA2QLRoG1uQ
	 n/OUi1+CPP+wN64LZcJkQVPdsJQ+NM6hWV8iVcaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 580/772] device property: Add cleanup.h based fwnode_handle_put() scope based cleanup.
Date: Thu, 12 Dec 2024 15:58:45 +0100
Message-ID: <20241212144413.911378385@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 59ed5e2d505bf5f9b4af64d0021cd0c96aec1f7c ]

Useful where the fwnode_handle was obtained from a call such as
fwnode_find_reference() as it will safely do nothing if IS_ERR() is true
and will automatically release the reference on the variable leaving
scope.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Link: https://lore.kernel.org/r/20240217164249.921878-3-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 73b03b27736e ("leds: flash: mt6360: Fix device_for_each_child_node() refcounting in error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/property.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/property.h b/include/linux/property.h
index ec3490591f934..f2e8590cefd89 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -11,6 +11,7 @@
 #define _LINUX_PROPERTY_H_
 
 #include <linux/bits.h>
+#include <linux/cleanup.h>
 #include <linux/fwnode.h>
 #include <linux/types.h>
 
@@ -129,6 +130,8 @@ struct fwnode_handle *device_get_named_child_node(const struct device *dev,
 struct fwnode_handle *fwnode_handle_get(struct fwnode_handle *fwnode);
 void fwnode_handle_put(struct fwnode_handle *fwnode);
 
+DEFINE_FREE(fwnode_handle, struct fwnode_handle *, fwnode_handle_put(_T))
+
 int fwnode_irq_get(const struct fwnode_handle *fwnode, unsigned int index);
 int fwnode_irq_get_byname(const struct fwnode_handle *fwnode, const char *name);
 
-- 
2.43.0



