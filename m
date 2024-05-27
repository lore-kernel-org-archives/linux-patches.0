Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C95A168C4;
	Mon, 27 May 2024 19:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837380; cv=none; b=GNK93pmZbyYBozJdIPX5OIWDvHLzWAv5OjNXh1yjjdxtqJCXOOEDg4dK4xwKJGyw64DXLP/BOjxjxAizxC16C05tk7/Oku9MbnPSb6mzl04Fbom0Opn+d/MSUwtPdTtCgCAUUE/bvGmaAJYK9bLARkW7nSAFyGYl+f9JrFRFpuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837380; c=relaxed/simple;
	bh=B1VP1y7THcyz7quUAqY7h6W5rqTR3kfSrGuIDZmHxzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J+/yjbQcxLm7VYkdjzJ5+fE4SZuXB132t3DLLyKXS2PExqzzBVbWpo4T5hVSjns+o0e7krRgXG2Fa7p3a9JcxMLx0A97fRyd0D2VNweSu+Sb8gu2IGddLKfsX58cGSTb9dQpHuIHvilKk3FYoccnJekx0AAYtB44jdaMaJc2u7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HCqrInJx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCqrInJx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CCEC32782;
	Mon, 27 May 2024 19:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837380;
	bh=B1VP1y7THcyz7quUAqY7h6W5rqTR3kfSrGuIDZmHxzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HCqrInJx/GhOaiOaZs+2kKzdGtEwve8LtbZ8BRSHEyGvQTgLqBSTqiKwB8ZSvcm+s
	 2E8n3y6YjrHcemaV4KjcBRvSSDaZDZb/htZEbyZltnATiosIWx54qqESKtec57SPqJ
	 CkE5g7ZHvgw0DFtRBJEjJiM7xCFB7DiWHMkKrHe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Neil Horman <nhorman@tuxdriver.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 419/427] af_packet: do not call packet_read_pending() from tpacket_destruct_skb()
Date: Mon, 27 May 2024 20:57:46 +0200
Message-ID: <20240527185635.672479544@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 581073f626e387d3e7eed55c48c8495584ead7ba ]

trafgen performance considerably sank on hosts with many cores
after the blamed commit.

packet_read_pending() is very expensive, and calling it
in af_packet fast path defeats Daniel intent in commit
b013840810c2 ("packet: use percpu mmap tx frame pending refcount")

tpacket_destruct_skb() makes room for one packet, we can immediately
wakeup a producer, no need to completely drain the tx ring.

Fixes: 89ed5b519004 ("af_packet: Block execution of tasks waiting for transmit to complete in AF_PACKET")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20240515163358.4105915-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 18f616f487eaa..150451ddd7553 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2522,8 +2522,7 @@ static void tpacket_destruct_skb(struct sk_buff *skb)
 		ts = __packet_set_timestamp(po, ph, skb);
 		__packet_set_status(po, ph, TP_STATUS_AVAILABLE | ts);
 
-		if (!packet_read_pending(&po->tx_ring))
-			complete(&po->skb_completion);
+		complete(&po->skb_completion);
 	}
 
 	sock_wfree(skb);
-- 
2.43.0



