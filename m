Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C59417366;
	Thu,  2 Jul 2026 16:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009428; cv=none; b=tbtyoa/vXxW3J97bymoYdP72x8aISuJJPSjFy8cXq/m2fy8niNB8/GZ/6ZvVHhJNMTWmYoNbyumpm0PAeCTegKCetcCQmuaIKRVqn8ygT6fvVZ/ipgDikDpLJK9WZBtx4DA+RexP1xM9zM+GLjclG6FTHNI4xA8KZ0o+798mpdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009428; c=relaxed/simple;
	bh=M3okWT1R1GxCHLIKXyaBATj5V2ZT1ZBrpq0myxncmjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DvO24KQ2C40W9J8unpxjrLweMsmv+nBR18vbcE/i50cvsddURhN1Wzfm/X8LSURJq9tmdeFHoD2NctuiJYcpdY/yPVDi+bBXBKWr8Wua9AIfxVYd9E3WHylVCNqHG2Bf6Co83nuASEUqtW5E/uxPoPFzKAYHhWiBRzPWLKscd+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BdSrFzhz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BdSrFzhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E00A11F00A3D;
	Thu,  2 Jul 2026 16:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009421;
	bh=SpXPF4sPgcIQaHwPwUrKoh8iD181SjuXqLthMxLVyUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BdSrFzhzlU2OBJoQ+eAPjx+8g05/WiXcb0cKeJms3EDwEaPDQpGmlyJHyIDXnsNu+
	 jXQomTB7RWWd+h2alKYv4cMjnJ5zXj72/DQjfkL9Yl4L3BRm096z+wEYruSaJ+MFuM
	 zwwW4ptBwdwo3dzu+2VZLhkfJq604QU/dZDfC+Io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 43/96] batman-adv: prevent ELP transmission interval underflow
Date: Thu,  2 Jul 2026 18:19:35 +0200
Message-ID: <20260702155109.892464823@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 5e50d4b8ae3ea622122d3c6a38d7f6fe68dfddca upstream.

batadv_v_elp_start_timer() enqeues a delayed work. The time when it starts
is randomly chosen between (elp_interval - BATADV_JITTER) and
(elp_interval + BATADV_JITTER). The configured elp_interval must therefore
be larger or equal to BATADV_JITTER to avoid that it causes an underflow of
the unsigned integer. If this would happen, then a "fast" ELP interval
would turn into a "day long" delay.

At the same time, it must not be larger than the maximum value the variable
can store.

Cc: stable@kernel.org
Fixes: a10800829040 ("batman-adv: Add elp_interval hardif genl configuration")
[ Context ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/netlink.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/batman-adv/netlink.c b/net/batman-adv/netlink.c
index 0b5cb03859b25b..e5a0b2c97162d2 100644
--- a/net/batman-adv/netlink.c
+++ b/net/batman-adv/netlink.c
@@ -939,9 +939,15 @@ static int batadv_netlink_set_hardif(struct sk_buff *skb,
 #ifdef CONFIG_BATMAN_ADV_BATMAN_V
 
 	if (info->attrs[BATADV_ATTR_ELP_INTERVAL]) {
+		u32 elp_interval;
+
 		attr = info->attrs[BATADV_ATTR_ELP_INTERVAL];
+		elp_interval = nla_get_u32(attr);
+
+		elp_interval = min_t(u32, elp_interval, INT_MAX);
+		elp_interval = max_t(u32, elp_interval, BATADV_JITTER);
 
-		atomic_set(&hard_iface->bat_v.elp_interval, nla_get_u32(attr));
+		atomic_set(&hard_iface->bat_v.elp_interval, elp_interval);
 	}
 
 	if (info->attrs[BATADV_ATTR_THROUGHPUT_OVERRIDE]) {
-- 
2.53.0



