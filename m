Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3BD27448;
	Wed,  7 Aug 2024 15:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043167; cv=none; b=NuUm8QQtLd+JzV/zyXq/cLfRlLWpqCRCVbT1YeYaUrwY2qOfkOhrNlJVdQwxcMLAikb83deseKg98G9VHbK7V6rp7pwOX6hkazVCsXcDhTIjinUjaYidSd6obY4eeRZW7QY7TDnrP5pyHZGRMgMAwUxFggM2TIn/Kog9h6S8e40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043167; c=relaxed/simple;
	bh=uF6yMg1s17fMjKnVzaQ+GKLOnOUA8B/qElaxIbkfZeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BtL4Y0l9b70RB1Y831NhInZlnYM40yHqHe4ruHEZth6GuLfblWWxT/Hcrt31LnSGwGa3v02pCqjDOw+KFd9j9TGoSo1zdaa2uK1MJlo9RbcoAiyi9Dxj+MeGseLD9tBe35Obbkzo+B32nrwBU8Z0c083QQqJaCNspxpnl7HcPoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YJkIkReS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJkIkReS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B843C32781;
	Wed,  7 Aug 2024 15:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043167;
	bh=uF6yMg1s17fMjKnVzaQ+GKLOnOUA8B/qElaxIbkfZeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJkIkReS5wswsS7kYqt7j5W+SLk9s5VU2TdIKjDczzSIBHs+DT4aGUj4e/anD5eFU
	 dxOUdWvUuaiC0rzbs6MPNbOjtcv8aCMhGxZJSvxd8dQOmkJF4DMglf+umqmPZnfqPS
	 H1wfOB4+/VrS7FuXDu6SZ4OLa1kL4XPHIU4MmHpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 6.10 116/123] mptcp: fix bad RCVPRUNED mib accounting
Date: Wed,  7 Aug 2024 17:00:35 +0200
Message-ID: <20240807150024.667333273@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -350,8 +350,10 @@ static bool __mptcp_move_skb(struct mptc
 	skb_orphan(skb);
 
 	/* try to fetch required memory from subflow */
-	if (!mptcp_rmem_schedule(sk, ssk, skb->truesize))
+	if (!mptcp_rmem_schedule(sk, ssk, skb->truesize)) {
+		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_RCVPRUNED);
 		goto drop;
+	}
 
 	has_rxtstamp = TCP_SKB_CB(skb)->has_rxtstamp;
 
@@ -844,10 +846,8 @@ void mptcp_data_ready(struct sock *sk, s
 		sk_rbuf = ssk_rbuf;
 
 	/* over limit? can't append more skbs to msk, Also, no need to wake-up*/
-	if (__mptcp_rmem(sk) > sk_rbuf) {
-		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_RCVPRUNED);
+	if (__mptcp_rmem(sk) > sk_rbuf)
 		return;
-	}
 
 	/* Wake-up the reader only for in-sequence data */
 	mptcp_data_lock(sk);


