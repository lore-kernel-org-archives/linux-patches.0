Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045934;
	b=EC51Fqhh3J50AhkAc43JwxhZVWIc8Ha77Cc9ouGowGGiuDdevJxiI+kViOQHhKTTDQAz
	 ovxe+1dWb1VilEFwQIrXdE5dtfe200GeTnWYbbvWWtlAqVgKsbzxYGqr4haFQiN2PNRCk
	 txfBdoqZ99ZS0Meo7j+t0VmDuRr+g3Z7XzD1b7gwuYlYdqHr8sKVH+vk/DFwdtMUMILgY
	 49Qo7/FpgtH9UKq51pqBb047KmVnRWgdQMfDSfwpWq9BvkB5a7qxtXP/0woSam40HFyZz
	 jCZ85TyGYVHn+sivKVnmzIOOdxiC/rWUrO/rKkY/Q8C/ysvhl1trBBmT1E1y6+WaBJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045934;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E38nJHxANc+xMnXyKkTKN8HutjaJ3UatripRWuZtzyc=;
	b=34d+cs5SFf1GbiJbDz8i7P0NAFG9IHgk2tLtU39d+6/pabuTxVtXb9JbGf/TvveM5T6f
	 1ajtW3Fjlb2siRSBqrwAUnfP7VIEdNZENV3LiKgI9CQDQS0KGQCyUjS5r5rCXhAGYXvhY
	 hitfEXwaMFb0FZooPumzIpg0/TsEBf3X/6DNnbHM1gYzRlUj3OdSUIduWEl3y7FOt2XQr
	 IxBZ8tefgSo69e9qOKEptTbPgxT43QfJCWPuc6KMRAyf6/UrZxYOEhS2T9PiupOCbaDCN
	 He9RiTWC6cqIvP+QYyfB6c8yURnX/rgNIqNRMxmwfzpOp9M2fXMUIKhxLcKFcFXUnJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FHycmcpX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EBD606A31C;
	Wed, 18 Nov 2026 23:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FHycmcpX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84031F000C4;
	Wed, 18 Nov 2026 23:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045934;
	bh=E38nJHxANc+xMnXyKkTKN8HutjaJ3UatripRWuZtzyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FHycmcpX2OTRplt6M/iYg+ctVhXAioDHu3z6tSphId61L/fiAssAVp7XcaPQPspgC
	 jWmAlBr2BxKFDV00xwxTG8SwStdO9vnIGQEE0BMn01ev11OSrx0GP+Y/2Wbe5V2Yyl
	 1skTjEZpBAIN+8NkdanF/tPS06WLuEUPny/aUDHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xia Yan <yanxia@cmss.chinamobile.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1074/2857] macvlan: fix passthru promiscuity accounting while down
Date: Wed, 18 Nov 2026 15:35:08 +0100
Message-ID: <20261118150240.280243570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b18d5178cd0eb..dd3daf2f7f3a5 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1602,7 +1602,8 @@ static int macvlan_changelink(struct net_device *dev,
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



