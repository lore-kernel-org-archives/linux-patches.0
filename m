Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5733E37DEA2;
	Thu, 20 Aug 2026 15:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238062; cv=none; b=f7hN6hcn12QJT16TnKE57FhzYwO8De6jIFt4pkM5TchmB+m0z7mk2axuFdy1PJt7RfJ3Pp+l1lwXj6LjyzD0qPHq3HzxZR/Q5tFx0bR37cKbufHi/tTl2vQfMVEQy16xOcT2rDA0Y/uf+p/ls8YSe2e0PhObpNXRZFAqjGNd6FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238062; c=relaxed/simple;
	bh=x9wYFsHCjx12msu7egLgHLSUl9UrvO+O4TNFY05UAKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dp9snR8FD4Zfu4VFr7MbI6gAjvSRMODwOzb8IkYwIMU6z3RLnf/zORQf/bJLwvNc+fGm7jhvcrKbzQoR/xCDQXOIarHyQKC0G3RvSahWQR8zQuhmhdF0/Z3mqZl1FPJx0rYGd1yCacVZ/vUYFU4j+5Zq7rq4ECks5/OK7h6gWcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R+Udtlav; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R+Udtlav"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D4D1F00A3E;
	Thu, 20 Aug 2026 15:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238061;
	bh=AoC3fIOfzn3uhxMb9SBlipNjQzH3TzpzocS1kcDit0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R+UdtlavEapI+SBwrvHBeMEGh95ic0rYE1P/VHHR6cLU+sEhdErJSC3gUjXMazha5
	 s4aCtVZAHJZPfrw0nucF9ukME9PQf4RqQW1YSN3FcrHaOcVAv8RIntB/xnWYDAAKTp
	 AJnHKjRj9CyUsszeFpjd95ZlmAB+EhMajMHUcn4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 007/228] mptcp: reclaim forward-allocated memory on RX path errors
Date: Thu, 20 Aug 2026 16:52:29 +0200
Message-ID: <20260820145244.689484401@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 41b49a8b914ec7dcb03eae93fb27f3c464078644 upstream.

After commit 9db5b3cec4ec ("mptcp: borrow forward memory from subflow"),
errors in the receive path prior to queueing skbs into the receive
queue do not trigger forward-allocated memory reclaiming.

Prevent forward memory from growing unboundedly in pathological drop
scenarios by explicitly reclaiming memory when skbs are dropped.

Fixes: 9db5b3cec4ec ("mptcp: borrow forward memory from subflow")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260803-net-mptcp-misc-fixes-7-2-rc6-v2-8-b8f496d71664@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -149,6 +149,12 @@ struct sock *__mptcp_nmpc_sk(struct mptc
 
 static void mptcp_drop(struct sock *sk, struct sk_buff *skb)
 {
+	/* The skb forward memory was already transferred to sk by
+	 * mptcp_borrow_fwdmem(), even before setting the destructor.
+	 */
+	if (!skb->destructor)
+		sk_mem_reclaim(sk);
+
 	sk_drops_skbadd(sk, skb);
 	__kfree_skb(skb);
 }


