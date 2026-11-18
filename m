Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019149;
	b=vOS6aQHV3fVRNOzQLDjZ05LYES4nAH6CX3q48pft5M9fm/EMUKAOXms1mtVK50GPxxpb
	 zvlh2nH5UTFGg/ntsSUEkxMxPtKb1whtbEKfoFKKp3/iTMxNbcXdxLmLVkw44SP6deD4U
	 jFjWDlKjhTLxg1hZOHtCyWd2bOI1M7HsgqAv45DPaagAhrT6zUS8vYuldi3upu59PFAZE
	 ZyCK+M/IArg7k+vlLEe6T5BOs+CRiUnjslbbchtAsLOphTfN+h595X6eMdeJZHHocbHv+
	 bBZJIBw/0UGpy7XbcdN54rvYchbjKRZhwel2G5iPGNEHMRUgWjAGxTjp2NyyOWRYc7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zZrj0AAtuAyWIiVXy9siVaBi0RrZJGh3AebD++IwcB8=;
	b=3eEZJEIAXEHeZeMw8Q3it90wQScK+god2fdx25PeKuklhwCpxiLv4Rq+CUT1KT/GzZs4
	 bRwsg5ziBGa7xbvRZJjBYBElxsocXrh0KVV6C7nOgVuW+XptEueWG/qaWy1g3FQc9Po/I
	 R1SREfflWmIdR5txtDcdGhgbhVrPpDWb617yasR6alggW9vz673mDVJ9+Wm4ZPzAgibic
	 IgkNm1MXiP5thp6GQgz8GnEXc5Ki6gRjB8vmtOO7Mh6Bm/8bLWo0QMHQz9yrDk1EvfbBt
	 KnJX2WSO4lKPjL9UjhPKLro0XOY6MmGakJ0MOlzoNlALUp6MuEES7DLL6OOkLDwKsRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UZA77IBi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CBE606A32F;
	Wed, 18 Nov 2026 16:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UZA77IBi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E92851F000C5;
	Wed, 18 Nov 2026 16:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019149;
	bh=zZrj0AAtuAyWIiVXy9siVaBi0RrZJGh3AebD++IwcB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UZA77IBiDqbNg7zVq5NHd6P0ntV6TMdEjxhNKmxgtaDX3ZbjE69NEhFmLGy/ppiP7
	 TI69W74ZV8KtW5AafY7kFqOEqI0BJDQeJ+GooUYbUGypi24BW2JvJb4J3DFF+mEX4k
	 CwOxtGrbHsYeGy2Wt0OxfjOBvfnxv/pxn7L4bBwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1494/2651] wifi: mt76: keep beacons from queueing the scan work during an abort
Date: Wed, 18 Nov 2026 15:45:34 +0100
Message-ID: <20261118150341.806521723@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 49701802948aadc573d84840853e04c9f1cf6777 ]

mt76_abort_scan() clears beacon_wait and then cancels the scan work. A
scan work that runs at that time can set beacon_wait again when it
moves to a NO_IR or radar channel. After the cancel, a beacon on that
channel makes mt76_scan_rx_beacon() queue the work again. The work then
runs without dev->mutex while mt76_scan_phy_complete() removes the scan
link, so mt76_scan_send_probe() can use the removed link. Reachable via
mac80211 cancel_hw_scan, chanctx changes, interface removal and the
mt7996 reset work.

Disable the scan works instead of cancelling them, so that no beacon
can queue them until the abort completes the scan. Enable them again
with dev->mutex held, so that a scan that mt76_hw_scan() starts after
the abort can always queue its work.

Fixes: 360552c8592d ("wifi: mt76: support upgrading passive scans to active")
Link: https://patch.msgid.link/20261007112419.1277594-9-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/scan.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/scan.c b/drivers/net/wireless/mediatek/mt76/scan.c
index ada7a8984971a..3271a2fa100df 100644
--- a/drivers/net/wireless/mediatek/mt76/scan.c
+++ b/drivers/net/wireless/mediatek/mt76/scan.c
@@ -76,14 +76,17 @@ void mt76_abort_scan(struct mt76_dev *dev)
 		phy->scan.beacon_wait = false;
 		spin_unlock_bh(&dev->scan_lock);
 
-		cancel_delayed_work_sync(&phy->scan_work);
+		disable_delayed_work_sync(&phy->scan_work);
 	}
 
 	mutex_lock(&dev->mutex);
 	for (i = 0; i < ARRAY_SIZE(dev->phys); i++) {
 		phy = dev->phys[i];
-		if (phy)
-			mt76_scan_phy_complete(phy, true);
+		if (!phy)
+			continue;
+
+		mt76_scan_phy_complete(phy, true);
+		enable_delayed_work(&phy->scan_work);
 	}
 	mutex_unlock(&dev->mutex);
 }
-- 
2.53.0



