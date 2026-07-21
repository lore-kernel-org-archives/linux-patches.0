Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B47F3A4F4B;
	Tue, 21 Jul 2026 19:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663328; cv=none; b=QHTn36zeYHPMFMpNpJsR0K+MYzRJwHAk5HFTV5ZoFbRE+2MiAytMfuuRqtqMS7Mgm/Ej7yJG9t53s4kwkBBecWR/PhhUke6HwJo5sK6SSpTcOYNG5y7DQ9AUOS3Ln3ROd/IjJ4Zkumav1EvQJ1ajDbm/puSjujSO3ZjiPQ7v7+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663328; c=relaxed/simple;
	bh=eFwaLvrtpG4+tc8qSzR2nwN5KgQ454Vfg/eyzl2cbnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q9B3cwgCOLDfV+kUJLnJK8sZ+IDzu0qRFn+o1OLwuy9VjGmVuXidY2M6bkYWnpTzGLgH1Iq5Vr+DTxeX5z+t4w3/3VXgYgcXUk9gT6oGMvFRx6LLbxoy3r7RaX1j6sRPo5ayKgy8xGtCd/qnSH4KajzwGtWodBw69TMa8FhOXdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uuZcEj3M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uuZcEj3M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8771F000E9;
	Tue, 21 Jul 2026 19:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663326;
	bh=EN221SazqPa67IwtHkLxGNJfNzKNrKwX41em3zGBwoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uuZcEj3M8uhdh0rAy4GdkO2yhYdQ15L/oAI+qoElikEdBUGcxC1TOt9HWzZfryiu5
	 kNoo+f5gF+HWphifXubdo7bbt3lkl4MHfF8Gh1WC2GkkITyXQE/4FG5JZ220lMKcF2
	 1OdLQ9ruJOj6z+CECGMOgJJ6zZAheYkCFWlNGd7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0779/1276] net/tls: Consume empty data records in tls_sw_read_sock()
Date: Tue, 21 Jul 2026 17:20:22 +0200
Message-ID: <20260721152503.509944397@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d3eab47b47ea65..2b875369d52326 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2391,6 +2391,17 @@ int tls_sw_read_sock(struct sock *sk, read_descriptor_t *desc,
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



