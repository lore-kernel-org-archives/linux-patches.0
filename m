Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7517191F66;
	Mon, 22 Sep 2025 19:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569693; cv=none; b=pp5NDedoB7zDiO82bNeezSyRIW+QtkhOpf3kEHP9wATjeRTq2Cwe822grtmP/JKGYKGmIZC54g19CaLw4N/s5nEQPAiZy/7rcw6U0jNgoLUFwvyNyZdaiOQJvE0qaFfkTk3bfTz4zxeLVdTwH8TeuZpVOqLo6vDHQkoXO2HKE3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569693; c=relaxed/simple;
	bh=0nQQoDdrvYw2KvBxjX5tHWdFPeo8EjNkNwbO0gWAgwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qypnFZ48vDO7GMblaXUJbmsLSh06subR5YJI8RhM6cWsVTNKLzLj3HsrRXPwgiWyMzdpsVYuczxPgLofY01O0Rdad7g/tNpJPmrTuGjLTitPFrcaqOPuxmz8pkVW+LR+6FUx4yXDsk69FEha+039L1nJntmxuBmplc2ZR2Y92lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EjgXihW8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EjgXihW8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19802C4CEF0;
	Mon, 22 Sep 2025 19:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569693;
	bh=0nQQoDdrvYw2KvBxjX5tHWdFPeo8EjNkNwbO0gWAgwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EjgXihW8qSAt0d7p0H0giEwQIAaGgW/dlYL3DgvkNdqPGqXrTINr+IoDJpjHyt39Y
	 ifrkF9fLoyPhQK8Nrz2x9dWMamYosolE+IYHRHsdkSP1YjJhp1lqpyZuVh/QogAXvW
	 UyuraXVH/gXHT6NdPofkLI6aslTvBQEfI5FxYz3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wilder <wilder@us.ibm.com>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 19/70] bonding: dont set oif to bond dev when getting NS target destination
Date: Mon, 22 Sep 2025 21:29:19 +0200
Message-ID: <20250922192405.070765154@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
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

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit a8ba87f04ca9cdec06776ce92dce1395026dc3bb ]

Unlike IPv4, IPv6 routing strictly requires the source address to be valid
on the outgoing interface. If the NS target is set to a remote VLAN interface,
and the source address is also configured on a VLAN over a bond interface,
setting the oif to the bond device will fail to retrieve the correct
destination route.

Fix this by not setting the oif to the bond device when retrieving the NS
target destination. This allows the correct destination device (the VLAN
interface) to be determined, so that bond_verify_device_path can return the
proper VLAN tags for sending NS messages.

Reported-by: David Wilder <wilder@us.ibm.com>
Closes: https://lore.kernel.org/netdev/aGOKggdfjv0cApTO@fedora/
Suggested-by: Jay Vosburgh <jv@jvosburgh.net>
Tested-by: David Wilder <wilder@us.ibm.com>
Acked-by: Jay Vosburgh <jv@jvosburgh.net>
Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20250916080127.430626-1-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 291f33c772161..f7ed129fc8110 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3261,7 +3261,6 @@ static void bond_ns_send_all(struct bonding *bond, struct slave *slave)
 		/* Find out through which dev should the packet go */
 		memset(&fl6, 0, sizeof(struct flowi6));
 		fl6.daddr = targets[i];
-		fl6.flowi6_oif = bond->dev->ifindex;
 
 		dst = ip6_route_output(dev_net(bond->dev), NULL, &fl6);
 		if (dst->error) {
-- 
2.51.0



