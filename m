Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD120346FB0;
	Wed,  8 Apr 2026 18:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673802; cv=none; b=IVPDnDMbFQWipMyFDzB9kgNgWa9HlyAkIKpbN6QdqfAaqPtc1HE3CI959JRKeZC1H0sKQCsIBfmVAkuqG/tCGvRX1yWZcgn6zg2tJ1j2Ei28kK76ewk/5RS2CJQNN0wWcOIKC0sAc16JtOdTLivWnfiFtuMWtSqBLOf4y0obSbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673802; c=relaxed/simple;
	bh=SWx/qjd0v/XEDTojjEibeEbRK2VAISZz+fQtd33WQnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ju1FfMEIgSyabUZDm7fDoyMw4oorrmLuwJHCiGh79hytL+fyhMqaNJ7LK7Qb8fY+oRl6iQ9YgbpTNu/mkgsS5thJqMl4ZdssWW5VFbD/noaLXPrNsPeU7lpJxZudFiXDStG0yFEIh7lvZunQqDnlrI40cCBl1kYYhj2/oBhqrrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xrWPRPng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xrWPRPng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E24C19421;
	Wed,  8 Apr 2026 18:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673802;
	bh=SWx/qjd0v/XEDTojjEibeEbRK2VAISZz+fQtd33WQnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xrWPRPngGSrf69K1O+EyVHYXNfJLbIk3Fgu5jjBCxcz+O4f2Y0bbyYJLPCfpZKpfO
	 YE6xAuRW6I+KBm5jW16o4rM1lmCeWd1g0dVLIjUzXXwWS2EjoOvH3JS2JewX5K/7S6
	 AbfQsZGx3KrlNcEnHc9MbV1bmGYxythtVzIjDZGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Schiller <ms@dev.tdt.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 095/242] net/x25: Fix potential double free of skb
Date: Wed,  8 Apr 2026 20:02:15 +0200
Message-ID: <20260408175930.639332669@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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



