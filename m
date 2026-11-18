Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060520;
	b=seWwvNQQ6PNyq/itKFz/O/Dbsy29qzjMoI6paAQ8vEhmAM41A1oqzRjJLwlMQUow5S8p
	 iC3X6sPqPzHICv27sre+mhtIYef3yT+XLgRB2FMgmV0dH+NwjJ6Fu9zgEdjxTlDSesxFs
	 GOZz7DfVKNT0HrBHcCVYwEH0l2H6ICCMOhb4U3MIvOD8NXejnLGYaaSfWG1N4nv17tQ9R
	 b/cEwryachrv4GUdrwC5Fn+URa0qhELT6/wMyc7XkF2yrjt02zVcWHkDCh53bQiq7j8m7
	 KEdNd5PHhVqggtmUxukkylDvVrXvEIy3xvVVaSzT3V0+kpHwLKVK3LJb0MBwFvgYo4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060520;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kvJ7VjZvvLvruXFncgC2K4JXBfV2hKAfeAdveO2GZlc=;
	b=2zCxW7romiVup/lrI20Lcryp/pg94jtiSfvaLTho3uQ/iWPzbmujQR2rFKycSXSaVM4v
	 zt1YMvejWRL76thL3S2zZsG0GwsJqf4PneaxIIFjZGku3XbnbCVxOi36BOpaWEXkPBHQE
	 qRe3jEBzydgQzUTbsPOr+bB/Kg475mBkMbMRcyeqqdXQcLM9+ThYbQuoOsXv4oBcriXHf
	 yK5XIaD9+f/vy+h58D8Zs2F5D3JMd26lx70OEFMl7yRoWCxkEdptwzyw3+porXVWFtXJH
	 Cn6EISELkl2gJlDU6eeTtB62y445Dr/sPw4jpSu3szrl14p049+CF941B2XIuvsd9kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qHSonYfu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3063606A325;
	Thu, 19 Nov 2026 03:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qHSonYfu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CFB1F000C4;
	Thu, 19 Nov 2026 03:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060520;
	bh=kvJ7VjZvvLvruXFncgC2K4JXBfV2hKAfeAdveO2GZlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qHSonYfuo6vkeGzWPJoCACHPo6ynezGP0C/i0HpPkAVxiZYDjNQbZr3QifvLLL0Gd
	 b/j+olQpbD6M0Crj9OWl2Irye02Y2q/4oWygn7A2ofoYpD4h49PX5xgb7MA52b9YX5
	 pKaffuZ56v1dzUs7HVVokpG6EZ5jzyVWK0Y1XFaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1227/1848] ip_tunnel: use WRITE_ONCE in ip_tunnel_encap_setup
Date: Wed, 18 Nov 2026 15:54:25 +0100
Message-ID: <20261118150011.282202727@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 88b84cae6b94087d3a9679845fe28ad19c7bef8b ]

Update ip_tunnel_encap_setup() to use WRITE_ONCE() when writing
to encap fields (type, sport, dport, flags) and hlen fields.
This ensures that concurrent lockless readers (like fill_info)
do not see torn writes.

Also remove the unsafe memset() on t->encap which could cause
concurrent readers to transiently see zeroed fields.
Removing it also fixes a bug where t->encap was left cleared
even if ip_encap_hlen() failed, resulting in partial configuration.

Fixes: 56328486539d ("net: Changes to ip_tunnel to support foo-over-udp encapsulation")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20260907075846.2913645-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_tunnel.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 99bcc43aa4f05..bee7ded2038de 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -476,19 +476,17 @@ int ip_tunnel_encap_setup(struct ip_tunnel *t,
 {
 	int hlen;
 
-	memset(&t->encap, 0, sizeof(t->encap));
-
 	hlen = ip_encap_hlen(ipencap);
 	if (hlen < 0)
 		return hlen;
 
-	t->encap.type = ipencap->type;
-	t->encap.sport = ipencap->sport;
-	t->encap.dport = ipencap->dport;
-	t->encap.flags = ipencap->flags;
+	WRITE_ONCE(t->encap.type, ipencap->type);
+	WRITE_ONCE(t->encap.sport, ipencap->sport);
+	WRITE_ONCE(t->encap.dport, ipencap->dport);
+	WRITE_ONCE(t->encap.flags, ipencap->flags);
 
-	t->encap_hlen = hlen;
-	t->hlen = t->encap_hlen + t->tun_hlen;
+	WRITE_ONCE(t->encap_hlen, hlen);
+	WRITE_ONCE(t->hlen, hlen + t->tun_hlen);
 
 	return 0;
 }
-- 
2.53.0



