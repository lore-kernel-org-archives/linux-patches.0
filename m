Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C94147F77A;
	Thu, 20 Aug 2026 17:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247268; cv=none; b=kA0weztgKN4+zfjljBvQ8OGt7aBT6jtmktA/P2jCByCFexxYqqglwbcRZq4Zxm8Z+8nThD5oZsk0zr+9vIE6XQ9rV3GO8dQ4gNmkkpM+WiDZbl+4xAvrtP/bHXfLPBARXfk/dD5TPKPHOLlsy4J2rad2Xdc4pZrHXKgAodRsC9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247268; c=relaxed/simple;
	bh=PTJJsizUp3QRQkZyQoNK+4gLmaD4Aa/ligbLxXcNowY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DwZIx/YCxR7Ege3koY01aQPexMW8Hb0rynSCdRvSfaWRyjwFbqSxnsO1p87+mLp9/jgpWIoyvaAYHuN7vQQTX13v0M4900YpbdaAJ0vEMwz2vrQqv5EG01iA6w0P55HBrhaINGhxu3yxbGRxg1+2vi//6OA3vQSXAHVeB+hMPoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hhoeoBQF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hhoeoBQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686A71F000E9;
	Thu, 20 Aug 2026 17:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247266;
	bh=dO1AJY4p/YOd/dN1lQtzDkcDufxGW7rERgVc5FQorYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hhoeoBQFxJzOd3S8XN4IN1lRcL2taf1gSNicxvnNogapvWJze3xmDL2hZZzALHrfJ
	 49Fv8zwBf2vl08sQiRW0AasozcmKKPMgacPuYe/t3Bon6FMgve70woxrCEb50pRbtj
	 JXa2kkoY2mkLiL4NFE5iGK3a/zv0ZjNWs/Lh/AhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+30b93b6845b19cc38581@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 207/220] af_packet: Dont send zero-byte data in tpacket_snd().
Date: Thu, 20 Aug 2026 16:56:37 +0200
Message-ID: <20260820145229.734409897@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 6bcd76c134c55c697148acb5c0194e9666abdf84 ]

syzbot reported a WARNING in __dev_queue_xmit() triggered via tpacket_snd():

skb_assert_len
WARNING: at include/linux/skbuff.h:2753 skb_assert_len
WARNING: at __dev_queue_xmit+0x21bc/0x4970 net/core/dev.c:4781

Call Trace:
 <TASK>
 dev_queue_xmit include/linux/netdevice.h:3448 [inline]
 packet_xmit+0x243/0x310 net/packet/af_packet.c:276
 tpacket_snd net/packet/af_packet.c:2907 [inline]
 packet_sendmsg+0x28d6/0x4eb0 net/packet/af_packet.c:3134

When sending 0-byte packets via TPACKET ring buffer on devices with no
hard header (e.g. dev->hard_header_len == 0), tpacket_fill_skb()
populates an skb with skb->len == 0 and returns 0. tpacket_snd() then
forwards this empty skb to packet_xmit(), causing __dev_queue_xmit() to
hit skb_assert_len(skb).

Similar checks exist in packet_snd() via commit dc633700f00f
("net/af_packet: check len when min_header_len equals to 0") and in
packet_sendmsg_spkt() via commit 6a341729fb31 ("af_packet: Don't send
zero-byte data in packet_sendmsg_spkt().").

Return -EINVAL in tpacket_fill_skb() when skb->len is zero to reject
zero-length packets in tpacket_snd().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+30b93b6845b19cc38581@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6a79e807.01d0871a.3a0d52.00ac.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/20260810150447.1220864-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 6a12d9c704a91..7e55ddab7b961 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2712,6 +2712,9 @@ static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
 		len = ((to_write > len_max) ? len_max : to_write);
 	}
 
+	if (unlikely(!skb->len))
+		return -EINVAL;
+
 	packet_parse_headers(skb, sock);
 
 	return tp_len;
-- 
2.53.0



