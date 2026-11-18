Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037023;
	b=ArxvPomLPN9RCN0sxZVFZtbJkYZ1/ZRVOH47Mt9yhRBBs9ypU3eW3i6DaStE5ANvmuVS
	 /3SpCICYJiS8j0QLRr5XjMYG5Tb9pXYjBMs9KBcjxkyAYG0hhoyA5TQoZNrkL52sufjwL
	 syCR4jPysj3KY3izbxV+oQLnlMJUvtJvAKXVd9MwkYbmMI2rqBYyZhzseY8jFcVQX5Oet
	 nOKoHwOl4yiyOC6FZ/yIPZeG1weoryuGSi79PE29feECOGD4vKtigUa4+lS6MgYVyvNnq
	 8OpLjThABHLs9hg4nN38G+PYCz+Iq/3AcVGzaRSS+thUasGxGauBujKqsZ3HPZ+blOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037023;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L6z0TKXD4QKZS/zE6LzfT1eGGWfNTTjKItlGA4SI+V8=;
	b=WcSIxCoqLTG1ZxYpqFP3ImWi8veTYR3HXpfVlnR5ah7ehFa7+rNdcXj3nC9TInl/PoUb
	 Z1pd2hinIujqZxESsotDX5a35jIlHhiR9i8400BNJKPMpXHi0PnE8virfh75jn6SagVPG
	 4dhKW/0fa0y5Ysu8gTHzjq2aAkAgLjiSXj2MQisTUyoEODTxlkUjsy5Pk2EhxEV9FlNSX
	 KbEmRXz5XB+Ygi4TSdW7ru/QQ6ZUpm+/lWYtpIso5gEcazLE9c9xzOyI1iKVtDJRIvs5U
	 ZgqAxSnpJerIyyJJTo37LMa4OxZkvdEw0J66sJ+Vfh4A99UApx6WbKJaUplzI74hypQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TMR1liwX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C42606A31C;
	Wed, 18 Nov 2026 21:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TMR1liwX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168951F000C4;
	Wed, 18 Nov 2026 21:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037022;
	bh=L6z0TKXD4QKZS/zE6LzfT1eGGWfNTTjKItlGA4SI+V8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TMR1liwX9y2WqagkzAYroPb7ZXSbhpDW9G0E6pbxul4mVXAVj4A4RKlvA4P487zDe
	 U12YcRUWOa9uAkxffgo9YI9XPkAbwkk4xA454NBE4CUR62Q+wHHWs5fo47226/l5eP
	 8dQH2JaOpoMWJHb3Ni5TP0nW2AkFxGTmXtv76hVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xia Yan <yanxia@cmss.chinamobile.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1266/3318] macvlan: fix passthru promiscuity accounting while down
Date: Wed, 18 Nov 2026 15:31:28 +0100
Message-ID: <20261118150358.199508848@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 438626c4480ef..b4ad150eb11bc 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1635,7 +1635,8 @@ static int macvlan_changelink(struct net_device *dev,
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



