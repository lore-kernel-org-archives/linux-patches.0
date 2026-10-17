Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAF13AE713;
	Sat, 17 Oct 2026 16:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256384; cv=none; b=U9RZbRqH6tN5r2dB0OQEvQVgWbFjkb7DlElkxZGkQGIRr8Lnu+VP7qJs/a8GFF7yQ1F7i7DARHnIrEEnPEoXIcG14ps8302mZrbJE5ZwROxK8Vc2177KItKSaYzUL/5cDHFjawCmdM9J9DpmcvV9GzXqroyWOHlCzFgO5w4IVYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256384; c=relaxed/simple;
	bh=f2Ln24WHh2wosL6DebQYVRrJJtncap5gvnnrWM5tZ8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IhUX/2+AdLtnS4fgeN4UpR90NBCrmbfMZ3huvtIdXf/rJUq1HAVWHPkqaJv3ibCc/LgrTvECc9Eo7sIZ9HEnnoFSn/t7FL+o4vcH6ihVRS3wTugcZsFfBfDgGuDOEl4+AkTkRCBPl5kbHDFT78eji2ztL7ueyasWftII3X5cf5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bKOVO9B/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bKOVO9B/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D60F1F000C4;
	Sat, 17 Oct 2026 16:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256382;
	bh=Fyb1q601EeFrPGXYuA0HJ460wOL3EPJrJvNTuaXcz4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bKOVO9B/uG2DFMe+l4lvCr7Gv9Z69Dufg2notR0omyQg4Q6qm23ps7BwfhIcwZ1L/
	 V2TpAaTS0uGzNwgq/8pDVqvZcZob0sHk9cQrxVF+J7Tpp3Z204Rh43hRqxl4SzAhwL
	 KpwFPf9TRwH/DvAp2d6JZLb6STpBXrPJWATmG0TY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Jo <jeffjo@openai.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0219/1674] tcp: refresh TS.Recent for accepted old ACKs
Date: Sat, 17 Oct 2026 17:41:31 +0200
Message-ID: <20261017160436.767778274@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Jeff Jo <jeffjo@openai.com>

[ Upstream commit 1b92780ae4fc3be64f05d97ed8833c445e73b0cf ]

A TCP packet can carry new data while acknowledging traffic in the
opposite direction. With overlapping traffic in both directions, a
delayed packet's acknowledgment can be older than one Linux has already
accepted, even when that packet fills a gap in the received data.

Linux accepts the data, but tcp_ack() takes the old_ack path and skips
updating TS.Recent, the timestamp saved for outgoing acknowledgments.
The reply therefore echoes an older timestamp. If the sender uses this
echo to measure round-trip time after a long idle period, its estimate
includes the idle time and can reduce its sending rate.

Update TS.Recent in old_ack using tcp_replace_ts_recent(), before SACK
processing can trigger a transmission. This reuses the existing timestamp
and sequence checks, including PAWS protection against old duplicate
packets. ACK validation already rejects old ACKs in SYN_RECV before this
path, so no additional state check is needed.

Echoing the timestamp of the packet that fills the receive gap follows
RFC 7323 section 4.3. In a socket reproduction with 300 seconds idle,
controlled reordering and retransmission to exercise timestamp-based RTT
sampling, the sender's smoothed round-trip time was 37.5 seconds without
the fix and 15.5 ms with it.

Fixes: 12fb3dd9dc3c ("tcp: call tcp_replace_ts_recent() from tcp_ack()")
Assisted-by: LLM sparse
Signed-off-by: Jeff Jo <jeffjo@openai.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 89ef6ed7f7504..e18c0e8b41c35 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4087,6 +4087,12 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 	return 1;
 
 old_ack:
+	/* An old ACK can carry new data. Update TS.Recent before SACK
+	 * processing can trigger a retransmission.
+	 */
+	if (flag & FLAG_UPDATE_TS_RECENT)
+		tcp_replace_ts_recent(tp, TCP_SKB_CB(skb)->seq);
+
 	/* If data was SACKed, tag it and see if we should send more data.
 	 * If data was DSACKed, see if we can undo a cwnd reduction.
 	 */
-- 
2.53.0



