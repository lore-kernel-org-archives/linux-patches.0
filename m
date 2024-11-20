Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BDA1A76C6;
	Wed, 20 Nov 2024 12:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107494; cv=none; b=q2jwCThqQ/zbs+qC7n6jQrF10R5V0X3sOQT4WwzJFBYDiR9WyzeANaXY/a+rc7t95cNVqijiQxPh3MQbej6t5G5HerZKT+TUgmRFu0s4IVtmbqh7NDNoVU6n39aVqQ28nncpocHPXbCESyvoWcoARBn+4NDT8Ktg8gtFCWcDuXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107494; c=relaxed/simple;
	bh=9vVSnWxUXKALwKMvQi44gYENpGfdpRF+HT1y4E8xE40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BlvCOi2yJIuzQZPbuEW8rhX2izPWucO7FXWGHVWZl1Umt+ZYHSmPqXJx0HagFY3/qm2zl773WQCsiMDWd6xrEn8JHBqZ23qRoZv1nEy4M8Yy9L7qnws3Q6uk2U9xAB0l+psuYyyWJzahFJORqcjBoefJExJg2dTbQT/YNCWl0YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rsCTJr47; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rsCTJr47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848FCC4CED8;
	Wed, 20 Nov 2024 12:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107494;
	bh=9vVSnWxUXKALwKMvQi44gYENpGfdpRF+HT1y4E8xE40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rsCTJr47pWirFTGX69UNUsvYPHzhz/curStA+3okWUrvJkCtFL4H3BDYQ+JDi4bM3
	 kWJIgHcWs5qaRGzfrAPXqKfP6+M7ZN2rZ4HB2EguZSfD6MitxjdcTXxbPKUTJ6GdC3
	 SKCEX8evDWTOTQpUYwyxZYy3oEdihSnCD1wyMkK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 017/107] virtio/vsock: Improve MSG_ZEROCOPY error handling
Date: Wed, 20 Nov 2024 13:55:52 +0100
Message-ID: <20241120125630.066430223@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit 60cf6206a1f513512f5d73fa4d3dbbcad2e7dcd6 ]

Add a missing kfree_skb() to prevent memory leaks.

Fixes: 581512a6dc93 ("vsock/virtio: MSG_ZEROCOPY flag support")
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Acked-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/virtio_transport_common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 5437819872dd7..0211964e45459 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -400,6 +400,7 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 			if (virtio_transport_init_zcopy_skb(vsk, skb,
 							    info->msg,
 							    can_zcopy)) {
+				kfree_skb(skb);
 				ret = -ENOMEM;
 				break;
 			}
-- 
2.43.0



