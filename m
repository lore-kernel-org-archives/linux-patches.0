Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE65D1BE22B;
	Tue,  2 Jul 2024 17:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941353; cv=none; b=jN76F7XGZPZ/GAYWEm+ORV61yufhrTlwA5WnKeJv1XR63bAzdMAmYnZ4HWd0GmJvj+B05CZfli36NUbuip/XtvAaEuG67PZ/vG96o28WKsYqH8obEZ0PNVPvs159tWpN2CFNCQ/2wdmO4AT0FWmbxj/rNJJnXhVIIVB0oUEwD4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941353; c=relaxed/simple;
	bh=an3yqWV00t7ayZ+Z7tDS1imUBLr6m9ia1aGzijfpTkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mPRr0FpbcVl9fEsnOeSQj+gDz6jRHrHF9l/xb4oYa+XGNF4QLSSl6qzgXSiVE3XGulcV0RPWVSfD1jqnVTLWQtFja8GUrmTQqu0E66xUYVprP2X4A86onY75gglTmnE+040+7DSJxN4s/jzZj1rTTMGcpSBrADfkKqVX9HEi9Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RAen88S4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RAen88S4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D76C116B1;
	Tue,  2 Jul 2024 17:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941352;
	bh=an3yqWV00t7ayZ+Z7tDS1imUBLr6m9ia1aGzijfpTkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RAen88S4qExyx2btGrIJE/WtfwZfK2ofRbmf8tZCpY0YQs0jwaV7xaYvpv45vvww5
	 su6mw4VbNrxMN+HgBr/A/28IIbOL0DA930YqHgRyJc8lroC5ZHo4iHrpFP+rZWvrRM
	 sqpJYHqHVYVBepp5Gub8g19iLXF9ZMl6PipBlsXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Coquelin <maxime.coquelin@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Xie Yongji <xieyongji@bytedance.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/128] vduse: Temporarily fail if control queue feature requested
Date: Tue,  2 Jul 2024 19:04:00 +0200
Message-ID: <20240702170227.711109409@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Coquelin <maxime.coquelin@redhat.com>

[ Upstream commit 56e71885b0349241c07631a7b979b61e81afab6a ]

Virtio-net driver control queue implementation is not safe
when used with VDUSE. If the VDUSE application does not
reply to control queue messages, it currently ends up
hanging the kernel thread sending this command.

Some work is on-going to make the control queue
implementation robust with VDUSE. Until it is completed,
let's fail features check if control-queue feature is
requested.

Signed-off-by: Maxime Coquelin <maxime.coquelin@redhat.com>
Message-Id: <20240109111025.1320976-3-maxime.coquelin@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Reviewed-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index cb35a76146b39..0ccece3f4f7da 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -8,6 +8,7 @@
  *
  */
 
+#include "linux/virtio_net.h"
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/cdev.h>
@@ -28,6 +29,7 @@
 #include <uapi/linux/virtio_config.h>
 #include <uapi/linux/virtio_ids.h>
 #include <uapi/linux/virtio_blk.h>
+#include <uapi/linux/virtio_ring.h>
 #include <linux/mod_devicetable.h>
 
 #include "iova_domain.h"
@@ -1425,6 +1427,9 @@ static bool features_is_valid(struct vduse_dev_config *config)
 	if ((config->device_id == VIRTIO_ID_BLOCK) &&
 			(config->features & BIT_ULL(VIRTIO_BLK_F_CONFIG_WCE)))
 		return false;
+	else if ((config->device_id == VIRTIO_ID_NET) &&
+			(config->features & BIT_ULL(VIRTIO_NET_F_CTRL_VQ)))
+		return false;
 
 	return true;
 }
-- 
2.43.0



