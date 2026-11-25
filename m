Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622151;
	b=vnnhxk82vbVqryXtbaHEIU3k0vq9xnxoUIlyaSyWMNQS1uNwgm5PJnITiCb3DVmJCmwy
	 R22IEd5dTcapgLZFHo35/veydFTPzzJx+YOEizWiq4u55x0mXz2jfDkOspO2i+4teeOEd
	 XVeboH3ps10AL1YYM2dNSUooB7Ykk98C6SGTFSaX8Z/p+1KZMGiUkw63lBobdw23d+JM1
	 8DlmjcopM9q9dmQHTxC+fxy1pHEi7NDZFi1KBkStG9jfMRj1vmVxDCcBU6qq4EyH/1cGI
	 97krjSW34xg6aDoSdHklahSQczweXAO1KOmKyPB10iIMFaYh3bAqHdBnakQWeHyABRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622151;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8C6sP4+BNzfj80Wsf85yPIXVubGAQsmS8sXxzKn6708=;
	b=dSOQJN9QwlOv6yGrMG50cAi1c9+ZuDZAHpILF9tHQvzvrJ77jGopez3pLB3sr/2TaXvD
	 QZNKiLhKIR1tKbOO1/YhIf9MbMt8RKfm+W2tGRljZUaCO2RRjTyfMz2rp2TJ+rhmUFVA0
	 f/e+NS0duluqhVYisIFAzQZKXzuxlBQt/UfF1L7f4X6SLIa8swot2Sylax64Tffrk2iQv
	 SEY0adLwwE6SM0XOW3uy8UR7Z2LsV/+z8f2AKhdsy943aEXvJP8zw4LDpy+nxJYdL5OC9
	 HSJL5CSHfXMRr/5186Qw24JNOQsTLKHDG27T11L5i9sHaMtL0l/DSRnVjavL0u4m8GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="JKLW/6tb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65BA606A321;
	Wed, 25 Nov 2026 15:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JKLW/6tb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FFE1F000EE;
	Wed, 25 Nov 2026 15:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622150;
	bh=8C6sP4+BNzfj80Wsf85yPIXVubGAQsmS8sXxzKn6708=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JKLW/6tbigz5bRYdSXvKzh7r9ltMYEiAVNyEVMW2clbSnfKkhtmY5gZb1pFE6cnGJ
	 JZ+SyRJpdobrIA7a00tmGh3eB94BT6OibSh3BWHubiM5Yb3SKyjtv79UpxzNQtdjMD
	 +moT67vRXgkTWowehx6oNqhD2QcNnkxhVIBYiV/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 438/990] fou: gue: check IP version of held packets for direct IP encapsulation
Date: Wed, 25 Nov 2026 15:30:05 +0100
Message-ID: <20261125143832.353705594@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index fc930274a1fd0..65da20c30b6ee 100644
--- a/net/ipv4/fou_core.c
+++ b/net/ipv4/fou_core.c
@@ -364,6 +364,18 @@ static struct sk_buff *gue_gro_receive(struct sock *sk,
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



