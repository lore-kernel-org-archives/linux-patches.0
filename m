Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75ECB13A27E;
	Wed,  3 Jul 2024 11:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006152; cv=none; b=leOhhrWB9q4er2RKaspbGAGh6SGQq10dw3kRPD+rpOgy52StJZ3giXpnFxJt0iQFVtrRSm4Z9n2NnI4yfi1V+hnfV+fvdaBnClGTItwNy+tqjtmA5SkaMS+AiLB7/W5Wykrn2eIY1i1d9KEYPetP9087zcDAC2ASLJmSKxDI9FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006152; c=relaxed/simple;
	bh=ux+lMOLih3FWGlz9VBro7IBUEv7OK/Bt5pbUeMHfgiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CAo4N2sZ2Nr2EhD/7nJ6FEjriMa71alfCg+Wc1vh95CUfe3Cy4Aq/MfS45T4IY8ySe3zx2lt7dyOHsTlZc7Ms0CFnjfdsxyleSLdPff1Zn4aHxuOF7+BSJUuZPV8gEw44q7H9E+nsZmr9CgetyX6JGKL4HZLTgDzQ8sGRgMh5Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XXTGLiqO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XXTGLiqO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4EAC2BD10;
	Wed,  3 Jul 2024 11:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006152;
	bh=ux+lMOLih3FWGlz9VBro7IBUEv7OK/Bt5pbUeMHfgiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XXTGLiqO+wyXF87IxcdIDEAtt3r0r+0LAiYxcKyo+NnVAct8znl8N1vZyRy9KwC6n
	 tY7KOc9Do8ve3WvW8l+929MYLySMf+B3iJTuHRKXFvYXNFvpeRCHdo0nun2VcvAiAZ
	 6jPbpWyyJ5T1O2j+c0xicp9P8xSePWpL1JUBRddg=
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
Subject: [PATCH 5.15 286/356] vduse: Temporarily fail if control queue feature requested
Date: Wed,  3 Jul 2024 12:40:22 +0200
Message-ID: <20240703102923.934305914@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 898ef597338a2..4684d4756b427 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -8,6 +8,7 @@
  *
  */
 
+#include "linux/virtio_net.h"
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/cdev.h>
@@ -26,6 +27,7 @@
 #include <uapi/linux/virtio_config.h>
 #include <uapi/linux/virtio_ids.h>
 #include <uapi/linux/virtio_blk.h>
+#include <uapi/linux/virtio_ring.h>
 #include <linux/mod_devicetable.h>
 
 #include "iova_domain.h"
@@ -1236,6 +1238,9 @@ static bool features_is_valid(struct vduse_dev_config *config)
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



