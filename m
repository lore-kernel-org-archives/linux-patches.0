Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5CE3AB285;
	Sat, 30 May 2026 17:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162661; cv=none; b=FfAcJCZGK7cOn+vZNibrbPG/fPuKEmuBTZ9SiPDaA7qjMP+SdfpCr6NwBQWF88F1Hytse6NXtTiRUKgCaEZTt/h8qcfUkFrqKvKSByZUHHsMlV8pOb3zVBe7dYpgkLs2bftYu2NBkAdlX6S+kLMTYZhFnGIMThW8o1maxMIY7wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162661; c=relaxed/simple;
	bh=KlmnENefY+TD59ElbWdUDOOMYJSQxz1a7ROQsnhzXxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDJ33n7Sri1hZpDceuqTSMyWDgwLxUKEZRdxyyRutYaMnVxcDM5G0Jeqw+IUFHRvknuhkGUsIi9kbPHlq1SUVweAjjip9FIBStFHLK3DWa+EAZK9J45SrO+vVbdwCETgalrN4uT5/tu6zSdVcs7Je0BOKvM6juTqEaSdrBcC0FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DTLcVNiI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DTLcVNiI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C001F00893;
	Sat, 30 May 2026 17:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162657;
	bh=J1ooY+hTdNmolOIiuPZXbtzgx0oweXmV6akdCDLVTFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DTLcVNiIXTFIn7BGVAFbbUkopPEL2VibXvTdrAfTuRL6SuWo/fV+WS4K+sgf7EP3J
	 sCZNNxpjHIH5+RmaRHNBNOPlIHzqiJGiEvmSbASKKNGhoqGmgufWUJy8PKIJqEKbsl
	 GgmKBmGQmZJS/Je+TUOHjklhuxGzMmKLxklXkoPA=
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
Subject: [PATCH 5.15 026/776] net: lapbether: handle NETDEV_PRE_TYPE_CHANGE
Date: Sat, 30 May 2026 17:55:40 +0200
Message-ID: <20260530160240.942596379@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 75613ac26641f..033d8cdde38a3 100644
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



