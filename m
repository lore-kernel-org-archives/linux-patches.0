Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E5318B46D;
	Tue, 10 Sep 2024 09:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961225; cv=none; b=dteus7js8W/kWkhn6b3w8x7DAylOigtaTrZ1eOv0L7QVjAF5oPkU6MwOirQr82VebpUShemhM3eRb3dfS1zsQpVZ2X8qgzvjCJi6+BAyTghO7bbLTv5OUQq+lTqh9CjXGFQ1RTv5kJBCbfvBn4t0QZTlFEWQsY9jk3SvlzQ0ofY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961225; c=relaxed/simple;
	bh=kX4CaXxGfg/qCO3hvIjR//RSmvb8/UCdLEtq5Rgwwkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gg/Tx8O5OAFKk9TOwU7nplk+2eCJSCLzF6Fd84WowQTOBkpkQPBS/sZ40OMOOIyQC7MFl5Q35mde1p79IDWcUPJNPhq3EY8pWNqeFO2qeEL83v2yjUX8npnOYLu0+q+4fBBUES9AQFxbAkZdiVFkkIaEaOPjUnAh6VMkUv4uPf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EG8km3l5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EG8km3l5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4004AC4CEC3;
	Tue, 10 Sep 2024 09:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961225;
	bh=kX4CaXxGfg/qCO3hvIjR//RSmvb8/UCdLEtq5Rgwwkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EG8km3l5bK5QuWFrGy7JzYobRjwUB8MgCe0tpcQvzudiwMwn+K4Yz5kEhRHgQ6O9M
	 mjqrLCI+8Z3Go2BlKjvY0K9wDWQ9KBMc+8olOS8yxiX4ERXeAzPZ48c7IB6LYjWiDJ
	 UFprwLzFc3sXj1BJoVrj2biuv0RxNGVxzo9rMU2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Foster Snowhill <forst@pen.gy>,
	Georgi Valkov <gvalkov@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 69/96] usbnet: ipheth: race between ipheth_close and error handling
Date: Tue, 10 Sep 2024 11:32:11 +0200
Message-ID: <20240910092544.584176435@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit e5876b088ba03a62124266fa20d00e65533c7269 ]

ipheth_sndbulk_callback() can submit carrier_work
as a part of its error handling. That means that
the driver must make sure that the work is cancelled
after it has made sure that no more URB can terminate
with an error condition.

Hence the order of actions in ipheth_close() needs
to be inverted.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Foster Snowhill <forst@pen.gy>
Tested-by: Georgi Valkov <gvalkov@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/ipheth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index 5e8fd2aa1888..0a86ba028c4d 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -407,8 +407,8 @@ static int ipheth_close(struct net_device *net)
 {
 	struct ipheth_device *dev = netdev_priv(net);
 
-	cancel_delayed_work_sync(&dev->carrier_work);
 	netif_stop_queue(net);
+	cancel_delayed_work_sync(&dev->carrier_work);
 	return 0;
 }
 
-- 
2.43.0



