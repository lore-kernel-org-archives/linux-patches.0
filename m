Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0684D14D2B3;
	Mon, 16 Sep 2024 12:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488487; cv=none; b=HcgFsdAKBHm15PuEZlM25XTNBuLj78CxQtMUq5WB+d4c3dYLmi8P6CepiBFtt06Pn65KbJ3//5IiYk3/4eFsgh8pNEPBoSRpi5e+MeFQ+YDXgavr14wliD0frYZipSDBXU3O1CUOS0P0LGQi8fwwINsDAU28ho1Bg3byocYBKqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488487; c=relaxed/simple;
	bh=MzogfVQc/xMoJRShvja2MHq68MoqdCnvO7r3EUiuJhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFIFU0L5LDOOKcI1gdYcnwHGjBTMK/cTF+6cXRkbhcHcxIK9ZhmoCdkMXY9gcHwvP413yHpNvMg3QNcw4R+E6NztGs2msYCKONDDOApMJm1ejIt2y5YvHyZIzVE+zqgS6zMBuc+FuOLiOQUPYvqdcERn3r96+VtrBE6aVDJa7u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LjfiFRaS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LjfiFRaS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82724C4CEC4;
	Mon, 16 Sep 2024 12:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488486;
	bh=MzogfVQc/xMoJRShvja2MHq68MoqdCnvO7r3EUiuJhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LjfiFRaSGRdgNimVnzTg0aTFZubWnLXA+Ennr+YiEbH6878wYjjr++IHCxETj3DBk
	 ohHPYFR5HGKR9lT0XQCuVGpaWAOq5GR/X/0ZZAi2PTV6dGPGmHdsgVtfnRaBwV8h5a
	 cmS79NagNgz2k+WIB43aXOWOvNl9Q9b83UcjAJhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 01/91] device property: Add cleanup.h based fwnode_handle_put() scope based cleanup.
Date: Mon, 16 Sep 2024 13:43:37 +0200
Message-ID: <20240916114224.556783854@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 61cbfb5368dd ("iio: adc: ad7124: fix DT configuration parsing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/property.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/property.h b/include/linux/property.h
index 1684fca930f7..909416c701b8 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -11,6 +11,7 @@
 #define _LINUX_PROPERTY_H_
 
 #include <linux/bits.h>
+#include <linux/cleanup.h>
 #include <linux/fwnode.h>
 #include <linux/stddef.h>
 #include <linux/types.h>
@@ -175,6 +176,8 @@ struct fwnode_handle *device_get_named_child_node(const struct device *dev,
 struct fwnode_handle *fwnode_handle_get(struct fwnode_handle *fwnode);
 void fwnode_handle_put(struct fwnode_handle *fwnode);
 
+DEFINE_FREE(fwnode_handle, struct fwnode_handle *, fwnode_handle_put(_T))
+
 int fwnode_irq_get(const struct fwnode_handle *fwnode, unsigned int index);
 int fwnode_irq_get_byname(const struct fwnode_handle *fwnode, const char *name);
 
-- 
2.43.0



