Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F0B46C4D9;
	Tue, 21 Jul 2026 19:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661237; cv=none; b=eLSytolkYN3u9GujCkv2WTbSQeF4NdjJWHx3Cl7kWF+6AYGzedO6zo41voyO8I1HZhiDHkQ0WORQGHWGarEr6u3k2t4fTpm1mms8YZ/iqwFI90mhebhASx3UCvGL9EkosPovkSb+PcgbZVD43Hzjx8PAukbYQt0EMRbqGKr3lD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661237; c=relaxed/simple;
	bh=kqgHDf9mYyeyrK+gbsujMndhYTSCc3UYdlPKxKt9B/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kpnnbzjhoxd6rKUOCp3OjGlSDLeTwTi/UFsDtCfZNVFr/tGgRIO9fvTI1GvT6KN2pceoayNvA1PZ2Ou2BuNQ1baPW6G4qbr5IeXk6w8/mwapLDWPSfosWgUxAZmyivCFlbHWjKLyoZMj1prFRV9gBEgQypdBbXZb+BKKewA9qzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NTMEoaom; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NTMEoaom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1F11F000E9;
	Tue, 21 Jul 2026 19:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661235;
	bh=23Uc26gH1MqrWVRHYRLXNiycXLucoyMnl/nqOz4JJSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NTMEoaomF93m35K2ezo46J7vZfOTUVVjVcJ52UdNwbMNcL7EOFH/Pu6SbTbEe7JRu
	 /HnY8r5sPIaHNuaYM2WUrLIgcYgaYO7sqspsyaW8kFoC2pBvEHPUxMbNmey3aVIMHl
	 zhR8KkvPCIwuKu3B8YwyNLB7f+ygIxbaWlPiuu+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Kyle Zeng <kylebot@openai.com>,
	Xiang Mei <xmei5@asu.edu>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1281/2077] geneve: gate GRO hint in geneve_gro_complete() on gs->gro_hint
Date: Tue, 21 Jul 2026 17:15:54 +0200
Message-ID: <20260721152623.030752209@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 2651c174445884ac9e85622aeade9c1f7b98d8e5 ]

geneve_gro_receive() reads the GRO hint through geneve_sk_gro_hint_off(),
which honours it only when the socket enabled IFLA_GENEVE_GRO_HINT
(gs->gro_hint). geneve_gro_complete() instead calls the low-level
geneve_opt_gro_hint_off() and acts on the hint unconditionally.

On a tunnel without the hint, receive aggregates the frames as plain
ETH_P_TEB while complete still honours an attacker-supplied hint option: it
inflates gh_len by gro_hint->nested_hdr_len (u8) and redirects the dispatch
type, so the inner gro_complete handler runs at nhoff + gh_len, an offset
receive never pulled nor validated, reading out of bounds of the skb head:

  BUG: KASAN: slab-out-of-bounds in ipv6_gro_complete (net/ipv6/ip6_offload.c:196)
  Read of size 1 at addr ffff88800fe91980 by task exploit/153
   ipv6_gro_complete (net/ipv6/ip6_offload.c:196)
   geneve_gro_complete (drivers/net/geneve.c:965)
   udp_gro_complete (net/ipv4/udp_offload.c:940)
   inet_gro_complete (net/ipv4/af_inet.c:1621)
   __gro_flush (net/core/gro.c:306)

Gate the complete path on gs->gro_hint too via geneve_sk_gro_hint_off(), so
both paths agree. Tunnels that enable the hint are unaffected.

Fixes: fd0dd796576e ("geneve: use GRO hint option in the RX path")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Reported-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Link: https://patch.msgid.link/20260618032622.484720-1-xmei5@asu.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/geneve.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index b2e74e815e5778..a48f6c52f12695 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -948,13 +948,13 @@ static int geneve_gro_complete(struct sock *sk, struct sk_buff *skb,
 	struct genevehdr *gh;
 	struct packet_offload *ptype;
 	__be16 type;
-	int gh_len;
+	unsigned int gh_len;
 	int err = -ENOSYS;
 
 	gh = (struct genevehdr *)(skb->data + nhoff);
 	gh_len = geneve_hlen(gh);
 	type = gh->proto_type;
-	geneve_opt_gro_hint_off(gh, &type, &gh_len);
+	geneve_sk_gro_hint_off(sk, gh, &type, &gh_len);
 
 	/* since skb->encapsulation is set, eth_gro_complete() sets the inner mac header */
 	if (likely(type == htons(ETH_P_TEB)))
-- 
2.53.0



