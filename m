Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AA233CD2;
	Wed,  7 Aug 2024 15:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043766; cv=none; b=f6xOgx+Xwdx9PDCtVl70cXgqx6iieNgH/XHd1lWb6dt0ixVTLSOBSj0xYr+sKyrHb6TX/CyJUu8yLqBkBYCZwmdM1HwtuqN7hogEVwtB+hhY1jGTvEHOcPn4Jff5yGP8U0V24m4/p7yk9/7BD+Gd8aVuTbW2a4snBAM8C59cfVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043766; c=relaxed/simple;
	bh=QnCU6DY0+URWC7EioR+LMdbe3rNfdIcBoTjHxImvI4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CrxyyEvqB8pZpEjxq2OpV/hBsCGfzlHBVHM29PVzwBkUbutxCfUafFYUyhWwJ7UOFpiTM/eoIjWIklBsOQvy7DgXhGCQ4Stksn3UpvgM6tYLBKQG6UmNqu2uP1g81Wny/sRJvoznHZE5ktsyAVGU81vZXp1bEGXS80ZzaZD5oN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rdqqOVtf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rdqqOVtf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32851C32781;
	Wed,  7 Aug 2024 15:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043766;
	bh=QnCU6DY0+URWC7EioR+LMdbe3rNfdIcBoTjHxImvI4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rdqqOVtfzO0M/Rn15pFVUu7LQ7Vsyb1EWEssdGFqYRxVbvz/1jLuzrbY4C3gqGZ+y
	 AJRf6tMsvQyNc1TleHqV5DRMDWYkL8+KkCTEVRGjm+SbAym/RQGeKJv4D+Mn6nil+3
	 5eqxXFHgLpmZLDJsQpNXxnkRCGqE3hzvTT4veyVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 6.1 85/86] mptcp: fix duplicate data handling
Date: Wed,  7 Aug 2024 17:01:04 +0200
Message-ID: <20240807150042.094476641@linuxfoundation.org>
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

commit 68cc924729ffcfe90d0383177192030a9aeb2ee4 upstream.

When a subflow receives and discards duplicate data, the mptcp
stack assumes that the consumed offset inside the current skb is
zero.

With multiple subflows receiving data simultaneously such assertion
does not held true. As a result the subflow-level copied_seq will
be incorrectly increased and later on the same subflow will observe
a bad mapping, leading to subflow reset.

Address the issue taking into account the skb consumed offset in
mptcp_subflow_discard_data().

Fixes: 04e4cd4f7ca4 ("mptcp: cleanup mptcp_subflow_discard_data()")
Cc: stable@vger.kernel.org
Link: https://github.com/multipath-tcp/mptcp_net-next/issues/501
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1103,14 +1103,22 @@ static void mptcp_subflow_discard_data(s
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
 	bool fin = TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN;
-	u32 incr;
+	struct tcp_sock *tp = tcp_sk(ssk);
+	u32 offset, incr, avail_len;
 
-	incr = limit >= skb->len ? skb->len + fin : limit;
+	offset = tp->copied_seq - TCP_SKB_CB(skb)->seq;
+	if (WARN_ON_ONCE(offset > skb->len))
+		goto out;
 
-	pr_debug("discarding=%d len=%d seq=%d", incr, skb->len,
-		 subflow->map_subflow_seq);
+	avail_len = skb->len - offset;
+	incr = limit >= avail_len ? avail_len + fin : limit;
+
+	pr_debug("discarding=%d len=%d offset=%d seq=%d", incr, skb->len,
+		 offset, subflow->map_subflow_seq);
 	MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_DUPDATA);
 	tcp_sk(ssk)->copied_seq += incr;
+
+out:
 	if (!before(tcp_sk(ssk)->copied_seq, TCP_SKB_CB(skb)->end_seq))
 		sk_eat_skb(ssk, skb);
 	if (mptcp_subflow_get_map_offset(subflow) >= subflow->map_data_len)


