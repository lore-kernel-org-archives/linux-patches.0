Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564CB379C35;
	Wed, 30 Sep 2026 19:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796911; cv=none; b=ql20EloFdU6wao5SU5SKE2jpFyP9wC3Xgdu73QUwS7q/gbob/WrYU/N6ivykITB0BX2o1NiI/yGnXvfdbUoXjiJYQZ9kYYIc8WwjaM8zm+afudv5I6lbuEogmsWtASM6/c28gVROf1duLTF39jgkfB1+JOGiaGJNSmYr9//I8bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796911; c=relaxed/simple;
	bh=qizG74p5oxcpFhOc2bkzjXiYKqTT0IGykkPtWEZlqOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LwPlELi/40t+qbQ6YoARWWwzbtwISfy91M1nRHpto1VEn7EOtc3Ax5RJY2zMzcovyfkr3hlvYewMmIXClFeCoHuZT5DPEBuXidDdDW1nkEZG8v3335byZG4cUUs7wGfqwV24Pax6SBnXHrKf8fW7g+oh8mb1dQMUHDfowmFRxys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vPy4ca62; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vPy4ca62"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74101F000FF;
	Wed, 30 Sep 2026 19:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796910;
	bh=RdMdyYs0SuQZYiK8zBdFL5ylC/BiyPLgWjpQkMB2JRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vPy4ca62LvOVsb9tcocfbERSMRHlI70M89WUdlRFW9UTcRNTkCqBgvMwytAgb/ICg
	 z5jb8tCKtPtliifKgvvds7hYhLML1ojkmEY6Z2qXTzJOx5FbYztPb/ZI84fcmmpibJ
	 opgGWvYZamfQumRbStgKZrQ9FBstJK3E7JEKfuWA=
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
Subject: [PATCH 6.6 1079/1193] bridge: check llc_mac_hdr_init() return value in br_send_bpdu()
Date: Wed, 30 Sep 2026 17:29:23 +0200
Message-ID: <20260930152458.202637785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



