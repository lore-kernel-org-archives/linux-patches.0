Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23110318B9D;
	Thu,  2 Jul 2026 16:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011198; cv=none; b=ogB5HtEvO5D9+S7ZbHC73ME3yAU4SUkkTE7nno22XrfAIaX23ckCUvYFynybOl9qhpnqHjiVbpM/KlGUQRTbdKBYp1qQDI+0VOvdH5yfxdbo46DAtBapnO+qIS/0bft3QZcx/EHCX74YQarxi2IUTKnkIJWYiUAJg1idcsdoNgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011198; c=relaxed/simple;
	bh=hgCmdJGM9me7c1skHOE9SWw2URkRplKltbzHeYH3Cj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dcgS1M7JOBFFhY9CoynHnq0krK94/qoTCF1b1AO6DJf/lSCMkTgiCqDUflsEhGW7LcPECvCySiyRSJoP986awhfTRfwc96EpznyfOgCQlvTVXiXI/1njY0aUBYz89ggYy88ozc4kPpPt0e2B4effKUGKc3thqYbLNlVGWFYs+84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E288OVe2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E288OVe2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897531F000E9;
	Thu,  2 Jul 2026 16:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011197;
	bh=zUO6n8r9OH4cdbjWqRIeByFvAYtf/kDqWgk1GbEKkck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E288OVe24IuWY6xhwW+ENxfBu8yeRjbyBW1s81YjWr5iKR5Rl3eOSqnGSF7ZlEwui
	 S0vPUSquqFERzjcp/y88AWVCFDse1hYwbArY+Ah7d7arHMMMZL8W20kg8dt7UYCwgx
	 CNPS6dzqWLELZP7v8LoyonNIIjqweYDd6bDwKUeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 018/108] batman-adv: ensure bcast is writable before modifying TTL
Date: Thu,  2 Jul 2026 18:20:15 +0200
Message-ID: <20260702155112.487110415@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 4cd6d3a4b96a8576f1fed8f9f9f17c2dc2978e0c upstream.

Before batman-adv is allowed to write to an skb, it either has to have its
own copy of the skb or used skb_cow() to ensure that the data part is not
shared.

The old implementation used a shared queue and created copies before
attempting to write to it. But with the new implementation, the broadcast
packet is already modified when it gets received. Potentially writing to
shared buffers in this process.

Adding a skb_cow() right before this operation avoids this and can at the
same time prepare it for the modifications required to rebroadcast the
packet.

Cc: stable@kernel.org
Fixes: 3f69339068f9 ("batman-adv: bcast: queue per interface, if needed")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/routing.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/batman-adv/routing.c b/net/batman-adv/routing.c
index 12c16f81cc51df..0672dc30bed3b1 100644
--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -1191,6 +1191,12 @@ int batadv_recv_bcast_packet(struct sk_buff *skb,
 	if (batadv_is_my_mac(bat_priv, bcast_packet->orig))
 		goto free_skb;
 
+	/* create a copy of the skb, if needed, to modify it. */
+	if (skb_cow(skb, ETH_HLEN) < 0)
+		goto free_skb;
+
+	bcast_packet = (struct batadv_bcast_packet *)skb->data;
+
 	if (bcast_packet->ttl-- < 2)
 		goto free_skb;
 
-- 
2.53.0



