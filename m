Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B161230BDF;
	Tue, 26 Aug 2025 13:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215728; cv=none; b=K5S4I3Ti4M+PPl+y5khsh4+hvX4eH/bLniO+ekrCp4joedKOGWitq+ugTBzbSeKD1wL25GXaw5edyYB1pvZq+QiS6m/19OX1dAg1o+kp3HGQaCQAZ67xvdJ2Zu63NJ/cHO5/cln2RVThxG8ny2B5OPITzuFQsV/FdDvA8+x6rf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215728; c=relaxed/simple;
	bh=aRFvik0zIkH8BG+3USPEhjVFZBI+CXa5B6n1ku53y6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sfN7tznBGkofRBr34w5hxeZDAUSwjt/04/7TX3Hk52kfkr0xztSBWY7zJzhPabRK+EEPcT89tnfwc6Jd7D9QdBWAMbDfoLXKateuNWQuogwW46leVYPAI8R4JTTJ/Ml6kBAkvfTRFjadbFpIbryUuslpK0SGw3dp1ZgHle83F1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OB9+MXFk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OB9+MXFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA84C4CEF1;
	Tue, 26 Aug 2025 13:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215728;
	bh=aRFvik0zIkH8BG+3USPEhjVFZBI+CXa5B6n1ku53y6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OB9+MXFkmOPbDY0Qq3qQ7FS9lJueV3+4pSVIre3DjP5aXDArbhhgnqi+vxjtplkN6
	 9VTNKSk7fX6isRjBlSpDwiChYYu6zHWUuHskYrAMeOjmKcNoYdShd7yGdP+H5SkepW
	 yYD4X5yzgzxEbnHC4pHZvmBwQlMx8ZhT1c+J9bJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"xin.guo" <guoxin0309@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 144/644] tcp: fix tcp_ofo_queue() to avoid including too much DUP SACK range
Date: Tue, 26 Aug 2025 13:03:55 +0200
Message-ID: <20250826110950.059484306@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 10f39b2762a7..fea019cc92d3 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4826,8 +4826,9 @@ static void tcp_ofo_queue(struct sock *sk)
 
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



