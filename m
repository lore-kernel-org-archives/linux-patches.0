Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9624743C7A8;
	Mon, 17 Aug 2026 13:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975045; cv=none; b=FizCKEaGFjt9PlHSYc9CZRPlWodk2wEeaP/CTKHMlTP1uOPSLyY03S9Xm2Z9l7PF8jO8hBT5YZUyyB4A11YVHN67ArXo9PmaiIm4YeZNN2mdTT/yFvwnsjROsAmfPm8csJUCnwSf438WySpfLFqcRhBHrEwTYcAmikhL/1Bgy3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975045; c=relaxed/simple;
	bh=hrCzbBB35Fksc1QEQyQRv+mgkg69xTkTUNz3VrcEoLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cOTwT1/CJ2ygyxRmvpwzyG+MXWw0FpYF4TafGpQnSQavk8+wO5zPtMhR2Inj0wGfkK9QTh1oql29o/y/XvqfuwbVEzS6f2AcGBr+q3bG1O77YQQuVwTAbhuXykSR8iyEC/2ustQph7wMz85vUMjVZadL+EU8qtTHzMEBLt2q6ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zKxz6E7S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zKxz6E7S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF32F1F000E9;
	Mon, 17 Aug 2026 13:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975044;
	bh=9PAodvtdYpfb7RX3vHldXFug5jVVOcAx3jf62Gao/0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zKxz6E7SRV996E8QdlVdds3YR5Fnvdw0jj0gGVE6H8HQWtPQ3s7Gb1AyECEsvF16B
	 H210/qFo+/Y0YFgPURZdMXosamTjzci+pV3eN+ake1WaSEfmm5Uu+deocRrDsuoZ61
	 7mOIT9ODf/oRzPq2bsPDrrKDea7ba+fNFDQ8Avgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zihan Xi <zihanx@nebusec.ai>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 142/250] mac802154: fix netdev use-after-free in beacon worker
Date: Mon, 17 Aug 2026 15:31:43 +0200
Message-ID: <20260817132542.354940957@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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


