Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1693634DCD2;
	Tue, 26 Aug 2025 14:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217412; cv=none; b=kO4bFXWt3ePZ2PxTP+tPkn0CQs3kC6GN3SpNs/vrN8FVi2EWCtEz/nMthW/pZDxMG2gVLIZcZ4b80vNxS+n7WP/wTJzuvDNReoVvm7RwddkTguu51TZRJLvbMhF5O7Z6wB89uWNBcRlvNHYAizzyFPYq2mLdneykaQgqf+QpIrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217412; c=relaxed/simple;
	bh=iw+ZBvYnJMI2zjRR8DB2z71Yt5I23YQkbvvfriT11gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VRAkJbl0+Y3+8nKt4Sk8Aq3NGFOGE1VW4223NAvfJDRRS1pxacD9xTbWSRzVa/pf2tyHixqDOs1vGdpeDFinmaI/RwjXk8drjvi7URjjuHK3MnXFRQ8JQFva61gRUoByDepBy8CqisT+ti2HzFluhHk2Su5k01cJrpusKvSPro8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=enOCw8hJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="enOCw8hJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7B3C4CEF1;
	Tue, 26 Aug 2025 14:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217412;
	bh=iw+ZBvYnJMI2zjRR8DB2z71Yt5I23YQkbvvfriT11gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=enOCw8hJ9109475YKhtBUNVJu3yRRJN/zQ60iN5otIGl1BwUr6N+n+y/aPiYTeNaP
	 weIhqXxDcUKXBoFl9cDooKeHPxtl1gPG1ZHAVwuryf1a2LHZNIOyL89U2xOzen9uf5
	 SbfQrQTIQLxhEyEmdH+XXXyBNcmQNuRwNfXVxH9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"xin.guo" <guoxin0309@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/523] tcp: fix tcp_ofo_queue() to avoid including too much DUP SACK range
Date: Tue, 26 Aug 2025 13:05:12 +0200
Message-ID: <20250826110927.055161894@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: xin.guo <guoxin0309@gmail.com>

[ Upstream commit a041f70e573e185d5d5fdbba53f0db2fbe7257ad ]

If the new coming segment covers more than one skbs in the ofo queue,
and which seq is equal to rcv_nxt, then the sequence range
that is duplicated will be sent as DUP SACK, the detail as below,
in step6, the {501,2001} range is clearly including too much
DUP SACK range, in violation of RFC 2883 rules.

1. client > server: Flags [.], seq 501:1001, ack 1325288529, win 20000, length 500
2. server > client: Flags [.], ack 1, [nop,nop,sack 1 {501:1001}], length 0
3. client > server: Flags [.], seq 1501:2001, ack 1325288529, win 20000, length 500
4. server > client: Flags [.], ack 1, [nop,nop,sack 2 {1501:2001} {501:1001}], length 0
5. client > server: Flags [.], seq 1:2001, ack 1325288529, win 20000, length 2000
6. server > client: Flags [.], ack 2001, [nop,nop,sack 1 {501:2001}], length 0

After this fix, the final ACK is as below:

6. server > client: Flags [.], ack 2001, options [nop,nop,sack 1 {501:1001}], length 0

[edumazet] added a new packetdrill test in the following patch.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: xin.guo <guoxin0309@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250626123420.1933835-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 82382ac1514f..64a87a39287a 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4769,8 +4769,9 @@ static void tcp_ofo_queue(struct sock *sk)
 
 		if (before(TCP_SKB_CB(skb)->seq, dsack_high)) {
 			__u32 dsack = dsack_high;
+
 			if (before(TCP_SKB_CB(skb)->end_seq, dsack_high))
-				dsack_high = TCP_SKB_CB(skb)->end_seq;
+				dsack = TCP_SKB_CB(skb)->end_seq;
 			tcp_dsack_extend(sk, TCP_SKB_CB(skb)->seq, dsack);
 		}
 		p = rb_next(p);
-- 
2.39.5



