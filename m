Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048154;
	b=wmD7/lnhVrFK7daBK+dqkWu+dmMCl0tL5UHUutkhi4gHwHI4RZgS1YeGWVoOzxZHhuq7
	 WONJ77Mi5Wp2qzOGf9HjYZolMsgGTs07J1xiKpgayuE6MA12nqJq3zfHKx3+i04vuzdsE
	 7v1QinPJmlB0dd3zu4GeRfCebR6UACpUzgi7LcJ9CyE7O6VAkNmd3sUG6NRuaBjJQ7NMb
	 R3Ng7CF/IoXfFsz4E+SpTqk18Z+v6918mD7oYXH+YaYEBq127eSFzY/W6N+fpKLwzw28Q
	 Aa0vWyCf21gA0ANUiMqfkhj4mshAzsbmQyypWEFbmrYIx7Fbczu+4Jf5qDC2jM1ooaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048154;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mMMkuz43W6mGWBqqPPurl0BxUGodJjQWiAKqJOhbY2Y=;
	b=fMI3ubp2nbG3CXCdeDbg3PnLlC8eiPDGbGgBQeEb0IxTW1fEAze2qK6s4IyCV+mreYDF
	 IO+BjcD2KhLrgRvJpO2eZ/vJEjN3CryLpHqLdi8NRaUv7s8Jw6hj0PQyaSKRZtms6n1eK
	 +KszEpEGDY48AryxxvUm6PzR8BXySL3TAXcSuGl1SPixtgNfWQNkZ+h80vBCVhu0Y2EvE
	 U44edUweXDgyudmwe1PFwKvF7hlckp/KKACgnNGeD3vIO54gPsEDbxX7zrlBpwpiAYgK9
	 C4WaePusB5DYmY1vN6uGqfM8zGmVRhMjmrFH9JT+ArE8dgsEcZ/0eLKRIxjFAZTlWag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MwILYrvS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82454606A334;
	Thu, 19 Nov 2026 00:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MwILYrvS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1531F000C4;
	Thu, 19 Nov 2026 00:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048154;
	bh=mMMkuz43W6mGWBqqPPurl0BxUGodJjQWiAKqJOhbY2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MwILYrvSdiSVnIIUyTNqFMzEBha9o1pPSezJCCAKt52bzcq7DIlwqar3qKzXVb9cb
	 8hWXYarO1s2WM7OKo3goqEur/loKrsFLQennt3V91vft/Y56UPxogsVmqyZYTOrYtp
	 F3Nyoinl/qv2kcOgFv/M5QJy1cGSqeBUBhkxGBRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1893/2857] ip_tunnel: use WRITE_ONCE in ip_tunnel_encap_setup
Date: Wed, 18 Nov 2026 15:48:47 +0100
Message-ID: <20261118150309.396187276@linuxfoundation.org>
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
index d250ed84f32b4..77376d0241232 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -490,19 +490,17 @@ int ip_tunnel_encap_setup(struct ip_tunnel *t,
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



