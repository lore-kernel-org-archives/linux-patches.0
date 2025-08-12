Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474692F5481;
	Tue, 12 Aug 2025 18:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023864; cv=none; b=I68v6St6ewUhs6EJyy/gKL0kFdinmsSqSq9xAx5FwahwY1n3UMb0DtO/s7ltA3YzxSM3opH14dp1tr2RHLba1fk6yQhWyqJmlDFQznTAzTW5uqGOqa++YbOwSd9QH7eMPu0LST3OZ9GWoisB2cdJWbIe6Uav7+e5Czi15Z7k0zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023864; c=relaxed/simple;
	bh=Qm8gA6TotxAn8OZxpk4iVksPXEG9kO1pZHwW2hiVOTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3fMc7txlu5R/LJcmIiD4uL+0htkNCoqSUryHtzDJgpPc5j/wnQxaHXaz9kjrX/9ofB+P1BqIfoCAIUjAYlpVkNdBUkCpLLXXGzfpaWxf8YGdFlqiy3MNVMPijDe4Uf3MbSP/ILrDY78VXTFu1otynBQ1yPSGzh5tkibwp+s0LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pimWklqo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pimWklqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8DDBC4CEF0;
	Tue, 12 Aug 2025 18:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023864;
	bh=Qm8gA6TotxAn8OZxpk4iVksPXEG9kO1pZHwW2hiVOTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pimWklqoCLTTg03XMC1ApQw5JcZob5gjA42mJ/lhYKt6FEuCaRsT0N5pSYoj+4rnY
	 xMFQ4Y8pHXSKzKjDfiOba4rZviSzM+xeGK9AYilMK9VtEhdwOZ08YF1UicT1tzWEHz
	 oEyajttdZ3S/s/41acMv4ITkcX1wfW4MVwOziEnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"xin.guo" <guoxin0309@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 172/627] tcp: fix tcp_ofo_queue() to avoid including too much DUP SACK range
Date: Tue, 12 Aug 2025 19:27:47 +0200
Message-ID: <20250812173425.821871068@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 68bc79eb9019..76b01df70e56 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4985,8 +4985,9 @@ static void tcp_ofo_queue(struct sock *sk)
 
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



