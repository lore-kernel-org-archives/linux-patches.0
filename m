Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2709C20E325;
	Tue, 12 Nov 2024 10:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408098; cv=none; b=guL7VaH3Dospw/9OPiOZ52iC3cSMH3mfA1HE+zuVvHuiHiym6BSB0E+4K5DxdEEmMVXN3gpYp5c1N9BoL4ICkSGjT2GhFFDTW9ydedtmM7MriblcY9jF8qXnfk28LwNAaQ1HiK1D+sHAkUM0DH7BcFJaKRR1GW4xwnyKD2Uhzcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408098; c=relaxed/simple;
	bh=u6z+Vse7OdfZ+L4+lqXPz9ZRj+Xo8gdG3vbzGGv5seE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fVD6L2Cw5qkwmxwgwjTZu1fKFS7hScVpdoLTSWHyjEdfh6PtDDlsHx9c1n7EPwTl4YzALdFZ3usmCzrRNCy9lpIt7lwhI99Vz+R8reLwte2DhMWONhG7JeT3nTXe4xBH6YFPlKLXItruI7BeW08fLniaW2ejKdsJke2UHy1vjeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ytz0zSWF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ytz0zSWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145FDC4CED7;
	Tue, 12 Nov 2024 10:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408097;
	bh=u6z+Vse7OdfZ+L4+lqXPz9ZRj+Xo8gdG3vbzGGv5seE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ytz0zSWF4piqw+Hn537QKWRInfuHf49IIJaW8Yep4AaOPT5TUsZIKyQp8R0LdT0pe
	 IHpp48kygqVrgRDcHPC5LFpBxLjHy7lGxPzVhAizwNNOu8AB706u09ZvCo4iPRyp5n
	 t2zSVai1EmeKN2dMPpQ7ZhyAU+BwH712YRrPr+OE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philo Lu <lulie@linux.alibaba.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Joe Damato <jdamato@fastly.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 057/184] virtio_net: Sync rss config to device when virtnet_probe
Date: Tue, 12 Nov 2024 11:20:15 +0100
Message-ID: <20241112101903.050581691@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philo Lu <lulie@linux.alibaba.com>

[ Upstream commit dc749b7b06082ccaacc602e724445da19cd03e9f ]

During virtnet_probe, default rss configuration is initialized, but was
not committed to the device. This patch fix this by sending rss command
after device ready in virtnet_probe. Otherwise, the actual rss
configuration used by device can be different with that read by user
from driver, which may confuse the user.

If the command committing fails, driver rss will be disabled.

Fixes: c7114b1249fa ("drivers/net/virtio_net: Added basic RSS support.")
Signed-off-by: Philo Lu <lulie@linux.alibaba.com>
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Joe Damato <jdamato@fastly.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 545dda8ec0775..b3232b8baa256 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -6584,6 +6584,15 @@ static int virtnet_probe(struct virtio_device *vdev)
 
 	virtio_device_ready(vdev);
 
+	if (vi->has_rss || vi->has_rss_hash_report) {
+		if (!virtnet_commit_rss_command(vi)) {
+			dev_warn(&vdev->dev, "RSS disabled because committing failed.\n");
+			dev->hw_features &= ~NETIF_F_RXHASH;
+			vi->has_rss_hash_report = false;
+			vi->has_rss = false;
+		}
+	}
+
 	virtnet_set_queues(vi, vi->curr_queue_pairs);
 
 	/* a random MAC address has been assigned, notify the device.
-- 
2.43.0



