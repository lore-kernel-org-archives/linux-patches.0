Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83905356919;
	Tue, 26 Aug 2025 14:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217687; cv=none; b=UvTCLaDrfqzwKc+0yuoGWaEQRl/GAeNX0tFZxErlvGngQv8wGMffjmxl7xpZD1rrJEcZs2YNfkBt5l8PXBdm6fJzbBWCuL7OizVi4+fyeqVz+RVDl6GofN6v36rvtZpDX7CBQqKEF+ZWomOlp3zNj7KEqmgWAHgqmbOm7aa4r2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217687; c=relaxed/simple;
	bh=rWcKNwWAm1zfG6nNCOCEQTKD2QYyXt3wzcrgc0pwlNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LL7TKchfpYIM25BXgJGpDTX43t0LNBUZF/i3ZsIlsUw03c7NyQeSdxEaDnO1ssZbtjpPpDfpR6KM1cBUz+FHclr7ppGw/8rs86Tzjm58o6AUEi2jYbH6TT0RjPPeqI1gZ2yY32Sga8rYiJa6k6o2ykZTQrbxfhymyzgJzABM4aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vT9kbE5q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vT9kbE5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1530AC113CF;
	Tue, 26 Aug 2025 14:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217687;
	bh=rWcKNwWAm1zfG6nNCOCEQTKD2QYyXt3wzcrgc0pwlNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vT9kbE5qY6aTjLYEDCeo4Psl12uxCPSX2ukzcUTe8o7NhMw/p06jiiJ0iee9fYsNT
	 xYymSXAAGT4LV94DZoZuorYmWz01fDPt0CYsQzm/GOmGsB4eUcq4Hb2HyO1tOin4Wq
	 Ev7Tw337PXLrU7zyw0J/EUEJLfeTZJq7N8JC/lrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+773e51afe420baaf0e2b@syzkaller.appspotmail.com,
	syzbot+70a42f45e76bede082be@syzkaller.appspotmail.com,
	Xin Long <lucien.xin@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 207/523] sctp: linearize cloned gso packets in sctp_rcv
Date: Tue, 26 Aug 2025 13:06:57 +0200
Message-ID: <20250826110929.551523276@linuxfoundation.org>
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

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit fd60d8a086191fe33c2d719732d2482052fa6805 ]

A cloned head skb still shares these frag skbs in fraglist with the
original head skb. It's not safe to access these frag skbs.

syzbot reported two use-of-uninitialized-memory bugs caused by this:

  BUG: KMSAN: uninit-value in sctp_inq_pop+0x15b7/0x1920 net/sctp/inqueue.c:211
   sctp_inq_pop+0x15b7/0x1920 net/sctp/inqueue.c:211
   sctp_assoc_bh_rcv+0x1a7/0xc50 net/sctp/associola.c:998
   sctp_inq_push+0x2ef/0x380 net/sctp/inqueue.c:88
   sctp_backlog_rcv+0x397/0xdb0 net/sctp/input.c:331
   sk_backlog_rcv+0x13b/0x420 include/net/sock.h:1122
   __release_sock+0x1da/0x330 net/core/sock.c:3106
   release_sock+0x6b/0x250 net/core/sock.c:3660
   sctp_wait_for_connect+0x487/0x820 net/sctp/socket.c:9360
   sctp_sendmsg_to_asoc+0x1ec1/0x1f00 net/sctp/socket.c:1885
   sctp_sendmsg+0x32b9/0x4a80 net/sctp/socket.c:2031
   inet_sendmsg+0x25a/0x280 net/ipv4/af_inet.c:851
   sock_sendmsg_nosec net/socket.c:718 [inline]

and

  BUG: KMSAN: uninit-value in sctp_assoc_bh_rcv+0x34e/0xbc0 net/sctp/associola.c:987
   sctp_assoc_bh_rcv+0x34e/0xbc0 net/sctp/associola.c:987
   sctp_inq_push+0x2a3/0x350 net/sctp/inqueue.c:88
   sctp_backlog_rcv+0x3c7/0xda0 net/sctp/input.c:331
   sk_backlog_rcv+0x142/0x420 include/net/sock.h:1148
   __release_sock+0x1d3/0x330 net/core/sock.c:3213
   release_sock+0x6b/0x270 net/core/sock.c:3767
   sctp_wait_for_connect+0x458/0x820 net/sctp/socket.c:9367
   sctp_sendmsg_to_asoc+0x223a/0x2260 net/sctp/socket.c:1886
   sctp_sendmsg+0x3910/0x49f0 net/sctp/socket.c:2032
   inet_sendmsg+0x269/0x2a0 net/ipv4/af_inet.c:851
   sock_sendmsg_nosec net/socket.c:712 [inline]

This patch fixes it by linearizing cloned gso packets in sctp_rcv().

Fixes: 90017accff61 ("sctp: Add GSO support")
Reported-by: syzbot+773e51afe420baaf0e2b@syzkaller.appspotmail.com
Reported-by: syzbot+70a42f45e76bede082be@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Link: https://patch.msgid.link/dd7dc337b99876d4132d0961f776913719f7d225.1754595611.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index 8fe1a74f0618..079b1bfc7d31 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -114,7 +114,7 @@ int sctp_rcv(struct sk_buff *skb)
 	 * it's better to just linearize it otherwise crc computing
 	 * takes longer.
 	 */
-	if ((!is_gso && skb_linearize(skb)) ||
+	if (((!is_gso || skb_cloned(skb)) && skb_linearize(skb)) ||
 	    !pskb_may_pull(skb, sizeof(struct sctphdr)))
 		goto discard_it;
 
-- 
2.50.1



