Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836D62E9EB2;
	Tue, 22 Jul 2025 14:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193028; cv=none; b=Dw38u7V54rAELYbfiPs5aFTpHrnrKV5rji0omrsJPImopq3wwEbZAhQusCk6IlbdWNiqFlbNfxQpLYBpzmqEYI4I5R+fdIm4f0HzXRt+FjUJlVHg1o/mL1MGcHfyWvuEpvSQ0AOn+rOfGgw+80zeXPXOL6MGjwcGoClMU74cX24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193028; c=relaxed/simple;
	bh=ti13YJoylT2ghBIlNKrynoLAo1rYdLdSld31nvvZFXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSylwBBnbzn6TVxRANq+Z4bgLIMIuWgnyRWaa225eMp0yeSGnAzGwZeJluv5ztYkl29L30p3m3jhjgxvQ5gvlh0e2xGggGmg/xnIzc3VqkgMp2hQ3Q1tj3VvHr8DGqmCHGBUlbSg+whNiN2FAvkBkuFMVg4Za3GoXYh07nWvKQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d9DBU0FF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d9DBU0FF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9863CC4CEEB;
	Tue, 22 Jul 2025 14:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193028;
	bh=ti13YJoylT2ghBIlNKrynoLAo1rYdLdSld31nvvZFXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d9DBU0FFlFlaenQZbx/aukPmhRflfJ/vCdqT7rxyUI/FlepWTe5C3299NZMmj79gM
	 BvgfCgKpPzJzLQr5G+NKACLESLsXxPuZZXRATgFVLh+/ui0VFbnsKGJZizX/z4jAxj
	 PHGi2xQ+SlwVpnzYBNpSIkKwzfeQi3XEVO77H/H4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zigit Zo <zuozhijie@bytedance.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 128/158] virtio-net: fix recursived rtnl_lock() during probe()
Date: Tue, 22 Jul 2025 15:45:12 +0200
Message-ID: <20250722134345.513059112@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 54c5d9a14c672..0408c21bb1220 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -6802,7 +6802,7 @@ static int virtnet_probe(struct virtio_device *vdev)
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



