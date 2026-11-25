Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624868;
	b=R7H09U6iiqnu9j1HhmqFwOZzsq65vL1IDmf1F9+oGQxs0wYF8VgRnmKL7z4xwZFluGVP
	 Z3egkGDW0aC0FZ8I7Ae1p+zHujOYdLd8Y0WmpTGde27yT3sQ0QDpqVK3KEO9Jtqgz4mzY
	 QVybomCa6Lh7jf5B9EwgcFv18GaUbEqT8T/ryrNefNO/7Vux7blDvF9RF6LZNo3Zhb7eU
	 qPeikn5H1vE6ePNvv9VOYKfNZS7urZ5REA7wF9wohezA8Q/4MqizgAchzYY1LQ8VoDrEr
	 xT4i0bybX3EiKxpsIW0uiC59OGKtVHUChMgWqdmYcJ17PUwRpUkRJiaGMVYrDzXJALw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=epWxy9H9VlD0b5aY0JkVJ5XXxpXoyLO/6yIIaya8XWQ=;
	b=r/3UJ7O91H7S/pgYhUt0NDGT6kDXuwWUdF3saNTSi25dxWg6aHMAbAZsQAmmvL2qP7TI
	 jo1/5ggxfG8WQcgFQ2nyIffCkvWa8VGYn5k7H1lNDW6xoyqA7fZbfkqoVNpt9AXX54xtZ
	 YEBmJyp3XCghBfq19Jje89fyC2DQAiIZyUHjHDQ2pR1wlWhh04ZeghBEsZQTsO2E8wkcP
	 2n8dS6expT1Js9eUX3LzDjRohFNbX1DmN9TEQxzGJrzV9H53m3oitXNL7SV5MNEHrL6yi
	 LzRl8GST/ocrgIio4WFCs8257Nmz/ZzSMsaGRoO0d0gkERrylzx+oWkMehqrHHQQv7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="uA7/642V";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C908606A31E;
	Wed, 25 Nov 2026 16:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uA7/642V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A2E1F000D1;
	Wed, 25 Nov 2026 16:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624868;
	bh=epWxy9H9VlD0b5aY0JkVJ5XXxpXoyLO/6yIIaya8XWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uA7/642Voe4I7wj+b8I0bHClBVJcineeoUJxB0/PKB7F0br+Z3Bh+8vDFah6Pmsnk
	 0SNk3COpj59SKMujxbmnWlZv+6UzP3dpGqSLab8qfcjirlbIh8GWYc//9k6UCC7AtQ
	 Gp9XruVMzwlSerbbdIdgfaACm0kSQlD/JaQW/YFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 333/816] fou: gue: check IP version of held packets for direct IP encapsulation
Date: Wed, 25 Nov 2026 15:31:21 +0100
Message-ID: <20261125143856.907626139@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit c59f004734a2a7c0e427011db13aca524e781498 ]

For GUE version 0, gue_gro_receive() compares the base GUE header and
its optional fields with every held packet. For GUE version 1 (direct
IP encapsulation), it skips this comparison and selects the next GRO
handler only from the IP version of the incoming packet.

A held version 0 GUE packet from the same outer flow therefore stays
eligible. For example, a GUE/IPv4/UDP packet can be aggregated with a
direct IPv4/TCP packet, and inet_gro_receive() then parses the held
packet's GUE header as an IPv4 header.

Clear same_flow for held packets whose first nibble does not match the
incoming IP version. A valid version 0 GUE header always has a first
nibble between 0 and 3, so this also separates the two GUE formats.
The reverse case is already handled: the version 0 path compares the
whole base GUE header, including the version bits.

Fixes: c1e48af7960e ("gue: Implement direction IP encapsulation")
Reported-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261106195615.2498766-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fou_core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/ipv4/fou_core.c b/net/ipv4/fou_core.c
index f1cfd5381e45b..37cfbece08c54 100644
--- a/net/ipv4/fou_core.c
+++ b/net/ipv4/fou_core.c
@@ -365,6 +365,18 @@ static struct sk_buff *gue_gro_receive(struct sock *sk,
 		default:
 			goto out;
 		}
+
+		/* Match the encapsulation format and IP version. */
+		list_for_each_entry(p, head, list) {
+			const struct iphdr *iph2;
+
+			if (!NAPI_GRO_CB(p)->same_flow)
+				continue;
+
+			iph2 = (const struct iphdr *)(p->data + off);
+			if (iph2->version != ((struct iphdr *)guehdr)->version)
+				NAPI_GRO_CB(p)->same_flow = 0;
+		}
 		goto next_proto;
 	default:
 		goto out;
-- 
2.53.0



