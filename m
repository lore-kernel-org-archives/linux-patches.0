Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA3F3D978;
	Tue,  2 Jul 2024 17:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940854; cv=none; b=Dse8j9Fr0a+fvWUf6vUP5ejraPushuT+LB8n7Z2eoLG8Szd0mN+P++Fh+veArh/7CglWDTx5mEFEQWgLPI9O6F5xkpz/oqMW60x7Z39St5NxvSIwenOy9ZuDyui1ot5ihpr+c0g6KNWqJo4OoTe0i9nTnGFmaVdj8qFvxGZeYXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940854; c=relaxed/simple;
	bh=30mGicKbY6reWOBfBttFRZRF/GUTN49ZlubxI7HSDoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fEzK4Xp76MgyWTt0PdiHkQwBELsyPzdEwJIk9pcc2ZpGKqEfPoWEv8NbvM/gSl0HtL6CjbuDYODs1ZFhj4YgtfHhKt5gNjsM1kiiPxz0cbQklNc22QUycnH0TJou8qhPuPvEYys250AwKmVJGjygvAuo0bDsxYbn+Fpd++tGOxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dKbqmZYs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dKbqmZYs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C766C116B1;
	Tue,  2 Jul 2024 17:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940854;
	bh=30mGicKbY6reWOBfBttFRZRF/GUTN49ZlubxI7HSDoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKbqmZYsZNC830r9hw1H6VIJsr6nX1aVXEvLQb7bhV1Sz/Q/rbid85udFlUgZQUiB
	 smc6RFXt6FKAkuG70eonlEw2fcwbItI2gjh+HAECw690KNQetINZoOIO0jjC7P0CCH
	 L3mDZOTRJa2tvajXEmeq0J823e3maMsHY5gKaFL8=
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
Subject: [PATCH 6.6 055/163] vduse: Temporarily fail if control queue feature requested
Date: Tue,  2 Jul 2024 19:02:49 +0200
Message-ID: <20240702170235.145238861@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d91fe7e0733b6..d7bda179ef79f 100644
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
@@ -1671,6 +1673,9 @@ static bool features_is_valid(struct vduse_dev_config *config)
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



