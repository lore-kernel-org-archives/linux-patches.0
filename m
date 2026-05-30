Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60442F25E4;
	Sat, 30 May 2026 16:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158534; cv=none; b=cIBLM50nCRBB1AVufW7OCdQUu4jp6OMDri8qgNgOGNkschuBo0AeCgT+k7dAcPYRHE1qo3qx7o5s+lEejgZbQkCEa+8hnf7qcq/fP+bz0ITvvO3fCRPA8x8/+dguXeD11NMzEdxVwm9LG/oLe1VABB29oMKDcx7TBgCFiv1izBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158534; c=relaxed/simple;
	bh=Y5xeR9pkaxxWlA7LIOrnFhjxnFRln7ZFCGSgxxDnHOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1AvIOmXBWCnPiNtgKRohioqOKaEW21o0GVFdb6XaADrxe83ySMWDPOfVxTFBJ6P5i7qduqurcvBqZ7ywd9Blt6oabIYDM7OmQM57c8KFrFsbXdnajOYM4OZHAZsgZRMVVhCztqWPP56GW7hE629yAwOUyZKbyHouWjAVKKNPy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hzdxIpM/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hzdxIpM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9B51F00893;
	Sat, 30 May 2026 16:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158533;
	bh=2cO3aSB2tsLttjns6TZ0tPlZzkaAkrllnq0cjCESYDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hzdxIpM/ZClmRvEG4qB9j5q/nzpO7ZKtePxYyfGHs8KYh0lsm74JnqkEw94JSlRYO
	 sFUxIMZXVH7Pc9E/h8cYS1Abej12pGnPFo8R18HxFgCv7/fWsBlA58Tjkq28aElnxQ
	 NB7fnQ/LdoidMD/5FjpmtUfItsaQuBCFhHxZoEWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d8c285748fa7292580a9@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Martin Schiller <ms@dev.tdt.de>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/969] net: lapbether: handle NETDEV_PRE_TYPE_CHANGE
Date: Sat, 30 May 2026 17:52:38 +0200
Message-ID: <20260530160301.370731534@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b120e4432f9f56c7103133d6a11245e617695adb ]

lapbeth_data_transmit() expects the underlying device type
to be ARPHRD_ETHER.

Returning NOTIFY_BAD from lapbeth_device_event() makes sure
bonding driver can not break this expectation.

Fixes: 872254dd6b1f ("net/bonding: Enable bonding to enslave non ARPHRD_ETHER")
Reported-by: syzbot+d8c285748fa7292580a9@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/69cd22a1.050a0220.70c3a.0002.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Martin Schiller <ms@dev.tdt.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260402103519.1201565-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/lapbether.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 56326f38fe8a3..da61716a66c46 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -444,33 +444,36 @@ static void lapbeth_free_device(struct lapbethdev *lapbeth)
 static int lapbeth_device_event(struct notifier_block *this,
 				unsigned long event, void *ptr)
 {
-	struct lapbethdev *lapbeth;
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct lapbethdev *lapbeth;
 
 	if (dev_net(dev) != &init_net)
 		return NOTIFY_DONE;
 
-	if (!dev_is_ethdev(dev) && !lapbeth_get_x25_dev(dev))
+	lapbeth = lapbeth_get_x25_dev(dev);
+	if (!dev_is_ethdev(dev) && !lapbeth)
 		return NOTIFY_DONE;
 
 	switch (event) {
 	case NETDEV_UP:
 		/* New ethernet device -> new LAPB interface	 */
-		if (!lapbeth_get_x25_dev(dev))
+		if (!lapbeth)
 			lapbeth_new_device(dev);
 		break;
 	case NETDEV_GOING_DOWN:
 		/* ethernet device closes -> close LAPB interface */
-		lapbeth = lapbeth_get_x25_dev(dev);
 		if (lapbeth)
 			dev_close(lapbeth->axdev);
 		break;
 	case NETDEV_UNREGISTER:
 		/* ethernet device disappears -> remove LAPB interface */
-		lapbeth = lapbeth_get_x25_dev(dev);
 		if (lapbeth)
 			lapbeth_free_device(lapbeth);
 		break;
+	case NETDEV_PRE_TYPE_CHANGE:
+		/* Our underlying device type must not change. */
+		if (lapbeth)
+			return NOTIFY_BAD;
 	}
 
 	return NOTIFY_DONE;
-- 
2.53.0



