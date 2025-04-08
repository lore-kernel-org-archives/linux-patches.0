Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23659267F4F;
	Tue,  8 Apr 2025 12:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115188; cv=none; b=ZWOqhIekIUc55ov0t0V5K5YB70dj5kuyzwqMlHpuNQd5S+c36WZSFekeuPDk+5qaJa90LVA0hefqmVcBBtGl6rrASw15TSpMkCAh/7fVBhQbV8gyaVapYd84hXjU+PdhBMZz8JqxLidLe7mSn69I2yNzM4qMTZ77Yov/0iK4dNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115188; c=relaxed/simple;
	bh=yfBB0wx4R1r62REePHe4+LwT2e4Zwl2M/fgqfCuFwks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mN3swFr/gjMksTt3jcwCiiKOfTenKbX8V/c97Ga5Jg0W3tnYV0e408kVj626ZnjJo5bYXRl2Kpv4z+ob+K6aDl87uMsgzFk5LnYSMVKkYDq7hP8jHY6VANQAZC7wO2cXnHkJHc3R5Qq3eCHhruCYYPczPhdlSVcOas+kuOe8vn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TABv+sUq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TABv+sUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93C8C4CEE5;
	Tue,  8 Apr 2025 12:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115188;
	bh=yfBB0wx4R1r62REePHe4+LwT2e4Zwl2M/fgqfCuFwks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TABv+sUqAJZ0EEfwYreMCZOejm4wI/5ARznj34Lcn1SPvsyY+SHGwVEh8Ns8SrIHm
	 3KdDv8myhxWeY15eJvdY1nH60y5cl3zNQX1HtLOsyXH5ZYrWmBNxCU5ifNsEnDe7ni
	 TqaevrY1tVMynKWLgOfOTBR+dKNFU2dLahqQ1CiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taehee Yoo <ap420073@gmail.com>,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 343/499] net: devmem: do not WARN conditionally after netdev_rx_queue_restart()
Date: Tue,  8 Apr 2025 12:49:15 +0200
Message-ID: <20250408104859.778349245@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit a70f891e0fa0435379ad4950e156a15a4ef88b4d ]

When devmem socket is closed, netdev_rx_queue_restart() is called to
reset queue by the net_devmem_unbind_dmabuf(). But callback may return
-ENETDOWN if the interface is down because queues are already freed
when the interface is down so queue reset is not needed.
So, it should not warn if the return value is -ENETDOWN.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Link: https://patch.msgid.link/20250309134219.91670-8-ap420073@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/devmem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/devmem.c b/net/core/devmem.c
index 11b91c12ee113..17f8a83a5ee74 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -108,6 +108,7 @@ void net_devmem_unbind_dmabuf(struct net_devmem_dmabuf_binding *binding)
 	struct netdev_rx_queue *rxq;
 	unsigned long xa_idx;
 	unsigned int rxq_idx;
+	int err;
 
 	if (binding->list.next)
 		list_del(&binding->list);
@@ -119,7 +120,8 @@ void net_devmem_unbind_dmabuf(struct net_devmem_dmabuf_binding *binding)
 
 		rxq_idx = get_netdev_rx_queue_index(rxq);
 
-		WARN_ON(netdev_rx_queue_restart(binding->dev, rxq_idx));
+		err = netdev_rx_queue_restart(binding->dev, rxq_idx);
+		WARN_ON(err && err != -ENETDOWN);
 	}
 
 	xa_erase(&net_devmem_dmabuf_bindings, binding->id);
-- 
2.39.5



