Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164091D0423;
	Wed,  2 Oct 2024 13:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875295; cv=none; b=gP8sQXWvS15LBT+GKvtYxLpHhPO0LXbiX8KIeqmnv4HZ+ivGv1Z3wwUUGuIWYhcil7+6q0wBzB7bL2snGUBMVRJZMUEqwCDKuHspIaw5GyZ7bL3S3mse/uQ680n/7ifpllJBpS8Funx1qg9aPzJSGwogf8mWuIh8evg1sm5+HFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875295; c=relaxed/simple;
	bh=VIEeea01Tz9ZK4TujwfrE4Qwelc8UBD1k71RWQ1KTho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJ6uJgweLmt6Sg1CzNMb9NkGdmAMeJzxfRzYSjLu/R44zNLLjjk3cQGukVZuD95MJ0nQf2SJkAXW4MluNXHlkvOIS+s+YaU6kybSIbAbkKTU3Vg92lXk+ni6/o9BB2xZ2ejyfrIhDXbtiVDZWGTDiO6pTvVXQ+RkshHDY39U2jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YNhDAsnD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YNhDAsnD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C35C4CECF;
	Wed,  2 Oct 2024 13:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875295;
	bh=VIEeea01Tz9ZK4TujwfrE4Qwelc8UBD1k71RWQ1KTho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YNhDAsnDOJUwrTEUSuimMawFbJ6xop14J16Pv7pxzvApwhAhB0X0+lGV5ppUuxU00
	 nZLaR8IAcdStEiPgVS+O8F+Km2TysG/YXpL5NejXNSwgtWWv/+drv+Skz4YN4SlDCB
	 lYCSA7f4VRoFyI9mdcnS91JwiPXMqvJd7RHxF/EU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 022/695] virtio-net: synchronize probe with ndo_set_features
Date: Wed,  2 Oct 2024 14:50:20 +0200
Message-ID: <20241002125823.378404173@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit c392d6019398315526b0b508282f87c7b2318c72 ]

We calculate guest offloads during probe without the protection of
rtnl_lock. This lead to race between probe and ndo_set_features. Fix
this by moving the calculation under the rtnl_lock.

Fixes: 3f93522ffab2 ("virtio-net: switch off offloads on demand if possible on XDP set")
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Link: https://patch.msgid.link/20240814052228.4654-5-jasowang@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 60833e7b5a935..6f4781ec2b369 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -6603,6 +6603,11 @@ static int virtnet_probe(struct virtio_device *vdev)
 		netif_carrier_on(dev);
 	}
 
+	for (i = 0; i < ARRAY_SIZE(guest_offloads); i++)
+		if (virtio_has_feature(vi->vdev, guest_offloads[i]))
+			set_bit(guest_offloads[i], &vi->guest_offloads);
+	vi->guest_offloads_capable = vi->guest_offloads;
+
 	rtnl_unlock();
 
 	err = virtnet_cpu_notif_add(vi);
@@ -6611,11 +6616,6 @@ static int virtnet_probe(struct virtio_device *vdev)
 		goto free_unregister_netdev;
 	}
 
-	for (i = 0; i < ARRAY_SIZE(guest_offloads); i++)
-		if (virtio_has_feature(vi->vdev, guest_offloads[i]))
-			set_bit(guest_offloads[i], &vi->guest_offloads);
-	vi->guest_offloads_capable = vi->guest_offloads;
-
 	pr_debug("virtnet: registered device %s with %d RX and TX vq's\n",
 		 dev->name, max_queue_pairs);
 
-- 
2.43.0



