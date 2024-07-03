Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0580017B4FF;
	Wed,  3 Jul 2024 10:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003335; cv=none; b=FNrT2btU3Bc66u5zF1TSNnlBRJ3E/s/+93gpFMMRd9++m8jO+N8iPj31kzQOcSTf8wS6nKUnNhke2vWG848hiC+07ZeWRPBTjSomHar5bl1/hE3AGdr4DH7kwYYy1ZscHb04ozbLg+mGweJDit+0bBSk0ZSwUwKH8a9S1B/y18c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003335; c=relaxed/simple;
	bh=BiGDNzPu7wEN6D7FmXMLaqA19GN9wF4g6BNnSaPyAV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+SuizgMp7Kr0UOtG0ZvG0LOimZTqa4odn5mBqixwihKMIwIvgM5L80DQVwXWr3Ecp2Fne8BylVKuyWDTYcjYVRgk9tqqYm8lZQJJ3tAcUiRLGFxFTmFi/VLMHL7SBupbqr/CZpb4ICacm3fOdD+X8RlBVANZ5JUgifJQeBbFXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tj3mHbpC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tj3mHbpC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73EAAC2BD10;
	Wed,  3 Jul 2024 10:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003334;
	bh=BiGDNzPu7wEN6D7FmXMLaqA19GN9wF4g6BNnSaPyAV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tj3mHbpCOLgwpf3FMmLVlHMjpdCuxRzM/cvt6sy3TTRnJR1k6jtDtNziiN3uMtGQk
	 nxbD9f5aEeRF6WuzHSYa/zBzhXocVPC4vcvg74ZhLUNodOBbYE5ZUePGXXdE8ovFAc
	 fflvK3tJZlgoc5ziymD8O6Fydzz5/g4OJ8660qqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 015/139] af_unix: Use skb_queue_len_lockless() in sk_diag_show_rqlen().
Date: Wed,  3 Jul 2024 12:38:32 +0200
Message-ID: <20240703102831.014587583@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 5d915e584d8408211d4567c22685aae8820bfc55 ]

We can dump the socket queue length via UNIX_DIAG by specifying
UDIAG_SHOW_RQLEN.

If sk->sk_state is TCP_LISTEN, we return the recv queue length,
but here we do not hold recvq lock.

Let's use skb_queue_len_lockless() in sk_diag_show_rqlen().

Fixes: c9da99e6475f ("unix_diag: Fixup RQLEN extension report")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/diag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/diag.c b/net/unix/diag.c
index f27b4e55da0e8..3ff6a623445eb 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -100,7 +100,7 @@ static int sk_diag_show_rqlen(struct sock *sk, struct sk_buff *nlskb)
 	struct unix_diag_rqlen rql;
 
 	if (READ_ONCE(sk->sk_state) == TCP_LISTEN) {
-		rql.udiag_rqueue = sk->sk_receive_queue.qlen;
+		rql.udiag_rqueue = skb_queue_len_lockless(&sk->sk_receive_queue);
 		rql.udiag_wqueue = sk->sk_max_ack_backlog;
 	} else {
 		rql.udiag_rqueue = (u32) unix_inq_len(sk);
-- 
2.43.0



