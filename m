Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8E1611A
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5079C433C8;
	Mon, 28 Aug 2023 10:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219282;
	bh=MNZ22KkZNghR2IfkLSw4sPcNZsLHKPYIXkhtblOFFDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2tRcJgyhW+LJipdrgzA8gkkwG1dYQpkJKaqjJFywfklgsYL76fL0zUtDCBPjTkK3m
	 UEypOl/m+/a98+D8+zYS5TQcgnxHypE7JAkUbfs/x9s9udXq1ZE2DNxLtWSwcAf429
	 D2fY1ocDKt4le2irBXNDkytV83/XlTwW4IJcgdTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f8812454d9b3ac00d282@syzkaller.appspotmail.com,
	Sven Eckelmann <sven@narfation.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 139/158] batman-adv: Hold rtnl lock during MTU update via netlink
Date: Mon, 28 Aug 2023 12:13:56 +0200
Message-ID: <20230828101202.222488327@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.322319621@linuxfoundation.org>
References: <20230828101157.322319621@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 987aae75fc1041072941ffb622b45ce2359a99b9 upstream.

The automatic recalculation of the maximum allowed MTU is usually triggered
by code sections which are already rtnl lock protected by callers outside
of batman-adv. But when the fragmentation setting is changed via
batman-adv's own batadv genl family, then the rtnl lock is not yet taken.

But dev_set_mtu requires that the caller holds the rtnl lock because it
uses netdevice notifiers. And this code will then fail the check for this
lock:

  RTNL: assertion failed at net/core/dev.c (1953)

Cc: stable@vger.kernel.org
Reported-by: syzbot+f8812454d9b3ac00d282@syzkaller.appspotmail.com
Fixes: c6a953cce8d0 ("batman-adv: Trigger events for auto adjusted MTU")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20230821-batadv-missing-mtu-rtnl-lock-v1-1-1c5a7bfe861e@narfation.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/netlink.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/batman-adv/netlink.c
+++ b/net/batman-adv/netlink.c
@@ -496,7 +496,10 @@ static int batadv_netlink_set_mesh(struc
 		attr = info->attrs[BATADV_ATTR_FRAGMENTATION_ENABLED];
 
 		atomic_set(&bat_priv->fragmentation, !!nla_get_u8(attr));
+
+		rtnl_lock();
 		batadv_update_min_mtu(bat_priv->soft_iface);
+		rtnl_unlock();
 	}
 
 	if (info->attrs[BATADV_ATTR_GW_BANDWIDTH_DOWN]) {


