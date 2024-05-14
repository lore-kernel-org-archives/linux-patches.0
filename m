Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AF912BF08;
	Tue, 14 May 2024 11:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687265; cv=none; b=gV51Hv48VcJMfi+V2FBEBuLVrobZtaP6vPFTAnWy5FgIXwO3evtCScGmXm2tqyUVuZdobg7gveW++At7fLZIOPdCI0sVWvecmRepMM/UMdQTrDcdDwSiX17IcZj94qPbHmYRSQ2SfHT3CiVHJZXa6LyhrDxhyxBHIc4B8zK4VyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687265; c=relaxed/simple;
	bh=w6EYMLUFotkESdOjNlE2wIWEQrLlgI4mgMlzY+tk3sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADfPFjg1V86kytf/yctNpG+rTSlOtY39hRN7T7MYEGKA7ochsTEGyHcwECvUpwqDGgjssXLiQ60zoOb0f/AoRnW/XmLr3odY9ns2RuiYGu3/DXKAWirAAD7ecizIMm/LHq1jICDf8h8/JsGt9BGkmGB1Ym67Esh6JxtlbQpoc54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cqV29MRZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cqV29MRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF184C2BD10;
	Tue, 14 May 2024 11:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687265;
	bh=w6EYMLUFotkESdOjNlE2wIWEQrLlgI4mgMlzY+tk3sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cqV29MRZ5CESb+0MpeI/x6PaolBwGr7bBTZBfq5Tj8mHfCW/eySLXuBYQgHOjXVD+
	 BS9908rm4yRxNYExO9FJqI71tQrIxiw1nzpnh3qdNB+E/W+db68z9qDlT2ovZiHQUK
	 QDYxRROCas+TvvVlDVLo3jHW5hfqCqfer4qHcU2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Paolo Abeni <pabeni@redhat.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 037/111] net: bridge: fix multicast-to-unicast with fraglist GSO
Date: Tue, 14 May 2024 12:19:35 +0200
Message-ID: <20240514100958.536530357@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 59c878cbcdd80ed39315573b3511d0acfd3501b5 ]

Calling skb_copy on a SKB_GSO_FRAGLIST skb is not valid, since it returns
an invalid linearized skb. This code only needs to change the ethernet
header, so pskb_copy is the right function to call here.

Fixes: 6db6f0eae605 ("bridge: multicast to unicast")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_forward.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index f2ef75c7ccc68..3a70682e63524 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -253,7 +253,7 @@ static void maybe_deliver_addr(struct net_bridge_port *p, struct sk_buff *skb,
 	if (skb->dev == p->dev && ether_addr_equal(src, addr))
 		return;
 
-	skb = skb_copy(skb, GFP_ATOMIC);
+	skb = pskb_copy(skb, GFP_ATOMIC);
 	if (!skb) {
 		DEV_STATS_INC(dev, tx_dropped);
 		return;
-- 
2.43.0



