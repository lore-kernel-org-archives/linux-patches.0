Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C7717A31C;
	Mon, 20 Apr 2026 15:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700764; cv=none; b=dWphIuZkVnSHg2gG/MWas0wqd0qN24oJVE1I9/c62CPJV95qZvu3dmIycHI1m3DVGFYa4aa6KK0Mw0RSuZmZIrPwRfYcGDPplOwcnJl0izMcQuvC85ITfscVadOAFD/6w2HylAtLnW1OzFY7cLDabHN+OlAtW8MlNhIgWNDkckA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700764; c=relaxed/simple;
	bh=MD6JnO4tNTiC8t62FNVGk9PLMImIXtPzGDxwtH0aP70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qT5r1Yf9mFJPtb8i3JVcOdplSr9Y1EkOeYK+OdbBi3QopgwWlTl20Fq4KKOSJw9uzf4TkJPCiNUYl4HkfX8Z/CNzT7uEKysYcEc2MHPKK5RI4qHMOKRksXY1HDB+ZzprYR2IkmY5nQYPXGHaDDIEdNHoRIB8nB8ZU6stUR/uUWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M25LJIj8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M25LJIj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203B9C19425;
	Mon, 20 Apr 2026 15:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700764;
	bh=MD6JnO4tNTiC8t62FNVGk9PLMImIXtPzGDxwtH0aP70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M25LJIj8thAWaIzIdh+tTbYnWpwl//Hon9ZvMJpMzPLYswy/NN6RFf9kZBOu8Rdd9
	 tmts9emykQfPS5/fJ3S+5uYZCDzyyi8FJwtCsNdccYxmDQzZ8qS8cKl+doOXQJ3aIJ
	 zvTjffdSDzqrbB/8QmMIz34rjfz7vKXj7RomwaNI=
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
Subject: [PATCH 6.18 071/198] net: lapbether: handle NETDEV_PRE_TYPE_CHANGE
Date: Mon, 20 Apr 2026 17:40:50 +0200
Message-ID: <20260420153938.167500779@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f357a7ac70ac4..9861c99ea56c4 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -446,33 +446,36 @@ static void lapbeth_free_device(struct lapbethdev *lapbeth)
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



