Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439F33D75AF;
	Wed,  8 Apr 2026 18:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672574; cv=none; b=e90NdrTigws4kSYiJIrzlA29Bmtbr2/HMOp6QHDR9i+p15Qr1kjq4ZOceOADmTr1Iz/XYf0t+XNMmKviPSt/LipBGZpEAa5Y+9KjpxW8zvsrGqvem0tDkS0PqaCQDJB7HJn9wJIlYrI7xViwQP/gyF3RWMNd1U7yMQFXOH7FscM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672574; c=relaxed/simple;
	bh=zV9A8xus7s9tP8qi4Wt29xQIa3sdLe0Zur4jzFrI6Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hu27AqMrcnUoqLiRFH+MphOri17zT6IdoVnBLOQ/TvgUq5Gn7SymCH0fL7Tqx/+9PAfn2k7LVp1VQrddFs+hb02ii5wwbtJKWNNCcrEQxB08EPCfo9LzVXnEG00CrcTSreoZ2ant50bsnMMZVQjEC8lf8zQESw6abVaO9N6ed+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Uq1GJhi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Uq1GJhi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD367C19421;
	Wed,  8 Apr 2026 18:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672574;
	bh=zV9A8xus7s9tP8qi4Wt29xQIa3sdLe0Zur4jzFrI6Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Uq1GJhiJyKsQXtqRq1/kFxSLYF2/fgFlH5Gvo8tprU1gWv0Jp/0rtXmucp7rLBPM
	 s5WJGV+AvO/EhTeRX89nMo6/5sCb0WFXWWFuacOl8j83GYEfdc3HiXTIO9vPfhqsfC
	 Zr1Xs79nm/lePN7PaTiwx4xIBQCd0b0t2fTDfCBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Schiller <ms@dev.tdt.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/160] net/x25: Fix potential double free of skb
Date: Wed,  8 Apr 2026 20:02:25 +0200
Message-ID: <20260408175915.373994121@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

From: Martin Schiller <ms@dev.tdt.de>

[ Upstream commit d10a26aa4d072320530e6968ef945c8c575edf61 ]

When alloc_skb fails in x25_queue_rx_frame it calls kfree_skb(skb) at
line 48 and returns 1 (error).
This error propagates back through the call chain:

x25_queue_rx_frame returns 1
    |
    v
x25_state3_machine receives the return value 1 and takes the else
branch at line 278, setting queued=0 and returning 0
    |
    v
x25_process_rx_frame returns queued=0
    |
    v
x25_backlog_rcv at line 452 sees queued=0 and calls kfree_skb(skb)
again

This would free the same skb twice. Looking at x25_backlog_rcv:

net/x25/x25_in.c:x25_backlog_rcv() {
    ...
    queued = x25_process_rx_frame(sk, skb);
    ...
    if (!queued)
        kfree_skb(skb);
}

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Martin Schiller <ms@dev.tdt.de>
Link: https://patch.msgid.link/20260331-x25_fraglen-v4-1-3e69f18464b4@dev.tdt.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/x25/x25_in.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/x25/x25_in.c b/net/x25/x25_in.c
index b981a4828d08c..0dbc73efab1cb 100644
--- a/net/x25/x25_in.c
+++ b/net/x25/x25_in.c
@@ -44,10 +44,9 @@ static int x25_queue_rx_frame(struct sock *sk, struct sk_buff *skb, int more)
 	if (x25->fraglen > 0) {	/* End of fragment */
 		int len = x25->fraglen + skb->len;
 
-		if ((skbn = alloc_skb(len, GFP_ATOMIC)) == NULL){
-			kfree_skb(skb);
+		skbn = alloc_skb(len, GFP_ATOMIC);
+		if (!skbn)
 			return 1;
-		}
 
 		skb_queue_tail(&x25->fragment_queue, skb);
 
-- 
2.53.0



