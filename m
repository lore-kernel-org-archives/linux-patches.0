Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9291A3029;
	Tue, 12 Aug 2025 19:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025728; cv=none; b=iprYY+vyiwLWA3SpMAtwK0+wy/Drgm0fJSBTveA1lItEpQZBrgeERi71hoWo8X4XrSNLWT9krma93ZJtqecrCwWd067pptX8mqi/qJg1oBVSmlgtLrr9LyNS2j+kgbU6AZt0LCr8tT3ljFVom8VJj6jy9yIq3OXsrqdzE1MgMW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025728; c=relaxed/simple;
	bh=1D1+DnHdukRarW+jzXGZcQsYp9gZSMZKwJ5WBfSeinI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqxNQ/lNy5V1jwmnXjiq3Xn9Ay8s4u/3Llr7HqXWymG8yDkEXaCW3nepAKPHbgRFRCp9BZ4ncvXvatzR2uCDKwj7xWtUA3WbvzQlih+Cxo3ZPcSl4Bbr7qLqQUTsaqiyel0YBw3nTl0KcLa+zffXE8dH8EUBzatdcYYF/pW95oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eWdadz3/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eWdadz3/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB94CC4CEF0;
	Tue, 12 Aug 2025 19:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025728;
	bh=1D1+DnHdukRarW+jzXGZcQsYp9gZSMZKwJ5WBfSeinI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eWdadz3/jXKRUhxVoA/ZhlHKPMtfUge7lKJ1GXZttSqP8gwXum6U4o2r1I8btbV7f
	 aeaO6VD6qgOd+vzXqRw+SUU5Yxc+mZktPCShCvMgDB/LO7NYM/ZD9s5bZMbKsgu67g
	 uQxQJcOc58LnRBGsHHTc+YQM4a5JPPoRH+DzrXxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"xin.guo" <guoxin0309@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 127/480] tcp: fix tcp_ofo_queue() to avoid including too much DUP SACK range
Date: Tue, 12 Aug 2025 19:45:35 +0200
Message-ID: <20250812174402.767341037@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index bce2a111cc9e..e75ee9023674 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4986,8 +4986,9 @@ static void tcp_ofo_queue(struct sock *sk)
 
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



