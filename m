Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1902134AC;
	Mon, 12 Aug 2024 16:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479960; cv=none; b=ASXASL4/Ruy7lCzXePqDliZTP6fMrIA2LQRjTjcNyFYG6gTdVoB0xASXW7W15wN04GCer0fcB96/tL2GVMrE8euHjB0NjUAoJtv3bhbQ+KrQ17r5LWibQPlZzHmjGGeRRSiu5jpMew2K01tzvBHaxqGGT9BGqLrLbGYI3HJUXI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479960; c=relaxed/simple;
	bh=1FHsjelaq+IOlb6hUbmDnhZFccBX9gALgsjSMfKj4tY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UZvGXSNccfWXJz4OboQv3IlcN/S+92z/URMe32Men2UDVHotZJlFyTjNQrIhpS3txk2bADFcvKIgBBvCKHANlW3rh3W1RNxtOOV3E3S19lbxX0ws8noFjdQIMUnz6QFJjPj8sP8lfZ7rND1Ylj8/JpJbzXmlU8zuVVtVT5KVzMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FRo/zbNi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FRo/zbNi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649EBC4AF0C;
	Mon, 12 Aug 2024 16:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479959;
	bh=1FHsjelaq+IOlb6hUbmDnhZFccBX9gALgsjSMfKj4tY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FRo/zbNiBYEgYF4UgIkYngZrX8Vr3fZQ2Pp6eG0BPcudPmjdQ+CltyzccV74aU3JR
	 63wUs+JKySqK7zDhKkJQ9L3ubAl5lbLdfiVKmYxjgM/lAwICxAK+gy1DN0mxjvVS9T
	 96Le1bPGrgQUrzbD1s7Csf+RyA8o/fp7qrYQyUrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heng Qi <hengqi@linux.alibaba.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9=20rez?= <eperezma@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 022/263] virtio-net: unbreak vq resizing when coalescing is not negotiated
Date: Mon, 12 Aug 2024 18:00:23 +0200
Message-ID: <20240812160147.391709548@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heng Qi <hengqi@linux.alibaba.com>

[ Upstream commit 4ba8d97083707409822264fd1776aad7233f353e ]

Don't break the resize action if the vq coalescing feature
named VIRTIO_NET_F_VQ_NOTF_COAL is not negotiated.

Fixes: f61fe5f081cf ("virtio-net: fix the vq coalescing setting for vq resize")
Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Eugenio Pé rez <eperezma@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 5161e7efda2cb..f32e017b62e9b 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3257,7 +3257,11 @@ static int virtnet_set_ringparam(struct net_device *dev,
 			err = virtnet_send_tx_ctrl_coal_vq_cmd(vi, i,
 							       vi->intr_coal_tx.max_usecs,
 							       vi->intr_coal_tx.max_packets);
-			if (err)
+
+			/* Don't break the tx resize action if the vq coalescing is not
+			 * supported. The same is true for rx resize below.
+			 */
+			if (err && err != -EOPNOTSUPP)
 				return err;
 		}
 
@@ -3272,7 +3276,7 @@ static int virtnet_set_ringparam(struct net_device *dev,
 							       vi->intr_coal_rx.max_usecs,
 							       vi->intr_coal_rx.max_packets);
 			mutex_unlock(&vi->rq[i].dim_lock);
-			if (err)
+			if (err && err != -EOPNOTSUPP)
 				return err;
 		}
 	}
-- 
2.43.0



