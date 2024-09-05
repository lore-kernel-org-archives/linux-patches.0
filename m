Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCD8195FCE;
	Thu,  5 Sep 2024 09:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529465; cv=none; b=EeaCrQDW4WnM4WyhNsbw5lgS89pVV7fnryD/KmM0gQgWbx3dnjD6+uSDpTjrLqmcYLmz+c6sCdLdox++I1E+s1OkpcAk0PL/wBKN+tT+huTfJopTZGSMuE/oP/FaZfqg9kShbyeDutsB/2fWzJ/klzkMmLQvFqgFBIE4+9Ztnuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529465; c=relaxed/simple;
	bh=NTUEPJh8V28vzSc1U5ge97fhQNheP38MWY5T9v4zY4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcjCRmSdwAYyYFSGsW6Kw0nRos/3u3TtLB3n7TLqU9YpHwB6+f6GWyr8UbCqAjGZBJEw7DLlrBssIyRWdgxwiBRkTBcAirMK8yTh31KYqwcIFPGFNi0eYj5txakJiKoXt2n0QyrmvU8+PPu0/BkLDkMaYRzAi1CBOZobqGSdEG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S9lAPYS/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S9lAPYS/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C959AC4CEC4;
	Thu,  5 Sep 2024 09:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529465;
	bh=NTUEPJh8V28vzSc1U5ge97fhQNheP38MWY5T9v4zY4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S9lAPYS/NzubhUnfNpeifdTke3jfA/geibOKFsg5it+5Pv1fHW2avcuPC5L+35GzD
	 qXo0bxbV5yj9auhNWYsrt83kLpVXwUuw4jit2gCtC1RjmJHRDZS3tZzieoQs6D8PL5
	 uQ6KQoB1M/wih2TxIXzsxD+ko2p55IlyEqREa1mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Heng Qi <hengqi@linux.alibaba.com>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 024/184] virtio-net: check feature before configuring the vq coalescing command
Date: Thu,  5 Sep 2024 11:38:57 +0200
Message-ID: <20240905093733.191535009@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

From: Heng Qi <hengqi@linux.alibaba.com>

[ Upstream commit b50f2af9fbc5c00103ca8b72752b15310bd77762 ]

Virtio spec says:

	The driver MUST have negotiated the VIRTIO_NET_F_VQ_NOTF_COAL
	feature when issuing commands VIRTIO_NET_CTRL_NOTF_COAL_VQ_SET
	and VIRTIO_NET_CTRL_NOTF_COAL_VQ_GET.

So we add the feature negotiation check to
virtnet_send_{r,t}x_ctrl_coal_vq_cmd as a basis for the next bugfix patch.

Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index f32e017b62e9b..21bd0c127b05a 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3172,6 +3172,9 @@ static int virtnet_send_rx_ctrl_coal_vq_cmd(struct virtnet_info *vi,
 {
 	int err;
 
+	if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_VQ_NOTF_COAL))
+		return -EOPNOTSUPP;
+
 	err = virtnet_send_ctrl_coal_vq_cmd(vi, rxq2vq(queue),
 					    max_usecs, max_packets);
 	if (err)
@@ -3189,6 +3192,9 @@ static int virtnet_send_tx_ctrl_coal_vq_cmd(struct virtnet_info *vi,
 {
 	int err;
 
+	if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_VQ_NOTF_COAL))
+		return -EOPNOTSUPP;
+
 	err = virtnet_send_ctrl_coal_vq_cmd(vi, txq2vq(queue),
 					    max_usecs, max_packets);
 	if (err)
-- 
2.43.0



