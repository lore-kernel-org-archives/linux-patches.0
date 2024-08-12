Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D661494B8;
	Mon, 12 Aug 2024 16:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480603; cv=none; b=bsi9T5UTZjRjOOvbT9kWmJWP3OrkLWH1qxY+gzoDj9AvNacUW4ax8ZxGDVDa+vdHAdyBeYYNFIpiE2CYrgzmKqq0X8QSL+CFZbQLJ5COXhJnI06QR0orNXPN4kwOFVvfAWePS8COB1NcwnimAZ6l4X2qihOMsrdSgfZr8Oi0tPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480603; c=relaxed/simple;
	bh=L0FbcHilDRDog6TkrAcGX9Uf2CEBTgkJnhOXWAP4ju8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBr57XOCVBqC4JTv1lf9QC+rRRimvThQ2aGMCp1OvGnDgW8jwZn94vqvQLvLzqS92T0QSjlkjYyR3OgwDfXczi5qNmZLVccrcCqaDUOWbW1YoQnqLoqilxU+b90VzaOa8yLkHxi4pi2/lE1O658m3eNiz5RNxRDysiuzfrP7ULg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aW83FlKO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aW83FlKO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18171C32782;
	Mon, 12 Aug 2024 16:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480603;
	bh=L0FbcHilDRDog6TkrAcGX9Uf2CEBTgkJnhOXWAP4ju8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aW83FlKOqAQN8e1/eBz3hoVoTbZXKIvsiZk86NImhRPZ6UoZbzOXb5sYssZWi5J+T
	 tz2iH2py1v4C2W5ZsYMA+QeCXnrCPjYCK+G0Et38zuxCQawFw89qpDc8D5BDwkFHgT
	 BKE2C3+W7gufEi9sbFVIiGE9uE/D3O3l/NMHIr2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Dave Airlie <airlied@redhat.com>,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 6.10 246/263] drm/mgag200: Bind I2C lifetime to DRM device
Date: Mon, 12 Aug 2024 18:04:07 +0200
Message-ID: <20240812160155.960579704@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit eb1ae34e48a09b7a1179c579aed042b032e408f4 upstream.

Managed cleanup with devm_add_action_or_reset() will release the I2C
adapter when the underlying Linux device goes away. But the connector
still refers to it, so this cleanup leaves behind a stale pointer
in struct drm_connector.ddc.

Bind the lifetime of the I2C adapter to the connector's lifetime by
using DRM's managed release. When the DRM device goes away (after
the Linux device) DRM will first clean up the connector and then
clean up the I2C adapter.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Fixes: b279df242972 ("drm/mgag200: Switch I2C code to managed cleanup")
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Jocelyn Falempe <jfalempe@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v6.0+
Link: https://patchwork.freedesktop.org/patch/msgid/20240513125620.6337-3-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mgag200/mgag200_i2c.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/mgag200/mgag200_i2c.c
+++ b/drivers/gpu/drm/mgag200/mgag200_i2c.c
@@ -31,6 +31,8 @@
 #include <linux/i2c.h>
 #include <linux/pci.h>
 
+#include <drm/drm_managed.h>
+
 #include "mgag200_drv.h"
 
 static int mga_i2c_read_gpio(struct mga_device *mdev)
@@ -86,7 +88,7 @@ static int mga_gpio_getscl(void *data)
 	return (mga_i2c_read_gpio(mdev) & i2c->clock) ? 1 : 0;
 }
 
-static void mgag200_i2c_release(void *res)
+static void mgag200_i2c_release(struct drm_device *dev, void *res)
 {
 	struct mga_i2c_chan *i2c = res;
 
@@ -125,5 +127,5 @@ int mgag200_i2c_init(struct mga_device *
 	if (ret)
 		return ret;
 
-	return devm_add_action_or_reset(dev->dev, mgag200_i2c_release, i2c);
+	return drmm_add_action_or_reset(dev, mgag200_i2c_release, i2c);
 }


