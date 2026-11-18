Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045672;
	b=5G3c9YCY7hyehH6WixR69rdEMAEeiSKdOQIRd3OvNvvApPtdU2sDwS3bPY8bmTXhqbQc
	 KwJQlPoetqreroIyc6+P6g8JAxfKbsPJPgFO9DiyJ4ZAPRgA24N9Pg5SJJQL2xYPWsfpC
	 eQ2EaIVPCSPRWJ+MVkV+/d2y4fQjbH2hLrSEKzTtupp+ykOlB5kkVaUcQEDpBEM2EG1AX
	 cdAxuPu0YeeZWx1nm3+WT3aHjY1mn2pbaZI8Kky1dL6IPTjEO2kiXiSNR/+h7DSk/1ak5
	 YqrUQApiqJyFZr61AkGffeKJWXMH/9mu5sjcPWlRqeuPOhK33V0bzSNrrx2X5yUj07w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045672;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XXb0Y3XkyExKaia3HodPxClzJ/5trDZGwPawE3zyCYc=;
	b=sDSIv3Z0e7gqh5f93zGJCTG0hQl9gnfVkV/63akHTD2pqWy24NOqdEUYhytc7BblSKyI
	 XGMz9pwCamQbNiEQqDpnDlMTp/utnsuj7U67VocKMxazGi7raLuXiQTXPUoB8KD4L6/Qf
	 JeAbBAYaPFGisipO7KbexQV3VOkIg7KSKbSSeC7lsOs7DdwtNkybDt+v0XQMXhj5tdRlP
	 oGHT+nhDyQofInFb1w3aphSCK1QYXSaFfbapMW3SX3sCukjvaO8iBebMdR1Jpr46dQSQL
	 ds9qLg+rrwh0/4R1DoLi5PUdwn4+0tbag2tp3ym+R6pZAYsVdkl0B+m++9JqQdptEng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rk3zeSDL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD168606A31C;
	Wed, 18 Nov 2026 23:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rk3zeSDL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8CB1F000C4;
	Wed, 18 Nov 2026 23:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045672;
	bh=XXb0Y3XkyExKaia3HodPxClzJ/5trDZGwPawE3zyCYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rk3zeSDLVWvvCTfQCnV1QzQwEEK/MCt7oNpfZRaX9ylXqRF9N6tWoxvABH9d0oPUh
	 QFR6UcosAsSLca6HwVLF/E/evOHZCV5y1r16wrvIYZSE5TE/62CZ8f3FYbxIINI4Ng
	 P1FtvWrjdgYFv77vHNPFTM0ub8YKRYqmsy2VavYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <netdev-bot+sashiko@kernel.org>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1007/2857] ipv6: do not restart DAD for a dead ifaddr
Date: Wed, 18 Nov 2026 15:34:01 +0100
Message-ID: <20261118150237.853157859@linuxfoundation.org>
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

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit ffb668669ce4144347973d8b2fad449e9be0563d ]

addrconf_dad_failure() can create a stable-privacy replacement without
RTNL. After ipv6_add_addr() publishes it, addrconf_ifdown() can mark the
new ifaddr DEAD, clear its route, and unlink it before the recovery path
takes ifp2->lock.

The recovery path then unconditionally changes the state back to PREDAD
and queues delayed DAD work. The MTU teardown path can leave IF_READY
set. For an optimistic address, addrconf_dad_begin() can consequently
pass the cleared NULL route to ip6_ins_rt().

This follow-on was found by source review and was not separately
triggered at runtime.

The new ifaddr is already initialized in PREDAD. Under ifp2->lock, record
the retry and queue DAD only if teardown has not changed the state to
DEAD. If teardown wins after this check, the work observes DEAD and exits
without reviving the address.

This complements the existing lock_errdad check that preserves the original
ifaddr's DEAD state after the same function reacquires its lock.

Fixes: 5f40ef77adb2 ("ipv6: do retries on stable privacy addresses")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <netdev-bot+sashiko@kernel.org>
Closes: https://lore.kernel.org/r/179161099408.434549.14449036924552933828@kernel.org
Link: https://lore.kernel.org/r/20260513025509.3776405-1-lilinmao@kylinos.cn
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20261015050651.1841557-5-4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 9b21080754133..e2630c226b620 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2141,6 +2141,7 @@ void addrconf_dad_failure(struct sk_buff *skb, struct inet6_ifaddr *ifp)
 			     ifp->idev->dev->name, &ifp->addr, eth_hdr(skb)->h_source);
 
 	if (ifp->flags & IFA_F_STABLE_PRIVACY) {
+		bool start_dad = false;
 		struct in6_addr new_addr;
 		struct inet6_ifaddr *ifp2;
 		int retries = ifp->stable_privacy_retry + 1;
@@ -2179,11 +2180,14 @@ void addrconf_dad_failure(struct sk_buff *skb, struct inet6_ifaddr *ifp)
 			goto lock_errdad;
 
 		spin_lock_bh(&ifp2->lock);
-		ifp2->stable_privacy_retry = retries;
-		ifp2->state = INET6_IFADDR_STATE_PREDAD;
+		if (ifp2->state != INET6_IFADDR_STATE_DEAD) {
+			ifp2->stable_privacy_retry = retries;
+			start_dad = true;
+		}
 		spin_unlock_bh(&ifp2->lock);
 
-		addrconf_mod_dad_work(ifp2, net->ipv6.sysctl.idgen_delay);
+		if (start_dad)
+			addrconf_mod_dad_work(ifp2, net->ipv6.sysctl.idgen_delay);
 		in6_ifa_put(ifp2);
 lock_errdad:
 		spin_lock_bh(&ifp->lock);
-- 
2.53.0



