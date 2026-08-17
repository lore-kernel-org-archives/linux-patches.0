Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214214322E5;
	Mon, 17 Aug 2026 14:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978095; cv=none; b=HiUIIfN0AhrMuyEFfYas7kkvlz31BjPGjyNCuQ9xMxx1zu5gRsajTeYgqG7wb6jpJBEKajUa3EgKVEQXLP24DyJkzSRMwhjQcd3wshnjBGDThWW4FeLWQXXYxGxukmMlLNf4Nlq8pWKpXMKWXuI/MFleTI1EA2VAyOIkzlClIN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978095; c=relaxed/simple;
	bh=oJEYY13lI5FT+JLE5AmvQZ2Mg0swiC5oNBqccjoql9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbzpFCOEduT+kilBuDZmIHWESwFZ7h7X2+WUQu59c3fjCLB2m05YmFChq2p5ZRr0iFc6qnqEuy+fCcYa0dmmxqwXMAKN55zTCXvlE9PHY0lOJ9ACCJvAguXA5Jg+bLIvBC8z6GUab78Mz3X/uPK/OQJpIwuUTkqMS28wC1zK/sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AyQxQDdy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AyQxQDdy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334471F000E9;
	Mon, 17 Aug 2026 14:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978093;
	bh=dCxW7EDO/TzuGfNBT6FOEjiZ0/YmgdGL00jTJ5e+zuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AyQxQDdyoML8e4jq8HQQaJtqzeRWgz8P9cMHwDOc6pfPqHn1Ztyx2HQsHZ3BoOSWL
	 zLFTmQnA0L/GvdP60QJq2qGmETCtKKs+9RezgaoaCnpN57edQ/p7sOhoGF50qkY6VG
	 ZdhZb0CTQmCsM/poX+qCXoDXiV8pGYJ8ljeAK9cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zihan Xi <zihanx@nebusec.ai>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 099/181] mac802154: fix netdev use-after-free in beacon worker
Date: Mon, 17 Aug 2026 15:33:13 +0200
Message-ID: <20260817132539.358032962@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

From: Zihan Xi <zihanx@nebusec.ai>

commit 5f26a690e8efa54315e4922368daf54e0b8f5515 upstream.

mac802154_beacon_worker() reads local->beacon_req under RCU and derives
the sub-interface from the request, but then drops the RCU read lock and
continues to use both sdata and the embedded wpan_dev.

mac802154_stop_beacons_locked() cancels only pending beacon work, clears
local->beacon_req and frees the request.  A beacon worker that is already
running can therefore continue after interface teardown and dereference
the freed netdev private area.

The scan worker already pins the netdev before leaving RCU.  Apply the
same lifetime rule to the beacon worker: take a netdev reference while
the request is still protected by RCU, and release it on all paths that
continue after the reference is acquired.

Fixes: 3accf4762734 ("mac802154: Handle basic beaconing")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/e9a3909c7a6281967961773ca841e860b8ecf40e.1785596603.git.zihanx@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac802154/scan.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/mac802154/scan.c
+++ b/net/mac802154/scan.c
@@ -415,6 +415,7 @@ void mac802154_beacon_worker(struct work
 		container_of(work, struct ieee802154_local, beacon_work.work);
 	struct cfg802154_beacon_request *beacon_req;
 	struct ieee802154_sub_if_data *sdata;
+	netdevice_tracker dev_tracker;
 	struct wpan_dev *wpan_dev;
 	u8 interval;
 	int ret;
@@ -427,12 +428,14 @@ void mac802154_beacon_worker(struct work
 	}
 
 	sdata = IEEE802154_WPAN_DEV_TO_SUB_IF(beacon_req->wpan_dev);
+	netdev_hold(sdata->dev, &dev_tracker, GFP_ATOMIC);
 
 	/* Wait an arbitrary amount of time in case we cannot use the device */
 	if (local->suspended || !ieee802154_sdata_running(sdata)) {
 		rcu_read_unlock();
 		queue_delayed_work(local->mac_wq, &local->beacon_work,
 				   msecs_to_jiffies(1000));
+		netdev_put(sdata->dev, &dev_tracker);
 		return;
 	}
 
@@ -450,6 +453,7 @@ void mac802154_beacon_worker(struct work
 	if (interval < IEEE802154_ACTIVE_SCAN_DURATION)
 		queue_delayed_work(local->mac_wq, &local->beacon_work,
 				   local->beacon_interval);
+	netdev_put(sdata->dev, &dev_tracker);
 }
 
 int mac802154_stop_beacons_locked(struct ieee802154_local *local,


