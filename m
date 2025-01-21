Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1830F1F0E36;
	Tue, 21 Jan 2025 18:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482881; cv=none; b=sFswi6oczPAbxnZiiIKD3xRSj+oHmBi3kR4aji+hYTumm9P34iGWhWjnqBxWv5kRZnClQw2hq/bEooNf1EMkgv80K5ZGy0rjVnsbR0VZuxPu1/7rIBUXqPFjlYXT9fP/D2ETvqJCl+uDgk8tY8EMchFeEp/tbgCa4f+Py66AaAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482881; c=relaxed/simple;
	bh=VRMy5xyb5vLWbNNUnK3OVIhDcc0RQBktenDtRFd/V88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ag+KTlp7ArwtMq6VjAK0OVEZJNf6/4HPiJgBZgb0MXqWvumGXDTbo1qKPvVI4LOgiwnW0JolG/t1ed8G0UN9xnH3EKddbeT8DtntmlDZ8TAKG30qqh57PnOiGPyt+XjVqvyp3LHPVE22UwJBzLTNqk2Rzmj2ArksXZ75honcI8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ghs7SHsL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ghs7SHsL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94332C4CEDF;
	Tue, 21 Jan 2025 18:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482881;
	bh=VRMy5xyb5vLWbNNUnK3OVIhDcc0RQBktenDtRFd/V88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ghs7SHsL82VMOjFQ3pStyz7pjHh8ysbwS5QGf6UdMu4kgXYnDF9hquXRoOci619Yf
	 uJReskhiVn32xN//AmqaZaGZwNrWi8rKhDI+UFIDfip6iTjNmwiMlBQY6tFAFVIauv
	 EAvRa91xZTjsLOGe73zKNkhTnKa1hyrjxUNN3Qi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Pastor <antonio.pastor@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 010/127] net: 802: LLC+SNAP OID:PID lookup on start of skb data
Date: Tue, 21 Jan 2025 18:51:22 +0100
Message-ID: <20250121174530.072352519@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Antonio Pastor <antonio.pastor@gmail.com>

[ Upstream commit 1e9b0e1c550c42c13c111d1a31e822057232abc4 ]

802.2+LLC+SNAP frames received by napi_complete_done() with GRO and DSA
have skb->transport_header set two bytes short, or pointing 2 bytes
before network_header & skb->data. This was an issue as snap_rcv()
expected offset to point to SNAP header (OID:PID), causing packet to
be dropped.

A fix at llc_fixup_skb() (a024e377efed) resets transport_header for any
LLC consumers that may care about it, and stops SNAP packets from being
dropped, but doesn't fix the problem which is that LLC and SNAP should
not use transport_header offset.

Ths patch eliminates the use of transport_header offset for SNAP lookup
of OID:PID so that SNAP does not rely on the offset at all.
The offset is reset after pull for any SNAP packet consumers that may
(but shouldn't) use it.

Fixes: fda55eca5a33 ("net: introduce skb_transport_header_was_set()")
Signed-off-by: Antonio Pastor <antonio.pastor@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250103012303.746521-1-antonio.pastor@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/802/psnap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/802/psnap.c b/net/802/psnap.c
index 4492e8d7ad20..ed6e17c8cce9 100644
--- a/net/802/psnap.c
+++ b/net/802/psnap.c
@@ -55,11 +55,11 @@ static int snap_rcv(struct sk_buff *skb, struct net_device *dev,
 		goto drop;
 
 	rcu_read_lock();
-	proto = find_snap_client(skb_transport_header(skb));
+	proto = find_snap_client(skb->data);
 	if (proto) {
 		/* Pass the frame on. */
-		skb->transport_header += 5;
 		skb_pull_rcsum(skb, 5);
+		skb_reset_transport_header(skb);
 		rc = proto->rcvfunc(skb, dev, &snap_packet_type, orig_dev);
 	}
 	rcu_read_unlock();
-- 
2.39.5



