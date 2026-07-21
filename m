Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AFA3B2FE4;
	Tue, 21 Jul 2026 20:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666934; cv=none; b=FdO35BL0Z08yE3rWtwQRqdropt+WtQ63RAHP+CoFzexSWLEEND2l9Ja5Q82PnNWoQQJherdhzG6lpZQatOFIl0mqnrjt3ac6ddH1Ku3RKvCOQYqoXRtDabzj61Dql6nMAClULylYDgjZgXO9Er8pGuXYBiyNhtWGHzwumgZTTo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666934; c=relaxed/simple;
	bh=QzK8AyBZWHcvv6rvBc5YSrgSDXOgYceZYRT9aYwuq08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dT6SUbBS7FXx4KaRH5eJmCZx7Mbp91TIw3WcEv8IB45yLQv86uJj9DDNSBvJYyZ7fRPb1s2ND5/HLmULVhuZs7TsLLJn2RLEP9BVeBNgUNtcy5Ma4e/l6TRJBhPmrK9BETAcvvhhxdUgOCf+kesRav2t5GH69WtLQyoTGeP3mAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lBoHeoy8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lBoHeoy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804391F00A3A;
	Tue, 21 Jul 2026 20:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666930;
	bh=qyXfA3ITBhQE9DWlcBo2Ge13v9TrEU8vbqgmUFf6peI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lBoHeoy80midURC+t7pfgNBRVCfPIZ/vq7DfJ8s//ZJM13ByGp2ZgKXdkuBaesK6L
	 D5+IFLBtEaAxVvwFRTXJgoM9hubAGocd0bKGru/Pj+Nhmg/yBZDC2J9QWWnrrQg9rr
	 DS9dT4sdzL/Zj662oFeeioM6ajTC+zj/ZqxTV5QY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0867/1266] net/tls: Consume empty data records in tls_sw_read_sock()
Date: Tue, 21 Jul 2026 17:21:44 +0200
Message-ID: <20260721152501.248851946@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 89f01227ca5bf3..39021fab3c5965 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2392,6 +2392,17 @@ int tls_sw_read_sock(struct sock *sk, read_descriptor_t *desc,
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



