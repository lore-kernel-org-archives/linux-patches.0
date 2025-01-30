Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735F51E7C27;
	Thu, 30 Jan 2025 14:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246630; cv=none; b=oQdfG5mkvBzvOBbcMZK09YuqhL67RBGAKEZWJIPu0Q2weiU8lOxhUP0HEA6PUhQdOSxEqHSUY7urTqwl9rt3ypS9ugsej5A+txB3mE6c1Ju8f9Ub4oFSteN0YWu2RwJE5ZfYJk3lkzyUuQ7mMHLc/H64bNVJVlOxlLKJ4Qlj6qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246630; c=relaxed/simple;
	bh=n6x1dmNfDTzIopLpXUlF1B869fgQIzrZ2PtTpFtZfPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqBnNqexAvg5aZ979hfgpfgkGFHEjBs5MdTE+AJgE6kgGqf33DzagagYceY+V6CNh4b+ecGNAa4IYmBy5fc2XQAEaEZLXfKLNUIq+EdUuVk9qMnyOM0qD4yalDeL8CM/FiloPbfE7ohKtsZs47fATsXoxZ8pnQu/hR2PgxTPW1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2RIHu9Hh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2RIHu9Hh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09B8C4CED2;
	Thu, 30 Jan 2025 14:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246630;
	bh=n6x1dmNfDTzIopLpXUlF1B869fgQIzrZ2PtTpFtZfPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2RIHu9HhzV4if/36ECU736YEgEcjN4PxlIk2khfHTcoyZAldm3c542bokq+5KDnkc
	 jqmiQ1OJh6mh0NmzqjHYAWCBcneCotuWL33n0WfMV2dl+50yn7A27mJBgzpc3sYMak
	 0VIRyDZ6m+plvn+cjgiIPTKdKqhl1VF/6WPtBNKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Pastor <antonio.pastor@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 06/91] net: 802: LLC+SNAP OID:PID lookup on start of skb data
Date: Thu, 30 Jan 2025 15:00:25 +0100
Message-ID: <20250130140133.926482003@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 40ab2aea7b31..7431ec077273 100644
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



