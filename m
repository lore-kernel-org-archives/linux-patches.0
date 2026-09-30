Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39857357D11;
	Wed, 30 Sep 2026 16:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787113; cv=none; b=hJry5tQSHEvyFh1BjLOYvCu30UOKjxZdAXghZexK5dUTuoNYbyJ017EK9AXicEExi7gWaqC4E5nw5vV6Iyei/9Dj7VBsAIBPYz8hcpYFxRB39xWg0Mfv/k/YRFT6BqiglhUguazBgXybWzndWvoMzimmFu6hP232jLbGit+LWzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787113; c=relaxed/simple;
	bh=v2h0AcJ4jxS+eV2Jij95ZdDapM/0zaRqWpiyyct45yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIM0iwPR2+CJW1xw/E3Q2RmEl5MoAe55nVMwvkMHudsXfeeoe4b3bh/iPfHj1KkGYB2BMNPFl/uwWXZIaeqEi5gSnNplJ8+TEdCSNSVZhkRwRJVuydYQrPc72D65QP2+cUNJTEZJxIFR+svU0KNATsByKCKx2BEBwNYMtCn48Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=shBhlOsy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="shBhlOsy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9337B1F00893;
	Wed, 30 Sep 2026 16:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787112;
	bh=zmUl5NZg38uqj9wGjQHPfd/QLdOy1L/CesoEZF9nJL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=shBhlOsyxdtoHrB/4SgsXCiaJL71JkimvIRvwu7fTeTFt3vRRpqkGltS1ETVt9Q+R
	 eMVrLjrg4uET/Bqq9jSCm8fS45lDyP3c/5mByO4H13zgGTowCkz1OI4PoAQeF55To5
	 Z7qAnvp67HhvmwsFVJuXu7TeSPB0WLZUVtXb57CA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralf Lici <ralf@mandelbit.com>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 117/457] ovpn: skip UDP source validation for unspecified addresses
Date: Wed, 30 Sep 2026 17:23:42 +0200
Message-ID: <20260930152348.578057281@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 7f69e8890b5b5..df4750dabd1e1 100644
--- a/drivers/net/ovpn/udp.c
+++ b/drivers/net/ovpn/udp.c
@@ -161,8 +161,8 @@ static int ovpn_udp4_output(struct ovpn_peer *peer, struct ovpn_bind *bind,
 	if (rt)
 		goto transmit;
 
-	if (unlikely(!inet_confirm_addr(sock_net(sk), NULL, 0, fl.saddr,
-					RT_SCOPE_HOST))) {
+	if (fl.saddr && unlikely(!inet_confirm_addr(sock_net(sk), NULL, 0,
+						    fl.saddr, RT_SCOPE_HOST))) {
 		/* we may end up here when the cached address is not usable
 		 * anymore. In this case we reset address/cache and perform a
 		 * new look up
@@ -238,7 +238,8 @@ static int ovpn_udp6_output(struct ovpn_peer *peer, struct ovpn_bind *bind,
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



