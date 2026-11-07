Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062631;
	b=W349eGY/cEBCm8lT/zmw32X3cPAsDPxxvy9/agVtTFoVk9A375wQ+5qVKZsVwLaarrTN
	 COiHlWYKfTLXcWDNvwS9GGfuCTfmHjb1h51prbnbDtG9tYk1I+t1gqAh8sK3CKlRer9Hd
	 6bRn1tkxl+1bflEcqlRjbZ2VInd2WNNmjXdtfuLAUgvfCdHdNt/ZKd3fOU2zRDmFh1mMZ
	 c6g1UCW6q548OuHTKNIwtMU889pW3j3KA2UMVEcddLawBnGW1CE0ShrOBOsF/ExczbCE6
	 XGtaJEkNAig8PUls+Xm+BwUJe0oq7Qr97E9x+SVXXxzxFGQwGDLEH/mufQYkAmB+Jww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062631;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aEuzPcGYKHUqmDqshEpPHy35RWU9vOAoR4T8kT3NCp0=;
	b=yeRYw6JtAutAQjwxrdI9oy0FOfdn2YUYS2YtjVPT47pktcJ73ABfF8IXwHC0fXDXdsri
	 waiMTRHjt/8D/xwx8pa5BBKFu4fxdyqGPjT8AGqMiMcrH3XxWQjVkfyA/eXqgPYxr5/zd
	 T3NgzUvTJBWKQt5uPuS04dcn7fPJyRV2nTIzgfAs4KXx0Dc1SDohw3Ol5Ti1Vyd782j72
	 tQosVKuoGU4siSEJaYI5JuhJBxK8lNHzsC1mXQnvPRUeHteik+V7i29Xcjp/yUj+6j692
	 X3l5aOQXzxQyjx3SSGH6+MtOhXaplgUftECdxcp55OGPE4JYiLSazPZ4NeenLTpZKgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lFjZRDI3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8576606A331;
	Sat,  7 Nov 2026 14:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lFjZRDI3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880F41F0089F;
	Sat,  7 Nov 2026 14:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062630;
	bh=aEuzPcGYKHUqmDqshEpPHy35RWU9vOAoR4T8kT3NCp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lFjZRDI3JzsB5oj8AgdkVV4Pw8qps7432X7MuueH9RjScrmqD9RsF5CLnNK1W275f
	 XKEAoctvtV7nmkQkS6WLdZ+iHk7LB+bwMCwb8ntYFfolWwAgzzUO4ajPDdi0xcLMre
	 c8N12gYezuMT0x1GmUuKkpaa3S91TwYlEAOhG0fY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xia Yan <yanxia@cmss.chinamobile.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1501/1536] macvlan: fix passthru promiscuity accounting while down
Date: Sat,  7 Nov 2026 08:58:37 -0500
Message-ID: <20261107135040.024363421@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xia Yan <yanxia@cmss.chinamobile.com>

[ Upstream commit b6743653d134c9ef8436e2db1be1ad4c1e0d0091 ]

macvlan_changelink() adjusts the lower device's promiscuity count when
NOPROMISC changes, even if the passthru macvlan is down. The reference
is acquired in macvlan_open() and released in macvlan_stop(), so a down
interface has no reference to change.

Clearing NOPROMISC while down leaves an extra reference after the next
open/stop cycle. Setting it while down can remove a reference held by
another user of the lower device.

Guard the count adjustment with netif_running(dev). Keep storing the
requested flags while down so the next open uses the new setting.

Comparing changelink with open/stop exposed the unmatched count changes;
the same issue was also described in earlier macvlan reviews. A netlink
test on UML reproduced both DOWN cases before the fix and verified the
expected counts afterwards. Repeated flag updates, two open/stop cycles,
deletion and bidirectional small-frame delivery were also checked.

Full x86_64 builds completed with WERROR disabled for allmodconfig, and
WERROR and KASAN disabled for allyesconfig, including the resulting
dependency changes. Neither comparison showed new diagnostics.

Fixes: df8ef8f3aaa6 ("macvlan: add FDB bridge ops and macvlan flags")
Link: https://lore.kernel.org/netdev/179170088566.434549.4699134797461783473@kernel.org/
Link: https://lore.kernel.org/netdev/20261016003009.2692872-1-kuba@kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Xia Yan <yanxia@cmss.chinamobile.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20261022090809.12019-1-yanxia@cmss.chinamobile.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macvlan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 4d1aae8e89cf0..03adfac510b4e 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1626,7 +1626,8 @@ static int macvlan_changelink(struct net_device *dev,
 	if (data && data[IFLA_MACVLAN_FLAGS]) {
 		__u16 flags = nla_get_u16(data[IFLA_MACVLAN_FLAGS]);
 		bool promisc = (flags ^ vlan->flags) & MACVLAN_FLAG_NOPROMISC;
-		if (macvlan_passthru(vlan->port) && promisc) {
+		if (macvlan_passthru(vlan->port) && promisc &&
+		    netif_running(dev)) {
 			int err;
 
 			if (flags & MACVLAN_FLAG_NOPROMISC)
-- 
2.53.0



