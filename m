Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD59239A7FD;
	Tue, 21 Jul 2026 18:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658225; cv=none; b=u3b8rnUC3G3aI1XK0FZbGGx3Tva3dmglM3jBUE3GWg+51LcwuJ2kGSKE+aL/ZSFSLQvwGcBv1jL5LOD4O9inT8lpDXbNlnsSDWBEEX0o4yrIIzZoGvYuDM5AdvywcSGrUdKLSqDyWCNQEaEpLZwQpNmiJrJULRnYyRTM3FnXkOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658225; c=relaxed/simple;
	bh=z020Az4srxi3tCRcKpYKFFB6u5RYfkeJFlpMOprrjPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2o89+cloa1XKhRGmwhszks8cnsqBbzgvGi8c58WZ60v+SLgf1C2xgsu1dcobnn/FVsCUNFsDKKJnVCJ0CCUMBUQ2B81H73GDffdCqPR7MsZTxau7Iy8w12iLZrm9mv9hxWeWXvIZOLWlqZwV5bawIxoYyGS6W9nIReTz+fH8pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wAU83HB3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wAU83HB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F97C1F000E9;
	Tue, 21 Jul 2026 18:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658224;
	bh=rt299YHmUxDWPjhzxm0iXEY+BPy8zK5EI8MIJ4cAb5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wAU83HB3XDPusP7hIgNWz6PFT5Otu4YGHqy4hg9GiCNLOIU/Z3vBNV3oSwWYzQMC4
	 z7m7pYWRs5XlAz1b4GqT0ngaoXd+VXN+UvXqxc20f0aL9ODrys+41aqvSRi2emZod+
	 Bx5SklqDnA+qyo/g+kkAZL5SUDtn1v25Q1WnWRPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1061/1611] net/tls: Consume empty data records in tls_sw_read_sock()
Date: Tue, 21 Jul 2026 17:19:37 +0200
Message-ID: <20260721152539.271577514@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

[ Upstream commit 3be28e2c9cd0230cb51fd4967df095273afd3848 ]

A peer may send a zero-length TLS application_data record; TLS 1.3
explicitly permits these as a traffic-analysis countermeasure (RFC
8446, Section 5.1). After decryption such a record has full_len ==
0. tls_sw_read_sock() hands it to the read_actor, which has no
payload to consume and returns zero. The loop treats a zero return
as backpressure (used <= 0), requeues the skb at the head of
rx_list, and stops. rx_list is serviced head-first on the next
call, so the empty record is dequeued, fails the same way, and is
requeued again; every later record on the connection is blocked
behind it.

tls_sw_recvmsg() does not stall on this: a zero-length data record
copies nothing and falls through to consume_skb(). Mirror that in
the read_sock() path by recognizing an empty data record before
the actor runs, consuming it, and continuing.

Fixes: 662fbcec32f4 ("net/tls: implement ->read_sock()")
Signed-off-by: Chuck Lever <cel@kernel.org>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/20260630191551.875664-1-cel@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index c80ae566ad4e6f..f19b504efa5d08 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2424,6 +2424,17 @@ int tls_sw_read_sock(struct sock *sk, read_descriptor_t *desc,
 			goto read_sock_requeue;
 		}
 
+		/* An empty data record (legal in TLS 1.3) gives a zero
+		 * read_actor return, indistinguishable from the consumer
+		 * stalling; the used <= 0 path would requeue it at the
+		 * head of rx_list and block all later records. Consume it
+		 * here instead.
+		 */
+		if (rxm->full_len == 0) {
+			consume_skb(skb);
+			continue;
+		}
+
 		used = read_actor(desc, skb, rxm->offset, rxm->full_len);
 		if (used <= 0) {
 			if (!copied)
-- 
2.53.0



