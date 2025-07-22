Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C229D28C039;
	Tue, 22 Jul 2025 13:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192515; cv=none; b=CrjNh/WWsQgnO8/DyEsPoxmL0HGxlbMeRbRFQvPkIsgUESMUZPwnbJWhysyt6KVsQ1Eu/S/FlTHnuxNnupu0U0kXFqKGlLra5JRQNnFuI+Ta6ZQ/4cqDsBytfCC9lpfFsB9XJKrcsKI/2bR0bvJXwEOsX40OCZf91a6XXF3e+uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192515; c=relaxed/simple;
	bh=y1RD81TdkB2HmaU6o6wIIz4Fn5r7RkQR48Y1rMNQedA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sF3Ejpb54C7SGB0ic2VikLn4jqB2htvhvIaR8QLwkhi0pxYEYnXwKYLjUwCRxrY0uByHElSlFj669AMEauq0iHGa1gjo+sgaZiuT3DRG9rDdAfZb44T7Rg601zkXKmX8HhDNBbSbdxY+OOhc8Y6XYMqjwZttTr8QOkfLLcAAnyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wd9vxp8m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wd9vxp8m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31086C4CEEB;
	Tue, 22 Jul 2025 13:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192515;
	bh=y1RD81TdkB2HmaU6o6wIIz4Fn5r7RkQR48Y1rMNQedA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wd9vxp8mOSoExMJIPg5lIzPz5A3Ns6dc4NVWaYkWTLzTjm4fNk1X0MgXwZoQkVOO/
	 Va6mgflfhbgGUR8N/STo+3z5Y6/OS9ZXbc8kbwrdyWDqTM23xYvnMCbdO+5Dnr76Wq
	 M65EsgX/v2kGUCe+m4T7E5BQbu8cWkQ5IVLhvvGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Huang <Joseph.Huang@garmin.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/111] net: bridge: Do not offload IGMP/MLD messages
Date: Tue, 22 Jul 2025 15:45:03 +0200
Message-ID: <20250722134336.676973385@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Joseph Huang <Joseph.Huang@garmin.com>

[ Upstream commit 683dc24da8bf199bb7446e445ad7f801c79a550e ]

Do not offload IGMP/MLD messages as it could lead to IGMP/MLD Reports
being unintentionally flooded to Hosts. Instead, let the bridge decide
where to send these IGMP/MLD messages.

Consider the case where the local host is sending out reports in response
to a remote querier like the following:

       mcast-listener-process (IP_ADD_MEMBERSHIP)
          \
          br0
         /   \
      swp1   swp2
        |     |
  QUERIER     SOME-OTHER-HOST

In the above setup, br0 will want to br_forward() reports for
mcast-listener-process's group(s) via swp1 to QUERIER; but since the
source hwdom is 0, the report is eligible for tx offloading, and is
flooded by hardware to both swp1 and swp2, reaching SOME-OTHER-HOST as
well. (Example and illustration provided by Tobias.)

Fixes: 472111920f1c ("net: bridge: switchdev: allow the TX data plane forwarding to be offloaded")
Signed-off-by: Joseph Huang <Joseph.Huang@garmin.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20250716153551.1830255-1-Joseph.Huang@garmin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_switchdev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 7b41ee8740cbb..f10bd6a233dcf 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -17,6 +17,9 @@ static bool nbp_switchdev_can_offload_tx_fwd(const struct net_bridge_port *p,
 	if (!static_branch_unlikely(&br_switchdev_tx_fwd_offload))
 		return false;
 
+	if (br_multicast_igmp_type(skb))
+		return false;
+
 	return (p->flags & BR_TX_FWD_OFFLOAD) &&
 	       (p->hwdom != BR_INPUT_SKB_CB(skb)->src_hwdom);
 }
-- 
2.39.5



