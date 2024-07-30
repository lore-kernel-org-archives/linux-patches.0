Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B9A189538;
	Tue, 30 Jul 2024 16:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355752; cv=none; b=BitGeQS+AQ6F12wGA3ZTUX4zLUItU8jWwm/TJH6MV6RtfCmwY3dcxAvDdpgo11OPxeiQTjz62kWAJNXF7ND7S4zDUND0/wUhUREmJ8zGxxxQ4BPccoCWi2Hn7zDQqw1H/Zp9UaUkB6v2a1w/RL5A6yD9HiaPxn3UxSDnF3YQwWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355752; c=relaxed/simple;
	bh=lZTdkFnDiKqI4ywVyRj2/oELBuspEj9/DOxLAWCQo7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XiO1oPCaQSgpC1Gxp5aeZMM9r1/nFoI+0lxyVu2vBJhfi5+QtJ0kq5qpSnzM4LYC8hvadO3uzRVu1NnqiRgeh12alMpkCgxZei89FTq9BC+LrBoVUQ+hhe84V9vUARBtaViioxIkd/N9eJUg2B47jp8aeRR9FEoij5CVd7P9BqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K6qhN0ff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K6qhN0ff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C99C32782;
	Tue, 30 Jul 2024 16:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355752;
	bh=lZTdkFnDiKqI4ywVyRj2/oELBuspEj9/DOxLAWCQo7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K6qhN0ffPgRUeSl8BR72l/+Qu0XihTYBfL0guAmpZsXMVevK3ljU7TYd0nlwYmO8v
	 dPQtIEvdTpSVUROxWJHK4FitsGSnbeqfomSk8exIsegt9h4lSZW8doNd/ID/FX7bQC
	 WRIL9HPkC7+akeHJcCByKUuktrq9I58eu9A1CFnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elliot Ayrey <elliot.ayrey@alliedtelesis.co.nz>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 127/440] net: bridge: mst: Check vlan state for egress decision
Date: Tue, 30 Jul 2024 17:46:00 +0200
Message-ID: <20240730151620.846195535@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Elliot Ayrey <elliot.ayrey@alliedtelesis.co.nz>

[ Upstream commit 0a1868b93fad5938dbcca77286b25bf211c49f7a ]

If a port is blocking in the common instance but forwarding in an MST
instance, traffic egressing the bridge will be dropped because the
state of the common instance is overriding that of the MST instance.

Fix this by skipping the port state check in MST mode to allow
checking the vlan state via br_allowed_egress(). This is similar to
what happens in br_handle_frame_finish() when checking ingress
traffic, which was introduced in the change below.

Fixes: ec7328b59176 ("net: bridge: mst: Multiple Spanning Tree (MST) mode")
Signed-off-by: Elliot Ayrey <elliot.ayrey@alliedtelesis.co.nz>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_forward.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 9661698e86e40..a32d73f381558 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -25,8 +25,8 @@ static inline int should_deliver(const struct net_bridge_port *p,
 
 	vg = nbp_vlan_group_rcu(p);
 	return ((p->flags & BR_HAIRPIN_MODE) || skb->dev != p->dev) &&
-		p->state == BR_STATE_FORWARDING && br_allowed_egress(vg, skb) &&
-		nbp_switchdev_allowed_egress(p, skb) &&
+		(br_mst_is_enabled(p->br) || p->state == BR_STATE_FORWARDING) &&
+		br_allowed_egress(vg, skb) && nbp_switchdev_allowed_egress(p, skb) &&
 		!br_skb_isolated(p, skb);
 }
 
-- 
2.43.0



