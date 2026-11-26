Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704964;
	b=oVpI7+hpn9Zb2LuDW2PMirZGMkfYygD136u4vUvlE1qn3fZ7mbITp8UH4hy1Ju+OWilG
	 2/DT+4IMi72h5QhoKErQX9UhavSi8hfQsE64G4uhHe+1c+gflQWkdU328RaDFi2hsk32M
	 RsRNzuPzp5oGhxDtukqaDZtMDOxbuKbIdarBZwEUi5dzfHKnOLSAQ8eXiI61+VLaIP3So
	 J3GDslZSrBOlvkVEZvhTy154dkhTR5lK/aw/x78g9cjNGFNpTqi+V6gnyex29A+VRiPqd
	 H8NUQTJrBukotHmjym23hWy972X1Qw5Gql2/PXySC+lpRP2K9C1NiqOIrcbZKa5I6FQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704964;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NxUhDBsLRXhYAzsXGp3APQ+ekM8Tpdd1X+SnsLTAc7k=;
	b=Gx2EskQISMWkKFKVPTkqCeEAWKolaj0bWA85s50eofcj6pAmVL5X/JSf0F4Ht5WTYHT9
	 +aR8d3hVfwFQgmz0+Bh7B3UQeZjseN/UvSGlbI8Mk7+080KjjY3yHb9QkyDNpZ/H7PRY7
	 8W4+ph9I8LZ8VYt1WpJwagWe4d1R0ojt0rd+gWNT9FoeGI+sfPCO0Zspzm1C1Ik7pjt8R
	 8bcDopBq7+mydcohOqpKP/EIqmMx3kpbvO3KKqVztOaqjhgBXkKMp0bnyCCnr7dKTWiW1
	 bZXLOh+/RPr2bpzCj21iZbyv9uwIHMaaEIaGv/Uh/Bapqqp7CugvcJjFzo+HHuDlS1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uEZWhQkv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8987D606A32A;
	Thu, 26 Nov 2026 14:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uEZWhQkv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0A71F0093E;
	Thu, 26 Nov 2026 14:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704964;
	bh=NxUhDBsLRXhYAzsXGp3APQ+ekM8Tpdd1X+SnsLTAc7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uEZWhQkvoVc5wgOb1hJQrqKKP1bunbibAuDzRaOb4mEfp3sBN3clJwqhHLAGQRaKh
	 2WUxEPdQPu8G/YXb8l4xiMQ0srt9e0lV5Em2MSaPq4MxXf5Rc+LQrMMGlM0kPKrKM+
	 QXVLf3ptn/7LSU9h68IkhnC507LkobqfdDrO3Wz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/319] bpf: Dont let bpf_skb_adjust_room() raise gso_size to GSO_BY_FRAGS
Date: Thu, 26 Nov 2026 15:36:45 +0100
Message-ID: <20261126144007.575934678@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 6d8118937ba477e03fa2e94e9bd9abac7291a2a2 ]

When bpf_skb_adjust_room() shrinks a TCP GSO skb, it adds the number of
removed bytes to gso_size. gso_size has 16 bits, and nothing checks the
sum. Thus gso_size can wrap to 0 or to a small size, or it can be
GSO_BY_FRAGS. GSO_BY_FRAGS is not a size. It tells skb_segment() to read
the length of each segment from the frag_list. If the TCP GSO skb has no
frag_list, skb_segment() dereferences a NULL pointer.

Return -ENOTSUPP and do not change the skb if the sum is GSO_BY_FRAGS or
larger. With BPF_F_ADJ_ROOM_FIXED_GSO the helper does not change gso_size,
so it shrinks the skb as before.

Fixes: 2be7e212d541 ("bpf: add bpf_skb_adjust_room helper")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-16-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index e8bb5d9b9a2fa..0783fa93319e6 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3629,6 +3629,14 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
 			return -ENOTSUPP;
 	}
 
+	/*
+	 * The MSS is raised by len_diff. It has 16 bits, and GSO_BY_FRAGS is
+	 * not a size.
+	 */
+	if (skb_is_gso(skb) && !(flags & BPF_F_ADJ_ROOM_FIXED_GSO) &&
+	    skb_shinfo(skb)->gso_size + len_diff >= GSO_BY_FRAGS)
+		return -ENOTSUPP;
+
 	ret = skb_unclone(skb, GFP_ATOMIC);
 	if (unlikely(ret < 0))
 		return ret;
-- 
2.53.0



