Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9001943E48C;
	Thu, 30 Jul 2026 14:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421814; cv=none; b=qGxEHBAUT/Es6XCn1wMv/a5tYTaic8obb4+HuH3hukgXYFKF5/0IOoN7fJsg4Qke10rnQqhnADGiNFUmkZpvUc6IiLJJtBNsdi4x1RqFzHb8B5F8iAxvBjACalmItc4w3xDuwAriUOG566IQu6TPshobGBF/uFnPYxhw0gZUcxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421814; c=relaxed/simple;
	bh=I7vi/JCseL/4+Xk3lL3ocPP1zrRw49F44TLn6h4BNCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u2qhd7AN3qSCFY86dK1mt4j5+T/I3d9PfEWn8CzgL8KpCjd6QoSyeX8+vMif6Vz5blJDQNfkBvEPVAzrdQlEdZrhNOwhtISMcAkB5wYVMmH+0+rnS5zB57yaRDMPDc+9tBdiO3gKYtS242EnjhTDsZ/3bwgWRJN5/a2vQv7oAWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jmLEiPPI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jmLEiPPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16921F000E9;
	Thu, 30 Jul 2026 14:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421813;
	bh=iU/k1op18JsIH7Zs1AYSBTpRMkTTE4WUMBgar0K1GEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jmLEiPPI5u3STYyRuLyKEeANTR/Uuj9xqa253fA/EECIvItKRAtU5cSAV5JPNVoQ+
	 pfjJHHv6trlPu22EJKJszFrE1oj8/NW8YlFIfsNjSprh6YreMsgw62wQECcFlfkr4i
	 0I8jWxaiC9vRBozCKMXdyHZj5WbU3tz6soenUAKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?Ricardo=20B . =20Marli=C3=A8re?=" <rbm@suse.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 230/744] selftests/net: Fix tun IPv6 test addresses to avoid 6to4 range
Date: Thu, 30 Jul 2026 16:08:23 +0200
Message-ID: <20260730141449.179891972@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo B. Marlière <rbm@suse.com>

[ Upstream commit ef01724fa235a228e3d3e8b117e89403cd8feb25 ]

The IPv6 addresses used for the tun_vnet_udptnl fixture currently fall in
the 2002::/16 prefix, which is reserved for the 6to4 transition mechanism
(RFC 3056).

On systems where the sit module is loaded, the kernel automatically claims
2002::/16 as a 6to4 tunnel prefix. When the test assigns a 2002:: address
to a TUN interface, sit registers a competing local route for the same
address. This ambiguity breaks the GENEVE decapsulation path: packets
injected via the TUN fd are not delivered to the test socket, causing the
IPv6-outer gtgso send_gso_packet variants to fail.

Replace all four IPv6 test addresses with addresses from the fd00:db8::/32
range, which is part of the ULA space (fc00::/7, RFC 4193) and carries no
special kernel semantics.

Fixes: 24e59f26eef2 ("selftest: tun: Add helpers for GSO over UDP tunnel")
Signed-off-by: Ricardo B. Marlière <rbm@suse.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260706-b4-net_tun_addr-v1-1-3d3cb2473560@suse.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/tun.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/tun.c b/tools/testing/selftests/net/tun.c
index cf106a49b55e38..abe488bac50bb3 100644
--- a/tools/testing/selftests/net/tun.c
+++ b/tools/testing/selftests/net/tun.c
@@ -42,19 +42,19 @@ static struct in_addr param_ipaddr4_inner_src = {
 };
 
 static struct in6_addr param_ipaddr6_outer_dst = {
-	{ { 0x20, 0x02, 0x0d, 0xb8, 0x01, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 } },
+	{ { 0xfd, 0x00, 0x0d, 0xb8, 0x01, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 } },
 };
 
 static struct in6_addr param_ipaddr6_outer_src = {
-	{ { 0x20, 0x02, 0x0d, 0xb8, 0x01, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2 } },
+	{ { 0xfd, 0x00, 0x0d, 0xb8, 0x01, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2 } },
 };
 
 static struct in6_addr param_ipaddr6_inner_dst = {
-	{ { 0x20, 0x02, 0x0d, 0xb8, 0x02, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 } },
+	{ { 0xfd, 0x00, 0x0d, 0xb8, 0x02, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 } },
 };
 
 static struct in6_addr param_ipaddr6_inner_src = {
-	{ { 0x20, 0x02, 0x0d, 0xb8, 0x02, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2 } },
+	{ { 0xfd, 0x00, 0x0d, 0xb8, 0x02, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2 } },
 };
 
 #ifndef BIT
-- 
2.53.0



