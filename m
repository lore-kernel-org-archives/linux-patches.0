Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E3133CD2;
	Wed,  7 Aug 2024 15:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043761; cv=none; b=HwC/aBhO6+NPzM0XsLbckWfZ0jzAqQ34ViEm0XU76uCYJRnDt/JDiXmTwM/FLyUT4PiVOSpJcgRSLQtw+ggnOAGPNT/bapDAJOYv2zY24fMRYvmvWaVWpv0+XkNhTxtOl1vTtBdQc4BrMHEDthcQE4PBFCq5tufa2F68+kL6+2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043761; c=relaxed/simple;
	bh=gQeBjhaANXWgUaolDFeOyaBKBEVor1W/eFjP2Nsn3oM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXfGOw/h1K7BdAAVPdgrSvTJMu14r25s1Kw/SmOfuQ4zvA/mXyWPIVC8iyNnJNbRNQxn7CZ4dX6zqrY7R9kPs/reqk5OpZ0M6cVxXvICrDIrzmgRIgOw+wVVoTRotZUteJVed4UsCjka5mhEc9D0d2uZf8qYqj0OQDs3nL2z/S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qWOmBk5Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qWOmBk5Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74F3C32781;
	Wed,  7 Aug 2024 15:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043761;
	bh=gQeBjhaANXWgUaolDFeOyaBKBEVor1W/eFjP2Nsn3oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qWOmBk5ZmzwBiG1C8mX8OZaw2W91w12b918NVgpx6NUUhTDSqpN0nbZmJajQlaRlC
	 DZpta/lkBz585bBvRQE/yiKgA74aOXECFBIxsnn0tWLGOwfZJWYB3Wb/8/8fhav1ic
	 jMTajEI9d0yFcUba5KOGYDqALn8HIVurnFMXxV4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 6.1 83/86] mptcp: fix bad RCVPRUNED mib accounting
Date: Wed,  7 Aug 2024 17:01:02 +0200
Message-ID: <20240807150042.032904861@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 0a567c2a10033bf04ed618368d179bce6977984b upstream.

Since its introduction, the mentioned MIB accounted for the wrong
event: wake-up being skipped as not-needed on some edge condition
instead of incoming skb being dropped after landing in the (subflow)
receive queue.

Move the increment in the correct location.

Fixes: ce599c516386 ("mptcp: properly account bulk freed memory")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -363,8 +363,10 @@ static bool __mptcp_move_skb(struct mptc
 	skb_orphan(skb);
 
 	/* try to fetch required memory from subflow */
-	if (!mptcp_rmem_schedule(sk, ssk, skb->truesize))
+	if (!mptcp_rmem_schedule(sk, ssk, skb->truesize)) {
+		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_RCVPRUNED);
 		goto drop;
+	}
 
 	has_rxtstamp = TCP_SKB_CB(skb)->has_rxtstamp;
 
@@ -851,10 +853,8 @@ void mptcp_data_ready(struct sock *sk, s
 		sk_rbuf = ssk_rbuf;
 
 	/* over limit? can't append more skbs to msk, Also, no need to wake-up*/
-	if (__mptcp_rmem(sk) > sk_rbuf) {
-		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_RCVPRUNED);
+	if (__mptcp_rmem(sk) > sk_rbuf)
 		return;
-	}
 
 	/* Wake-up the reader only for in-sequence data */
 	mptcp_data_lock(sk);


