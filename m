Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58C337B40C;
	Tue, 21 Jul 2026 17:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653826; cv=none; b=B6bC+k+70klnldgQ+1W6dW7w4oBgrI0xqetAo5VoqYlIeIGqUM9PymMogqjbFBVill571QMPxPuigwBeg1dTs255mhGJ56I4r+Yt4G62+msd9FlmmnhU/ZSA+7UaEmSBR5V78jiVo8TlDRxy7W6HXP+YZAKjkPvo4D9jZhHw5ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653826; c=relaxed/simple;
	bh=E3RXpvK49nFf4cXxCci4ds8VRorv5xfXGIcqXBBVHxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GuULHdYsHaj8PnRXxd3WScfSfBWiih1HLfMn+eBsT5xRAUFf9wPMEZo2z6gZuiuD01Ccnk2G0tYKZxYjptCq+FGWYGPPsP7hbgWPTyFsvhHnPdwObd41cT34xh93yb3LzPrZh7f1nhWqhEzjRouMUk86ZH4UVWjFfgH7c89ly2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ftsDuxP/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ftsDuxP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B6D1F00A3A;
	Tue, 21 Jul 2026 17:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653824;
	bh=j1aKEKVw0qHl3AMv9jR7GGojJjVbl0QQdK0dOedujcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ftsDuxP/ZrtVISTnUI1NAeL2qJPEgkWAsyO0CL9d4c3iwFbXTTsTsq40g/Qu8pggx
	 Yog3dln/W2OShvAihXlMXxNS/m3tCWyPSLz6BUAXm5rEeiVgzm90r5qp4qumk/tPB3
	 dbMywghqLFPypTODorttJCvexvdHYJoZbFW7xF1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1471/2077] net/tls: Consume empty data records in tls_sw_read_sock()
Date: Tue, 21 Jul 2026 17:19:04 +0200
Message-ID: <20260721152627.488287338@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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
index a47f6a1e2c77d5..ba95f9d927a35b 100644
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



