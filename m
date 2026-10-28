Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215769;
	b=tR9KKZNppLXyDaQpl7GyKb8+0QwsHYldi+EAO+AUenXXcI2ubwXwQYLfLrJgxd1SBDc3
	 eZ/K4nXN+TbaEbo4sC33DkZx/Bg5PZn4xAHxX0CODZo6pBJaAAFPaXQqWAOiqfCbnRUxv
	 1TowmdgPyc+055bCtAG+LzMLIrB4aWHhSB8ZXgptspSbIBWs/siF7pnEkmyrD4DPwtRQ2
	 2PlKmg44xJ78JQIMioCcvZA13IEKycRDREeHThElmXepSMdoZrLaEKTLjdCCNiXhYQpxW
	 CHi9nEMFOi2k0HI/n1JIwKbaj9z4AugrUMuCe1Hsv6QNCmh8S35GmQ9J95Wxtk7RZbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1j5PXWSY/2K8bVB5ub9RUjFCkkPQoSs6IlB6ii3HGI0=;
	b=QHWvfPGwF5wKt3xBAuJYvl0DvzXL83787mICA5MKF+7nFCqD7hrNlWasZaQTv64jtbN1
	 /fpRKZPIuv/x05o7FkScqwlIGJih2FB3/WRrZK+fAVBiplGmcsCRhVFptTqIrQ1hHy86R
	 m9Oku8kbdQuiuHAVXB//Bq7WiMOPm2s9zVN4O5rjdPrjqZSP/VVGob+hAfrWNTK7Zr3Rc
	 sEap6qc7boxdxeY21Ur3DMe0b2xyacYlyRx71rY18xTIPMS8LQGmwchOLyLn6mMyQ8Ezl
	 omkUCDbec5nZ6xfK+Hu0zKDgzXHbTFC6UrEj6s0+oAY3BzFm0o9b4Rda9HfoEdk5EdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nD5meZIt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42E0606A31E;
	Wed, 28 Oct 2026 19:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nD5meZIt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207C31F01825;
	Wed, 28 Oct 2026 19:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215768;
	bh=1j5PXWSY/2K8bVB5ub9RUjFCkkPQoSs6IlB6ii3HGI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nD5meZItZ2Krjq0NBi4FqBwNcXomPixpTYuUKmT+/CBGjGGqupPURqOTzu4bokbAF
	 shUiFqTMKAnfhjfCxWtfscW30EW2a9RvN+7jENohv9jk/o5yYmkkxZ1NGk/S56MLOL
	 i9YepL1GQfIovjsYS7ju0PGXjJOtFIQy/D/ZcQn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1327/1887] netfilter: synproxy: fix unaligned memory access in timestamp adjustment
Date: Wed, 28 Oct 2026 17:57:03 +0100
Message-ID: <20261028170529.628225657@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 992c20bc8a4aba220c8b95b467d049289778dad6 ]

Use get_unaligned_be32() and put_unaligned_be32() to safely read and
write the timestamp fields. This prevents performance degradation due to
unaligned memory access or even a crash on strict alignment
architectures.

This follows the implementation of timestamp parsing in the networking
stack at tcp_parse_options() and synproxy_parse_options().

Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_synproxy_core.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 52f1f30f95add..35c38c3268a6a 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -190,7 +190,7 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 		       const struct nf_conn_synproxy *synproxy)
 {
 	unsigned int optoff, optend;
-	__be32 *ptr, old;
+	u32 new, old;
 
 	if (synproxy->tsoff == 0)
 		return true;
@@ -220,18 +220,17 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 			if (op[0] == TCPOPT_TIMESTAMP &&
 			    op[1] == TCPOLEN_TIMESTAMP) {
 				if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY) {
-					ptr = (__be32 *)&op[2];
-					old = *ptr;
-					*ptr = htonl(ntohl(*ptr) -
-						     synproxy->tsoff);
+					old = get_unaligned_be32(&op[2]);
+					new = old - synproxy->tsoff;
+					put_unaligned_be32(new, &op[2]);
 				} else {
-					ptr = (__be32 *)&op[6];
-					old = *ptr;
-					*ptr = htonl(ntohl(*ptr) +
-						     synproxy->tsoff);
+					old = get_unaligned_be32(&op[6]);
+					new = old + synproxy->tsoff;
+					put_unaligned_be32(new, &op[6]);
 				}
 				inet_proto_csum_replace4(&th->check, skb,
-							 old, *ptr, false);
+							 cpu_to_be32(old),
+							 cpu_to_be32(new), false);
 			}
 			optoff += op[1];
 		}
-- 
2.53.0



