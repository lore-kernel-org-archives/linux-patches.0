Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B442B4F85CA;
	Wed, 30 Sep 2026 16:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786586; cv=none; b=CPbb/b4suxMH4guR2xxQ06o/7XxTSbIPZNaO/1DrX9KEixa24MYS3ItJtXO/9qamOR+cBFZaEzbwjkFDS+6fLfs51dUVJQeB3yXlU34TNAQfGGVdxC620mgGPoNyvevX0fDnEsmtvbIVBWPkq0qEyd5+VOFDW68OCydJpT6Cd+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786586; c=relaxed/simple;
	bh=q8vt18I0APi2cvHJnEKMStMxKRwynv5722WvCdBnlLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=loLjLZDq/4THdc/di9ZwVAQB4IOwx1lvLxRNUperZ1twVNIXZLWmCwYygXYadW+TtuzCvVyHgEyYb2dHbVwU63/Wn7jHI0E3pjhkOY0cq9/rUJ4sdGL92FSJL8yzd2bXtATGJpQaAmV0Ll23ynYls2a8ZNrqGYN51LGZA2+Dq2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eFKLEARv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eFKLEARv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208901F000FF;
	Wed, 30 Sep 2026 16:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786585;
	bh=mQHUrmu9vu2W8IQERQKW3F98ojxwOXtrFaEDN2irRN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eFKLEARv8jKQbDbzyPi3rwICYfkByhlmFmgcCQ0bT8Qh42sD95HeE6NHb9MPDe25W
	 R1xoCD1i3Blh40SOHfYfOCHnRzFksF5nPbppK4mIKCm+uUFKg7fisO5knNOj2lQ/vY
	 5JLe/tFgBFPw0vcpV8c7E1dMjEVpOy/QUwp2DbNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	bridge@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 913/982] bridge: check llc_mac_hdr_init() return value in br_send_bpdu()
Date: Wed, 30 Sep 2026 17:27:29 +0200
Message-ID: <20260930152436.350283074@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

[ Upstream commit ac704ff08e511c87643799c385f55ecd69b85e03 ]

If llc_mac_hdr_init() fails (for instance if the port device type does
not support LLC or dev_hard_header() fails), br_send_bpdu() should drop
the skb instead of resetting the mac header to the LLC payload and
transmitting a malformed frame.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Closes: https://lore.kernel.org/netdev/179022851638.2160803.1808206741379444999@kernel.org/
Cc: Nikolay Aleksandrov <razor@blackwall.org>
Cc: Ido Schimmel <idosch@nvidia.com>
Cc: bridge@lists.linux.dev
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20260924082951.1599377-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_stp_bpdu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_stp_bpdu.c b/net/bridge/br_stp_bpdu.c
index 0e4572f313307..1917d11411d72 100644
--- a/net/bridge/br_stp_bpdu.c
+++ b/net/bridge/br_stp_bpdu.c
@@ -52,7 +52,10 @@ static void br_send_bpdu(struct net_bridge_port *p,
 			    LLC_SAP_BSPAN, LLC_PDU_CMD);
 	llc_pdu_init_as_ui_cmd(skb);
 
-	llc_mac_hdr_init(skb, p->dev->dev_addr, p->br->group_addr);
+	if (llc_mac_hdr_init(skb, p->dev->dev_addr, p->br->group_addr)) {
+		kfree_skb(skb);
+		return;
+	}
 
 	skb_reset_mac_header(skb);
 
-- 
2.53.0



