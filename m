Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065508;
	b=TNolCDtAuGrmIrFxnkE1V37/LMgHayAb4iZNvLMSiZU+A3KyF/u5lC18Pbblg3+6GZMm
	 8l/SigV0l3z7rbS00VqS19vvyjRPPHtUkbD9LP8Soi72LHwVaw8NDs1ZRMI8+bla0HreV
	 H+hLKY3j7TM3ulh6jQp72TFQno5KajaBFr2RAmVgsQQIk8uo1RqlrCY4nLK9itol5kB9n
	 oJbyIfVwYgSXItVRRjVH0tSWb9AoSYzK2QoAcw2i2lHLC6b3ByhZOEdCCzsAUL9k1a2Ls
	 SM0FtJ/pByselawZAdeQDlhoT/13cRDEsDhbzfBMiqOMEEZZXn+EJoh9Te9jjwBLIUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065508;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9daHAQOiXyM3TYONNd+rEShBFfEh3b69o9zUQ3kQ/EU=;
	b=aUGsy5ng7SpKeBDsIjDXwTO01Pj2plAkppI+COqBNk9Dtpc3Vzcdnucdnr8tgUh0HT7Y
	 RGLhLFnnSn3JdfPCCyD7vSFWc/FYYb/gAdpyOu9Iw01oyMdSe3ZpldgAzCP4jlc4qJ7sW
	 jcfSNEl2xWC4BLKCu37ftUbxjCnaHVW9dzWw7iJrXvNqX5vDf5TTtQAcoIoazpcQRK35K
	 6+O5wBCGkM7y4R4yKpcLjKFCSTIfD64LmhD1xFPfWFIdNAsm+7b3lX6yqOjoKvGwpmm6Y
	 FWDGXsQ78lfIQbbpOAuAkOuoa4zgcxNA5KFwuy7pqs4bdhc+VD9IhfJcImkmOGvDpCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="UTN5T7/C";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B739A606A33B;
	Sat,  7 Nov 2026 15:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UTN5T7/C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651A21F0089F;
	Sat,  7 Nov 2026 15:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065507;
	bh=9daHAQOiXyM3TYONNd+rEShBFfEh3b69o9zUQ3kQ/EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UTN5T7/C4alSUtrUB4peLfAJhHYI81e7313u8ECxrUPoJk78oes3c78JJD0iAi8U6
	 dnU/Uw7qIHON4PzqEqcGNhXwHt8UIKK+RkCu7u8lEaeFbhZDtF/dBQsmo/rSqqYNKg
	 6Na7KWD6Q3x/6+cMh422XleLBByVSb9LEQFmpQ3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xia Yan <yanxia@cmss.chinamobile.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1192/1257] macvlan: fix passthru promiscuity accounting while down
Date: Sat,  7 Nov 2026 08:58:08 -0500
Message-ID: <20261107135012.088606224@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index afad90b9222a2..a48c9e662fe9f 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1664,7 +1664,8 @@ static int macvlan_changelink(struct net_device *dev,
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



