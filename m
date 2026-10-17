Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E52202F70;
	Sat, 17 Oct 2026 16:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254689; cv=none; b=GxA3yhZUX9aKCl5x2e6pv2iwWmLs2jOb9Cj726EMtzXm3xkrQ4rDEyTUf1xxWp4mZBSeXTY8ZJBcSRyLy3UByTaw623449b/WJqC8X6czwPmFTZcA9XmfKbE2QW0QyFDApOrIXU7DCp3R6S93+9Hi5NmoNhZ5+LrftI8zcz7Qx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254689; c=relaxed/simple;
	bh=zbfnBZIZI+oCA87O5QJEKzZUZo01WGeIBV8CC8DHUps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J8vtDV80ok4h2vWOrjwj93tL9/3NY23ZqtslJ1SxL8hwPmJ0LsDJ/YSrcfhD13c/fwfbAbFAKDwepk4o/pMVHDtm6w8uRdqCoZFYbiZyn2i5YjCgXI1NiNfm5biu8j7Td6mCnMjJjREzTsx+2Gb2QlbFtg2mw6CWWhFvdO02dOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0MjaU72S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0MjaU72S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B655E1F000C4;
	Sat, 17 Oct 2026 16:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254688;
	bh=91O2DPFlfnkghISI46AYYhuxZ/y6rQxWNKEfCEKdOTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0MjaU72SbjWv5yvE9AnCQNNvaaDxyE0UW9Ec+QSwJAAWdApN29BpUSaBW0mHSRCwB
	 v9GskQPm/+xcNyO7GFIuc8foP8TVfNnyCLC9wyfRkZ3hgFF2XaZi1kdbxQPLo1BttH
	 T3QLEDtYHrmwbISc+JqPaJp8AKerLv++nP77mTCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e0bd4e4815a910c0daa8@syzkaller.appspotmail.com,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 530/869] ieee802154: Avoid calling WARN_ON() on -ENOMEM in cfg802154_switch_netns()
Date: Sat, 17 Oct 2026 17:56:11 +0200
Message-ID: <20261017160050.697570555@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Abramov <i.abramov@mt-integration.ru>

[ Upstream commit 0569f67ed6a7af838e2141da93c68e6b6013f483 ]

It's pointless to call WARN_ON() in case of an allocation failure in
dev_change_net_namespace() and device_rename(), since it only leads to
useless splats caused by deliberate fault injections, so avoid it.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 66e5c2672cd1 ("ieee802154: add netns support")
Reported-by: syzbot+e0bd4e4815a910c0daa8@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/000000000000f4a1b7061f9421de@google.com/#t
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Ivan Abramov <i.abramov@mt-integration.ru>
Link: https://lore.kernel.org/20250403101935.991385-3-i.abramov@mt-integration.ru
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
index 4a4379c828b90..9b807f78a3105 100644
--- a/net/ieee802154/core.c
+++ b/net/ieee802154/core.c
@@ -245,7 +245,7 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 			wpan_dev->netdev->netns_local = false;
 			err = dev_change_net_namespace(wpan_dev->netdev, net,
 						       "wpan%d");
-			WARN_ON(err);
+			WARN_ON(err && err != -ENOMEM);
 			wpan_dev->netdev->netns_local = true;
 		}
 
@@ -255,7 +255,7 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 	wpan_phy_net_set(&rdev->wpan_phy, net);
 
 	err = device_rename(&rdev->wpan_phy.dev, dev_name(&rdev->wpan_phy.dev));
-	WARN_ON(err);
+	WARN_ON(err && err != -ENOMEM);
 
 	return 0;
 }
-- 
2.53.0



