Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C44F18CBE9;
	Tue, 10 Sep 2024 10:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963062; cv=none; b=LggHGCWQ0RBLJ9tprDUA1H/R3VcGEwFBKBErjtorsVupzLsjGOu2vOqH8Wiarb16DNcryLsKjC4N7iosQV3skUqMx1OxFDQUEncZPHDbqDknXOgp1NUW/PTlbGBj5H+3OOYZ9R/IBJ6kyMlaiuLNjydgifCpSbI8jrZkvZB6i0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963062; c=relaxed/simple;
	bh=Uoym0uFAX8WBMTMlVt2tQxX4r0Q6zuNMIGajuEcWq00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Afx1JQhkVvegPdSq6p6whOUjfO3QFk2G/K6amRT+wjUZ7WUM50HB0IlsWxMVYUaZwWARvUK2wezyF0bNmD+wo7o6BhxwGxNqb1ZYkb5nmUJsP3GCCRvf9Hhyzm55x4uzuldC4mntdJ/ONFsqfROvwPuG12awRO0DiWDWkAYu6pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pfqfGhoj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pfqfGhoj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCFFC4CEC3;
	Tue, 10 Sep 2024 10:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963062;
	bh=Uoym0uFAX8WBMTMlVt2tQxX4r0Q6zuNMIGajuEcWq00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pfqfGhojEkIiMGCrUqEk7PBKeJMA+FPubt98oFWGF5dJS/6yWP/tFEXhqSk/HoNKJ
	 jnNFy9f71TGUzxESfI6hw/SWd/a/LofvsVWBAR38f2NzaM5rxXJNiLMxc9UUEt2ceY
	 DYm4Qm2UJHmZxpD6h5uYDBuOTRju/i2dzOHdWFZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Foster Snowhill <forst@pen.gy>,
	Georgi Valkov <gvalkov@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 123/192] usbnet: ipheth: race between ipheth_close and error handling
Date: Tue, 10 Sep 2024 11:32:27 +0200
Message-ID: <20240910092603.096659950@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6a769df0b421..13381d87eeb0 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -353,8 +353,8 @@ static int ipheth_close(struct net_device *net)
 {
 	struct ipheth_device *dev = netdev_priv(net);
 
-	cancel_delayed_work_sync(&dev->carrier_work);
 	netif_stop_queue(net);
+	cancel_delayed_work_sync(&dev->carrier_work);
 	return 0;
 }
 
-- 
2.43.0



