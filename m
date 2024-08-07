Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C201227448;
	Wed,  7 Aug 2024 15:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043175; cv=none; b=eoBEbeyBzQQDtCecawltSFM3NUanVugIZRuAUn5lF5kW8iHqVeidHRa4jss5K1JkJ/ugKAaUOa0YC3FE+Ess5xsd/wpWKqGBDO86ocyX6BlO3kM/8Vnf8mbh7gdI4p1Oxxk/+eIaAiUkIYu/xzpj+8x2PRvLHq8RSsWprzgq068=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043175; c=relaxed/simple;
	bh=aDbrvKhPUxjQmiNHaEOhIE4rfoVz1hHKSPUZ3zXWvhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFA6wCWNhYcTFlFbCbZO6ltid2Ghr3FGIeVKP6FLt10ZcFQgxBiHIF25rWFQJXXHRaoiY2bHe54lgyhHqGFjqDNjK9jVRoA6gpnRd27UsxXb1aRyEKQC8bwms4EeK71MeFx7Co5w6y2SoNjvR2PBlna8+zcBiEVc6cnOBfiObCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1YPGeUl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1YPGeUl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FEDC32781;
	Wed,  7 Aug 2024 15:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043175;
	bh=aDbrvKhPUxjQmiNHaEOhIE4rfoVz1hHKSPUZ3zXWvhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u1YPGeUlVjkOhgF2l6dq/KY9dPF+AaNjDc1Y8I36GK43BnqFMz1WCSK6RGyxcCtB7
	 tF1SmOEeYTWlfE2wka5zXi8C63TXgbh3AWyf132NfzBaV4/H9OnqLfUbP1+pxmuRrE
	 G+7K3WdH5GsFDghfzmofmB5LMDs3cYSLe8fQNlcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 6.10 119/123] mptcp: fix duplicate data handling
Date: Wed,  7 Aug 2024 17:00:38 +0200
Message-ID: <20240807150024.775354485@linuxfoundation.org>
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
@@ -1230,14 +1230,22 @@ static void mptcp_subflow_discard_data(s
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


