Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6E71E2834;
	Wed, 25 Feb 2026 01:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983538; cv=none; b=hVxcejI9Ub7TwhNJz3+qhu+wKXvSikpq+2Ht0FCBXtthRmFpsY6qV0tG/3YH1rg+0iWFIJT5bWTOw7bSGfw6fuY1b6o1nI0mBQhaEb1xX1DLIzM2dTMxHRqwhFKsNaIIj6FTWk7MwNnhDfZmQXdqPWey4WaPaf9WaoZeO5d4jmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983538; c=relaxed/simple;
	bh=4b2XzWZ9pz/PvmZw/yEslev6Q3jbSdZxeFnf5DtJ0SA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K90ZeiXutHhIFYvtxnFoAGQdNmxWJlD3/8rVkIs00ynVolXxmrbm9UNilMMWO1+I6GtVNJopZh3R6L79h+cr65MxtuUdc+cLk8dRTa8IDa+lJOcWq8ViYcSYkKy4XhrsF28ay8MOcgBWl3c2MdvCzNF7GyywUWdOwEqszYGKwJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sBt0itTl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sBt0itTl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDFDFC116D0;
	Wed, 25 Feb 2026 01:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983538;
	bh=4b2XzWZ9pz/PvmZw/yEslev6Q3jbSdZxeFnf5DtJ0SA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sBt0itTlDNsSzxWloJ4TGyk1LQPX/HFFclXNvKkG/mGBn/MCnX4Tz5OAkJpBTyenf
	 lRBOJYDHj8yJ7d6jyGIL7dtpX8LA30/G8Sd+3qBe0rKfh4/BkxLQT0ha14Ku2aPW5q
	 JrUIHiqh/j+2Jxym3bw5iNN1LBua8y92GjVBTIpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 642/781] net: mscc: ocelot: add missing lock protection in ocelot_port_xmit_inj()
Date: Tue, 24 Feb 2026 17:22:31 -0800
Message-ID: <20260225012415.549240482@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ziyi Guo <n7l8m4@u.northwestern.edu>

[ Upstream commit 026f6513c5880c2c89e38ad66bbec2868f978605 ]

ocelot_port_xmit_inj() calls ocelot_can_inject() and
ocelot_port_inject_frame() without holding the injection group lock.
Both functions contain lockdep_assert_held() for the injection lock,
and the correct caller felix_port_deferred_xmit() properly acquires
the lock using ocelot_lock_inj_grp() before calling these functions.

Add ocelot_lock_inj_grp()/ocelot_unlock_inj_grp() around the register
injection path to fix the missing lock protection. The FDMA path is not
affected as it uses its own locking mechanism.

Fixes: c5e12ac3beb0 ("net: mscc: ocelot: serialize access to the injection/extraction groups")
Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20260208225602.1339325-4-n7l8m4@u.northwestern.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index a7966c174b2e2..1b82693204640 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -597,14 +597,22 @@ static netdev_tx_t ocelot_port_xmit_inj(struct sk_buff *skb,
 	int port = priv->port.index;
 	u32 rew_op = 0;
 
-	if (!ocelot_can_inject(ocelot, 0))
+	ocelot_lock_inj_grp(ocelot, 0);
+
+	if (!ocelot_can_inject(ocelot, 0)) {
+		ocelot_unlock_inj_grp(ocelot, 0);
 		return NETDEV_TX_BUSY;
+	}
 
-	if (!ocelot_xmit_timestamp(ocelot, port, skb, &rew_op))
+	if (!ocelot_xmit_timestamp(ocelot, port, skb, &rew_op)) {
+		ocelot_unlock_inj_grp(ocelot, 0);
 		return NETDEV_TX_OK;
+	}
 
 	ocelot_port_inject_frame(ocelot, port, 0, rew_op, skb);
 
+	ocelot_unlock_inj_grp(ocelot, 0);
+
 	consume_skb(skb);
 
 	return NETDEV_TX_OK;
-- 
2.51.0



