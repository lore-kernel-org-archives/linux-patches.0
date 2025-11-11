Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B4833F8D3;
	Tue, 11 Nov 2025 01:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823440; cv=none; b=Up97gw+KaRhFllVNjCKBx85iILBw9WNJ5pVLDPvG7QRxHGFFbJU3ZO8hePUsFKO2rQ4agPJPl8hU09qekmydovTflWTwONm+/mdH2owNCXhqRdukL+OQKTYhCvlL3aIwmpmvHashhNglDoXhvpkuX70gyjDWN4juTxY1aMeKDvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823440; c=relaxed/simple;
	bh=R0LgxYH9R/E6JkAAaBtISmtGKLLE22zDu3p5HM+mOPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AgdC9QyJ/OEYcTAoqJ1ucmV4U4tISJvayw+lwX8rprojeDbixvnc3C26dwd0OcN/X5zn7qU9cUiqSpYvQIUvJNud+k8+yOW8m/eeNxf3RSPrM6yZj6yftPZ1/HxgskriQ/eum/oOtQJiQNRWoPofiynUptuPAQ2kx5dSLg8mGbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pa61vcrD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pa61vcrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134E8C16AAE;
	Tue, 11 Nov 2025 01:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823440;
	bh=R0LgxYH9R/E6JkAAaBtISmtGKLLE22zDu3p5HM+mOPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pa61vcrD1eAszmV3xnDGyEegOkYWQwn/v2IPtbNEi4rIDMvdFRIcb36QChXWt0/HH
	 9Qd20U+jawNIiL2NMOI3UaAGpsBbm8P9O4d9IF+6tQTXSkppmlMUYcyKef7kPGlzfG
	 ziF/VZS9NMhStdjvT8WKQ4FY+ImgnQthBCl/TUXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 300/849] bridge: Redirect to backup port when port is administratively down
Date: Tue, 11 Nov 2025 09:37:50 +0900
Message-ID: <20251111004543.663053280@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 3d05b24429e1de7a17c8fdccb04a04dbc8ad297b ]

If a backup port is configured for a bridge port, the bridge will
redirect known unicast traffic towards the backup port when the primary
port is administratively up but without a carrier. This is useful, for
example, in MLAG configurations where a system is connected to two
switches and there is a peer link between both switches. The peer link
serves as the backup port in case one of the switches loses its
connection to the multi-homed system.

In order to avoid flooding when the primary port loses its carrier, the
bridge does not flush dynamic FDB entries pointing to the port upon STP
disablement, if the port has a backup port.

The above means that known unicast traffic destined to the primary port
will be blackholed when the port is put administratively down, until the
FDB entries pointing to it are aged-out.

Given that the current behavior is quite weird and unlikely to be
depended on by anyone, amend the bridge to redirect to the backup port
also when the primary port is administratively down and not only when it
does not have a carrier.

The change is motivated by a report from a user who expected traffic to
be redirected to the backup port when the primary port was put
administratively down while debugging a network issue.

Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20250812080213.325298-2-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_forward.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 29097e984b4f7..870bdf2e082c4 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -148,7 +148,8 @@ void br_forward(const struct net_bridge_port *to,
 		goto out;
 
 	/* redirect to backup link if the destination port is down */
-	if (rcu_access_pointer(to->backup_port) && !netif_carrier_ok(to->dev)) {
+	if (rcu_access_pointer(to->backup_port) &&
+	    (!netif_carrier_ok(to->dev) || !netif_running(to->dev))) {
 		struct net_bridge_port *backup_port;
 
 		backup_port = rcu_dereference(to->backup_port);
-- 
2.51.0



