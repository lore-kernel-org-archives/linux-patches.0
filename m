Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9BF2EB5BC;
	Tue, 22 Jul 2025 14:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193632; cv=none; b=iU5Z9aZc0fnF0uxmhsaWFqrBx4UMYInNnFCHotK4zCZuBUGTs7ZMfKyM+zp/q7gcsmx6OiCTwYVjN4q8eIt2ACVJZ7f8S3L4xEA8/EQYhYRLFZS80JTtES+1ksxZlFUJXbdG+ktI1jUiKwsPv9lGBRyaMr80yw68ivQeZWgN9Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193632; c=relaxed/simple;
	bh=E5P8n1Z85bTqOQO/jYXZIxeaqka6GUYXqR4zZDjdytA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lKIVYOtFSzk5eW0zLR2m2lAFtlM42RAS7sqOnUnRXEShpG/s0qgc5rMeey4SIAtgL4S0hWYYg2eIOlcp3KYz3LU+kyovm84nHLUjqHc1zpmLHZqm0z50d8qnvK7M0gMg1OwxdKrWt6i89AouB1mqi7U2qNcr8be0roKq6iD+jf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zy+22P/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zy+22P/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF34C4CEEB;
	Tue, 22 Jul 2025 14:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193631;
	bh=E5P8n1Z85bTqOQO/jYXZIxeaqka6GUYXqR4zZDjdytA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zy+22P/DKyh1aeIznRpuvCT39pI+LJn394Lb1Aj1IBcaKb/4G2qP0wttQcQoT4iQp
	 lTJodOE3TmPzIYsI2IfpA8A75Pvt4cHQKfayleWyqxzbCSwSeTz3l9z7vdJSpmrKFs
	 eSNMjJkWbnkXzqDkHAEEQ7UNi/eRacc87kDLrSYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zigit Zo <zuozhijie@bytedance.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 151/187] virtio-net: fix recursived rtnl_lock() during probe()
Date: Tue, 22 Jul 2025 15:45:21 +0200
Message-ID: <20250722134351.411990406@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zigit Zo <zuozhijie@bytedance.com>

[ Upstream commit be5dcaed694e4255dc02dd0acfe036708c535def ]

The deadlock appears in a stack trace like:

  virtnet_probe()
    rtnl_lock()
    virtio_config_changed_work()
      netdev_notify_peers()
        rtnl_lock()

It happens if the VMM sends a VIRTIO_NET_S_ANNOUNCE request while the
virtio-net driver is still probing.

The config_work in probe() will get scheduled until virtnet_open() enables
the config change notification via virtio_config_driver_enable().

Fixes: df28de7b0050 ("virtio-net: synchronize operstate with admin state on up/down")
Signed-off-by: Zigit Zo <zuozhijie@bytedance.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://patch.msgid.link/20250716115717.1472430-1-zuozhijie@bytedance.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index d5be73a964708..c69c241948019 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -7074,7 +7074,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 	   otherwise get link status from config. */
 	netif_carrier_off(dev);
 	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_STATUS)) {
-		virtnet_config_changed_work(&vi->config_work);
+		virtio_config_changed(vi->vdev);
 	} else {
 		vi->status = VIRTIO_NET_S_LINK_UP;
 		virtnet_update_settings(vi);
-- 
2.39.5



