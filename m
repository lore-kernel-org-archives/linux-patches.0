Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285A01714A1;
	Thu, 15 Aug 2024 13:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730257; cv=none; b=K3ObpnteAzM3D7/wiVPiqTTmPRfRT20W0gpQ58mFWBTlG5/QH1wgxQTE6adGwuevc0ODjmVnr3TpGM2PIARg832iIRa+D0cfewIJ7FO34ouT7xTWHuWsTWEm5xl6QbabLL2+3sEud4/neg7ZfItepgDGj7TxdZ3OMTXscLb1Sno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730257; c=relaxed/simple;
	bh=Mqo8BSnkJt/8lUuEF8qRNzCYweuMf5ubHCJGtICLLbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxO53M5Eoz0BbL/sny4n7ix31hyccDmfTeNo1a4BG0awtqR7xUxakpauEX7gk4uLIhaKwBf5nENt0FBYjxerQaYgzsLQoEUPpAMP22KIg34Y9QSY17vz5PQis5tvL56JOZU0l2ex6V022yvKXYnTmMK6XEp3GoIGwp+7x2qusw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f5HgW0EX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f5HgW0EX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C41C4AF0C;
	Thu, 15 Aug 2024 13:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730257;
	bh=Mqo8BSnkJt/8lUuEF8qRNzCYweuMf5ubHCJGtICLLbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f5HgW0EXVfq9+m/H3in4u2xkGdlqAnfA0w3ezrd1phAsZ4uRM6enQcca3Ac5Xleoy
	 AJwZ1igIpk+dO/oJh627pcFlCXlLWFAgQsh/lqe2iqK6g7QM0dg72zo7rHvfYW5D46
	 rhQDMjEjehxvX812Cs5Ms+Ks7kZYc+vHsz2IS2xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 5.15 352/484] mptcp: fix duplicate data handling
Date: Thu, 15 Aug 2024 15:23:30 +0200
Message-ID: <20240815131955.023893960@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1099,14 +1099,22 @@ static void mptcp_subflow_discard_data(s
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


