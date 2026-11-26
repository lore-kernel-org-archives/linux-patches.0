Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704445;
	b=n5aDSRtvLdGkr9y1GkyHUEeMCF3EcopXfpM13f4AzyqnYCqDyl+zUoD5IVAmG8K8Fnlc
	 qJxxaDwpvttJhA9yux89SL0989IgIXyCmWb/6k/NyA5eZ+axhi8WhlzAr4tupuX1gZI/K
	 LTg8eCKLP+KJU/YBxeuiYQtE1nYr9JHj44axYf1d7hnUNTcKKyyXFMPn2qjtCNi5xZ6j1
	 PsprNwkfBclgiQLrIaFOF9u9hWEl9CM3C/bz7ZQhuEUfXuaCS0vt8LKExW04HkynKQkyb
	 qn2DKESSs90r9RHb6ZyvdiCInorz6X2r3sXGn/Lhg4NsYmtGg+RQQks++jHyq9UKm7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+hWDrbTAComivep7gFNaQDfbp2/kMjcQIf5nV0FUoj0=;
	b=v7vDUSsGs6PL9iEThSHYZfuwkBup+LlTdvCYYIk0TLwNAa3MUJ8312JtahvJFaxYgIFj
	 X7zvE+umgd8qT09XPEyNgBwHqyR8t4qHOj0mKO2s5iVwR/9IIyyKI9w7JGT2AjWvlKjWQ
	 Txl5KeMxDYMdNSfZIj/hXEIWlN7nDLaxFs4yVbpjaTJN/4onBcwi/znCC4fz7yYbvcPgb
	 xOzZE2B85BP0gqoj8xwzYA+YxuAaf+Ma7/RUx1hvSX1JsrdL5kwXCtbBz1jywe845dz1z
	 e+PI5A2Qo9HqIIEO8lR/MxDnGI+uV5xnB8m7xNQfs9kO3qRTbcRSDa0a668u9jcuddw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qthc7MGd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80774606A338;
	Thu, 26 Nov 2026 14:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qthc7MGd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3BA41F000EE;
	Thu, 26 Nov 2026 14:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704445;
	bh=+hWDrbTAComivep7gFNaQDfbp2/kMjcQIf5nV0FUoj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qthc7MGd/1CwaRuqqMZfxuROALhRc7sZ59FuPB60J4hdLyVM3by75AlyG+HgnBbMB
	 +ZyPG5KECzy5/fyFcGnRGghftPorRPLBzyntn4HLuBLuucSUA4WdL9YU9EsETUKGpx
	 +93UlGCQQTobjIaKs2YEYGAmzzDb2neWxS4upQsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 127/265] fou: gue: check IP version of held packets for direct IP encapsulation
Date: Thu, 26 Nov 2026 15:37:37 +0100
Message-ID: <20261126143613.916979759@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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
index 556323c687e5b..9636a31e0a63e 100644
--- a/net/ipv4/fou_core.c
+++ b/net/ipv4/fou_core.c
@@ -368,6 +368,18 @@ static struct sk_buff *gue_gro_receive(struct sock *sk,
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



