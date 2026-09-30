Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B69A50279A;
	Wed, 30 Sep 2026 18:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792997; cv=none; b=YbViv50jlZqZ8zhh/smSfHIo4D5dHo8WoAzpBum0ZxpgwdYnw7ASe/unXe1QI4+5fxm2Rv8wByGKHDabwWfHAuno4s4AIPJNSJhZ7Z+zXEjjiBl6U/l4gawzZRAR0jaRvKwjK/oH4TMfLOoZmFOUYOQUlHQNe5fXB/rEPDstbpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792997; c=relaxed/simple;
	bh=ls9niFSK6zVznXHzY90YzvkmacxylDiCUMkVLTPIKQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imP5WJVucLngFO3HS+jEU92Kcvv0Q9CWTosKk5taHjiSv/AFiBSC412bySSJ4A95Kfoq2XHOx8rgySBeNPgt2ZWpVSJNUIavQLDrpUDTUWMotz1+3lZvsjT1eY9xGjJAr4Dieu8xq9ZJV3v6XMABYd8N0Gr3ORb7XXfNyG/SXpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W87WmmD2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W87WmmD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9601A1F000FF;
	Wed, 30 Sep 2026 18:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792996;
	bh=E5AkJ6rOa6l7qHfvhXVPYqpl+7j0vfkmR4+HTYZotlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W87WmmD2dvFjeuCYSX3yfomonrBTNtxEsfvgoXu7nBRr6gXYuIjTGsb3PvP2y7bXz
	 2qDUT98erpRzf4478+NDpqjXz2shSDqqc0kOZdM57A3BCBfGzpckk8Do8D8aaCBB0S
	 0dqaXOUQpqu8pa+iqU5Vaus5HKmvWr2btNCwbOP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralf Lici <ralf@mandelbit.com>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 099/395] ovpn: skip UDP source validation for unspecified addresses
Date: Wed, 30 Sep 2026 17:26:01 +0200
Message-ID: <20260930152342.781506816@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Ralf Lici <ralf@mandelbit.com>

[ Upstream commit 77393b4d72dfeb764b2af2b848acc659f6fcfd0a ]

ovpn validates the cached local UDP source address before reusing or
refreshing a peer dst cache. This is only meaningful when a concrete
source address is selected.

For IPv6, calling ipv6_chk_addr with :: checks whether the unspecified
address itself is configured on the host. A peer may legitimately have
bind->local.ipv6 set to :: when no local endpoint was configured or
after a stale learned address was cleared. In that case the source
should be left unspecified and selected by ip6_dst_lookup_flow().

For IPv4, inet_confirm_addr(..., local = 0, ...) asks for local address
autoselection rather than validating a chosen source. Skip the precheck
there as well and let ip_route_output_flow select or reject the source.

Only validate non-zero/non-any source addresses.

Fixes: 08857b5ec5d9 ("ovpn: implement basic TX path (UDP)")
Signed-off-by: Ralf Lici <ralf@mandelbit.com>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/udp.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ovpn/udp.c b/drivers/net/ovpn/udp.c
index 367563d84472f..a8185f39a8def 100644
--- a/drivers/net/ovpn/udp.c
+++ b/drivers/net/ovpn/udp.c
@@ -162,8 +162,8 @@ static int ovpn_udp4_output(struct ovpn_peer *peer, struct ovpn_bind *bind,
 	if (rt)
 		goto transmit;
 
-	if (unlikely(!inet_confirm_addr(sock_net(sk), NULL, 0, fl.saddr,
-					RT_SCOPE_HOST))) {
+	if (fl.saddr && unlikely(!inet_confirm_addr(sock_net(sk), NULL, 0,
+						    fl.saddr, RT_SCOPE_HOST))) {
 		/* we may end up here when the cached address is not usable
 		 * anymore. In this case we reset address/cache and perform a
 		 * new look up
@@ -239,7 +239,8 @@ static int ovpn_udp6_output(struct ovpn_peer *peer, struct ovpn_bind *bind,
 	if (dst)
 		goto transmit;
 
-	if (unlikely(!ipv6_chk_addr(sock_net(sk), &fl.saddr, NULL, 0))) {
+	if (!ipv6_addr_any(&fl.saddr) &&
+	    unlikely(!ipv6_chk_addr(sock_net(sk), &fl.saddr, NULL, 0))) {
 		/* we may end up here when the cached address is not usable
 		 * anymore. In this case we reset address/cache and perform a
 		 * new look up
-- 
2.53.0



