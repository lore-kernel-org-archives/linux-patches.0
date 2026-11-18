Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023473;
	b=em+lewmFyJ8nYUIZ/1esVJoqo5Gzfdzt7nVD5bdfGbEdLVxfbeOx0c/s+DosmYBIHak2
	 hHuRn3gxiuCr1ATPKGmpI9t+tfXvWwxkDnGMYyK65ExDmpnJgBpvNNMW51J9sECSla8Df
	 vDWgjmOChyWj6SxO1MF1pcXNJUi8rfEGgjTqWFTtD9QuaDPR1Lo4rGM8vaBlgGRgIQA/D
	 3TpsrlDgq5dqDU5rbxzb5RmeiBDA3N09iWT3oLPMkCmPuvpZ6rZ/ia0oQYtlU5xW8mqOC
	 1b1HjiBuJYrNa0P35DnOlmmjcN8Uk4l7AFxLy3Z1rbtrtAT75s8EwatxdaMGUFoM78w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aYKRpc2WoUUw6gamQjfklJApzKtUU0szavhQ4glI9Z4=;
	b=oz4Bmng8LhHueDP9xmWYTi1xTETWwy+/FZteTy8iy+FD+Pk1U53ArBnBof8UEmc0AsK9
	 9iYCkCCQVYI+AJOUQHpvhlBpHx5DpjSLhLix7ZOwfGDzV04Yf5ZeDyLtDryefOsIyZ7mV
	 cATS0//mj6yybQESv/haFCViI8is7PO6BAuSERMuj6cdqdV93f04fAwKQU/zuwZdr0B77
	 DtN6/J/pY4yHqdi08+85PvHU4u5HxaiHGFgE/E5QCW8R1l0kDQrvx8zua1Kip+gn2G38A
	 RVc9+zeVIYVlt0Aqq4xry/ESwd1Jc6YcKgCnMZ4z4LUamVISnMTbdU9lH0/rsFGOJ5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CkjW4Vby;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A36606A32A;
	Wed, 18 Nov 2026 17:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CkjW4Vby
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B771F000C4;
	Wed, 18 Nov 2026 17:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023473;
	bh=aYKRpc2WoUUw6gamQjfklJApzKtUU0szavhQ4glI9Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CkjW4VbyNLjDlKj6Ww+0JkReYszS5xgYNM0g1hWGIol996OkSDrJNqwEnHqwTtQf6
	 zsltJ/U9dmY8nddSF75jf9g8NcIOJCanZcoQqI8nWVs+Bq9RYjtuJU5G0wawin848l
	 huSDa0UY2rnS13KsyvqcirQBxvtIkX+I1BEDsi4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0380/2151] ip_tunnel: use WRITE_ONCE in ip_tunnel_encap_setup
Date: Wed, 18 Nov 2026 15:35:15 +0100
Message-ID: <20261118150135.926930123@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e9da39010f8b3..41867ac981b69 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -491,19 +491,17 @@ int ip_tunnel_encap_setup(struct ip_tunnel *t,
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



